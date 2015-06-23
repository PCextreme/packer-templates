#!/bin/bash

echo "updating the machine"
rm -fR /var/lib/apt/lists/*
apt-get update
apt-get -y dist-upgrade

echo "installing additional packages"
apt-get -y install cloud-init ndisc6 resolvconf

echo "installing cloud-set-guest-password"
chmod +x /etc/init.d/cloud-set-guest-password
update-rc.d cloud-set-guest-password defaults

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab

echo "setting ntp server"
sed -i 's|ntp.ubuntu.com|ntp.pcextreme.nl|g' /etc/ntp.conf

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
update-grub2

echo "Prioritizing IPv6 resolvers"
sed -i '2i 000.*' /etc/resolvconf/interface-order
