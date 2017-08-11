---
title: New CentOS Atomic Release and Kubernetes System Containers Now Available
author: jbrooks
date: 2017-08-11 19:22:35 UTC
tags: atomic, centos, kubernetes
comments: true
published: true
---

Last week, the CentOS Atomic SIG released an [updated version](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) of CentOS Atomic Host (7.1707), a lean operating system designed to run Docker containers, built from standard CentOS 7 RPMs, and tracking the component versions included in Red Hat Enterprise Linux Atomic Host.

The release, which came as part of the monthly CentOS release stream, was a modest one, including only a single [glibc bugfix update](https://lists.centos.org/pipermail/centos-announce/2017-July/022505.html). The next Atomic Host release will be based on the [RHEL 7.4 source code](https://seven.centos.org/2017/08/centos-linux-7-1708-based-on-rhel-7-4-source-code/) and will include support for overlayfs container storage, among other enhancements.

READMORE

Outside of the Atomic Host itself, the SIG has updated its Kubernetes container images to be usable as [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/). What's more, in addition to the Kubernetes 1.5.x-based containers that derive from RHEL, the Atomic SIG is now producing packages and containers that provide the current 1.7.x version of Kubernetes.

## Containerized Master

The downstream release of CentOS Atomic Host ships without the kubernetes-master package built into the image. You can install the master kubernetes components (apiserver, scheduler, and controller-manager) as system containers, using the following commands:

```bash
# atomic install --system --system-package=no --name kube-apiserver registry.centos.org/centos/kubernetes-apiserver:latest

# atomic install --system --system-package=no --name kube-scheduler registry.centos.org/centos/kubernetes-scheduler:latest

# atomic install --system --system-package=no --name kube-controller-manager registry.centos.org/centos/kubernetes-controller-manager:latest
```

## Kubernetes 1.7.x

The CentOS Virt SIG is now producing Kubernetes 1.7.x rpms, available through [this yum repo](https://github.com/CentOS/CentOS-Dockerfiles/blob/master/kubernetes-sig/master/virt7-container-common-candidate.repo). The Atomic SIG is maintaining system containers based on these rpms that can be installed as as follows:

### on your master

```bash
# atomic install --system --system-package=no --name kube-apiserver registry.centos.org/centos/kubernetes-sig-apiserver:latest

# atomic install --system --system-package=no --name kube-scheduler registry.centos.org/centos/kubernetes-sig-scheduler:latest

# atomic install --system --system-package=no --name kube-controller-manager registry.centos.org/centos/kubernetes-sig-controller-manager:latest
```

### on your node(s)

```bash
# atomic install --system --system-package=no --name kubelet registry.centos.org/centos/kubernetes-sig-kubelet:latest

# atomic install --system --system-package=no --name kube-proxy registry.centos.org/centos/kubernetes-sig-proxy:latest
```

Both the 1.5.x and 1.7.x sets of containers have been tested with the [kubernetes ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) provided in the upstream contrib repository, and function as drop-in replacements for the installed rpms. If you prefer to run Kubernetes from installed rpms, you can layer the master components onto your Atomic Host image using rpm-ostree package layering with the command: `atomic host install kubernetes-master`.

The containers referenced in these systemd service files are built in and hosted from the [CentOS Community Container Pipeline](https://wiki.centos.org/ContainerPipeline), based on Dockerfiles from
the [CentOS-Dockerfiles repository](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/kubernetes).

## Download CentOS Atomic Host

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. For links to media, see the [CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download).

## Upgrading

If you're running a previous version of CentOS Atomic Host, you can upgrade to the current image by running the following command:

```
$ sudo atomic host upgrade
```

## Release Cycle

The CentOS Atomic Host image follows the upstream Red Hat Enterprise Linux Atomic Host cadence. After sources are released, they're rebuilt and included in new images. After the images are tested by the SIG and deemed ready, we announce them.

## Getting Involved

CentOS Atomic Host is produced by the [CentOS Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic), based on upstream work from  [Project Atomic](http://www.projectatomic.io/). If you'd like to work on testing images, help with packaging, documentation -- join us!

The SIG meets every two weeks on Tuesday at 04:00 UTC in #centos-devel, and on the alternating weeks, meets as part of the Project Atomic community meeting at 16:00 UTC on Monday in the #atomic channel. You'll often find us in #atomic and/or #centos-devel if you have questions. You can also join the [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) mailing list if you'd like to discuss the direction of Project Atomic, its components, or have other questions.
