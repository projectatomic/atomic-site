---
title: New CentOS Atomic Host with Optional Docker 1.12
author: jbrooks
date: 2016-10-18 17:50:04 UTC
tags: docker, centos,  swarm
published: false
comments: true
---

Last week, the CentOS Atomic SIG [released](https://seven.centos.org/2016/10/new-centos-atomic-host-with-optional-docker-1-12/) an updated version of CentOS Atomic Host (tree version 7.20161006), which offers users the option of substituting the host’s default docker 1.10 container engine with a more recent, docker 1.12-based version, provided via the docker-latest package.

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box; or as an installable ISO, qcow2, or Amazon Machine image. Check out the [CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) for download links and installation instructions, or read on to learn more about what’s new in this release.

READMORE

CentOS Atomic Host includes these core component versions:

* atomic-1.10.5-7.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64
* docker-1.10.3-46.el7.centos.14.x86_64
* etcd-2.3.7-4.el7.x86_64
* flannel-0.5.3-9.el7.x86_64
* kernel-3.10.0-327.36.1.el7.x86_64
* kubernetes-1.2.0-0.13.gitec7364b.el7.x86_64
* ostree-2016.7-2.atomic.el7.x86_64

## docker-latest

You can switch to the alternate docker version by running:

```
# systemctl disable docker --now
# systemctl enable docker-latest --now
# sed -i '/DOCKERBINARY/s/^#//g' /etc/sysconfig/docker
```

You cannot run both docker and docker-latest at the same time on the same system.

After enabling docker-latest on a trio of CentOS Atomic hosts, I thought I'd try out one of the major docker 1.12 features, [swarm](https://docs.docker.com/engine/swarm/swarm-tutorial/create-swarm/).

```
# docker swarm init --advertise-addr 10.10.171.201
Swarm initialized: current node (e4w8o2f842vgn5yl77koi88m6) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-5db4knvzzljlkmpyzgqf58x2blzim0nn8r63qvzp5r14fs22m2-3mkjppcdeenqlcxgcudra98rl \
    10.10.171.201:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

I ran the command provided on two additional CentOS Atomic hosts on which I'd also enabled docker-latest, and started up *hello world* service recommended in the swarm docs:

```
# docker service create --replicas 3 --name helloworld alpine ping docker.com

# docker service inspect --pretty helloworld
ID:		2ysb3w0v5c80fc01mibxpa9un
Name:		helloworld
Mode:		Replicated
 Replicas:	3
Placement:
UpdateConfig:
 Parallelism:	1
 On failure:	pause
ContainerSpec:
 Image:		alpine
 Args:		ping docker.com
Resources:
```

I'm more familiar with kubernetes than with swarm, so I'm interested to hear about your own docker 1.12 use cases and how you fare with them on CentOS Atomic.
