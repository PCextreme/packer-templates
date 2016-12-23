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

bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

skipx
zerombr

clearpart --all --initlabel

part / --fstype xfs --size=1 --grow
part swap --size=512

%packages --ignoremissing
@core
%end

%post
dnf upgrade -y
dnf install -y cloud-init
dnf clean all
echo "This template was provided by PCextreme B.V." > /root/.pcextreme
%end

firstboot --disabled
reboot
