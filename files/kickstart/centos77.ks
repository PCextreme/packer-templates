ignoredisk --only-use=sda

# Partition clearing information
clearpart --none --initlabel

# Use text based install
text
install
eula --agreed

# Repos
repo --name=os --baseurl=https://centos.mirror.pcextreme.nl/7/os/x86_64/
repo --name=updates --baseurl=https://centos.mirror.pcextreme.nl/7/updates/x86_64/
repo --name=extras --baseurl=https://centos.mirror.pcextreme.nl/7/extras/x86_64/
url --url=https://centos.mirror.pcextreme.nl/7/os/x86_64/

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8

# Network
network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=centos8

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

# Enable SELinux
selinux --enforcing

# Package installation
%packages --ignoremissing
@core
acpid
at
bind-utils
binutils
cloud-init
cloud-utils
curl
deltarpm
dstat
git
iotop
ipset
iptraf-ng
lsof
mc
mtr
net-tools
nmap
pciutils
policycoreutils
policycoreutils-python
redhat-lsb-core
rsync
screen
strace
tcpdump
unzip
uuid
vim-enhanced
wget
nano
%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

# Post scripts
%post
yum update -y
yum clean all
sed -i '/^disable_root/s/1/0/ ; /^disable_root/s/true/false/ ; /^ssh_pwauth/s/0/1/ ; /^ssh_pwauth/s/false/true/' /etc/cloud/cloud.cfg
%end

reboot
