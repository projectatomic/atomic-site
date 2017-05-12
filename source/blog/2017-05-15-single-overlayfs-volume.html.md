---
title: Installing One Big Volume with Overlay2
author: jberkus
date: 2017-05-12 14:00:00 UTC
published: true
comments: true
tags: atomic, fedora, overlayfs
---

One of the major benefits of the overlay2 filesystem for Docker is that you no longer need to have a separate storage volume for your Docker containers, images and volumes.  This means that you don't need to try to decide how much free space you need in the root FS as opposed to how much you need for containers; you can just create one big volume to fill up the disk.

Since overlay2 is fairly new, though, we've chosen to install a separate Docker volume by default on Fedora 26 Atomic Host.  This lets users switch back to devicemapper if they run into some kind of issue with overlay2.  However, if you're installing a new dev system, you might want the ease-of-management of having one big volume.

READMORE

The best way to do this is via your kickstart or cloud-init files, so that you can have the one big volume.  I'm going to give examples for a kickstart file because that's what I have for my microcluster.  First, modify the storage setup in your kickstart file so that the root volume takes up all the disk space not needed for the boot partition or swap.

```
part pv.01 --grow --ondisk=sda
volgroup atomicos pv.01
logvol / --size=57000 --fstype="xfs" --name=root --vgname=atomicos
logvol swap --fstype swap --name=lv_swap --vgname=atomicos --size=2048
```

Second, add a script to your kickstarter file which changes the configuration for docker-storage-setup:

```
%post --erroronfail
rm -f /etc/ostree/remotes.d/fedora-atomic.conf
ostree remote add --set=gpg-verify=false fedora-atomic 'http://dl.fedoraproject.org/pub/fedora/linux/atomic/25/'
echo -e "\nSTORAGE_DRIVER='overlay2'\nCONTAINER_ROOT_LV_MOUNT_PATH=''\n" >> /etc/sysconfig/docker-storage-setup
%end
```

It's the last line of the script which is doing the work.  Specifically, you need to change the defaults for `docker-storage-setup`.   `STORAGE_DRIVER` needs to be set to `overlay2` and `CONTAINER_ROOT_LV_MOUNT_PATH` needs to be set to an empty string.  This tells `docker-storage-setup` to use overlay2, but not to create a separate volume for it (which would fail anyway, since we've left it no space).

The result is what you'd expect: one big volume for files and containers:

 ```
 -bash-4.3# lsblk
NAME                 MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb                    8:16   1   7.2G  0 disk
├─sdb2                 8:18   1   5.2M  0 part
└─sdb1                 8:17   1     1G  0 part
sda                    8:0    0  59.2G  0 disk
├─sda2                 8:2    0     1G  0 part /boot
├─sda3                 8:3    0  56.2G  0 part
│ ├─atomicos-lv_swap 253:1    0     2G  0 lvm  [SWAP]
│ └─atomicos-root    253:0    0  55.7G  0 lvm  /sysroot
└─sda1                 8:1    0   200M  0 part /boot/efi
```

At some point in the future, we may switch to this behavior by default.  Or not; tell us what you think through the Atomic community if you have an opinion.
