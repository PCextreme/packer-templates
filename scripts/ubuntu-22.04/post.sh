#!/bin/bash
set -xe
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
logrotate -f /etc/logrotate.conf
find /var/log -type f -name '*.log' -delete
find /var/log -type f -name '*.gz' -delete

echo "Cleaning up cloud-init"
cloud-init clean -s -l
find /etc/cloud/cloud.cfg.d/ -type f ! -name '05_logging.cfg' -print -delete
find /var/log/ -type f -name 'cloud-init*.log' -print -delete

echo "Removing default user ubuntu"
deluser ubuntu

echo "Delete root password and lock account"
passwd --lock --delete root
sed -i 's|^ *PermitRootLogin .*|PermitRootLogin yes|g' /etc/ssh/sshd_config
sed -i 's|^ *PasswordAuthentication .*|PasswordAuthentication no|g' /etc/ssh/sshd_config

unset HISTFILE

sync
