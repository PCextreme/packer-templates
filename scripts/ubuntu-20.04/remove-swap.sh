#!/bin/bash
set -xe

echo "Removing and disabling swap"
swapoff -a
sed -i '/swap/d' /etc/fstab
find / -maxdepth 1 -type f -name 'swap.img' -print -delete
