PARTITIONS=vtbd0
DISTRIBUTIONS="base.txz kernel.txz lib32.txz"

#!/bin/sh
cat >> /boot/loader.conf <<EOF
virtio_balloon_load="YES"
virtio_blk_load="YES"
virtio_scsi_load="YES"
EOF

cat >> /etc/rc.conf <<EOF
hostname="freebsd10.local"
ifconfig_em0="DHCP"
keymap="it.iso.kbd"
sshd_enable="YES"
dumpdev="AUTO"
ifconfig_vtnet0_name="em0"
EOF

cat >> /etc/resolv.conf <<EOF
nameserver 2a00:f10:10a:9::53
nameserver 2001:14a0:300:4::53
nameserver 109.72.90.52
nameserver 217.115.199.215
EOF

echo 'WITHOUT_X11="YES"' >> /etc/make.conf

env ASSUME_ALWAYS_YES=1 pkg bootstrap
pkg update
pkg install -y bash nano wget
pkg autoremove

echo 'installer' | pw usermod root -h 0
sed -i -e 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
