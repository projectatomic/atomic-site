---
title: New CentOS Atomic Host with Docker 1.13
author: jbrooks
date: 2017-05-16 19:00:00 UTC
tags: kubernetes, docker, etcd, centos
comments: true
published: true
---

An updated version of [CentOS Atomic Host](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) (tree version 7.20170428), is
now available, featuring the option of substituting the host’s default
docker 1.12 container engine with a more recent, docker 1.13-based
version, provided via the docker-latest package.

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
* docker-1.12.6-16.el7.centos.x86_64
* etcd-3.1.3-1.el7.x86_64
* flannel-0.7.0-1.el7.x86_64
* kernel-3.10.0-514.16.1.el7.x86_64
* kubernetes-node-1.5.2-0.5.gita552679.el7.x86_64
* ostree-2017.3-2.el7.x86_64
* rpm-ostree-client-2017.3-1.atomic.el7.x86_64

## Containerized kubernetes-master

The downstream release of CentOS Atomic Host ships without the
kubernetes-master package built into the image. Instead, you can run the
master kubernetes components (apiserver, scheduler, and
controller-manager) in containers, managed via systemd, using the
[service files and instructions on the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster). The containers
referenced in these systemd service files are built in and hosted from
the CentOS Community Container Pipeline, based on Dockerfiles from the
CentOS-Dockerfiles repository.

These containers have been tested with the kubernetes ansible scripts
provided in the upstream contrib repository, and they work as expected,
provided you first copy the service files onto your master.

Alternatively, you can install the kubernetes-master components using
rpm-ostree package layering using the command:

```
atomic host install kubernetes-master
```

## docker-latest

You can switch to the alternate docker version by running:

```
# systemctl disable docker --now
# systemctl enable docker-latest --now
# sed -i '/DOCKERBINARY/s/^#//g' /etc/sysconfig/docker
```

Because both docker services share the `/run/docker` directory, you cannot
run both docker and docker-latest at the same time on the same system.

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

The easiest way to consume these images is via [the Atlas / Vagrant Cloud
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
  ap-south-1       ami-9c7b06f3
  eu-west-2        ami-14425570
  eu-west-1        ami-a1b9b7c7
  ap-northeast-2   ami-e01cc18e
  ap-northeast-1   ami-2a0d304d
  sa-east-1        ami-ce7619a2
  ca-central-1     ami-8b813def
  ap-southeast-1   ami-61e36702
  ap-southeast-2   ami-84c7cde7
  eu-central-1     ami-f970ae96
  us-east-1        ami-4a70015c
  us-east-2        ami-d2cfe8b7
  us-west-1        ami-57ba9c37
  us-west-2        ami-fbd8bd9b
```

### SHA Sums

* 977c9b6e70dd0170fc092520f01be26c4d256ffe5340928d79c762850e5cedd9
CentOS-Atomic-Host-7.1704-GenericCloud.qcow2
* 781074c43aa6a6f3cad61a77108541976776eb3cb6fe30f54ca746a8314b5f87
CentOS-Atomic-Host-7.1704-GenericCloud.qcow2.gz
* aef7fedf01b920ee75449467eb93724405cb22d861311fbc42406a7bd4dbfee2
CentOS-Atomic-Host-7.1704-GenericCloud.qcow2.xz
* 669c5fd1b97bc2849a7e3dbec325207d98e834ce71e17e0921b583820d91f4f5
CentOS-Atomic-Host-7.1704-Installer.iso
* b5ef69bff65ab595992649f62c8fc67c61faa59ba7f4ff0cb455a9196e450ae2
CentOS-Atomic-Host-7.1704-Vagrant-Libvirt.box
* 73757f50ef9cdac2e3ba6d88a216cca23000a32fa96891902feaa86d49147e3f
CentOS-Atomic-Host-7.1704-Vagrant-VirtualBox.box

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
