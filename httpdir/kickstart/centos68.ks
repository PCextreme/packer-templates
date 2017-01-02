install
text
url --url http://mirror.pcextreme.nl/centos/6/os/x86_64/
repo --name=updates --baseurl=http://mirror.pcextreme.nl/centos/6/updates/x86_64/

lang en_US.UTF-8
keyboard us
timezone --utc UTC

network --onboot yes --device eth0 --bootproto dhcp
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

part / --fstype xfs --fsoptions="rw,noatime" --size=1 --grow
part swap --size=512

%post
yum upgrade -y
yum clean all
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
