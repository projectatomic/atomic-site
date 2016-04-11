---
title: New CentOS Atomic Host Release, with Docker 1.9.1
author: jbrooks
date: 2016-04-11 18:00:00 UTC
tags: docker, kubernetes, centos
published: true
comments: true
---

An updated version of CentOS Atomic Host (version 7.20160404) is now available for [download](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download), featuring significant updates to Docker (1.9.1) and to the [atomic run tool](https://github.com/projectatomic/atomic).

CentOS Atomic Host is a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host.

Version 1.9 of the atomic run tool now includes support for [storage backend migration](https://github.com/projectatomic/atomic/blob/master/docs/atomic-migrate.1.md), for downloading and deploying [specific atomic](https://github.com/projectatomic/atomic/blob/master/docs/atomic-host.1.md) [tree versions](http://blog.verbum.org/2015/12/15/new-atomic-host-verb-rpm-ostree-deploy/), and for displaying process information from all containers running on a host.

CentOS Atomic Host includes these core component versions:

* docker-1.9.1-25.el7.centos.x86_64
* kubernetes-1.2.0-0.9.alpha1.gitb57e8bd.el7.x86_64
* kernel-3.10.0-327.13.1.el7.x86_64
* atomic-1.9-4.gitff44c6a.el7.x86_64
* flannel-0.5.3-9.el7.x86_64
* ostree-2016.1-2.atomic.el7.x86_64
* etcd-2.2.5-1.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64

For more information on the new release, check out [this post](http://seven.centos.org/2016/04/download-updated-centos-atomic-host-today/) on the [CentOS blog](http://seven.centos.org/).
