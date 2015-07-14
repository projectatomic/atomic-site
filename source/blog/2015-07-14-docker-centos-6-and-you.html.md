---
title: Docker, CentOS 6, and You
author: jbrooks
date: 2015-07-14 16:18:24 UTC
tags: docker, centos
comments: true
published: true
---

Recently, I blogged about [docker-on-loopback-storage woes and workarounds](http://www.projectatomic.io/blog/2015/06/notes-on-fedora-centos-and-docker-storage-drivers/) -- a topic that came up during several conversations I had at last month's Dockercon. Another frequently-discussed item from the conference involved Docker on CentOS 6, and whether and for how long users can count on running this combination.

Docker and CentOS 6 have never been a terrific fit, which shouldn't be surprising considering that the version of the Linux kernel that CentOS ships was first released over three years before Docker's first public release (0.1.0). The OS and kernel version you use matter a great deal, because with Docker, that's where all your contained processes run.

With a hypervisor such as KVM, it's not uncommon or problematic for an elder OS to host, through the magic of virtualization, all manner of bleeding-edge software components. In fact, if you're attached to CentOS 6, virtualization is a solid option for running containers in a more modern, if virtual, host.

READMORE

If you're set on CentOS 6, and set on hosting your containers on bare metal, you've had a few options, however. Docker has been available in EPEL, under the name [`docker-io`](https://dl.fedoraproject.org/pub/epel/6/x86_64/repoview/docker-io.html), for some time, although that package version has been sitting at 1.5.0 since February.

The Docker project, for its part, has counted CentOS 6 among its supported OSes, and provided CentOS 6 packages for the [1.7.0](https://get.docker.com/rpm/1.7.0/centos-6/RPMS/x86_64/docker-engine-1.7.0-1.el6.x86_64.rpm) release that dropped during the conference. Even then, the project includes this note of kernel-related caution:

> Docker requires a 64-bit installation regardless of your CentOS version. Also, your kernel must be 3.10 at minimum. CentOS 7 runs the 3.10 kernel, 6.5 does not. We make an exception for CentOS 6.5. To run Docker on CentOS-6.5 or later, you need kernel 2.6.32-431 or higher.

>*from: https://docs.docker.com/installation/centos/*

Kernel version exception or no, it didn't take long for users to encounter a [regression](https://github.com/docker/docker/issues/14024) in Docker 1.7.0 that prevented the service from starting on hosts running CentOS 6. Soon after, the project announced that beginning with the next major Docker release, CentOS 6 will exit the project's list of supported OSes:

> Current state of things:
> 
> Those distros are supported as per http://docs.docker.com/installation/rhel/and http://docs.docker.com/installation/centos/
> 
> Red Hat themselves only support Docker on RHEL7 (as stated by https://access.redhat.com/solutions/1378023, and confirmed by several people)
> 
> 1.7.0 is broken on these (most notably because of libnetwork bridge creation code: [#14024](https://github.com/docker/docker/issues/14024))
> 
> We shipped 1.7.0 without mentioning we would break compatibility, so this will be fixed in 1.7.1, but we will drop support in 1.8.0.

> *from: https://github.com/docker/docker/issues/14365*

There are already [release candidate packages](https://test.docker.com/rpm/1.7.1-rc1/centos-6/RPMS/x86_64/docker-engine-1.7.1-0.1.rc1.el6.x86_64.rpm) for 1.7.1 available to test now, but a somewhat longer-term solution will require a newer kernel. While the official CentOS 6 kernel won't be making any huge leaps forward, there's a newer kernel maintained by the CentOS [virtualization Special Interest Group](http://wiki.centos.org/SpecialInterestGroup/Virtualization) for its [Xen4CentOS](http://wiki.centos.org/Manuals/ReleaseNotes/Xen4-01) variant.

I installed this kernel on a CentOS 6 VM, alongside the 1.7.0 package from Docker, and managed to start and use Docker normally:

````
# yum install -y centos-release-xen
# echo includepkgs=kernel kernel-firmware >> /etc/yum.repos.d/CentOS-Xen.repo
# yum update -y kernel
# reboot
# yum install -y https://get.docker.com/rpm/1.7.0/centos-6/RPMS/x86_64/docker-engine-1.7.0-1.el6.x86_64.rpm
# service docker start
````
Docker worked fine -- I gave it a solid run-through using this slick [kubernetes-in-containers walkthrough](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/docker.md) and it performed as expected. 

I couldn't, however, figure out how to switch the default storage driver from loopback to direct-lvm. It's possible that I'd need a newer device-mapper package to make this work. 

If you're interested in helping figure out what additional dependencies are required to get and keep Docker running well on CentOS 6, check out this [mailing list thread](http://lists.centos.org/pipermail/centos-devel/2015-July/013585.html) about getting involved with the effort, or come introduce yourself in #centos-devel on Freenode.