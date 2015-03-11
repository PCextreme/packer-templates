#!/bin/bash

echo "Installing Basic Server packages"
yum -y groupinstall base
yum -y install acpid ntp ndisc6
chkconfig rdisc on

# Install cloud-init manually because distro version is broken
echo "Installing cloud-init"
rpm -i http://dl.fedoraproject.org/pub/epel/7/x86_64/c/cloud-init-0.7.5-6.el7.x86_64.rpm
