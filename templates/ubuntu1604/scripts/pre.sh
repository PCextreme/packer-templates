#!/bin/bash
echo "Ensure everything is up-to-date"
apt-get update
sudo apt-get -o Dpkg::Options::="--force-confnew" upgrade

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
update-grub2

echo "Ensure ens3 is used instead of ens4 in interfaces file"
sed -i 's/ens4/ens3/g' /etc/network/interfaces

echo "Adding IPv6 configuration to interfaces file"
IFACE=$(cat /etc/network/interfaces|grep iface|tail -1|awk '{print $2}')

echo "iface ${IFACE} inet6 auto" >> /etc/network/interfaces
echo "# To enable IPv6 Prefix Delegation uncomment the lines below" >> /etc/network/interfaces
echo "#    dhcp 1" >> /etc/network/interfaces
echo "#    request_prefix 1" >> /etc/network/interfaces

unset HISTFILE
