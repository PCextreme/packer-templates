#!/usr/bin/env bash

echo "Install packages"
yum -y groupinstall base
yum -y install acpid ntp cloud-init
chkconfig rdisc on
