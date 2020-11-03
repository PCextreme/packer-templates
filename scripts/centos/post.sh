#!/bin/bash

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Remove SSH host keys"
find /etc/ssh -type f -name 'ssh_host*key*' -delete

echo "Enable systemd services"
systemctl enable cloud-init cloud-config fstrim.timer qemu-guest-agent

echo "Cleaning up cloud-init"
cloud-init clean -s -l

unset HISTFILE
