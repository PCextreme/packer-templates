#!/bin/bash
set -xe

echo "Remove DHCP leases"
find /var/lib -type f -name '*.lease' -print -delete

echo "Configurating network interface"
mv /etc/sysconfig/network-scripts/ifcfg-ens4 /etc/sysconfig/network-scripts/ifcfg-ens3
sed -i 's|ens[0-9]|ens3|g' /etc/sysconfig/network-scripts/ifcfg-ens3

echo "Configuring DNS"
find /etc -maxdepth 1 -type l -name 'resolv.conf' -print -delete
echo "nameserver 2a00:f10:ff04:153::53"|tee /etc/resolv.conf
echo "nameserver 2a00:f10:ff04:253::53"|tee -a /etc/resolv.conf

echo "Enable services: cloud-init NetworkManager-wait-online fstrim.timer"
systemctl enable cloud-init cloud-config fstrim.timer qemu-guest-agent

echo "Generating GRUB"
grub2-mkconfig -o /boot/grub2/grub.cfg

echo "Cleaning up cloud-init"
find /var/log -type f -name 'cloud-init*.log' -print -delete
cloud-init clean -s -l

echo "Delete root password and lock account"
passwd --lock --delete root
sed -i 's|PermitRootLogin .*|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config

unset HISTFILE

sync
