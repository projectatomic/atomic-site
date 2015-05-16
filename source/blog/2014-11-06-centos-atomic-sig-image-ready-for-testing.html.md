---
author: jzb
title: CentOS Atomic SIG Image Ready for Testing
date: 2014-11-06 
tags:
- CentOS
- Docker
- Cockpit
- alpha
- Release
categories:
- Blog
---
The CentOS Atomic SIG is pleased to announce that [we have a CentOS Atomic Host image ready for testing](http://buildlogs.centos.org/rolling/7/). The image is currently being built in CentOS infrastructure, but not yet fully integrated into CentOS build systems.

The image should be considered **alpha** quality, ready for testing, patches, and feedback. It's more or less package-complete but we still have a ways to go before calling the CentOS Atomic Host ready for any production workloads:

READMORE

 * Image signing.
 * Final package set (may remove non-essential packages to reduce image size, add packages that make Atomic easier to use, etc.). 
 * Other ways we can slim down the image to the bare essentials.
 * Much more testing of the images and a regular release cadence for stable updates.
 * Bare metal installer. 
 * Additional image formats.
 * Documentation.
 * Slice, dice, and make Julienne fries.

You get the idea. We want to get a lot of hands-on testing and feedback from folks who are putting containers into production. For ideas about what to test/try out, see the Project Atomic [download](http://www.projectatomic.io/download/) and [quick start](http://www.projectatomic.io/docs/quickstart/) pages.

We actually have two downloads: the [qcow2](http://buildlogs.centos.org/rolling/7/CentOS-7-x86_64-AtomicHost-20141029_02.qcow2) with no compression (for direct import into OpenStack, *etc.*) and the [gzipped image](http://buildlogs.centos.org/rolling/7/CentOS-7-x86_64-AtomicHost-20141029_02.qcow2.gz) for faster downloads if you don't need to import the image directly. The [directory also has sha256 sums](http://buildlogs.centos.org/rolling/7/) so you can verify the images.

The image comes pre-configured with an atomic update repository, but if you're interested in building your own updates for the image, check out [this howto](http://www.projectatomic.io/blog/2014/11/build-your-own-atomic-updates/) on the Project Atomic blog.

## Updates

The goal right now is to produce new images on a monthly basis, and update tress on a daily basis. This means you should be getting the SIG's latest work very quickly if you're using this SIG image and using `rpm-ostree upgrade`. If you hit a snag, of course, it's dead easy to revert to the previous known-good image.

Ultimately, we plan to have multiple trees that you can follow for updates depending on your needs. That means an alpha or experimental tree for folks who are doing work on CentOS Atomic itself, a beta tree for updates that are about to land in the stable tree, and a stable tree.

## What's in this release

This release is based on packages from CentOS 7, plus an updated Docker 1.3., Cockpit, and Kubernetes with additional dependencies that may not be in CentOS 7, and (of course) rpm-ostree.
You'll need to use [cloud-init](http://cloudinit.readthedocs.org/en/latest/) to log in to the image. If you're testing with a service or tool that does not provide cloud-init, you can directions for creating a local cloud-init provider in this [blog entry](https://www.technovelty.org/linux/running-cloud-images-locally.html).

## Working with the CentOS Atomic SIG

We've still got a ways to go, and would love more input from the larger community on what the final CentOS Atomic Host should be. See the [Atomic Host Definition](https://gist.github.com/jzb/0f336c6f23a0ba145b0a) for an outline of the base definition of the Atomic Host, and [the SIG Workgroup charter](http://wiki.centos.org/SpecialInterestGroup/Atomic). 

Questions about this release? Speak up on the centos-devel mailing list! We look forward to hearing your thoughts and working with the CentOS community to make Atomic the best way to deploy Docker containers.
