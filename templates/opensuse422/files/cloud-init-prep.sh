#!/bin/sh
mkdir -p /var/lib/dhcp
echo "option dhcp-server-identifier $(grep -hoPm1 "(?<=<server-id>)[^<]+" /var/lib/wicked/*.xml)" > /var/lib/dhcp/dhclient.cloud-init.lease
