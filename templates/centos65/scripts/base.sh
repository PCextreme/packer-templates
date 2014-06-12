#!/bin/bash

echo "Update packages"
yum -y update

echo "installing cloud-set-guest-sshkey"
chmod +x /etc/init.d/cloud-set-guest-sshkey
chkconfig --add cloud-set-guest-sshkey

echo "setting noatime option"
sed -i 's|defaults|defaults,noatime|g' /etc/fstab
