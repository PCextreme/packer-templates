#!/bin/bash

echo "Update packages"
yum -y update

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

echo "Set noatime option"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab
