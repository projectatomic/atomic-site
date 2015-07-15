---
title: CentOS Atomic Host Released
author: jzb
date: 2015-06-23 16:30:55 UTC
tags: Docker, CentOS, RHEL
comments: true
published: true
---

We would like to announce the general availability of CentOS Atomic Host (May 2015), a lean operating system designed to run Docker containers, derived from Red Hat Enterprise Linux Atomic Host (7.1.2), and built from standard CentOS 7 RPMs. 

CentOS Atomic Host is produced by the [CentOS Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic), based on upstream work from  [Project Atomic](http://www.projectatomic.io/). 

READMORE

CentOS Atomic Host is available as a qcow2 image, as VirtualBox or libvirt-formatted Vagrant box and as an installable ISO image. These images are available for download at [cloud.centos.org](http://cloud.centos.org/centos/7/atomic/images/). The backing ostree repo is published to [mirror.centos.org](http://mirror.centos.org/centos/7/atomic/x86_64/repo).

If you currently run an atomic host (from any distro or release in the past), you can rebase to this released CentOS Atomic Host by running the following two commands :

```
  ostree remote add centos-atomic-host http://mirror.centos.org/centos/7/atomic/x86_64/repo
  rpm-ostree rebase  centos-atomic-host:centos-atomic-host/7/x86_64/standard
```

## Images

The [CentOS-Atomic-Host-7-GenericCloud.qcow2](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-GenericCloud.qcow2) (847MB)  is suitable for use in on-premise and local virtualised environments. We test this on OpenStack, AWS and local Libvirt installs. In order to login, you will need to provide a cloud-init consumeable metadata source, like the NoCloud iso file. The Generic Cloud image is also avalable [compressed in gz format](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-GenericCloud.qcow2.gz) (388 MB) and [xz compressed](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-GenericCloud.qcow2.xz) (308MB).

The [installer ISO](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Installer.iso) (660 MB) can be used via regular install methods (PXE, CD, USB image, etc.) and uses the Anaconda installer to deliver the CentOS Atomic Host. This allows flexibility to control the install using kickstarts and define custom storage, networking and user accounts. This is the recommended process for getting CentOS Atomic Host onto bare metal machines, or to generate your own image sets for custom environments.

[CentOS-Atomic-Host-7-Vagrant-Libvirt.box](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Vagrant-Libvirt.box) (385 MB) and [CentOS-Atomic-Host-7-Vagrant-Virtualbox.box](http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Vagrant-Virtualbox.box) (395 MB) are Vagrant boxes for Libvirt and Virtualbox providers. 

The easiest way to consume these images is via the Atlas / Vagrant Cloud setup (see [https://atlas.hashicorp.com/centos/boxes/atomic-host](https://atlas.hashicorp.com/centos/boxes/atomic-host). For example, getting the VirtualBox instance up would involve running the following two commands on a machine with vagrant installed:

```
  vagrant init centos/atomic-host && vagrant up --provider virtualbox 
```

### SHA Sums

c7eb7d770947d3bbb18464d621bb7597b3ecd41dd518551ca6269c7630edc347  CentOS-Atomic-Host-7-GenericCloud.qcow2
d371c3e4441fef32d3c4456fb08cbd01f0d3c30baafd60c25f4f7f9be4eca1c5  CentOS-Atomic-Host-7-GenericCloud.qcow2.gz
7ab0e527e108ce8e8861f59f34b9206ea3ac45e3944ce419fc0fa754fbd8b08d  CentOS-Atomic-Host-7-GenericCloud.qcow2.xz
bfd773fbec8fe15f58e9bb01d91809d2ccc9671079b2dff572d08ab607b12acf  CentOS-Atomic-Host-7-Installer.iso
8cf02325b1aa04b04c18d988bd3a31b049c2487768f718e3093ade7e8fe33cd4  CentOS-Atomic-Host-7-Vagrant-Libvirt.box
af8fd6b5af0c98a87543578591230b7f20da97a4d5f53fb091306616bf34577a  CentOS-Atomic-Host-7-Vagrant-Virtualbox.box


## Component Versions:

* Kernel 3.10.0-229
* Docker 1.6.0
* Kubernetes 0.15.0-123
* Flannel 0.2.0

## Release Cycle

The rebuild image will follow the upstream Red Hat Enterprise Linux Atomic Host cadence. After sources are released, they'll be rebuild and included in new images. After the images are tested by the SIG and deemed ready, they'll be announced. If you'd like to help with the process, there's plenty to do!

## Getting Involved

The CentOS Atomic SIG seeks to produce two 'streams' for users, a rebuild of the RHEL Atomic Host, and a monthly release that tracks upstream components more closely. Users who want to take a more conservative approach to components like Docker, Kubernetes, and so forth will prefer the rebuild.

Our monthly image gives the community the opportunity to preview new technologies, and to experiment with packages that may not be carried in RHEL Atomic Host. If you'd like to work on testing images, help with packaging, documentation, or even help define the direction of our montly release -- join us! 

The SIG meets weekly on Thursdays at 16:00 UTC in the #centos-devel channel, and you'll often find us in #atomic and/or #centos-devel if you have questions. You can also join the [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) mailing list if you'd like to discuss the direction of Project Atomic, its components, or have other questions. 

## Getting Help

If you run into any problems with the images or components, feel free to ask on the [centos-devel](http://lists.centos.org/mailman/listinfo/centos-devel) mailing list. 

Have questions about using Atomic? See the [atomic](https://lists.projectatomic.io/mailman/listinfo/atomic) mailing list or find us in the #atomic channel on Freenode.