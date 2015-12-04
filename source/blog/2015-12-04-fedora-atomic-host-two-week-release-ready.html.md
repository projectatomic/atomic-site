---
title: Fedora Atomic Host Two-Week Release Ready!
author: jzb
date: 2015-12-04 17:58:06 UTC
tags: fedora, atomic host
comments: true
published: true
---

The [Fedora Project's Cloud Working Group](https://fedoraproject.org/wiki/Cloud)is happy to announce the [first post-Fedora 23 Atomic release](https://getfedora.org/en/cloud/download/atomic.html). Fedora Atomic Host is optimized to run Docker containers and is on a rapid-release cycle to match the pace of Linux container technology.
 
Approximately every two weeks we will release the Fedora Atomic Host image in all of our supported formats (installable ISO, qcow2, Vagrant Boxes, and EC2 images), with the most up-to-date snapshot of our stack to work with Linux containers.

READMORE

Note you can just grab the Vagrant boxes using `vagrant init  fedora/23-atomic-host` and then use `vagrant up` if you're already using Vagrant. See the [Fedora Magazine piece on Vagrant with Fedora 22](https://fedoramagazine.org/using-fedora-22-atomic-vagrant-boxes/) if you're new to using Vagrant on Fedora.

This release features several updates to key packages:
 
 * kernel-4.2.6-301.fc23.x86_64
 * cloud-init-0.7.6-5.20140218bzr1060.fc23.noarch
 * atomic-1.6-5.git09ac479.fc23.x86_64
 * kubernetes-1.1.0-0.17.git388061f.fc23.x86_64
 * etcd-2.2.1-2.fc23.x86_64
 * ostree-2015.9-3.fc23.x86_64
 * docker-1.9.1-2.git78bc3ea.fc23.x86_64
 * flannel-0.5.1-3.fc23.x86_64
 
Many thanks to all the Fedora folks who worked on this release, especially Adam Miller, Dennis Gilmore, Ralph Bean, Sayan Chowdhury, and Kushal Das. 

The Atomic release is produced by the Fedora Cloud Working Group. We are always looking for additional contributors and folks to help test the releases. If you have questions about the Fedora Atomic release, find us on Freenode in #fedora-cloud or on cloud@lists.fedoraproject.org.
