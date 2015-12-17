---
title: Fedora Atomic Host Two-Week Release (12-15-2015) Ready!
author: jzb
date: 2015-12-17 14:20:54 UTC
tags: Fedora, Fedora Cloud, Atomic Host, Docker
comments: true
published: true
---

The Fedora Project's Cloud Working Group is pleased to announce the December 15 two-week Fedora Atomic Host is [ready to download](https://getfedora.org/en/cloud/download/atomic.html). Fedora Atomic Host is optimized to run Docker containers and is on a rapid-release cycle to match the pace of Linux container technology. Note that there will be no release on December 29 due to the holiday.

We release the Fedora Atomic Host builds approximately every two weeks in all the supported formats (installable ISO, qcow2, Vagrant Boxes, and EC2 images), with the most up-to-date snapshot of our stack to work with Linux containers.

READMORE

The 15 December 2015 release includes updates for [Docker](https://bodhi.fedoraproject.org/updates/FEDORA-2015-5917f166c6), RPM-ostree, and fixes a few [filesystem issues with the bare metal install](https://bugzilla.redhat.com/show_bug.cgi?id=1290257). Changed packages include:

 * docker-1.9.1-4.git6ec29ef.fc23.x86_64
 * ostree-2015.11-2.fc23.x86_64

If you're new to Atomic and want to give it a try, the easiest way is to use Vagrant. You can grab the Vagrant boxes with `vagrant init fedora/23-atomic-host` and then use `vagrant up`. If you're already using the two-week releases with Vagrant, just start your box and do `sudo atomic host upgrade` to grab the latest bits. (Note that there are already newer bits in the Fedora Atomic Host tree, so you should probably do an upgrade anyway!)

The Atomic release is produced by the Fedora Cloud Working Group. We are always looking for additional contributors and folks to help test the releases. If you have questions about the Fedora Atomic release, find us on Freenode in #fedora-cloud or on [cloud@lists.fedoraproject.org](https://admin.fedoraproject.org/mailman/listinfo/cloud).
