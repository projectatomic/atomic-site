---
title: Changes to Kickstarts for Fedora Atomic 26
author: jberkus
date: 2017-07-17 18:00:00 UTC
published: true
comments: true
tags: atomic, fedora, fedora 26
---

As you know, I'm all about [installing Atomic on bare metal using kickstarts](blog/2016/10/install-with-kickstart/).  And one of the things which has changed with Fedora Atomic 26 is some of the tags and locations you need for your kickstarts.  You'll find that your old kickstarts no longer work.

READMORE

First, your `ostreesetup` line needs to change. Here's my new one:

```
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic-26" --url="file:///ostree/repo" --ref="fedora/26/x86_64/atomic-host" --nogpg
```

Three things changed here.  First, the `remote` is now &quot;fedora-atomic-26&quot; instead of just &quot;fedora-atomic&quot; (`osname` can really be whatever you want). This is a temporary measure until we [merge all of the repos for continuous upgrade](https://fedoramagazine.org/upcoming-fedora-atomic-lifecycle-changes/).  Second, the `url` to install from local media has changed to the simpler &quot;file:///ostree/repo&quot;.  Third, the upstream `ref` is now &quot;fedora/26/x86_64/atomic-host&quot;, which both removes the reference to a specific container runtime from the edition and makes the urls consistent with other Fedora Editions.

We can also stop disabling cloud-init for Anaconda (bare metal) installs:

```
services --enabled="systemd-timesyncd"
```

Previously, we'd have added `--disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"` in that line, but Anaconda now automatically disables cloud-init since it won't be used for a local install, so we don't have to.  

In `%post` where I add in the final configuration for ostree, I also had to change the `url` and `remote`:

```
ostree remote add --if-not-exists --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-26-primary fedora-atomic-26 https://kojipkgs.fedoraproject.org/atomic/26
```

There's also some other nice improvements there. First, gpg-signing of upgrades and rebases works consistently, so we're adding in gpg checking.  Second, `--if-not-exists` is a nice ostree feature which lets us add remotes idempotently, to better work with Ansible and other config management software.  It's not actually useful here since we're deleting the prior remote, but it's a good idea to get into using it in general (and naming your remotes uniquely).

Below is a completed example kickstart, with all of the changes, which installs Fedora Atomic with OverlayFS to One Big Volume of 60GB and static networking.  Note that in Fedora Atomic 27, One Big Volume will be the default.

```
install
reboot
lang en_US.UTF-8
keyboard us
timezone --utc America/Los_Angeles
selinux --enforcing
zerombr
clearpart --all --initlabel
bootloader --location=mbr --boot-drive=sda
reqpart --add-boot
#part /boot --size=300 --fstype="ext4" --ondisk=sda
part pv.01 --grow --ondisk=sda
volgroup atomicos pv.01
logvol / --size=57000 --fstype="xfs" --name=root --vgname=atomicos
logvol swap --fstype swap --name=lv_swap --vgname=atomicos --size=2048
services --enabled="systemd-timesyncd"
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic-26" --url="file:///ostree/repo" --ref="fedora/26/x86_64/atomic-host" --nogpg

network --device=link --bootproto=static --ip=192.168.1.101 --netmask=255.255.255.0 --hostname=node1.projectatomic.rocks --gateway=192.168.1.1 --nameserver=192.168.1.100

user --name=atomic --groups=wheel --password=atomic

%post --erroronfail
rm -f /etc/ostree/remotes.d/fedora-atomic.conf
ostree remote add --if-not-exists --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-26-primary fedora-atomic-26 https://kojipkgs.fedoraproject.org/atomic/26
echo -e "\nSTORAGE_DRIVER='overlay2'\nCONTAINER_ROOT_LV_MOUNT_PATH=''\n" >> /etc/sysconfig/docker-storage-setup
%end
```
