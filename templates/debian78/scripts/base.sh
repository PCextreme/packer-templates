#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y dist-upgrade

echo "installing cloud-set-guest-password"
chmod +x /etc/network/if-up.d/cloud-set-guest-password

echo "setting noatime option"
sed -i 's|errors=remount-ro|errors=remount-ro,noatime|g' /etc/fstab

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
update-grub2

echo "Prioritizing IPv6 Resolvers"
sed -i '2i 000.*' /etc/resolvconf/interface-order

