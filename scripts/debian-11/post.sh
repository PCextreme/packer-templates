#!/bin/bash
set -xe

echo "Installing and updating needed packages"
apt-get update
apt-get -o Dpkg::Options::="--force-confold" -y dist-upgrade

echo "Removing uneeded packages"
apt-get -y autoremove
apt-get -y clean

echo "cleaning up dhcp leases"
find /var/lib/dhcp -type f -delete

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Configuring network interface"
sed -i 's|ens[0-9]|ens3|g' /etc/network/interfaces
echo "iface ens3 inet6 auto" >> /etc/network/interfaces

echo "Configuring DNS"
echo "nameserver 2a00:f10:ff04:153::53"|tee -a /etc/resolvconf/resolv.conf.d/head
echo "nameserver 2a00:f10:ff04:253::53"|tee -a /etc/resolvconf/resolv.conf.d/head

echo "cleaning up log files"
logrotate -f /etc/logrotate.conf
find /var/log -type f -name '*.log' -delete
find /var/log -type f -name '*.gz' -delete

echo "Enabling services"
systemctl enable fstrim.timer

echo "Cleaning up cloud-init"
cloud-init clean --logs

echo "Delete root password and lock account"
passwd --lock --delete root
sed -i 's|PermitRootLogin .*|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config

unset HISTFILE

sync
