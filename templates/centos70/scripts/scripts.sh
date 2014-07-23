#!/bin/bash

echo "installing cloud-set-guest-password"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-password
systemctl enable /etc/systemd/system/cloud-set-guest-password.service

echo "installing cloud-set-guest-sshkey"
chmod +x /usr/lib/systemd/scripts/cloud-set-guest-sshkey
systemctl enable /etc/systemd/system/cloud-set-guest-sshkey.service