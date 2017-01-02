#!/bin/bash

echo "Clean yum cache"
yum -y clean all

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable cloud-set-guest-password

echo "Enable NetworkManager-wait-online"
systemctl enable NetworkManager-wait-online.service

unset HISTFILE
