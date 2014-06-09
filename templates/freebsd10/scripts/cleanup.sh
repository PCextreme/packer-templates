#!/bin/sh


echo "cleaning up dhcp leases"
rm -f /var/db/dhclient.leases.*


echo "removing existing ssh server keys"
rm -f /etc/ssh/*key*

echo "Removing any left over script.sh files from packer"
rm /tmp/script.sh

echo "removing history"
rm /root/.history
history -c && exit

