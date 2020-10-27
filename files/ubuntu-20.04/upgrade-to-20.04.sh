#!/bin/bash

sed -i 's|bionic|focal|g' /etc/apt/sources.list
apt update
apt -y dist-upgrade
apt -y autoremove
