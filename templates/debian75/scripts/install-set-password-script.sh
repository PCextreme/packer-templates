#!/bin/bash

echo "installing cloud-set-guest-password"
wget -O /etc/init.d/cloud-set-guest-password http://download.cloud.com/templates/4.2/bindir/cloud-set-guest-password.in
chmod +x /etc/init.d/cloud-set-guest-password
sed -i '25i# Wait 5sec for network\nsleep 5\n' /etc/init.d/cloud-set-guest-password
update-rc.d cloud-set-guest-password defaults
