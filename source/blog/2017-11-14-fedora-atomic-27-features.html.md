---
title: Fedora 27 Atomic Features
author: jberkus
date: 2017-11-13 14:00:00 UTC
published: true
comments: false
tags: atomic, fedora, ostree, ARM, kubernetes
---

[Fedora 27 Atomic Host](https://getfedora.org/en/atomic/download/) is now available, and the project has included a bunch of changes and features to make it an even better platform for your container cloud.  Highlights of this version include multi-architecture support, containerized Kubernetes, a single OverlayFS volume by default, and new OSTree layering capabilities.

Over the next week or so, we will have additional posts on each of these features, giving technical details and use-cases.  But today, for the release, we'll have quick summary of the major changes.

Multi-Architecture Support
--------------------------

Thanks to tremendous efforts across the Fedora project, Fedora 27 Atomic Host is available for [64-bit ARM]() and [Power8]() processor architectures as well as 64-bit Intel (i.e. AArch64, ppc64le and x86_64).  Not only are we distributing ISOs and cloud images for all three architectures, we will also be providing two-week OSTree updates for them as well.  More on this in a later post.

Containerized Kubernetes
-------------------------

As planned, the Kubernetes binaries have been removed from the base image for Atomic Host.  This change both shrinks the base image size, and allows users to install the container orchestration platform and version of their choice, whether it's Kubernetes, OpenShift, or something else.

Users will now need to install Kubernetes using package layering, or, preferably, as [system containers](/blog/2017/09/running-kubernetes-on-fedora-atomic-26/).  To support this, the Fedora Layered Image Build System (FLIBS) [repository](https://fedoraproject.org/wiki/Atomic/FLIBS_Catalog) now includes supported system container images for Kubernetes, etcd, and flannel.  Look for a blog post soon which will explain how to migrate from Fedora 26 Atomic's built-in Kubernetes to the new version.

"Atomic Workstation" Updates
------------------

For over a year, Fedora contributors have been experimenting with an RPM-OStree build of Fedora Workstation, with all of their applications running in containers or Flatpaks. This spin is informally known as "Atomic Workstation." We are now expanding that experiment, by [offering regular automated updates]() to the Atomic Workstation image and OStree refs, starting with Fedora 27.  While not yet ready for most users, Atomic Workstation offers benefits, such as rollback, to developers who want to test the latest builds of Fedora.

One Big OverlayFS2 Volume
-------------------------

Having tested OverlayFS2 through the Fedora 26 cycle, we are now committing to it.  New Atomic Host systems will now get a single filesystem volume by default, which will share binaries, system containers, and OCI/docker containers using OverlayFS2.  This change will make installing Atomic simpler for new users, as well as being appropriate for small public cloud instances.  Users who need to partition container images and storage onto a separate volume can still do so using kickstart options and `container-storage-setup` configuration.

More OSTree Package Layering
----------------------------

In the biweekly Atomic Host updates, we've tested out some additional capabilities for RPM-OSTree that give administrators more flexibility in how to add software to hosts.  First, [remove and replace overrides](/blog/2017/07/rpm-ostree-v2017.7-released/) allow system owners to experiment with changes to the software mix on their host image, including replacing existing binaries with different versions.  Second, [LiveFS layering](/blog/2017/06/rpm-ostree-v2017.6-released/) eliminates the need to reboot when the only RPM-OSTree change a user makes is adding software.

Upgrading and Support Policy
----------------------------

With the release of Fedora 27 Atomic Host, updates to the Fedora 26 Atomic Host will be strictly on a best-effort basis.  As such, we strongly encourage users to upgrade to the new release soon. We will have several blog posts addressing specific upgrade steps and issues within then next couple of weeks.  

The Fedora team is proud of the new release of Atomic Host, and hopes that you will find it more powerful and easier to use.  [Download it](https://getfedora.org/en/atomic/download/) and try it out soon.
