#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y upgrade

echo "installing cloud-set-guest-sshkey"
chmod +x /etc/init.d/cloud-set-guest-sshkey
update-rc.d cloud-set-guest-sshkey defaults

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab
