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
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

echo 'WITHOUT_X11="YES"' >> /etc/make.conf

env ASSUME_ALWAYS_YES=1 pkg bootstrap
pkg update
pkg install -y bash nano wget
pkg autoremove

echo 'installer' | pw usermod root -h 0
sed -i -e 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
