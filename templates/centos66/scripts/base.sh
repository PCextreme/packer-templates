#!/usr/bin/env bash

echo "Update packages"
yum -y upgrade

echo "Install cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
chkconfig --add cloud-set-guest-password

echo "Mount partitions with noatime attribute"
sed -i '0,/defaults/{s/defaults/defaults,noatime/g}' /etc/fstab

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
grub2-mkconfig > /boot/grub2/grub.cfg
