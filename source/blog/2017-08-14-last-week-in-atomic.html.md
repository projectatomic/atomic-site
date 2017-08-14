---
title: Last Week In Atomic
author: jberkus
date: 2017-08-14 18:00:00 UTC
tags: atomic, centos, kubernetes, cri-o, kpod
comments: false
published: true
---

Since Project Atomic has now spread out across several blogs and websites, this is the second of what will become regular updates on events and posts around the Atomic community.  This is also a useful catch-up for anyone who doesn't have time to backfill on all of the individual blog posts.

This week includes kpod, vagrant-buildah, Fedora Atomic Host, CentOS Atomic Host, Kubernetes containers, and more.

READMORE

## New Projects and Tools

As a sub-project of CRI-O, that team has now [announced development of the `kpod` command](https://medium.com/cri-o/introducing-kpod-f06109b96374).  `kpod` is an administrative and troubleshooting tool for containers running on individual kubernetes nodes, especially if the docker daemon is not involved.  Current commands include [version](https://medium.com/cri-o/kpod-version-b9fd7175c730), [push](https://medium.com/cri-o/kpod-push-62bce8705c3f), and [pull](https://medium.com/cri-o/kpod-pull-36765d2e5fb8).

Tyler Britten released some scripts for [playing with Buildah on Windows or Mac](https://github.com/vmtyler/vagrant-buildah), using Vagrant.

## Releases

* Fedora released their [August 8th Update for Fedora 26 Atomic](http://www.projectatomic.io/blog/2017/08/fedora-atomic-august-08/).
* CentOS released [version 7.1707 of CentOS Atomic Host](http://www.projectatomic.io/blog/2017/08/new-centos-atomic-release-and-kubernetes-system-containers-now-available/).
* The CentOS Virt SIG and Atomic SIG released [new Kubernetes system containers](http://www.projectatomic.io/blog/2017/08/new-centos-atomic-release-and-kubernetes-system-containers-now-available/) based on version 1.7.

## Blog Posts

* Dusty Mabe explained [how the Fedora OSTree repos get built](https://dustymabe.com/2017/08/08/how-do-we-create-ostree-repos-and-artifacts-in-fedora/).
* Tom Sweeney blogged about [using Buildah to create "fit" images](http://www.projectatomic.io/blog/2017/08/buildah-getting-fit/).
* Joe Brockmeier lays out [what will be in RHEL Atomic 7.4](http://rhelblog.redhat.com/2017/08/01/whats-new-in-red-hat-enterprise-linux-atomic-host-7-4/), coming soon.

## Events

The Fedora Atomic WG will be participating heavily in the upcoming [Flock to Fedora](https://flocktofedora.org/) conference.  This includes sessions on multi-architecture containers, becoming a container package maintainer, system containers, an Atomic Host documentation writeathon, and many more sessions.

[ContainerCamp UK](https://2017.container.camp/uk/speakers/michael-hausenblas/) will feature Michael Hausenblas of the OpenShift team talking about Kubernetes backup.

[OSS Summit NA](http://events.linuxfoundation.org/events/open-source-summit-north-america) will have an Atomic booth presence in the Red Hat pavillion. We could use booth volunteers if you love Atomic.  We will also have a [BOF on Atomic Host](http://sched.co/BDpX).

[Kubecon US](http://events.linuxfoundation.org/events/cloudnativecon-and-kubecon-north-america) still has their CfP open.  Sumbit talks involving Atomic projects!
