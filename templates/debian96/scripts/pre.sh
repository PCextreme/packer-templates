#!/bin/bash
echo "Ensure everything is up-to-date"
apt-get update
apt-get -y upgrade

echo "install cloud-init"
apt-get install cloud-init cloud-utils -y

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
update-grub2

#echo "Update cloud.cfg"
#sed -i 's/set-passwords/\[ set-passwords\, always \]/g' /etc/cloud/cloud.cfg

echo "Adding IPv6 configuration to interfaces file"
IFACE=$(cat /etc/network/interfaces|grep iface|tail -1|awk '{print $2}')

echo "iface ${IFACE} inet6 auto" >> /etc/network/interfaces
echo "# To enable IPv6 Prefix Delegation uncomment the lines below" >> /etc/network/interfaces
echo "#    dhcp 1" >> /etc/network/interfaces
echo "#    request_prefix 1" >> /etc/network/interfaces

echo "Ensure ens3 is used instead of ens4 in interfaces file"
sed -i 's/ens4/ens3/g' /etc/network/interfaces

echo "Enable fstrim on a weekly basis"
cp /usr/share/doc/util-linux/examples/fstrim.service /etc/systemd/system
cp /usr/share/doc/util-linux/examples/fstrim.timer /etc/systemd/system
systemctl enable fstrim.timer

unset HISTFILE
