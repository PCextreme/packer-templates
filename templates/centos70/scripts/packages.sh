#!/bin/bash

echo "Install Basic Server packages"
yum -y groupinstall base
yum -y install acpid ntp ndisc6 cloud-init
chkconfig rdisc on
