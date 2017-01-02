#!/bin/bash

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable cloud-set-guest-password

echo "enable cloud-init"
systemctl enable cloud-init

#echo "Enable NetworkManager-wait-online"
#systemctl enable NetworkManager-wait-online.service

unset HISTFILE
