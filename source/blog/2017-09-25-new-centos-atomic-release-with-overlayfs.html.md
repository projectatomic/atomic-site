---
title: New CentOS Atomic Release and Kubernetes System Containers Now Available
author: jbrooks
date: 2017-09-25 18:15:00 UTC
tags: atomic, centos, docker
comments: false
published: true
---

The CentOS Atomic SIG has [released an updated version](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) of
CentOS Atomic Host (7.1708), a lean operating system designed to run
Linux containers, built from standard CentOS 7 RPMs, and tracking the
component versions included in Red Hat Enterprise Linux Atomic Host.

This release, which is [based on the RHEL 7.4 source code](https://seven.centos.org/2017/08/centos-linux-7-1708-based-on-rhel-7-4-source-code/),
includes an updated kernel that supports overlayfs container storage,
among other enhancements.

READMORE

CentOS Atomic Host includes these core component versions:

* atomic-1.18.1-3.1.git0705b1b.el7.x86_64
* cloud-init-0.7.9-9.el7.centos.2.x86_64
* docker-1.12.6-48.git0fdc778.el7.centos.x86_64
* etcd-3.1.9-2.el7.x86_64
* flannel-0.7.1-2.el7.x86_64
* kernel-3.10.0-693.2.2.el7.x86_64
* kubernetes-node-1.5.2-0.7.git269f928.el7.x86_64
* ostree-2017.7-1.el7.x86_64
* rpm-ostree-client-2017.6-6.atomic.el7.x86_64

## OverlayFS Storage

In previous releases of CentOS Atomic Host, SELinux had to be in
permissive or disabled mode for OverlayFS storage to work. Now you can
run the OverlayFS file system with SELinux in enforcing mode. CentOS
Atomic Host still defaults to devicemapper storage, but you can switch
to OverlayFS using the following commands:

```
$ systemctl stop docker
$ atomic storage reset
# Reallocate space to the root VG - tweak how much to your liking
$ lvm lvextend -r -l +50%FREE atomicos/root
$ atomic storage modify --driver overlay2
$ systemctl start docker
```

For more information on storage management options, see [the
RHEL documentation about container storage](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/managing_containers/#overlay_graph_driver).

## Containerized Master

CentOS Atomic Host ships without the kubernetes-master package built
into the image. For information on how to run these kubernetes
components as system containers, [consult the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download).

If you prefer to run Kubernetes from installed rpms, you can layer the
master components onto your Atomic Host image using rpm-ostree package
layering with the command: `atomic host install kubernetes-master -r`.

## Download CentOS Atomic Host

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted
Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image.
For links to media, [see the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download).

## Upgrading

If you're running a previous version of CentOS Atomic Host, you can
upgrade to the current image by running the following command:

```
$ sudo atomic host upgrade
```

## Release Cycle

The CentOS Atomic Host image follows the upstream Red Hat Enterprise
Linux Atomic Host cadence. After sources are released, they're rebuilt
and included in new images. After the images are tested by the SIG and
deemed ready, we announce them.

## Getting Involved

CentOS Atomic Host is produced by the [CentOS Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic), based on
upstream work from Project Atomic. If
you'd like to work on testing images, help with packaging,
documentation &mdash; join us!

The SIG meets every two weeks on Tuesday at 04:00 UTC in
`#centos-devel` on irc.freenode.net, and on the alternating weeks, meets as part of the
Project Atomic community meeting at 16:00 UTC on Monday in the #atomic
channel. You'll often find us in #atomic and/or #centos-devel if you
have questions. You can also join the [atomic-devel mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) if you'd like to discuss the direction of Project Atomic, its
components, or have other questions.

## Getting Help

If you run into any problems with the images or components, feel free
to ask on the [centos-devel](http://lists.centos.org/mailman/listinfo/centos-devel) mailing list.

Have questions about using Atomic? See [the atomic mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) 
or find us in the #atomic channel on Freenode.
