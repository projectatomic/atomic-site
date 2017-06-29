---
title: Fedora Layered Image Release June 2017
author: amiller
date: 2017-06-28 19:00:00 UTC
tags: docker, containers, OCI, fedora, atomic host
published: true
comments: true
---

On behalf of the [Fedora Atomic WG](https://pagure.io/atomic-wg) and
[Fedora Release Engineering](https://docs.pagure.org/releng/),
I am pleased to announce the latest Fedora Layered
Image Release. This follows the latest Atomic Host Release that came
out yesterday.

READMORE

At this time the following Container Images are available in the
Fedora Registry.

## Updated Base Images:

(Note that the "latest" tag currently points to "25" and the "rawhide"
tag currently points to "27", if no tag is provided in your pull
command then it will always default to "latest")

* registry.fedoraproject.org/fedora:latest
* registry.fedoraproject.org/fedora:rawhide
* registry.fedoraproject.org/fedora:27
* registry.fedoraproject.org/fedora:26
* registry.fedoraproject.org/fedora:25

## Updated Layered Images:

(Note: Layered Images are namespaced in the registry and at this time
we are only releasing for the f25 namespace.)

```
registry.fedoraproject.org/f25/ruby:0-8.f25docker
registry.fedoraproject.org/f25/ruby:0
registry.fedoraproject.org/f25/ruby
registry.fedoraproject.org/f25/kubernetes-master:0.1-16.f25container
registry.fedoraproject.org/f25/kubernetes-master:0.1
registry.fedoraproject.org/f25/kubernetes-master
registry.fedoraproject.org/f25/kubernetes-kubelet:0-14.f25container
registry.fedoraproject.org/f25/kubernetes-kubelet:0
registry.fedoraproject.org/f25/kubernetes-kubelet
registry.fedoraproject.org/f25/redis:0-5.f25container
registry.fedoraproject.org/f25/redis:0
registry.fedoraproject.org/f25/redis
registry.fedoraproject.org/f25/etcd:0.1-15.f25container
registry.fedoraproject.org/f25/etcd:0.1
registry.fedoraproject.org/f25/etcd
registry.fedoraproject.org/f25/cockpit:135-10.f25container
registry.fedoraproject.org/f25/cockpit:135
registry.fedoraproject.org/f25/cockpit
registry.fedoraproject.org/f25/mongodb:0-5.f25container
registry.fedoraproject.org/f25/mongodb:0
registry.fedoraproject.org/f25/mongodb
registry.fedoraproject.org/f25/php:0-4.f25container
registry.fedoraproject.org/f25/php:0
registry.fedoraproject.org/f25/php
registry.fedoraproject.org/f25/s2i-base:1-13.f25container
registry.fedoraproject.org/f25/s2i-base:1
registry.fedoraproject.org/f25/s2i-base
registry.fedoraproject.org/f25/nodejs:0-5.f25container
registry.fedoraproject.org/f25/nodejs:0
registry.fedoraproject.org/f25/nodejs
registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1-15.f25container
registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1
registry.fedoraproject.org/f25/kubernetes-controller-manager
registry.fedoraproject.org/f25/mariadb:10.1-13.f25container
registry.fedoraproject.org/f25/mariadb:10.1
registry.fedoraproject.org/f25/mariadb
registry.fedoraproject.org/f25/kubernetes-scheduler:0.1-15.f25container
registry.fedoraproject.org/f25/kubernetes-scheduler:0.1
registry.fedoraproject.org/f25/kubernetes-scheduler
registry.fedoraproject.org/f25/kubernetes-node:0.1-14.f25container
registry.fedoraproject.org/f25/kubernetes-node:0.1
registry.fedoraproject.org/f25/kubernetes-node
registry.fedoraproject.org/f25/kubernetes-proxy:0-15.f25container
registry.fedoraproject.org/f25/kubernetes-proxy:0
registry.fedoraproject.org/f25/kubernetes-proxy
registry.fedoraproject.org/f25/httpd:0-7.f25container
registry.fedoraproject.org/f25/httpd:0
registry.fedoraproject.org/f25/httpd
registry.fedoraproject.org/f25/toolchain:1-11.f25container
registry.fedoraproject.org/f25/toolchain:1
registry.fedoraproject.org/f25/toolchain
registry.fedoraproject.org/f25/kubernetes-apiserver:0.1-15.f25container
registry.fedoraproject.org/f25/kubernetes-apiserver:0.1
registry.fedoraproject.org/f25/kubernetes-apiserver
registry.fedoraproject.org/f25/mirrormanager2-mirrorlist:0.7.3-7.f25container
registry.fedoraproject.org/f25/mirrormanager2-mirrorlist:0.7.3
registry.fedoraproject.org/f25/mirrormanager2-mirrorlist
registry.fedoraproject.org/f25/flannel:0.1-13.f25container
registry.fedoraproject.org/f25/flannel:0.1
registry.fedoraproject.org/f25/flannel
```

The source of this content is provided in DistGit which can easily be
searched via the [container pkgdb namespace](https://admin.fedoraproject.org/pkgdb/packages/container/%2A/).

As always, we welcome feedback and would encourage anyone interested
to come join the Fedora Atomic WG as we continue to iterate on
integrating the Project Atomic family of technologies into Fedora.
Anyone interested in contributing Container Images, please feel free
to join in and [submit one for Review](https://fedoraproject.org/wiki/Container:Review_Process).
