---
title: Migrating the Docker Storage Driver to overlay2
author: miabbott
date: 2017-03-29 16:00:00 UTC
published: true
comments: true
tags: atomic, fedora, docker, overlay2
---

On the [Project Atomic mailing list](https://lists.projectatomic.io/projectatomic-archives/atomic/2017-March/msg00015.html), [Colin Walters](https://twitter.com/cgwalters) posted
a quick set of instructions on how to migrate the Docker storage driver from `devicemapper` to `overlay2` on Fedora Atomic Host.

The `overlay2` driver will be the default storage driver in Fedora 26, so making this change will give you a chance to test out your workloads
before the Fedora 26 release.

Colin noted that the folks working on the `atomic` CLI are developing a way to [migrate all of your images and containers](https://trello.com/c/vAunYr5K/310-docker-storage-migrate-images-containers-when-switching-drivers) when you want to switch storage drivers.  Until that work is complete, the only way to switch drivers is destructive and results in a loss of your images and containers.

Instead of using the raw commands noted in the email, we can do much of the same thing using the `atomic` CLI.

**WARNING** These steps should only be performed if you understand that this will destroy all of your containers, images, and volumes.

```
$ systemctl stop docker
$ atomic storage reset
  # Reallocate space to the root VG - tweak how much to your liking
$ lvm lvextend -r -l +50%FREE atomicos/root
  # Note, this 'atomic modify' command is currently broken in Fedora 25 Atomic Host (See https://bugzilla.redhat.com/show_bug.cgi?id=1437136)
$ atomic storage modify --driver overlay2
$ systemctl start docker
```

READMORE

If you want to perform the migration without using the `atomic` CLI, you can use the raw commands.

```
$ systemctl stop docker
$ rm /var/lib/docker/* -rf
$ lvm lvremove atomicos/docker-pool
  # Reallocate space to the root - tweak how much to your liking
$ lvm lvextend -r -l +50%FREE atomicos/root
$ echo STORAGE_DRIVER=overlay2 >> /etc/sysconfig/docker-storage-setup
$ rm /etc/sysconfig/docker-storage
$ systemctl start docker
```
