#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y upgrade

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab
