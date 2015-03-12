---
author: jzb
layout: post
title: Fedora 22 Alpha and Vagrant Boxes
date: 2015-03-12
tags:
- Fedora
- CentOS
- Vagrant
categories: 
- Blog
---
A couple of interesting Atomic releases to take a look at this week. The [Fedora Project](http://fedoraproject.org/) has [released Fedora 22 alpha](http://fedoramagazine.org/fedora-22-alpha-released/), which includes the [Cloud edition Atomic Host](https://getfedora.org/en/cloud/prerelease/) images, as well as the Server and Workstation editions. We also have a few new test images from the CentOS Atomic SIG to check out &ndash; including Vagrant boxes.

## Fedora Images

The Fedora release includes the standard [raw](http://download-i2.fedoraproject.org/pub/fedora/linux/releases/test/22_Alpha/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22_Alpha-20150305.x86_64.raw.xz) and [qcow2](http://download-i2.fedoraproject.org/pub/fedora/linux/releases/test/22_Alpha/Cloud/x86_64/Images/Fedora-Cloud-Atomic-22_Alpha-20150305.x86_64.qcow2) images, as well as new Vagrant boxes for [VirtualBox](http://download-i2.fedoraproject.org/pub/fedora/linux/releases/test/22_Alpha/Cloud/x86_64/Images/Fedora-Cloud-Atomic-Vagrant-22_Alpha-20150305.x86_64.vsphere.ova) and [libvirt/KVM](http://download-i2.fedoraproject.org/pub/fedora/linux/releases/test/22_Alpha/Cloud/x86_64/Images/Fedora-Cloud-Atomic-Vagrant-22_Alpha-20150305.x86_64.rhevm.ova). 

As an alpha release, this should give an excellent preview of the Fedora 22 release but it's entirely possible it will have some interesting bugs as well. Please do give it a spin and let us know if you run into any problems! If you have questions, feel free to ask on cloud@lists.fedoraproject.org or [report any bugs you might find](http://fedoraproject.org/wiki/Bugzilla).

## New CentOS Atomic SIG Images

We also have some news on the CentOS front, with new images and Vagrant boxes for libvirt and VirtualBox:

 * [qcow2 image](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-20150228_01.qcow2)
 * [xz compressed qcow2 image](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-20150228_01.qcow2.xz)
 * [Vagrant VirtualBox image](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-Vagrant-VirtualBox-20150228_01.box)
 * [Vagrant libvirt image](http://buildlogs.centos.org/rolling/7/isos/x86_64/CentOS-7-x86_64-AtomicHost-Vagrant-LibVirt-20150228_01.box)

Note that the most recent CentOS qcow2 images do not include the LVM backing storage, but that is included in the Vagrant boxes. 

Also worth noting, the CentOS SIG images are **not** rebuilds of [Red Hat Enterprise Linux Atomic Host](http://www.redhat.com/en/resources/red-hat-enterprise-linux-atomic-host) which was [released last week](http://www.projectatomic.io/blog/2015/03/red-hat-enterprise-linux-atomic-host-released/). The CentOS SIG products are still work-in-progress, and should be treated as such. 

Questions or comments on the CentOS Atomic work? Ping us on [centos-devel](http://lists.centos.org/mailman/listinfo/centos-devel) or [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel), or ask in #atomic on Freenode.
