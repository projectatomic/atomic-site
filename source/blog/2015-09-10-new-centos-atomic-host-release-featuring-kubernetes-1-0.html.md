---
title: New CentOS Atomic Host Release, Featuring Kubernetes 1.0
author: jbrooks
date: 2015-09-10 21:34:55 UTC
tags: centos, atomic, kubernetes, docker
comments: true
published: true
---

Big news, fans of all things Atomic -- the [CentOS Project's](https://www.centos.org/) [Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic) has released an updated CentOS Atomic Host system tree and image set, which includes [Kubernetes](http://kubernetes.io/) v1:

READMORE

>Today we’re releasing a significant update to the CentOS Atomic Host (version 7.20150908), a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host.

>CentOS Atomic Host is available as a [VirtualBox](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Vagrant-Virtualbox.box) or [libvirt-formatted](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Vagrant-Libvirt.box) Vagrant box, as an installable [ISO image](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Installer.iso), as a [qcow2 image](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-GenericCloud.qcow2.gz), or as an Amazon Machine Image. These images are available for download at cloud.centos.org. The backing ostree repo is published to mirror.centos.org.

>Currently, the CentOS Atomic Host includes these core component versions:

> * kernel 3.10.0-229
> * docker 1.7.1-108
> * kubernetes 1.0.0-0.8.gitb2dafda
> * etcd 2.0.13-2
> * flannel 0.2.0-10
> * cloud-init 0.7.5-10
> * ostree 2015.6-4
> * atomic 1.0-108

For more information, go check out the [release announcement](http://seven.centos.org/2015/09/announcing-a-new-release-of-centos-atomic-host/) at the CentOS project blog. If you're particularly impatient, vagrant offers the fastest route to getting up and running with the new image:

```
$ vagrant init centos/atomic-host && vagrant up
```