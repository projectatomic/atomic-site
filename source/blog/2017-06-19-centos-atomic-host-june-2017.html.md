---
title: CentOS Atomic Host 1705 Release
author: jbrooks
date: 2017-06-19 20:00:00 UTC
tags: centos, atomic host, kubernetes
comments: true
published: true
---

An updated version of [CentOS Atomic Host](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) (tree version 7.1705), is now
available.

In this release, we've modified the versioning scheme we're using for
the ostree repo to match the monthly `major-version.YYMM` numbering that
the rest of CentOS uses for its monthly releases. Moving forward, we
plan on releasing CentOS Atomic host on a monthly schedule. The next
CentOS Atomic Host release that will roll up all of June's software
updates, will be versioned 7.1706, and so on in the following months.
We also intend to add an additional ostree ref to our repository,
called "updates," which will enable users to access the latest
packages as they become available. Stay tuned during the coming weeks
for more information on that option.

READMORE

CentOS Atomic Host includes these core component versions:

-   atomic-1.17.2-4.git2760e30.el7.x86_64
-   cloud-init-0.7.5-10.el7.centos.1.x86_64
-   docker-1.12.6-28.git1398f24.el7.centos.x86_64
-   etcd-3.1.7-1.el7.x86_64
-   flannel-0.7.0-1.el7.x86_64
-   kernel-3.10.0-514.21.1.el7.x86_64
-   kubernetes-node-1.5.2-0.6.gitd33fd89.el7.x86_64
-   ostree-2017.5-1.el7.x86_64
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
  us-east-1        ami-90e7c686
  ap-south-1       ami-2ba1de44
  eu-west-2        ami-2b44524f
  eu-west-1        ami-a6c5dbc0
  ap-northeast-2   ami-87ba65e9
  ap-northeast-1   ami-64868e03
  sa-east-1        ami-f9197295
  ca-central-1     ami-66e55a02
  ap-southeast-1   ami-850a88e6
  ap-southeast-2   ami-caf7e6a9
  eu-central-1     ami-42e84f2d
  us-east-2        ami-89bb9dec
  us-west-1        ami-245b7644
  us-west-2        ami-68818a11
```

SHA Sums

```
    46082267562f9eefbc4b29058696108f07cb0ceb2dafe601ec5d66bb1037120a
CentOS-Atomic-Host-7.1705-GenericCloud.qcow2
    1bd6dfbe360be599a45734f03b34e08cc903630327e1c54534eb4218bf18d0da
CentOS-Atomic-Host-7.1705-GenericCloud.qcow2.gz
    aa4a3ac057d3ea898bea07052aa9fd20c7ca7ea3c8a5474bca9227622915e5e2
CentOS-Atomic-Host-7.1705-GenericCloud.qcow2.xz
    d99c2e9d1d31907ace3c1e54fc3087ebb9d627ca46168f7e65b469789cd39739
CentOS-Atomic-Host-7.1705-Installer.iso
    cfd6a29e26e202476b6a2dc54b1b31321688270a6cc6a9ef4206ac0ebd0e309c
CentOS-Atomic-Host-7.1705-Vagrant-Libvirt.box
    d9b5f965f637a909efa15cd43063729db002c012c81a8cde0de588ea0932f970
CentOS-Atomic-Host-7.1705-Vagrant-VirtualBox.box
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
