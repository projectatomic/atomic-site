---
title: Fedora Layered Image Release August 2017
author: jberkus
date: 2017-08-30 12:00:00 UTC
tags: containers, OCI, fedora, atomic host
published: true
comments: true
---

The [Fedora Atomic WG](https://pagure.io/atomic-wg) and
[Fedora Release Engineering](https://docs.pagure.org/releng/) teams have updated the Fedora Layered Image Registry.  With this latest release, images based on Fedora 26 are now available, in addition to the images which were already available based on Fedora 25.  This update also includes "fedora-minimal" images for all active releases, each containing a stripped-down version of Fedora at about 100MB in size.

READMORE

At this time the following Container Images are available in the [Fedora Registry](https://fedoraproject.org/wiki/Atomic/FLIBS_Catalog):

Updated Base Images:

* registry.fedoraproject.org/fedora:latest
* registry.fedoraproject.org/fedora:rawhide
* registry.fedoraproject.org/fedora:28
* registry.fedoraproject.org/fedora:27
* registry.fedoraproject.org/fedora:26
* registry.fedoraproject.org/fedora:25

Fedora-Minimal Images:

* registry.fedoraproject.org/fedora-minimal:latest
* registry.fedoraproject.org/fedora-minimal:rawhide
* registry.fedoraproject.org/fedora-minimal:28
* registry.fedoraproject.org/fedora-minimal:27
* registry.fedoraproject.org/fedora-minimal:26
* registry.fedoraproject.org/fedora-minimal:25

Fedora 25 Images:


* registry.fedoraproject.org/f25/kubernetes-scheduler:0.1-18.f25container
* registry.fedoraproject.org/f25/kubernetes-scheduler:0.1
* registry.fedoraproject.org/f25/kubernetes-scheduler
* registry.fedoraproject.org/f25/nodejs:0-8.f25container
* registry.fedoraproject.org/f25/nodejs:0
* registry.fedoraproject.org/f25/nodejs
* registry.fedoraproject.org/f25/kubernetes-apiserver:0.1-18.f25container
* registry.fedoraproject.org/f25/kubernetes-apiserver:0.1
* registry.fedoraproject.org/f25/kubernetes-apiserver
* registry.fedoraproject.org/f25/httpd:0-10.f25container
* registry.fedoraproject.org/f25/httpd:0
* registry.fedoraproject.org/f25/httpd
* registry.fedoraproject.org/f25/php:0-7.f25container
* registry.fedoraproject.org/f25/php:0
* registry.fedoraproject.org/f25/php
* registry.fedoraproject.org/f25/container-engine:0-3.f25container
* registry.fedoraproject.org/f25/container-engine:0
* registry.fedoraproject.org/f25/container-engine
* registry.fedoraproject.org/f25/kubernetes-proxy:0-18.f25container
* registry.fedoraproject.org/f25/kubernetes-proxy:0
* registry.fedoraproject.org/f25/kubernetes-proxy
* registry.fedoraproject.org/f25/redis:0-8.f25container
* registry.fedoraproject.org/f25/redis:0
* registry.fedoraproject.org/f25/redis
* registry.fedoraproject.org/f25/etcd:0.1-18.f25container
* registry.fedoraproject.org/f25/etcd:0.1
* registry.fedoraproject.org/f25/etcd
* registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1-18.f25container
* registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1
* registry.fedoraproject.org/f25/kubernetes-controller-manager
* registry.fedoraproject.org/f25/mongodb:0-7.f25container
* registry.fedoraproject.org/f25/mongodb:0
* registry.fedoraproject.org/f25/mongodb
* registry.fedoraproject.org/f25/mirrormanager2-mirrorlist:0.7.3-10.f25container
* registry.fedoraproject.org/f25/mirrormanager2-mirrorlist:0.7.3
* registry.fedoraproject.org/f25/mirrormanager2-mirrorlist
* registry.fedoraproject.org/f25/waiverdb:0-3.f25container
* registry.fedoraproject.org/f25/waiverdb:0
* registry.fedoraproject.org/f25/waiverdb
* registry.fedoraproject.org/f25/cockpit:135-13.f25container
* registry.fedoraproject.org/f25/cockpit:135
* registry.fedoraproject.org/f25/cockpit
* registry.fedoraproject.org/f25/mariadb:10.1-16.f25container
* registry.fedoraproject.org/f25/mariadb:10.1
* registry.fedoraproject.org/f25/mariadb
* registry.fedoraproject.org/f25/ruby:0-11.f25docker
* registry.fedoraproject.org/f25/ruby:0
* registry.fedoraproject.org/f25/ruby
* registry.fedoraproject.org/f25/s2i-base:1-16.f25container
* registry.fedoraproject.org/f25/s2i-base:1
* registry.fedoraproject.org/f25/s2i-base
* registry.fedoraproject.org/f25/flannel:0.1-15.f25container
* registry.fedoraproject.org/f25/flannel:0.1
* registry.fedoraproject.org/f25/flannel
* registry.fedoraproject.org/f25/kubernetes-master:0.1-20.f25container
* registry.fedoraproject.org/f25/kubernetes-master:0.1
* registry.fedoraproject.org/f25/kubernetes-master
* registry.fedoraproject.org/f25/toolchain:1-14.f25container
* registry.fedoraproject.org/f25/toolchain:1
* registry.fedoraproject.org/f25/toolchain
* registry.fedoraproject.org/f25/kubernetes-node:0.1-17.f25container
* registry.fedoraproject.org/f25/kubernetes-node:0.1
* registry.fedoraproject.org/f25/kubernetes-node
* registry.fedoraproject.org/f25/kubernetes-kubelet:0-17.f25container
* registry.fedoraproject.org/f25/kubernetes-kubelet:0
* registry.fedoraproject.org/f25/kubernetes-kubelet
* registry.fedoraproject.org/f25/docker:0-7.f25container
* registry.fedoraproject.org/f25/docker:0
* registry.fedoraproject.org/f25/docker

Fedora 26 Images:


* registry.fedoraproject.org/f26/kubernetes-scheduler:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-scheduler:0
* registry.fedoraproject.org/f26/kubernetes-scheduler
* registry.fedoraproject.org/f26/nodejs:0-3.f26container
* registry.fedoraproject.org/f26/nodejs:0
* registry.fedoraproject.org/f26/nodejs
* registry.fedoraproject.org/f26/kubernetes-apiserver:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-apiserver:0
* registry.fedoraproject.org/f26/kubernetes-apiserver
* registry.fedoraproject.org/f26/mariadb:10.1-11.f26container
* registry.fedoraproject.org/f26/mariadb:10.1
* registry.fedoraproject.org/f26/mariadb
* registry.fedoraproject.org/f26/kubernetes-proxy:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-proxy:0
* registry.fedoraproject.org/f26/kubernetes-proxy
* registry.fedoraproject.org/f26/redis:0-3.f26container
* registry.fedoraproject.org/f26/redis:0
* registry.fedoraproject.org/f26/redis
* registry.fedoraproject.org/f26/python3:0-2.f26container
* registry.fedoraproject.org/f26/python3:0
* registry.fedoraproject.org/f26/python3
* registry.fedoraproject.org/f26/etcd:0.1-6.f26container
* registry.fedoraproject.org/f26/etcd:0.1
* registry.fedoraproject.org/f26/etcd
* registry.fedoraproject.org/f26/kubernetes-controller-manager:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-controller-manager:0
* registry.fedoraproject.org/f26/kubernetes-controller-manager
* registry.fedoraproject.org/f26/python-classroom:0.3-3.f26container
* registry.fedoraproject.org/f26/python-classroom:0.3
* registry.fedoraproject.org/f26/python-classroom
* registry.fedoraproject.org/f26/mongodb:0-3.f26container
* registry.fedoraproject.org/f26/mongodb:0
* registry.fedoraproject.org/f26/mongodb
* registry.fedoraproject.org/f26/mirrormanager2-mirrorlist:0.7.3-9.f26container
* registry.fedoraproject.org/f26/mirrormanager2-mirrorlist:0.7.3
* registry.fedoraproject.org/f26/mirrormanager2-mirrorlist
* registry.fedoraproject.org/f26/waiverdb:0-3.f26container
* registry.fedoraproject.org/f26/waiverdb:0
* registry.fedoraproject.org/f26/waiverdb
* registry.fedoraproject.org/f26/docker-distribution:2.5.1-3.f26container
* registry.fedoraproject.org/f26/docker-distribution:2.5.1
* registry.fedoraproject.org/f26/docker-distribution
* registry.fedoraproject.org/f26/php:0-3.f26container
* registry.fedoraproject.org/f26/php:0
* registry.fedoraproject.org/f26/php
* registry.fedoraproject.org/f26/s2i-base:1-10.f26container
* registry.fedoraproject.org/f26/s2i-base:1
* registry.fedoraproject.org/f26/s2i-base
* registry.fedoraproject.org/f26/flannel:0.1-5.f26container
* registry.fedoraproject.org/f26/flannel:0.1
* registry.fedoraproject.org/f26/flannel
* registry.fedoraproject.org/f26/kubernetes-master:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-master:0
* registry.fedoraproject.org/f26/kubernetes-master
* registry.fedoraproject.org/f26/kubernetes-node:0-1.f26container
* registry.fedoraproject.org/f26/kubernetes-node:0
* registry.fedoraproject.org/f26/kubernetes-node
* registry.fedoraproject.org/f26/kubernetes-kubelet:0-2.f26container
* registry.fedoraproject.org/f26/kubernetes-kubelet:0
* registry.fedoraproject.org/f26/kubernetes-kubelet


The source of this content is provided in DistGit which can easily be
searched via the [container pkgdb namespace](https://admin.fedoraproject.org/pkgdb/packages/container/%2A/).

As always, we welcome feedback and would encourage anyone interested
to come join the Fedora Atomic WG as we continue to iterate on
integrating the Project Atomic family of technologies into Fedora.
Anyone interested in contributing Container Images, please feel free
to join in and [submit one for Review](https://fedoraproject.org/wiki/Container:Review_Process).
