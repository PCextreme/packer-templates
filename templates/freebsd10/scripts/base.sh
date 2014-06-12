#!/bin/sh

echo "updating the machine"

# FreeBSD makes it absolutly impossible to run freebsd-update non-interactive, 
# but for automating the install we have to. We use the cron command which can
# run non-interactive but we need to remove the sleep or it will take al long time.
# The reason for not running the non-interactive is to prevent a broken system by 
# automated update, cause we monitor the packer installations, it's safe to do this. 

sed 's/sleep `jot -r 1 0 3600`//' /usr/sbin/freebsd-update > /tmp/freebsd-update
chmod +x /tmp/freebsd-update
/tmp/freebsd-update cron
rm /tmp/freebsd-update
freebsd-update install

echo "setting noatime option"
sed -i -e 's|rw|rw,noatime|g' /etc/fstab

echo "setting permission of cloud-set-guest-password"
chmod +x /usr/local/etc/rc.d/cloud-set-guest-password

echo "setting permission of cloud-set-guest-sshkey"
chmod +x /usr/local/etc/rc.d/cloud-set-guest-sshkey