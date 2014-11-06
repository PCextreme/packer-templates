#!/bin/bash

echo "Install Basic Server packages"
yum -y groupinstall base
yum -y install ndisc6
chkconfig rdisc on
