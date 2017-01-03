install
text
url --mirrorlist https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
eula --agreed

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot yes --device ens3 --bootproto dhcp
network  --hostname=fedora24
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
acpid
at
bind-utils
binutils
cloud-init
curl
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
%end

%post
dnf upgrade -y
dnf clean all
sed -i '/^disable_root/s/true/false/ ; /^ssh_pwauth/s/0/1/' /etc/cloud/cloud.cfg
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
