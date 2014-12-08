---
author: jzb
comments: true
layout: post
title: "New CentOS Atomic image, Updated CentOS containers, and FreeIPA 4.1.2"
date: 2014-12-08 21:53 UTC
tags:
- CentOS
- Docker
categories:
- Blog
---
If you're running the [CentOS images released last month](http://www.projectatomic.io/blog/2014/11/centos-atomic-sig-image-ready-for-testing/), you'll notice that you can pull an update using `atomic update` that will pick up updates to a number of crucial packages (e.g. Docker) from base CentOS as well as additional packages carried by the Atomic SIG.

We also have new [monthly images](http://buildlogs.centos.org/rolling/7/isos/x86_64/) up on CentOS.org, and a new pointer to the most recent images. 

Any time you want to grab the most recent CentOS Atomic Host image use:

 * [http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost.qcow2](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost.qcow2)
 * [http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-20141129_02.qcow2.xz](
http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-20141129_02.qcow2.xz)

The xz image is compressed, the uncompressed qcow image is good for importing directly into OpenStack or another cloud platform that requires uncompressed image URLs.

## Updated CentOS Containers

Worth noting that the CentOS Docker images have been updated as well on Docker Hub, so if you're using CentOS containers you may want to do a `docker pull` to update them or respin any images that are using CentOS as the base container. 

## New FreeIPA Container
[FreeIPA](http://www.freeipa.org/page/Main_Page) is an exciting project if you need an integrated security information management solution. The [CentOS FreeIPA Docker container](http://seven.centos.org/2014/12/freeipa-4-1-2-and-centos/) is super-useful if you want to use FreeIPA with minimal hassle. 

The CentOS FreeIPA container was updated last week to 4.1.2, which brings the CentOS FreeIPA container up to date with the most recent stable FreeIPA release. See the [CentOS.org post for more information](http://seven.centos.org/2014/12/freeipa-4-1-2-and-centos/). 

Of course, FreeIPA isn't the only containerized application available via the [CentOS repo on Docker Hub](https://registry.hub.docker.com/repos/centos/). You'll also find Wildfly, Nginx, MariaDB, and the Apache Web Server.
 
Have an idea for a new image for CentOS? If you have a Dockerfile you can [submit a pull request to the GitHub repo](https://github.com/CentOS/CentOS-Dockerfiles). Have questions about the CentOS containers? Ask for help on the centos-devel mailing list or in #centos-devel on Freenode. 

