#!/bin/bash

echo "Enable services: cloud-init cloud-set-guest-password"
systemctl enable cloud-init cloud-set-guest-password

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

systemctl daemon-reload

unset HISTFILE
