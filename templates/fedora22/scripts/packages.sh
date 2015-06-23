#!/bin/bash

unset HISTFILE

echo "Installing Basic Server packages"
dnf -y install cloud-init
systemctl enable rdisc
