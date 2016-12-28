#!/bin/bash

echo "Create directories"
mkdir -p /usr/lib/systemd/scripts

#echo "Symlink dhclient folder to NetworkManager so cloud-init is able to find the leases file"
#rm -rf /var/lib/dhclient
#ln -s /var/lib/NetworkManager /var/lib/dhclient

unset HISTFILE
