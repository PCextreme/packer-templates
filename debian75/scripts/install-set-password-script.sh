#!/bin/bash

echo "installing cloud-set-guest-password"
wget -O /etc/init.d/cloud-set-guest-password http://download.cloud.com/templates/4.2/bindir/cloud-set-guest-password.in
chmod +x /etc/init.d/cloud-set-guest-password


