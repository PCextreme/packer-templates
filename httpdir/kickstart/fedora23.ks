install
repo --name=fedora --mirrorlist https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
url --mirrorlist https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
eula --agreed

lang en_US.UTF-8
keyboard us
timezone --utc Europe/Amsterdam

network --onboot yes --device eth0 --bootproto dhcp
network  --hostname=fedora22
firewall --enabled --service=ssh

auth --useshadow --enablemd5
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --plaintext installer

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

text
skipx
zerombr

clearpart --all --initlabel

part / --size=1 --grow
part swap --size=512

%packages --ignoremissing
@core
%end

%post
yum update -y
yum install -y cloud-init
yum clean all
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
