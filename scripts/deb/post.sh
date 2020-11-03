#!/bin/bash
echo "Removing uneeded packages"
apt-get -y autoremove
apt-get -y clean

echo "cleaning up dhcp leases"
find /var/lib/dhcp -type f -delete

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Remove SSH host keys"
find /etc/ssh -type f -name 'ssh_host*key*' -delete

echo "cleaning up log files"
if [ -f /var/log/audit/audit.log ]; then cat /dev/null > /var/log/audit/audit.log; fi
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null
rm -f /var/log/upstart/*.log /var/log/upstart/*.log.*.gz

echo "Cleaning up cloud-init"
cloud-init clean -s -l

unset HISTFILE
