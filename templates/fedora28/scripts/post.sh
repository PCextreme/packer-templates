#!/bin/bash

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

echo "Enable services: cloud-init NetworkManager-wait-online fstrim.timer"
systemctl enable cloud-init cloud-config NetworkManager-wait-online fstrim.timer

unset HISTFILE
