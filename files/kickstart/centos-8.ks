# Partition clearing information
clearpart --none --initlabel

# Use text based install
text
install
eula --agreed

# Network
network  --bootproto=dhcp --device=ens4 --ipv6=auto --activate
network  --hostname=centos8

# Repos
repo --name=base --baseurl=http://mirror.centos.org/centos-8/8.3.2011/BaseOS/x86_64/os/
url --url=http://mirror.centos.org/centos-8/8.3.2011/BaseOS/x86_64/os/

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Root password
rootpw --plaintext installer

# Disable the Setup Agent on first boot
firstboot --disabled

# Do not configure the X Window System
skipx

# System services
services --enabled="chronyd"

# System timezone
timezone Europe/Amsterdam --isUtc

# Disk partitioning information
part / --fstype xfs --fsoptions="rw,noatime" --size=1 --grow
#autopart --type=lvm

# Enable SELinux
selinux --enforcing

# Package installation
%packages
@^server-product-environment
qemu-guest-agent
acpid
bind-utils
binutils
cloud-init
cloud-utils-growpart
curl
git
iotop
ipset
lsof
nano
net-tools
nmap
pciutils
rsync
tcpdump
unzip
uuid
vim-enhanced
wget
-alsa-*
-ivtv*
-iwl*firmware
%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

# Post scripts
%post
dnf update -y
dnf clean all
sed -i '/^disable_root/s/1/0/ ; /^disable_root/s/true/false/ ; /^ssh_pwauth/s/0/1/ ; /^ssh_pwauth/s/false/true/' /etc/cloud/cloud.cfg
%end

reboot
