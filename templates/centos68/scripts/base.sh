#!/usr/bin/env bash

echo "Install cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
chkconfig --add cloud-set-guest-password
