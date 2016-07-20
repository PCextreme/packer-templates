#!/usr/bin/env bash

echo "Update packages"
yum -y upgrade

echo "Install packages"
yum -y install at binutils curl dstat git iotop ipset lsof mc mtr nmap pciutils rsync screen strace tcpdump unzip util-linux-ng uuid wget acpid policycoreutils policycoreutils-python bind-utils redhat-lsb-core vim-enhanced watchdog

echo "Install cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
chkconfig --add cloud-set-guest-password

echo "Mount partitions with noatime attribute"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab

echo "Making sure i6300esb Watchdog is loaded"
echo i6300esb >> /etc/modules

echo "Enabling watchdog"
chkconfig watchdog on
