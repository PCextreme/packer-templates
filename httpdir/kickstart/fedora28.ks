install
text
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot yes --device eth0 --bootproto dhcp
network  --hostname=fedora28

auth --useshadow --enablemd5
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --plaintext installer

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet nomodeset"

skipx
zerombr

clearpart --all --drives=sda

part / --fstype xfs --fsoptions="rw,noatime" --size=1 --grow

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

%post
dnf update -y
dnf clean all
%end

firstboot --disabled
reboot
