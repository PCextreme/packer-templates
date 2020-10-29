#!/bin/bash

rm /etc/resolv.conf
echo "nameserver 2a00:f10:ff04:153::53" > /etc/resolv.conf
echo "nameserver 2a00:f10:ff04:253::53" > /etc/resolv.conf
