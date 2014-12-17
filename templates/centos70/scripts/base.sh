#!/bin/bash

echo "Update packages"
yum -y update

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

echo "Symlink dhclient folder to NetworkManager so cloud-init is able to find the leases file"
rm -rf /var/lib/dhclient
ln -s /var/lib/NetworkManager /var/lib/dhclient

echo "Set noatime option"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab
