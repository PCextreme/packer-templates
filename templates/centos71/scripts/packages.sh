#!/bin/bash

unset HISTFILE

echo "Installing Basic Server packages"
yum -y groupinstall base
yum -y install acpid ntp ndisc6 cloud-init
sysyemctl enable rdisc
