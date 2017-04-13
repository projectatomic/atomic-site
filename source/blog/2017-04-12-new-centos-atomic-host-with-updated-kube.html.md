---
title: New CentOS Atomic Host with Updated Kubernetes, Flannel, and Etcd
author: jbrooks
date: 2017-04-12 18:00:00 UTC
tags: kubernetes, docker, etcd, centos
comments: true
published: true
---

An updated version of CentOS Atomic Host (tree version 7.20170405), is
[now available](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download), including significant updates to kubernetes (version
1.5.2), etcd (version 3.1) and flannel (version 0.7).

READMORE

CentOS Atomic Host is a lean operating system designed to run Docker
containers, built from standard CentOS 7 RPMs, and tracking the
component versions included in Red Hat Enterprise Linux Atomic Host.

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted
Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image.
These images are available for download at cloud.centos.org. The backing
ostree repo is published to mirror.centos.org.

CentOS Atomic Host includes these core component versions:

* atomic-1.15.4-2.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64
* docker-1.12.6-11.el7.centos.x86_64
* etcd-3.1.0-2.el7.x86_64
* flannel-0.7.0-1.el7.x86_64
* kernel-3.10.0-514.10.2.el7.x86_64
* kubernetes-node-1.5.2-0.2.gitc55cf2b.el7.x86_64
* ostree-2017.1-3.atomic.el7.x86_64
* rpm-ostree-client-2017.1-6.atomic.el7.x86_64

## Containerized kubernetes-master

The downstream release of CentOS Atomic Host ships without the
kubernetes-master package built into the image. Instead, you can run the
master kubernetes components (apiserver, scheduler, and
controller-manager) in containers, managed via systemd, using the
service files and [instructions on the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster). The containers
referenced in these systemd service files are built in and hosted from
the CentOS Community Container Pipeline, based on Dockerfiles from the
CentOS-Dockerfiles repository.

These containers have been tested with the kubernetes ansible scripts
provided in the upstream contrib repository, and they work as expected,
provided you first copy the service files onto your master.

## Upgrading

If you're running a previous version of CentOS Atomic Host, you can
upgrade to the current image by running the following command:

    $ sudo atomic host upgrade


## Images

### Vagrant

CentOS-Atomic-Host-7-Vagrant-Libvirt.box and
CentOS-Atomic-Host-7-Vagrant-Virtualbox.box are Vagrant boxes for
Libvirt and Virtualbox providers.

The easiest way to consume these images is via the [Atlas / Vagrant Cloud
setup](https://atlas.hashicorp.com/centos/boxes/atomic-host). For
example, getting the VirtualBox instance up would involve running the
following two commands on a machine with vagrant installed:

```
$ vagrant init centos/atomic-host && vagrant up --provider virtualbox
```

### ISO

The installer ISO can be used via regular install methods (PXE, CD, USB
image, etc.) and uses the Anaconda installer to deliver the CentOS
Atomic Host. This image allows users to control the install using
kickstarts and to define custom storage, networking and user accounts.
This is the recommended option for getting CentOS Atomic Host onto bare
metal machines, or for generating your own image sets for custom
environments.

### QCOW2

The CentOS-Atomic-Host-7-GenericCloud.qcow2 image is suitable for use in
on-premise and local virtualized environments. We test this on
OpenStack, AWS and local Libvirt installs. If your virtualization
platform does not provide its own cloud-init metadata source, you can
create your own NoCloud iso image.

### Amazon Machine Images

```
  Region           Image ID
  ---------------- --------------
  us-east-1        ami-a50d85b3
  ap-south-1       ami-13f6857c
  eu-west-2        ami-42233726
  eu-west-1        ami-49063c2f
  ap-northeast-2   ami-d1c81abf
  ap-northeast-1   ami-7b1c3e1c
  sa-east-1        ami-914f2dfd
  ca-central-1     ami-2de75b49
  ap-southeast-1   ami-53328c30
  ap-southeast-2   ami-6d929c0e
  eu-central-1     ami-dca270b3
  us-east-2        ami-18bc987d
  us-west-1        ami-b22a0fd2
  us-west-2        ami-2e2bbb4e
```

### SHA Sums

*    b337bc56a71b6b25237a5c0c06c9f48a33973b4e41c648288bcfaf5a494af98c
CentOS-Atomic-Host-7.1703-GenericCloud.qcow2
*    707db9907a850816fca7782da1dca3584fa0d8be821d0ee95525b688aaa0cc6d
CentOS-Atomic-Host-7.1703-GenericCloud.qcow2.gz
*    c4ef91cc801777e214106522f848f8b388fb92699d67ed4fe86cc942a361f7a2
CentOS-Atomic-Host-7.1703-GenericCloud.qcow2.xz
*    5e41a0306a8c1c212117c68eae10f0f59b25cb6c57dec9629bf3ac760bca54bc
CentOS-Atomic-Host-7.1703-Installer.iso
*    f509eb482a614d2eb047009aaa6c37c125b66cdd483e7015983cae5f72d9f041
CentOS-Atomic-Host-7.1703-Vagrant-Libvirt.box
*    2c0ba7dda2f4f249aa6c31cfcb36df1a17913b9d8786afb7b340a24b15b404f1
CentOS-Atomic-Host-7.1703-Vagrant-VirtualBox.box


## Release Cycle

The CentOS Atomic Host image follows the upstream Red Hat Enterprise
Linux Atomic Host cadence. After sources are released, they're rebuilt
and included in new images. After the images are tested by the SIG and
deemed ready, we announce them.

## Getting Involved

CentOS Atomic Host is produced by the CentOS Atomic SIG, based on
upstream work from Project Atomic. If you'd like to work on testing
images, help with packaging, documentation -- join us!

The SIG meets weekly on Thursdays at 16:00 UTC in the #centos-devel
channel, and you'll often find us in #atomic and/or #centos-devel if you
have questions. You can also join the atomic-devel mailing list if you'd
like to discuss the direction of Project Atomic, its components, or have
other questions.
