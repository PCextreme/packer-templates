echo "install set-hostname-script"
cat > /etc/dhcp/dhclient-exit-hooks.d/sethostname <<'EOM'
#!/bin/sh
# dhclient change hostname script for Ubuntu
# /etc/dhcp/dhclient-exit-hooks.d/sethostname
# logs in /var/log/upstart/network-interface-eth0.log

# for debugging:
echo "cloudstack-sethostname BEGIN"
export
set -x

statefile="/var/lib/misc/cloudstack-hostname-set"

if [ -f "$statefile" ]; then
    exit 0
fi

if [ $reason = "BOUND" ]; then
    echo new_ip_address=$new_ip_address
    echo new_host_name=$new_host_name
    echo new_domain_name=$new_domain_name

    oldhostname=$(hostname -s)
    if [ $oldhostname != $new_host_name ]; then

        # Rename Host
        echo $new_host_name > /etc/hostname
        hostname -F /etc/hostname

        # Update /etc/hosts if needed
        TMPHOSTS=/tmp/hosts.dhcp.new
        if ! grep "$new_ip_address $new_host_name.$new_domain_name $new_host_name" /etc/hosts; then
            # Remove the 127.0.1.1 put there by the debian installer
            grep -v '127\.0\.1\.1 ' < /etc/hosts > $TMPHOSTS
            # Add the our new ip address and name
            echo "$new_ip_address $new_host_name.$new_domain_name $new_host_name" >> $TMPHOSTS
            mv $TMPHOSTS /etc/hosts
        fi

        # Recreate SSH2 keys
        export DEBIAN_FRONTEND=noninteractive 
        dpkg-reconfigure openssh-server

        # Script should run once and not set the hostname on every boot
        touch $statefile
    fi
fi
echo "cloudstack-sethostname END"
EOM
chmod 644 /etc/dhcp/dhclient-exit-hooks.d/sethostname

