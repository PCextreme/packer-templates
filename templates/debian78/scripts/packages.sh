#!/bin/bash

echo "installing cloud-init from backports"
echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list
apt-get update
apt-get install -y -t wheezy-backports cloud-init