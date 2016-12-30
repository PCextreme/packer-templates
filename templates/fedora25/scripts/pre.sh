#!/bin/bash

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

echo "Symlink dhclient folder to NetworkManager so cloud-init is able to find the leases file"
rm -rf /var/lib/dhclient
ln -s /var/lib/NetworkManager /var/lib/dhclient

#echo "Fixing GRUB"
#cat >>/etc/default/grub <<TOGRUB
#GRUB_RECORDFAIL_TIMEOUT=10
#GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
#GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
#TOGRUB
#grub2-mkconfig > /boot/grub2/grub.cfg

echo "Do not use IPv4 DHCP DNS"
sed -i 's|^PEERDNS=yes|PEERDNS=no|g' /etc/sysconfig/network-scripts/ifcfg-*

unset HISTFILE
