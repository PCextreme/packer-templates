install
text
repo --name=os --mirrorlist=http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=os
repo --name=updates --mirrorlist=http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=updates
repo --name=extras --mirrorlist=http://mirrorlist.centos.org/?release=6&arch=x86_64&repo=extras
cdrom

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot=on --device eth0 --bootproto=dhcp
network --hostname=centos6
firewall --enabled --service=ssh

auth --useshadow --enablemd5
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --plaintext installer

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet nomodeset"

skipx
zerombr

clearpart --all --initlabel

part / --fstype ext4 --fsoptions="rw,noatime" --size=1 --grow
part swap --size=512

%packages --ignoremissing
@core
acpid
at
bind-utils
binutils
cloud-init
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
ntp
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
%end

%post
yum upgrade -y
yum clean all
chkconfig cloud-init off
sed -i '/^disable_root/s/1/0/ ; /^ssh_pwauth/s/0/1/' /etc/cloud/cloud.cfg
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
