#!/bin/bash

echo "installing cloud-set-guest-password"
wget -O /etc/init.d/cloud-set-guest-password http://crew.pcextreme.nl/files/linux/util/cloudstack/cloud-set-guest-password.in || exit 1

chmod +x /etc/init.d/cloud-set-guest-password

if [ -d "/etc/sysconfig" ]; then
	chkconfig --add cloud-set-guest-password
else
	update-rc.d cloud-set-guest-password defaults
fi

