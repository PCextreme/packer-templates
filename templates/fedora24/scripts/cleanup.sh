#!/bin/bash

unset HISTFILE

echo "Clean dnf cache"
dnf -y clean all

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Clean udev rules"
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

echo "Remove temporary file for cloud-set-guest-password fix"
rm -f /tmp/cloud-password-fix.pp
