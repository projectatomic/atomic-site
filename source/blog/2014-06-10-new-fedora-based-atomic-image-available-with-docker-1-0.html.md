---
comments: true
layout: post
author: jzb
title: New Fedora-based Atomic Image Available with Docker 1.0
date: 2014-06-10 13:59 UTC
tags: 
- Atomic
- Docker
- Cockpit
categories:
- Blog
---
Yesterday at DockerCon, the Docker folks [announced the 1.0 release](http://blog.docker.com/2014/06/dockercon-day-1-keynote-highlights/) along with a number of other interesting announcements. To make sure that the Atomic community has the latest and greatest tools to work with, we've rolled up a new image based on Fedora 20 with Docker 1.0 and a number of other updates.

Note that some of the packages in this image come from updates-testing or Copr builds. A big thanks to Jason Brooks for managing the builds and the Copr packages! 

## What's New

In addition to Docker 1.0 (see the [official Docker post on that](http://blog.docker.com/2014/06/its-here-docker-1-0/)), the latest release of the Atomic proof-of-concept image includes:

* Cockpit 0.9
  * Cockpit no longer needs SELinux disabled
  * Cockpit runs mostly unprivileged now
  * Cockpit listens on port 1001 
* Updated GearD
* Additional packages to make working with the image easier (e.g. GNU Screen)

See also [Stef Walter's post on Cockpit](http://www.projectatomic.io/blog/2014/05/what-s-new-in-cockpit/). A number of other packages have also been updated. If you're already testing Atomic, you can update to the latest with `rpm-ostree upgrade` and then `systemctl reboot`. 

If you haven't tried it yet, you can grab the newest images for KVM [20140609.qcow2.xz](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/f20/qemu/) or VirtualBox [20140609.vdi.bz2](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/f20/vbox/). Be sure to check out the [Get Started with Atomic page](http://www.projectatomic.io/download/) as well.

Have questions? Come find us on Freenode in the #atomic channel, or [ask questions on Ask.ProjectAtomic.io](http://ask.projectatomic.io/en/questions/). 
