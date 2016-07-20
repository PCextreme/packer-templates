#!/bin/bash

unset HISTFILE

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable cloud-set-guest-password

echo "adding SElinux exceptions for cloud-set-guest-password"
semodule -i /tmp/cloud-password-fix.pp

echo "enable cloud-init"
systemctl enable cloud-init

echo "Enable NetworkManager-wait-online"
systemctl enable NetworkManager-wait-online.service
