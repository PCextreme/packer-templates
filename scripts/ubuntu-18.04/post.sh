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

echo "Removing uneeded packages"
apt-get -y autoremove
apt-get -y clean

echo "Disabling apt timers"
systemctl disable apt-daily.timer apt-daily-upgrade.timer

echo "cleaning up dhcp leases"
find /var/lib/dhcp -type f -delete

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Configuring network interface"
sed -i 's|ens[0-9]|ens3|g' /etc/netplan/01-netcfg.yaml

echo "Configuring DNS"
echo "nameserver 2a00:f10:ff04:153::53"|tee -a /etc/resolvconf/resolv.conf.d/head
echo "nameserver 2a00:f10:ff04:253::53"|tee -a /etc/resolvconf/resolv.conf.d/head

echo "Enable DNSSEC"
mkdir /etc/systemd/resolved.conf.d
echo "[Resolve]"|tee /etc/systemd/resolved.conf.d/10-dnssec.conf
echo "DNSSEC=true"|tee -a /etc/systemd/resolved.conf.d/10-dnssec.conf

echo "cleaning up log files"
if [ -f /var/log/audit/audit.log ]; then cat /dev/null > /var/log/audit/audit.log; fi
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null
rm -f /var/log/upstart/*.log /var/log/upstart/*.log.*.gz

echo "Cleaning up cloud-init"
cloud-init clean --logs

echo "Delete root password and lock account"
passwd --lock --delete root
sed -i 's|PermitRootLogin .*|PermitRootLogin prohibit-password|g' /etc/ssh/sshd_config

unset HISTFILE

sync
