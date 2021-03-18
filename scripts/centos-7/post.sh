#!/bin/bash

echo "Remove DHCP leases"
find /var/lib -type f -name '*.lease' -delete

echo "Remove SSH host keys"
find /etc/ssh -type f -name 'ssh_host*key*' -delete

echo "Configuring DNS"
find /etc -maxdepth 1 -type l -name 'resolv.conf' -delete
echo "nameserver 2a00:f10:ff04:153::53"|tee /etc/resolv.conf
echo "nameserver 2a00:f10:ff04:253::53"|tee -a /etc/resolv.conf

echo "Enabling systemd services"
systemctl enable cloud-init cloud-config fstrim.timer qemu-guest-agent

echo "Cleaning up cloud-init"
cloud-init clean --logs

unset HISTFILE

sync
