#!/bin/bash

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password

echo "enable cloud-init"
systemctl enable cloud-init cloud-set-guest-password NetworkManager-wait-online

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Clean udev rules"
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-e*

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

unset HISTFILE
