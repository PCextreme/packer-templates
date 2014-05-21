#!/bin/bash

echo "Removing uneeded packages"
yum -y clean all

echo "cleaning up dhcp leases"
rm /var/lib/dhclient/*

echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0

echo "removing excisting ssh server keys"
rm -f /etc/ssh/ssh_host*key*

echo "removing history"
history -c
unset HISTFILE

