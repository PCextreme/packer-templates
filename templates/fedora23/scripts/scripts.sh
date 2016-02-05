#!/bin/bash

unset HISTFILE

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable cloud-set-guest-password

echo "Enable NetworkManager-wait-online"
systemctl enable NetworkManager-wait-online.service
