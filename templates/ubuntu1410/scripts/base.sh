#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y dist-upgrade

echo "installing cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
update-rc.d cloud-set-guest-password defaults

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab
