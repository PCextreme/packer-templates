#!/bin/bash

unset HISTFILE

echo "Installing Basic Server packages"
yum -y groupinstall base
yum -y install acpid ndisc6 cloud-init
systemctl enable rdisc
