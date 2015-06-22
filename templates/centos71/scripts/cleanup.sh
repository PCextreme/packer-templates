#!/bin/bash

unset HISTFILE

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*
