#!/bin/bash

echo "Update packages"
yum -y upgrade

echo "Install packages"
yum -y install at binutils curl dstat git iotop ipset lsof mc mtr nmap pciutils rsync screen strace tcpdump unzip net-tools uuid wget acpid policycoreutils iptraf-ng policycoreutils-python bind-utils redhat-lsb-core vim-enhanced 	qemu-guest-agent

unset HISTFILE

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

echo "Symlink dhclient folder to NetworkManager so cloud-init is able to find the leases file"
rm -rf /var/lib/dhclient
ln -s /var/lib/NetworkManager /var/lib/dhclient

echo "Set noatime option"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
grub2-mkconfig > /boot/grub2/grub.cfg

echo "Do not use IPv4 DHCP DNS"
sed -i 's|^PEERDNS=yes|PEERDNS=no|g' /etc/sysconfig/network-scripts/ifcfg-eth0
