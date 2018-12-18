#!/bin/bash

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

echo "Symlink dhclient folder to NetworkManager so cloud-init is able to find the leases file"
rm -rf /var/lib/dhclient
ln -s /var/lib/NetworkManager /var/lib/dhclient

echo "Correcting bug in CloudStack cloud-init provider"
# https://bugs.launchpad.net/cloud-init/+bug/1717147
sed -i 's/if file_name.startswith("dhclient.") and \\/if file_name.startswith("dhclient-") and \\/g' /usr/lib/python2.7/site-packages/cloudinit/sources/DataSourceCloudStack.py

echo "Do not use IPv4 DHCP DNS"
sed -i 's|^PEERDNS=yes|PEERDNS=no|g' /etc/sysconfig/network-scripts/ifcfg-eth0

echo "Making sure i6300esb Watchdog is loaded"
echo i6300esb >> /etc/modules

unset HISTFILE
