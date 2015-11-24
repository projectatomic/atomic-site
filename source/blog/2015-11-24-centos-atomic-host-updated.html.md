---
title: CentOS Atomic Host Updated
author: jbrooks
date: 2015-11-24 12:00:00 UTC
tags: cockpit, fedora, atomic, systemd, cloud-init, docker
comments: true
published: true
---

The CentOS Atomic SIG has released an updated filesystem tree and new set of deployment/installation images, featuring updates to docker and atomic, among other components. 

Check out the details below, and stay tuned for the next CentOS Atomic Host update, which should arrive soon after the main CentOS Project finishes building its [next major release](http://seven.centos.org/2015/11/rhel-7-2-released-today/).

READMORE

> Today we're announcing an update to CentOS Atomic Host (version 7.20151118), a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host. Please note that this release is based on content derived from the upstream 7.1 release.

> CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. These images are available for download at [cloud.centos.org](http://cloud.centos.org/centos/7/atomic/images/). The backing ostree repo is published to [mirror.centos.org](http://mirror.centos.org/centos/7/atomic/x86_64/repo).

> CentOS Atomic Host includes these core component versions:

> * kernel-3.10.0-229.20.1.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64
* atomic-1.6-6.gitca1e384.el7.x86_64
* kubernetes-1.0.3-0.2.gitb9a88a7.el7.x86_64
* etcd-2.1.1-2.el7.x86_64
* ostree-2015.6-4.atomic.el7.x86_64
* docker-1.8.2-7.el7.centos.x86_64
* flannel-0.2.0-10.el7.x86_64

For more information about the release, check out the [announcement post](http://seven.centos.org/2015/11/centos-atomic-host-updated/) over at the CentOS Project blog.
