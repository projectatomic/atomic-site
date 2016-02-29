---
title: New CentOS Atomic Host Images Available for Download
author: jbrooks
date: 2016-02-29 21:49:31 UTC
tags: centos, docker, kubernetes
comments: true
published: true
---

There's an updated filesystem tree and set of deployment/installation images available now for CentOS Atomic Host, which include a patched glibc and a refreshed set of Kubernetes packages, among other updates:

> An updated version of CentOS Atomic Host (version 7.20160224) is now available for download. CentOS Atomic Host is a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host.
>
> CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. These images are available for download at [cloud.centos.org](http://cloud.centos.org/centos/7/atomic/images/). The backing ostree repo is published to [mirror.centos.org](http://mirror.centos.org/centos/7/atomic/x86_64/repo).
>
> CentOS Atomic Host includes these core component versions:
>
> * kernel-3.10.0-327.10.1.el7.x86_64
> * cloud-init-0.7.5-10.el7.centos.1.x86_64
> * atomic-1.6-6.gitca1e384.el7.x86_64
> * kubernetes-1.2.0-0.6.alpha1.git8632732.el7.x86_64
> * etcd-2.2.2-5.el7.x86_64
> * ostree-2016.1-2.atomic.el7.x86_64
> * docker-1.8.2-10.el7.centos.x86_64
> * flannel-0.5.3-9.el7.x86_64

For more information about the release, check out the [announcement post](http://seven.centos.org/2016/02/new-centos-atomic-host-images-available-for-download/) over at the CentOS Project blog.