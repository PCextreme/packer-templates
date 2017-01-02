install
repo --name=base --mirrorlist http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
repo --name=updates --mirrorlist http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
repo --name=extras --mirrorlist http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
url --mirrorlist http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
eula --agreed

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot yes --device eth0 --bootproto dhcp
network  --hostname=centos7
firewall --enabled --service=ssh
services --enabled=chronyd,rdisc

auth --useshadow --enablemd5
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --plaintext installer

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet nomodeset"

text
skipx
zerombr

clearpart --all --initlabel

part / --fstype xfs --size=1 --grow
part swap --size=512

%packages --nobase --ignoremissing
@core
@base
deltarpm
%end

%post
yum update -y
yum install -y cloud-init
yum clean all
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
