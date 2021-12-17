#!/bin/bash
set -x
export DEBIAN_FRONTEND=noninteractive

echo "Installing and updating needed packages"
apt-get update
apt-get -o Dpkg::Options::="--force-confold" -y install \
    qemu-guest-agent ndisc6 cloud-init at byobu curl fping git htop iftop iotop \
    ipset jq mc mtr ncdu nmap rsync screen strace tcpdump unzip util-linux whois \
    uuid wget vim software-properties-common sysstat rdnssd watchdog
apt-get -o Dpkg::Options::="--force-confold" --force-yes -y dist-upgrade

echo "Enabling services"
systemctl enable cloud-init.service fstrim.timer qemu-guest-agent.service watchdog.service

echo "Disabling apt timers"
systemctl disable apt-daily.timer apt-daily-upgrade.timer

echo "Removing uneeded packages"
apt -y autoremove
apt -y clean

echo "cleaning up dhcp leases"
find /var/lib -type f -name '*.lease' -print -delete

echo "Configurating network interface"
find /etc/netplan -type f -name '00-installer-config.yaml' -print -delete

echo "Enable DNSSEC"
mkdir /etc/systemd/resolved.conf.d
echo "[Resolve]"|tee /etc/systemd/resolved.conf.d/10-dnssec.conf
echo "DNSSEC=true"|tee -a /etc/systemd/resolved.conf.d/10-dnssec.conf

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "cleaning up log files"
if [ -f /var/log/audit/audit.log ]; then cat /dev/null > /var/log/audit/audit.log; fi
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null
rm -f /var/log/upstart/*.log /var/log/upstart/*.log.*.gz

echo "Cleaning up cloud-init"
cloud-init clean -s -l
find /etc/cloud/cloud.cfg.d/ -type f ! -name '05_logging.cfg' -print -delete
find /var/log/ -type f -name 'cloud-init*.log' -print -delete

echo "Removing default user ubuntu"
deluser ubuntu

unset HISTFILE

sync
