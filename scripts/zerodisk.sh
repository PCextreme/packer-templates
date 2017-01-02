#!/usr/bin/env bash
echo "Info: Zero out the free space to save space"

AVAIL=$(df --block-size=4K /|tail -1|awk '{print $4}')

dd if=/dev/zero of=/EMPTY conv=fsync bs=4k count=${AVAIL}
rm -f /EMPTY
sync
