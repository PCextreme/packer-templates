#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y dist-upgrade

echo "installing cloud-set-guest-password"
chmod +x /etc/network/if-up.d/cloud-set-guest-password

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab
