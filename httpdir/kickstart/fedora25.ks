install
text
url --mirrorlist https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
eula --agreed

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot yes --device eno3 --bootproto dhcp
network  --hostname=fedora25
firewall --enabled --service=ssh

auth --useshadow --enablemd5
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --plaintext installer

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet nomodeset"

skipx
zerombr

clearpart --all --initlabel

part / --fstype xfs --fsoptions="rw,noatime" --size=1 --grow
part swap --size=512

%packages --ignoremissing
@core
cloud-init
at
binutils
curl
dstat
git
iotop
ipset
lsof
mc
mtr
nmap
pciutils
rsync
screen
strace
tcpdump
unzip
net-tools
uuid
wget
acpid
policycoreutils
iptraf-ng
policycoreutils-python
bind-utils
redhat-lsb-core
vim-enhanced
%end

%post
dnf upgrade -y
dnf clean all
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
