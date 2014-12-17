#!/usr/bin/env bash

echo "Update packages"
yum -y update

echo "Install cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
chkconfig --add cloud-set-guest-password

echo "Mount partitions with noatime attribute"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab
