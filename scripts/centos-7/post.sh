#!/bin/bash
set -xe

echo "Remove DHCP leases"
find /var/lib -type f -name '*.lease' -delete

echo "Configuring DNS"
find /etc -maxdepth 1 -type l -name 'resolv.conf' -delete
echo "nameserver 2a00:f10:ff04:153::53"|tee /etc/resolv.conf
echo "nameserver 2a00:f10:ff04:253::53"|tee -a /etc/resolv.conf

echo "Enabling systemd services"
systemctl enable cloud-init cloud-config fstrim.timer qemu-guest-agent

echo "Cleaning up cloud-init"
cloud-init clean --logs

echo "Delete root password and lock account"
passwd --delete root
passwd --lock root
sed -i 's|PermitRootLogin .*|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config

unset HISTFILE

sync
