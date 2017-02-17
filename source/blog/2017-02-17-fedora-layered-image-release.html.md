---
title: 'Fedora's First Ever Container Layered Image Release'
author: maxamillion
date: 2017-02-17 16:00:00 UTC
tags: docker, containers, OCI
published: true
comments: true
---
On behalf of the [Fedora Atomic WG](https://pagure.io/atomic-wg) and [Fedora Release Engineering](https://docs.pagure.org/releng/), I am pleased to announce the first ever Fedora Layered Image Release. From now on we will be doing regularly scheduled releases of Fedora Layered Image content that will match the [Fedora Atomic Two Week](https://getfedora.org/en/atomic/download/) Release schedule.

Each Container Image is released with the following streams which aim to provide lifecycle management choices to our users.

```
Name
Name-Version
Name-Version-Release
```

Each of the `Name` and `Name-Version` tags will be updated in place with their respective updates for as long as the maintainer supports them and the `Name-Version-Release` will always be a frozen in time reference to that particular release of the Container Image.

READMORE

At this time the following Container Images are available in the Fedora Registry.

```
registry.fedoraproject.org/f25/cockpit:130-1.f25docker
registry.fedoraproject.org/f25/cockpit:130
registry.fedoraproject.org/f25/cockpit
registry.fedoraproject.org/f25/kubernetes-node:0.1-2.f25docker
registry.fedoraproject.org/f25/kubernetes-node:0.1
registry.fedoraproject.org/f25/kubernetes-node
registry.fedoraproject.org/f25/toolchain:1-1.f25docker
registry.fedoraproject.org/f25/toolchain:1
registry.fedoraproject.org/f25/toolchain
registry.fedoraproject.org/f25/kubernetes-master:0.1-3.f25docker
registry.fedoraproject.org/f25/kubernetes-master:0.1
registry.fedoraproject.org/f25/kubernetes-master
```

We're targeting 20 more Layered Images before our next release, so keep an eye out for the offerings from the Fedora Project in our rapidly growing registry.

## What are Fedora Layered Images?

Fedora Layered Images are [OCI](https://www.opencontainers.org/) [Container Images](https://github.com/opencontainers/image-spec) that are built on top of the [Fedora Base Image](https://github.com/fedora-cloud/docker-brew-fedora). These images aim to provide verified content built in a way that can be developed on, contributed to, and audited openly by the community. The images are maintained by [Fedora Contributors](https://fedoraproject.org/wiki/Contribute) and they will follow a regular two-week release cycle which will include security updates. (Note: Out of band updates will be released for critical security issues as needed)

The original goal of Layered Images was to provid Container Image content to the Fedora user community to help foster new ideas such as [Fedora Atomic Host](https://getfedora.org/en/atomic/), [Fedora.Next](https://fedoraproject.org/wiki/Fedora.next) and [Fedora Modularity](https://fedoraproject.org/wiki/Modularity). In the early days we targeted creating a [reproducible build system for Docker images](https://opensource.com/business/16/7/creating-reproducible-build-system-docker-images), but since the idea's inception, the container technology landscape has changed considerably and instead of targeting only [Docker](https://github.com/docker/docker/) we are now providing a solution that allows our users and contributors choice in their container runtime.

Ultimately we hope to provide content in a way that can highlight the [Project Atomic](http://www.projectatomic.io/) family of technologies as a part of the Fedora Project.

## Extra Notes

We are currently working on a way to provide browse and search functionality for Fedora Container Images so please stay tuned for that.

For those interested, the source of this content is provided in DistGit which can easily be searched via the [container-specific pkgdb namespace](https://admin.fedoraproject.org/pkgdb/packages/docker/*/).

As always, we welcome feedback and would encourage anyone interested to come join the [Fedora Atomic WG](https://pagure.io/atomic-wg) as we continue to iterate on integrating the [Project Atomic](http://www.projectatomic.io/) family of technologies into Fedora.

Anyone interested in contributing Container Images, please feel free to join in and submit one for [Review](https://fedoraproject.org/wiki/Container:Review_Process)

