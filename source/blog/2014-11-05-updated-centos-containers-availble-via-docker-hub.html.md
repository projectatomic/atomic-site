---
author: jzb
layout: blog
title: Updated CentOS Containers Availble via Docker Hub
date: 2014-11-05 17:08 UTC
tags:
- Docker
- CentOS
- Updates
---
The CentOS project [has updated its Docker Images](http://lists.centos.org/pipermail/centos-announce/2014-November/020735.html) on the Docker Hub for CentOS 5, CentOS 6, and CentOS 7.

If you're using CentOS containers, you can quickly update the image with `docker pull centos:centos6` (to get CentOS 6.6). This will grab the image if you don't have it locally, or update the image if you have it and just need to catch up to the latest release. 

The latest releases are:
 * CentOS 5.11
 * CentOS 6.6
 * CentOS 7.0.1406

Note that this updates the fakesystemd package to properly include dependencies for the lsb-base container, and has fixed some broken symlinks in the CentOS 7 container.

The CentOS Project also makes a number of pre-packaged container applications available on the [Docker Hub](https://registry.hub.docker.com/u/centos/). Currently you can choose from MariaDB, FreeIPA, Nginx, Apache httpd, and Wildfly. 

If you have any questions or have an interest in helping to package additional container applications, see the [centos-devel](http://lists.centos.org/mailman/listinfo/centos-devel) mailing list or join the conversation in #centos-devel on Freenode.
