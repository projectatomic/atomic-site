---
author: scollier
layout: post 
comments: true
title: "How to rescue an Atomic host"
date: 2014-10-01
tags:
- Docker
- Atomic
categories:
- Blog
---

On a running Atomic system that you can boot into, you have two options for rollback. By default, atomic keeps the previously booted os tree; it will be available as a secondary bootloader entry. The first option is, while on a physical console, hold down shift to access the syslinux boot menu.  While logged into a running system, atomic rollback will swap the bootloader order to the previous tree. The second option is, while logged into a running system, type _atomic rollback_ which will swap the bootloader order to the previous tree.

There may be a time when you have an issue with the Atomic host and need to enter rescue mode to fix an issue.  In this article, we will explore how to do just that. 

READMORE

## Obtain the media and boot the system.

* Boot your system to the Atomic ISO image and follow the instructions to enter rescue mode.

* Arrow down to _Troubleshooting_, hit _Enter_
* Arrow down to _Rescue a RHEL Atomic Host system_, hit _Enter_
* Choose _Continue_ to allow the installer to find and mount the existing file systems.

Now you should have a prompt.

## Configure the environment in rescue mode.

* Activate the logical volumes.

Explore the existing partitions and LVM configuration.  You should have home, root and swap set up as logical volumes.  The _boot_ partition will be /dev/sda1.  Not the attributes before and after activating the volume. After activating the logical volume for _root_ it will have an _a_ attribute.  This means it is now active.

```
# lvm lvs

# lvchange -ay rah/root

# lvm lvs
```

* Mount the filesystems to gain access to everything. 

This path includes the _deployment_ which contains the _root_ filesystem that we need access to. 

```
# mount /dev/mapper/rah-rhel /mnt/sysimage/
```

The next step is to mount the /boot/ partition.  This article is assuming a default install.  However, to confirm where the _/boot_ partition is you can use _lsblk_ and _fdisk -l_.  _lsblk_ will give you a good overview of how the disks are allocated.  From that, you can also look at _fdisk -l_ for the parition marked bootable and mount it as follows. In addition, since the root filesystem is mounted and you are chrooted into the proper environment you can confirm the disk UUID is correct by comparing what _blkid_ reports and what's in _/etc/fstab_.

```
# lsblk

# cat /etc/fstab

# blkid /dev/sda1

# mount /dev/sda1 /boot
```

After the _/boot_ partition has been mounted, we can mount the rest of the filesystems.  Note here that the path includes _/mnt/sysimage/ostree/*_.  The last command uses systemd-nspawn to mount /dev/ and /proc/ appropriately inside the rescue environment.

```
# systemd-nspawn -D /mnt/sysimage/ostree/deploy/rhel-atomic-host/deploy/<CHECKSUM>/
```

At this point, you should have a functioning rescue environment.
