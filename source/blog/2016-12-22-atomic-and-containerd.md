---
title: 'Looking forward to working with containerd'
author: dwalsh
date: 2016-12-22 14:00:00 UTC
tags: docker, containerd, oci, runc, crio
published: true
comments: true
---

A number of folks have asked for my thoughts on the Docker [containerd
announcement](https://blog.docker.com/2016/12/introducing-containerd/)
last week. While containerd itself is not new, having been [announced
over a year
ago](https://blog.docker.com/2015/12/containerd-daemon-to-control-runc/),
we were happy to see that Docker Inc. is now spinning this out as an
independent project. This is aligned with Red Hat's overall goal to
drive open industry [standards for Linux
containers](https://www.redhat.com/en/about/blog/linux-container-standards-didn%E2%80%99t-we-talk-about-last-year)
and the work that we've helped drive as a [leading contributor to the
Docker
project](http://www.infoworld.com/article/2925484/application-virtualization/look-whos-helping-build-docker-besides-docker-itself.html),
a founding member of the [Open Containers
Initiative](https://www.opencontainers.org/), and a leading contributor
to related projects like [OCI runC](https://runc.io/) and [CRI-O
(previously
OCID)](https://www.redhat.com/en/about/blog/running-production-applications-containers-introducing-ocid).
Splitting containerd from Docker Engine and contributing it to a neutral
foundation, as Docker Inc. has
[committed](https://www.docker.com/docker-news-and-press/docker-extracts-and-donates-containerd-its-core-container-runtime-accelerate)
to do, is another positive step in that direction.

When we launched CRI-O as a Kubernetes incubator project and
implementation of the Kubernetes Container Runtime Interface, we
discussed the importance of having a comprehensive open container
runtime standard that &quot;follows the time-tested UNIX philosophy of
modular programming.&quot; This led us to create key modules for [image
distribution](https://github.com/containers/image) and
[storage](https://github.com/containers/storage), that built on runC
and delivered stable container runtime functionality platform builders
could rely on. We are happy that Docker Inc. has followed the lead of
[CRI-O](https://www.redhat.com/en/about/blog/running-production-applications-containers-introducing-ocid)
in breaking apart the upstream Docker Engine into a series of more
modular components, starting with
[containerd](https://containerd.io/). We hope that the containerd
project will be able to use some of the work we've done and also
continue to get broken down into sub-components. This is critical for
delivering on the promise of &quot;boring infrastructure&quot; at the container
runtime level that platform builders in the container ecosystem, whether
they are customers or vendors, can rely on.

As we've done in the past, we would love to work together with the open
source community on the components needed to support running containers
locally or by orchestration tools, as customers move towards running
containers at scale in production environments.

We have every intention of contributing to the containerd effort while
continuing to engaging with the broader container ecosystem. In this
spirit, we have offered
[github.com/containers/storage](https://github.com/containers/storage)
and[ github.com/containers/image](https://github.com/containers/image)
as sub packages to containerd, just in the past few days.
([issue 376](https://github.com/docker/containerd/issues/376),
[issue 379](https://github.com/docker/containerd/issues/379))

These libraries could be shared between containerd, CRI-O and other
lower level command line tools like
[skopeo](https://github.com/projectatomic/skopeo) for the
pulling/pushing and storage of images. We want to see these components
used by many different open source projects, and to be able to evolve at
their own pace. The goal is to build a set of tools around them so
people can experiment with building and running Linux containers in a
myriad of different ways.

Red Hat also plans to continue contributing to CRI-O, as we feel this
can be a great way to run Kubernetes workloads in the OpenShift
platform, in addition to the docker container runtime default.
Meanwhile, the [Kubernetes Container Runtime Interface
(CRI)](http://blog.kubernetes.io/2016/12/container-runtime-interface-cri-in-kubernetes.html),
recently released in Kubernetes 1.5, allows users to plug in different
container runtimes to suit their needs. I believe a dedicated daemon for
serving the Kubernetes CRI protocol, not servicing all different
orchestration tools, is the great way to go. &quot;One daemon to service them
all&quot; has the potential to get bloated over time. Conflicts between
orchestration tools may occur, which could lead to compromises that
could affect performance of one orchestrator over another.

Finally, I am happy to announce we are planning to ship the first alpha
release of CRI-O inside of Fedora Rawhide (Fedora 26), so that people
can start to play with it. We have integrated CRI-O and Kubernetes and
successfully run a basic pod. We are thrilled with the
[contributors](https://github.com/rhatdan/cri-o/graphs/contributors)
who have joined us from many of the top Linux, open source and container
companies, and are contributing to getting this first package out the
door.
