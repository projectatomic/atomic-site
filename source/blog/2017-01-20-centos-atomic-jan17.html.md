---
title: New CentOS Atomic Host with Containerized Kubernetes
author: jbrooks
date: 2017-01-19 10:00:00 UTC
tags: docker, centos, atomic host, kubernetes
published: true
comments: true
---

A new CentOS Atomic Host release (7.20170117), based on CentOS 7.1611,
is now available. Beyond the rebase to the new CentOS version, the
biggest change in this release is the removal of the kubernetes-master
package from the image, a change that we've inherited from RHEL
Atomic.

READMORE

You can run the master kubernetes components (apiserver, scheduler,
and controller-manager) in containers, managed via systemd, using the
service files and instructions on the [CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster). The containers
referenced in these systemd service files are built in and hosted from
the [CentOS Community Container Pipeline](https://wiki.centos.org/ContainerPipeline), based on Dockerfiles from
the [CentOS-Dockerfiles](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/kubernetes) repository.

I've tested these containers with the kubernetes ansible scripts
provided in the [upstream contrib repository](https://github.com/kubernetes/contrib/tree/master/ansible), and they work as
expected, provided you first copy the service files onto your master.
I've also tested the containers with a cluster already running
kubernetes as configured by the ansible scripts, and that case works
as well.

There is, however, [an SELinux issue](https://bugzilla.redhat.com/show_bug.cgi?id=1412803), the workaround for which is
running your kubernetes nodes in permissive mode. The fix for this
issue requires updating to the docker 1.12 version released this week
as part of this week's RHEL AH 7.3.2. As soon as docker and the rest
of the "atomic" packages are built for CentOS, we'll test and release
an updated CentOS Atomic Host, along with refreshed media.

For now, if you wish to upgrade to 7.20170117, do so by running:

```
atomic host upgrade
```

If you aren't already running CentOS Atomic, you can download an image
from our [download page](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) on the CentOS wiki and upgrade that to the
latest tree.

## Components

CentOS Atomic Host 7.20170117 includes these core component versions:

* atomic-1.13.8-1.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64
* docker-1.10.3-59.el7.centos.x86_64
* etcd-2.3.7-4.el7.x86_64
* flannel-0.5.5-1.el7.x86_64
* kernel-3.10.0-514.2.2.el7.x86_64
* kubernetes-node-1.3.0-0.3.git86dc49a.el7.x86_64
* ostree-2016.11-2.atomic.el7.x86_64
