---
title: Fedora Layered Image Release April 2017
author: amiller
date: 2017-04-24 18:00:00 UTC
tags: docker, containers, OCI, fedora, atomic host
published: true
comments: true
---

On behalf of the [Fedora Atomic WG](https://pagure.io/atomic-wg) and
[Fedora Release Engineering](https://docs.pagure.org/releng/),
I am pleased to announce the latest Fedora Layered
Image Release. This follows the latest Atomic Host Release that came
out [last week](/blog/2017/04/fedora_atomic_apr18/).

At this time the following Container Images are available in the
Fedora Registry:

READMORE

## Base Images

(Note that the "latest" tag currently points to "25" and the "rawhide"
tag currently points to "27", if no tag is provided in your pull
command then it will always default to "latest")

* registry.fedoraproject.org/fedora:latest
* registry.fedoraproject.org/fedora:rawhide
* registry.fedoraproject.org/fedora:27
* registry.fedoraproject.org/fedora:26
* registry.fedoraproject.org/fedora:25
* registry.fedoraproject.org/fedora:24

## Layered Images

(Note: Layered Images are namespaced in the registry and at this time
we are only releasing for the f25 namespace.)

* registry.fedoraproject.org/f25/cockpit:135-5.f25docker
* registry.fedoraproject.org/f25/cockpit:135
* registry.fedoraproject.org/f25/cockpit
* registry.fedoraproject.org/f25/kubernetes-node:0.1-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-node:0.1
* registry.fedoraproject.org/f25/kubernetes-node
* registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-controller-manager:0.1
* registry.fedoraproject.org/f25/kubernetes-controller-manager
* registry.fedoraproject.org/f25/mariadb:10.1-8.f25docker
* registry.fedoraproject.org/f25/mariadb:10.1
* registry.fedoraproject.org/f25/mariadb
* registry.fedoraproject.org/f25/kubernetes-apiserver:0.1-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-apiserver:0.1
* registry.fedoraproject.org/f25/kubernetes-apiserver
* registry.fedoraproject.org/f25/kubernetes-scheduler:0.1-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-scheduler:0.1
* registry.fedoraproject.org/f25/kubernetes-scheduler
* registry.fedoraproject.org/f25/kubernetes-master:0.1-10.f25docker
* registry.fedoraproject.org/f25/kubernetes-master:0.1
* registry.fedoraproject.org/f25/kubernetes-master
* registry.fedoraproject.org/f25/s2i-base:1-8.f25docker
* registry.fedoraproject.org/f25/s2i-base:1
* registry.fedoraproject.org/f25/s2i-base
* registry.fedoraproject.org/f25/kubernetes-kubelet:0-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-kubelet:0
* registry.fedoraproject.org/f25/kubernetes-kubelet
* registry.fedoraproject.org/f25/flannel:0.1-8.f25docker
* registry.fedoraproject.org/f25/flannel:0.1
* registry.fedoraproject.org/f25/flannel
* registry.fedoraproject.org/f25/kubernetes-proxy:0-9.f25docker
* registry.fedoraproject.org/f25/kubernetes-proxy:0
* registry.fedoraproject.org/f25/kubernetes-proxy
* registry.fedoraproject.org/f25/etcd:0.1-10.f25docker
* registry.fedoraproject.org/f25/etcd:0.1
* registry.fedoraproject.org/f25/etcd
* registry.fedoraproject.org/f25/toolchain:1-7.f25docker
* registry.fedoraproject.org/f25/toolchain:1
* registry.fedoraproject.org/f25/toolchain

The source of this content is provided in DistGit which can easily be
searched via the [container pkgdb namespace](https://admin.fedoraproject.org/pkgdb/packages/container/%2A/).

As always, we welcome feedback and would encourage anyone interested
to come join the Fedora Atomic WG as we continue to iterate on
integrating the Project Atomic family of technologies into Fedora.
Anyone interested in contributing Container Images, please feel free
to join in and [submit one for Review](https://fedoraproject.org/wiki/Container:Review_Process).

Special side note with this release, all layered images have been
rebuilt to ensure the base image they rely upon includes the [fix for
CVE-2017-5461](https://bugzilla.redhat.com/show_bug.cgi?id=1440080).
