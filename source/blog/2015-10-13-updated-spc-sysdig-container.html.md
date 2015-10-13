---
title: Updates to running a sysdig SPC to troubleshoot containers
author: mmicene
date: 2015-10-13 14:19:21 UTC
tags: fedora, atomic, docker
comments: true
published: true
---

In a interesting coincidence, the same day we posted [the super privileged containers post](http://www.projectatomic.io/blog/2015/09/using-a-spc-to-troubleshoot-containers/) using [Sysdig](www.sysdig.org/), the Sysdig team announced [support for Atomic hosts](https://sysdig.com/dig-into-atomic-host/).  You can take a look at that announcement for how sysdig does it's magic on an Atomic host and which Atomic hosts are supported.

So no more need to build your own sysdig container for your Atomic clusters, you can use the offical builds.  Here's what that looks like now.

READMORE

I exchanged email with the Sysdig team after they noticed the coinciding posts.  After a few exchanges, Gianluca from the Sysdig team not only had solid sets of kernel support for Atomic, but had merged the docker LABEL to get `atomic run` functional for their upstream container.

Getting a sysdig super privileged container running on an Atomic host is as simple as:

`# atomic run --spc -n sysdig-spc sysdig/sysdig`

This will give you a container named `sysdig-spc` and a bash shell as root in the container.  You can run `csysdig -pc` and start your inspections.  I like to add the `-spc` to the name of the container, that way I can tell that it has escalated privileges at a glance.

One thing you'll see in the output is that sysdig is checking for the kernel headers–and when it doesn't find them, checks for a precompiled module matching the kernel version.  Those modules get built for each kernel that gets pushed out to the official repos for Fedora, Red Hat, and CentOS.  

Open source for the win!