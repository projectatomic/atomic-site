---
title: New CentOS Atomic Host with Updated Docker, Kubernetes and Etcd
author: jbrooks
date: 2017-02-17 11:00:00 UTC
tags: kubernetes, docker, etcd, centos
comments: true
published: true
---

An updated version of CentOS Atomic Host (tree version 7.20170209), [is now available](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download), including significant updates to docker (version 1.12.5), kubernetes (version 1.4) and etcd (version 3.0.15).

CentOS Atomic Host is a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host.

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. These images are available for download at [cloud.centos.org](http://cloud.centos.org/centos/7/atomic/images/). The backing ostree repo is published to [mirror.centos.org](http://mirror.centos.org/centos/7/atomic/x86_64/repo).

CentOS Atomic Host includes these core component versions:

* atomic-1.14.1-5.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64
* docker-1.12.5-14.el7.centos.x86_64
* etcd-3.0.15-1.el7.x86_64
* flannel-0.5.5-2.el7.x86_64
* kernel-3.10.0-514.6.1.el7.x86_64
* kubernetes-node-1.4.0-0.1.git87d9d8d.el7.x86_64
* ostree-2016.15-1.atomic.el7.x86_64
* rpm-ostree-client-2016.13-1.atomic.el7.x86_64

## Containerized kubernetes-master

The downstream release of CentOS Atomic Host ships without the kubernetes-master package built into the image. Instead, you can run the master kubernetes components (apiserver, scheduler, and controller-manager) in containers, managed via systemd, using the service files and [instructions on the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster). The containers referenced in these systemd service files are built in and hosted from the [CentOS Community Container Pipeline](https://wiki.centos.org/ContainerPipeline), based on Dockerfiles from
the [CentOS-Dockerfiles repository](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/kubernetes).

These containers have been tested with the [kubernetes ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) provided in the upstream contrib repository, and they work as expected, provided you first copy the service files onto your master.

For more information, see the CentOS [project blog](https://seven.centos.org/2017/02/new-centos-atomic-host-with-updated-docker-kubernetes-and-etcd/) or the CentOS Atomic [download page](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download).
