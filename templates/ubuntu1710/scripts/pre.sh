#!/bin/bash
echo "Ensure everything is up-to-date"
apt-get update
sudo apt-get -o Dpkg::Options::="--force-confnew" upgrade

echo "Ensure latest cloud-init is installed"
cd /tmp
wget http://nl.archive.ubuntu.com/ubuntu/pool/main/c/cloud-init/cloud-init_17.1-46-g7acc9e68-0ubuntu1~17.10.1_all.deb
dpkg -i cloud-init_17.1-46-g7acc9e68-0ubuntu1~17.10.1_all.deb

echo "Fixing GRUB"
cat >>/etc/default/grub <<TOGRUB
GRUB_RECORDFAIL_TIMEOUT=10
GRUB_CMDLINE_LINUX_DEFAULT="\$(echo \$GRUB_CMDLINE_LINUX_DEFAULT | sed 's/\(quiet\|splash\|nomodeset\)//g') quiet"
GRUB_CMDLINE_LINUX="\$(echo \$GRUB_CMDLINE_LINUX | sed 's/\(quiet\|splash\|nomodeset\)//g') nomodeset"
TOGRUB
update-grub2

echo "Ensure ens3 is used instead of ens4 in netcfg file"
sed -i 's/ens4/ens3/g' /etc/netplan/01-netcfg.yaml

unset HISTFILE
