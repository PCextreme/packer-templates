#!/bin/bash

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

systemctl daemon-reload

unset HISTFILE
