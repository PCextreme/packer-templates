#!/bin/bash

echo "updating the machine"
rm -fR /var/lib/apt/lists/*
apt-get update
apt-get -y dist-upgrade

echo "installing cloud-init"
apt-get -y install cloud-init

echo "installing cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
update-rc.d cloud-set-guest-password defaults

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab
