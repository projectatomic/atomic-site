---
title: "Subatomic cluster install with Kickstart"
author: jberkus
date: 2016-08-27 12:00:00 UTC
tags: atomic host, administration, microcluster
published: true
comments: true
---

In my previous install of the [Subatomic Cluster](), I simply did the manual Ananconda install.  However, since this cluster is for testing, I wanted a way to re-install it rapidly so that I can test out various builds of Atomic.

I also wanted to fix the disk allocation.  Due to various limitations, the initial root partition for a new Atomic Host is of fixed size (3GB) regardless of the amount of disk space available.  I wanted to increase that to 1/4 of the 64GB size of each SSD.  

Enter Kickstart, which is the standard installation automation system used by Fedora, CentOS, RHEL, and other Linux distributions.  I was more familiar with Kickstart as part of a PXEboot network install, and re-installing the cluster required something simpler.  In this case, a Kickstart file on the network, combined with editing the boot line for install.  Since the Kickstart documentation is extensive enough to be confusing, here's some details.  

First, I created an atomic-ks.cfg file and dropped it on my laptop.  I've added comments in the example file so that you can understand what it's doing and modify it for your own use.  I then served this file on the local network just using `python -m SimpleHTTPServer`.

```
# install Fedora Atomic and then reboot automatically
install
reboot

# set language, keyboard and timezone
lang en_US.UTF-8
keyboard us
timezone --utc America/Los_Angeles

#erase all existing boot records and partitions
zerombr
clearpart --all --initlabel

# create a boot record and a boot partition
bootloader --location=mbr --boot-drive=sda
reqpart --add-boot

# create an LVM partition and volume group
part pv.01 --grow --ondisk=sda
volgroup atomicos pv.01

# create root directory 16GB in size.
logvol / --size=16000 --fstype="xfs" --name=root --vgname=atomicos

# create a swap partition 2GB in size
logvol swap --fstype swap --name=lv_swap --vgname=atomicos --size=2048

# disable cloud-init so that the system will boot normally without an init ISO
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local"

# set up ostree to pull from the thumb drive
ostreesetup --osname="fedora-atomic" --remote="fedora-atomic" --url="file:////run/install/repo/content/repo" --ref="fedora-atomic/24/x86_64/docker-host" --nogpg

# turn on selinux
selinux --enforcing

# add some demo users and passwords
rootpw --plaintext fedora24
user --name=atomic --groups=wheel --password=atomic

# once the system boots, switch the ostree repo to be the upstream one so that
# we can pull a new ostree, then upgrade
%post --erroronfail
rm -f /etc/ostree/remotes.d/fedora-atomic.conf
ostree remote add --set=gpg-verify=false fedora-atomic 'http://dl.fedoraproject.org/pub/fedora/linux/atomic/24/'
rpm-ostree upgrade
%end
```

I then booted each minnowboard off the USB.  There was one manual step: I had to edit the grub boot menu and tell it to use the kickstart file.  When the boot menu comes up, I selected "Install Fedora 24", pressed "e" and edited the linuxefi boot line:

```
linuxefi /images/pxeboot/vmlinuz inst.ks=http://192.168.1.105:8000/atomic-ks.cfg inst.stage2=hd:LABEL=Fedora-Atomic-24-x86_64 quiet
```

After that, it's all automatic.  Anaconda will partition, install, and boot the system.

*Thanks to Dusty Mabe and Matthew Micene for helping me create this Kickstart config and troubleshoot it*
