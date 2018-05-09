---
title: Fedora 27 Atomic Released
author: jberkus
date: 2017-11-14 16:00:00 UTC
published: true
comments: false
tags: atomic, fedora, ostree, ARM, PPC, kubernetes, workstation
---

[Fedora 27 Atomic Host](https://getfedora.org/en/atomic/download/) is now available.  Highlights of this version include multi-architecture support, containerized Kubernetes, a single OverlayFS volume by default, and new OSTree layering capabilities.

Over the next week or so, we will have additional posts on each of these features, giving technical details and use-cases.  But today, for the release, we'll have quick summary of the major changes.

READMORE

## Features

* **Multi-Architecture Support**: Fedora 27 Atomic Host is available for [64-bit ARM]() and [Power8]() processor architectures as well as 64-bit Intel (i.e. AArch64, ppc64le and x86_64).  Not only are we distributing ISOs and cloud images for all three architectures, we will also be providing two-week OSTree updates for them as well.
* **Containerized Kubernetes**: As planned, the Kubernetes binaries have been removed from the base image for Atomic Host.  This change both shrinks the base image size, and allows users to install the container orchestration platform and version of their choice, whether it's Kubernetes, OpenShift, or something else.  Look for a blog post tommorrow on how to migrate your Kubernetes install.
* **Atomic Workstation Updates**: For over a year, Fedora contributors have been experimenting with an RPM-OStree build of Fedora Workstation, with all of their applications running in containers or Flatpaks. This build, now called "Atomic Workstation", will be receiving regular updates starting with this release.
* **One Big OverlayFS2 Volume**: New Atomic Host systems will now get a single filesystem volume by default, which will share binaries, system containers, and OCI/docker containers using OverlayFS2.  Users who need to partition container images and storage onto a separate volume can still do so using kickstart options and `container-storage-setup` configuration.
* **OSTree Package Layering Improvements**: RPM-OStree has added two capabilities supporting modifying individula systems: [remove and replace overrides](/blog/2017/07/rpm-ostree-v2017.7-released/), and [LiveFS layering](/blog/2017/06/rpm-ostree-v2017.6-released/).

With the release of Fedora 27 Atomic Host, updates to the Fedora 26 Atomic Host will be strictly on a best-effort basis.  As such, we strongly encourage users to upgrade to the new release soon. Our upgrade guide begins with [this post](/blog/2017/11/fedora-atomic-26-to-27-upgrade/).

## Release Details

The OSTree update hash for Fedora 27 Atomic is:

Version: 27.1

* Commit(x86_64): d428d3ad8ecf44e53d138042bad56a10308883a0c5d64b9c51eff27fdc9da82c
* Commit(aarch64): da1bd08012699a0aacaa11481d3ed617477858aab0f2ea7300168ce106202255
* Commit(ppc64le): 362888edfac04f8848072ae4fb8193b3da2f4fd226bef450326faff4be290abd

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

Existing systems can be upgraded in place via `atomic host rebase`, `atomic host upgrade` or
`atomic host deploy`.  However, see the Upgrading post in this blog for [more information
about upgrading from Fedora 26](/blog/2017/11/fedora-atomic-26-to-27-upgrade/).

Corresponding image media for new installations can be [downloaded from Fedora](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Aarch64  ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/aarch64/iso/Fedora-Atomic-27-20171110.1-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/ppc64le/iso/Fedora-Atomic-27-20171110.1-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/x86_64/iso/Fedora-Atomic-27-20171110.1-x86_64-CHECKSUM)
* [Aarch64 CloudImage](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/aarch64/images/Fedora-CloudImages-27-20171110.1-aarch64-CHECKSUM)
* [ppc64le CloudImage](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/ppc64le/images/Fedora-CloudImages-27-20171110.1-ppc64le-CHECKSUM)
* [x86_64 CloudImage](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/x86_64/images/Fedora-CloudImages-27-20171110.1-x86_64-CHECKSUM)

For direct download, the "latest" targets are always available here:

* [ISO](https://getfedora.org/atomic_iso_latest)
* [QCOW2](https://getfedora.org/atomic_qcow2_latest)
* [Raw](https://getfedora.org/atomic_raw_latest)
* [Libvirt](https://getfedora.org/atomic_vagrant_libvirt_latest)
* [VirtualBox](https://getfedora.org/atomic_vagrant_virtualbox_latest)

Filename fetching URLs are available here:

* [ISO](https://getfedora.org/atomic_iso_latest_filename)
* [QCOW2](https://getfedora.org/atomic_qcow2_latest_filename)
* [Raw](https://getfedora.org/atomic_raw_latest_filename)
* [Libvirt](https://getfedora.org/atomic_vagrant_libvirt_latest_filename)
* [VirtualBox](https://getfedora.org/atomic_vagrant_virtualbox_latest_filename)

Alternatively, image artifacts can be found at the following links:

* [Fedora-Atomic-ostree-aarch64-27-20171110.1.iso](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20171110.1.iso)
* [Fedora-Atomic-ostree-ppc64le-27-20171110.1.iso](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20171110.1.iso)
* [Fedora-Atomic-ostree-x86_64-27-20171110.1.iso](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20171110.1.iso)
* [Fedora-Atomic-27-20171110.1.aarch64.qcow2](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/aarch64/images/Fedora-Atomic-27-20171110.1.aarch64.qcow2)
* [Fedora-Atomic-27-20171110.1.aarch64.raw.xz](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/aarch64/images/Fedora-Atomic-27-20171110.1.aarch64.raw.xz)
* [Fedora-Atomic-27-20171110.1.ppc64le.qcow2](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20171110.1.ppc64le.qcow2)
* [Fedora-Atomic-27-20171110.1.ppc64le.raw.xz](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20171110.1.ppc64le.raw.xz)
* [Fedora-Atomic-27-20171110.1.x86_64.qcow2](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/x86_64/images/Fedora-Atomic-27-20171110.1.x86_64.qcow2)
* [Fedora-Atomic-27-20171110.1.x86_64.raw.xz](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/x86_64/images/Fedora-Atomic-27-20171110.1.x86_64.raw.xz)
* [Fedora-Atomic-Vagrant-27-20171110.1.x86_64.vagrant-libvirt.box](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20171110.1.x86_64.vagrant-libvirt.box)
* [Fedora-Atomic-Vagrant-27-20171110.1.x86_64.vagrant-virtualbox.box](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20171110.1.x86_64.vagrant-virtualbox.box)

For more information about the latest targets, please reference the [Fedora
Atomic Wiki space](https://fedoraproject.org/wiki/Atomic_WG#Fedora_Atomic_Image_Download_Links).

Do note that it can take some of the mirrors up to 12 hours to "check-in" at
their own discretion.
