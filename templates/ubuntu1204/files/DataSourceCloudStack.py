# vi: ts=4 expandtab
#
#    Copyright (C) 2012 Canonical Ltd.
#    Copyright (C) 2012 Cosmin Luta
#
#    Author: Cosmin Luta <q4break@gmail.com>
#    Author: Scott Moser <scott.moser@canonical.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License version 3, as
#    published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

import cloudinit.DataSource as DataSource

import os
from cloudinit import seeddir as base_seeddir
from cloudinit import log
import cloudinit.util as util
from socket import inet_ntoa
import time
import boto.utils as boto_utils
from struct import pack


class DataSourceCloudStack(DataSource.DataSource):
    api_ver = 'latest'
    seeddir = base_seeddir + '/cs'
    metadata_address = None

    def __init__(self, sys_cfg=None):
        DataSource.DataSource.__init__(self, sys_cfg)
        # Cloudstack has its metadata/userdata URLs located at
        # http://<virtual-router-ip>/latest/
        vr_addr = self.get_vr_address()
        if not vr_addr:
            raise RuntimeError("No virtual router found!")
        self.metadata_address = "http://%s/" % vr_addr

    def get_default_gateway(self):
        """ Returns the default gateway ip address in the dotted format
        """
        with open("/proc/net/route", "r") as f:
            for line in f.readlines():
                items = line.split("\t")
                if items[1] == "00000000":
                    # found the default route, get the gateway
                    gw = inet_ntoa(pack("<L", int(items[2], 16)))
                    log.debug("found default route, gateway is %s" % gw)
                    return gw

    def get_dhclient_d(self):
        # find lease files directory
        supported_dirs = ["/var/lib/dhclient", "/var/lib/dhcp"]
        for d in supported_dirs:
            if os.path.exists(d):
                log.debug("Using %s lease directory", d)
                return d

    def get_latest_lease(self):
        # find latest lease file
        lease_d = self.get_dhclient_d()
        if not lease_d:
            return None
        lease_files = os.listdir(lease_d)
        latest_mtime = -1
        latest_file = None
        for file_name in lease_files:
            if file_name.endswith(".lease") or file_name.endswith(".leases"):
                abs_path = os.path.join(lease_d, file_name)
                mtime = os.path.getmtime(abs_path)
                if mtime > latest_mtime:
                    latest_mtime = mtime
                    latest_file = abs_path
        return latest_file

    def get_vr_address(self):
        # Get the address of the virtual router via dhcp leases
        # see http://bit.ly/T76eKC for documentation on the virtual router.
        # If no virtual router is detected, fallback on default gateway.
        lease_file = self.get_latest_lease()
        if not lease_file:
            log.debug("No lease file found, using default gateway")
            return self.get_default_gateway()

        latest_address = None
        with open(lease_file, "r") as fd:
            for line in fd:
                if "dhcp-server-identifier" in line:
                    words = line.strip(" ;\r\n").split(" ")
                    if len(words) > 2:
                        dhcp = words[2]
                        log.debug("Found DHCP identifier %s", dhcp)
                        latest_address = dhcp
        if not latest_address:
            # No virtual router found, fallback on default gateway
            log.debug("No DHCP found, using default gateway")
            return self.get_default_gateway()
        return latest_address

    def __str__(self):
        return "DataSourceCloudStack"

    def get_data(self):
        seedret = {}
        if util.read_optional_seed(seedret, base=self.seeddir + "/"):
            self.userdata_raw = seedret['user-data']
            self.metadata = seedret['meta-data']
            log.debug("using seeded cs data in %s" % self.seeddir)
            return True

        try:
            start = time.time()
            self.userdata_raw = boto_utils.get_instance_userdata(self.api_ver,
                None, self.metadata_address)
            self.metadata = boto_utils.get_instance_metadata(self.api_ver,
                self.metadata_address)
            log.debug("crawl of metadata service took %ds" %
                (time.time() - start))
            return True
        except Exception as e:
            log.exception(e)
            return False

    def get_instance_id(self):
        return self.metadata['instance-id']

    def get_availability_zone(self):
        return self.metadata['availability-zone']

datasources = [
  (DataSourceCloudStack, (DataSource.DEP_FILESYSTEM, DataSource.DEP_NETWORK)),
]


# return a list of data sources that match this set of dependencies
def get_datasource_list(depends):
    return DataSource.list_from_depends(depends, datasources)
