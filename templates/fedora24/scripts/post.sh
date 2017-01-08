#!/bin/bash

echo "Enable services: cloud-init cloud-set-guest-password NetworkManager-wait-online"
systemctl enable cloud-init cloud-set-guest-password NetworkManager-wait-online

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Clean udev rules"
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-*

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

unset HISTFILE
