---
title: CentOS Atomic Host 1706 Release
author: jbrooks
date: 2017-07-20 18:00:00 UTC
tags: centos, atomic host, kubernetes
comments: false
published: true
---

An updated version of [CentOS Atomic Host](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) (tree version 7.1706), is now
available.

READMORE

CentOS Atomic Host includes these core component versions:

-   atomic-1.17.2-9.git2760e30.el7.x86_64
-   cloud-init-0.7.5-10.el7.centos.1.x86_64
-   docker-1.12.6-32.git88a4867.el7.centos.x86_64
-   etcd-3.1.9-1.el7.x86_64
-   flannel-0.7.1-1.el7.x86_64
-   kernel-3.10.0-514.26.2.el7.x86_64
-   kubernetes-node-1.5.2-0.7.git269f928.el7.x86_64
-   ostree-2017.5-3.el7.x86_64
-   rpm-ostree-client-2017.5-1.atomic.el7.x86_64

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted
Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image.
These images are available for download at cloud.centos.org. The backing
ostree repo is published to mirror.centos.org.

## Containerized kubernetes-master

The downstream release of CentOS Atomic Host ships without the
kubernetes-master package built into the image. Instead, you can run the
master kubernetes components (apiserver, scheduler, and
controller-manager) in containers, managed via systemd, using the
service files and instructions on the CentOS wiki. The containers
referenced in these systemd service files are built in and hosted from
the CentOS Community Container Pipeline, based on Dockerfiles from the
CentOS-Dockerfiles repository.

These containers have been tested with the kubernetes ansible scripts
provided in the upstream contrib repository, and they work as expected,
provided you first copy the service files onto your master.

Alternatively, you can install the kubernetes-master components using
rpm-ostree package layering using the command:
atomic host install kubernetes-master.


## Upgrading

If you're running a previous version of CentOS Atomic Host, you can
upgrade to the current image by running the following command:

```
$ sudo atomic host upgrade
```

## Images

### Vagrant

CentOS-Atomic-Host-7-Vagrant-Libvirt.box and
CentOS-Atomic-Host-7-Vagrant-Virtualbox.box are Vagrant boxes for
Libvirt and Virtualbox providers.

The easiest way to consume these images is via the Atlas / Vagrant Cloud
setup (see https://atlas.hashicorp.com/centos/boxes/atomic-host). For
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
us-east-1        ami-70e8fd66
ap-south-1       ami-c0c4bdaf
eu-west-2        ami-dba8bebf
eu-west-1        ami-42b6593b
ap-northeast-2   ami-7b5e8015
ap-northeast-1   ami-597a9e3f
sa-east-1        ami-95aedaf9
ca-central-1     ami-473e8123
ap-southeast-1   ami-93b425f0
ap-southeast-2   ami-e1332f82
eu-central-1     ami-e95ffd86
us-east-2        ami-1690b173
us-west-1        ami-189fb178
us-west-2        ami-a52a34dc
```

SHA Sums

```
f854d6ea3fd63b887d644b1a5642607450826bbb19a5e5863b673936790fb4a4
CentOS-Atomic-Host-7.1706-GenericCloud.qcow2
9e35d7933f5f36f9615dccdde1469fcbf75d00a77b327bdeee3dbcd9fe2dd7ac
CentOS-Atomic-Host-7.1706-GenericCloud.qcow2.gz
836a27ff7f459089796ccd6cf02fcafd0d205935128acbb8f71fb87f4edb6f6e
CentOS-Atomic-Host-7.1706-GenericCloud.qcow2.xz
e15dded673f21e094ecc13d498bf9d3f8cf8653282cd1c83e5d163ce47bc5c4f
CentOS-Atomic-Host-7.1706-Installer.iso
5266a753fa12c957751b5abba68e6145711c73663905cdb30a81cd82bb906457
CentOS-Atomic-Host-7.1706-Vagrant-Libvirt.box
b85c51420de9099f8e1e93f033572f28efbd88edd9d0823c1b9bafa4216210fd
CentOS-Atomic-Host-7.1706-Vagrant-VirtualBox.box

```

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

## Getting Help

If you run into any problems with the images or components, feel free to
ask on the centos-devel mailing list.

Have questions about using Atomic? See the atomic mailing list or find
us in the #atomic channel on Freenode.
