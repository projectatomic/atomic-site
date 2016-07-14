---
title: New CentOS Atomic Host Releases Available for Download
author: jbrooks
date: 2016-07-14 07:00:00 UTC
tags: docker, kubernetes, centos
published: true
comments: true
---

Last week, the [CentOS Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic) [released](https://seven.centos.org/2016/07/new-centos-atomic-host-ready-for-download/) an updated version of CentOS Atomic Host (tree version 7.20160707), featuring updated versions of docker and the atomic run tool.

CentOS Atomic Host includes these core component versions:

* docker-1.10.3-44.el7.centos.x86_64
* kubernetes-1.2.0-0.12.gita4463d9.el7.x86_64
* kernel-3.10.0-327.22.2.el7.x86_64
* atomic-1.10.5-5.el7.x86_64
* flannel-0.5.3-9.el7.x86_64
* ostree-2016.5-3.atomic.el7.x86_64
* etcd-2.2.5-2.el7.0.1.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. Check out the [CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) for download links and installation instructions, or read on to learn more about what's new in this release.

## OCI Advances: runC and OCI Hooks
CentOS Atomic Host now ships with [runC](http://runc.io/), a lightweight client wrapper around libcontainer for spawning and running containers according to the [Open Container Initiative](https://www.opencontainers.org/) specification. In this release, the host's atomic run tool makes use of runC to manage system services running in containers. While it's possible to run system containers with docker, there are certain system components that present chicken-and-egg scenarios, such as flannel, on which docker itself depends.

runC-based containers can be pushed and pulled from standard docker registries, but are composed slightly differently than standard docker containers, as described in [this post](http://www.projectatomic.io/blog/2016/04/running_OCI/) from [Mrunal Patel](https://twitter.com/mrunalp), and this [Dockercon 2016 talk](https://www.youtube.com/watch?v=ZAhzoz2zJj8) from [Phil Estes](https://twitter.com/estesp).

For more information on the system container feature in atomic, check out the man page for the [atomic install](https://github.com/projectatomic/atomic/blob/v1.10.5/docs/atomic-install.1.md) command and [this blog post](http://www.scrivano.org/2016/03/24/system-containers-for-atomic/) from [Giuseppe Scrivano](https://twitter.com/gscrivano).

Elsewhere on the OCI front, users who wish to run systemd inside of their containers can do so more simply with this new atomic host release, thanks to a pair of [OCI hooks](https://github.com/projectatomic/oci-systemd-hook) that enable users to run systemd in docker and OCI compatible runtimes such as runc without requiring the `--privileged` flag, and to display journal information from these containers using the host's journalctl command.

## Modifying the Host & CentOS Atomic Continuous
Also new in CentOS Atomic Host is an updated version of OSTree, the project that provides for atomic system upgrades for Atomic Hosts. The new OSTree version adds support for the `ostree admin unlock` command, which mounts a writable overlayfs, allowing users to install rpms on their otherwise immutable atomic hosts. These overlaid packages can be made either to persist between reboots or not, but the overlay will be discarded following an ostree upgrade. For more information on this feature, check out [Jonathan Lebon's](https://github.com/jlebon) blog post on [hacking and extending atomic hosts](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host).

For a more permanent package overlay option, there's a brand-new package layering capability available, which Jonathan also covers in [his post](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host). However, this capability is not yet included in the main CentOS Atomic Host release.

To facilitate the testing of this and other new atomic host features, the SIG is now producing a [Continuous](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) atomic host tree, which combines a base of CentOS packages with an overlay of [certain continuously-built packages](https://github.com/CentOS/sig-atomic-buildscripts/blob/master/overlay.yml) pulled from upstream git sources. The packages are built using a project called [rpmdistro-gitoverlay](https://github.com/cgwalters/rpmdistro-gitoverlay) that runs as a [Jenkins job](https://ci.centos.org/job/atomic-rdgo-centos7/) within the CentOS CI infrastructure.

Switching to the Continuous release involves adding a new remote entry to an existing atomic host, rebasing to the continuous tree, and rebooting into the new tree:

```
# ostree remote add --set=gpg-verify=false centos-atomic-continuous https://ci.centos.org/artifacts/sig-atomic/rdgo/centos-continuous/ostree/repo/
# rpm-ostree rebase centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
# systemctl reboot
```
