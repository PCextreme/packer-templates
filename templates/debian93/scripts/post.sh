#!/bin/bash
echo "Ensure everything is up-to-date"
apt-get update
apt-get -y upgrade

echo "Removing uneeded packages"
apt-get -y autoremove
apt-get -y clean

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "remove cloud-init network interfaces file"
rm -f /etc/network/interfaces.d/50-cloud-init.cfg

echo "cleaning up log files"
if [ -f /var/log/audit/audit.log ]; then cat /dev/null > /var/log/audit/audit.log; fi
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null
rm -f /var/log/upstart/*.log /var/log/upstart/*.log.*.gz

unset HISTFILE
