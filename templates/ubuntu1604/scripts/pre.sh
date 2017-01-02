#!/bin/bash

echo "updating the machine"
apt-get update
apt-get -y dist-upgrade

echo "installing packages"
apt-get -y install at binutils byobu curl dstat fping git htop iftop incron iotop ipset jq lsof mc mtr ncdu nmap pciutils rsync screen sl strace tcpdump unzip util-linux whois uuid wget acpid apparmor-utils apparmor-profiles apt-file dnsutils conntrack iptraf vim lsb-release xfsprogs apt-transport-https software-properties-common sysstat python-software-properties rdnssd qemu-guest-agent watchdog

echo "install cloud-init"
apt-get -y install cloud-init

echo "Moving cloud-init config file"
mv /etc/cloud/cloud.cfg.custom /etc/cloud/cloud.cfg

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

#
# Ubuntu 16.04 ships with a broken ifupdown package which doesn't handle DHCPv6 properly
#
# https://bugs.launchpad.net/ubuntu/+source/ifupdown/+bug/1543352
#
# Ifupdown 0.8.11 contains this fix, but it also supports requesting a Prefix through
# DHCPv6+PD (IA_PD)
#
# PCextreme Aurora Compute will support IPv6 Prefix Delegation in 2016 and this adds
# support to the Ubuntu 16.04 template
#
# iface ens3 inet6 auto
#   dhcp 1
#   request_prefix 1
#
# See 'man interfaces' for more information
#

echo "Installing patched version of ifupdown for IPv6 PD support"
wget -O /tmp/ifupdown.deb https://pcextreme.o.auroraobjects.eu/ubuntu/ifupdown_0.8.11_amd64.deb
dpkg -i /tmp/ifupdown.deb

echo "Adding IPv6 configuration to interfaces file"
IFACE=$(cat /etc/network/interfaces|grep iface|tail -1|awk '{print $2}')

echo "iface ${IFACE} inet6 auto" >> /etc/network/interfaces
echo "# To enable IPv6 Prefix Delegation uncomment the lines below" >> /etc/network/interfaces
echo "#    dhcp 1" >> /etc/network/interfaces
echo "#    request_prefix 1" >> /etc/network/interfaces

echo "Making sure i6300esb Watchdog is loaded"
echo i6300esb >> /etc/modules
