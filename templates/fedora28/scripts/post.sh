#!/bin/bash

echo "Remove DHCP leases"
rm -f /var/lib/NetworkManager/*.lease

echo "Remove SSH host keys"
rm -f /etc/ssh/ssh_host*key*

echo "Enable services"
systemctl enable cloud-init cloud-config NetworkManager-wait-online fstrim.timer

echo "Modify systemd service to ensure cloud-init is started after network is online"
touch /etc/systemd/system/cloud-init.service
cat > /etc/systemd/system/cloud-init.service <<EOF
[Unit]
Description=Initial cloud-init job (metadata service crawler)
DefaultDependencies=no
Wants=cloud-init-local.service
Wants=sshd-keygen.service
Wants=sshd.service
After=cloud-init-local.service
After=systemd-networkd-wait-online.service
After=network.service
After=network-online.target
Before=sshd-keygen.service
Before=sshd.service
Before=systemd-user-sessions.service

[Service]
Type=oneshot
ExecStart=/usr/bin/cloud-init init
RemainAfterExit=yes
TimeoutSec=0

# Output needs to appear in instance console output
StandardOutput=journal+console

[Install]
WantedBy=cloud-init.target
EOF
systemctl daemon-reload

unset HISTFILE
