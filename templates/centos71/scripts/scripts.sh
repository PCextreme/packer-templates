#!/bin/bash

unset HISTFILE

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable /etc/systemd/system/cloud-set-guest-password.service

echo "Enable NetworkManager-wait-online" 
systemctl enable NetworkManager-wait-online.service

echo "Enable various services."
systemctl enable rdisc
