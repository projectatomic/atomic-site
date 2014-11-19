---
author: jzb
layout: post
title: Fedora Atomic Test Day Tomorrow
date: 2014-11-19 12:50 UTC
tags:
- Docker
- Atomic
- Fedora
- Kubernetes
categories:
- Blog
---
As Fedora ramps up for the final Fedora 21 release, scheduled for December 9th, we want to make sure that all the components and variants of Fedora get a proper testing. To that end, the Fedora Cloud Working Group is holding a Fedora Test Day on Thursday, 20 November. 

Please join us in the #atomic channel on Freenode if you have questions, or shoot us an email to cloud@lists.fedoraproject.org. 

Things to test: 

 * Booting the image
 * Docker functionality (everything fro pulling images to running, making changes, committing images, etc.) 
 * `atomic` (rpm-ostree) upgrade and rollback
 * Cockpit
 * Kubernetes

We will have test cases on the [Fedora wiki](https://fedoraproject.org/wiki/Test_Day:2014-11-20_Atomic) and you are (of course) encouraged to come up with your own tests! 

The test day image can be found [here](https://kojipkgs.fedoraproject.org//work/tasks/8904/8118904/Fedora-Cloud-Atomic-20141112-21.x86_64.qcow2). Note that this is a test candidate, not a final release. Expect that things will change between now and the final release.
