---
comments: true
layout: post
author: bkp
title: Containers Vs. Virtual Machines is a Fake Conflict
date: 2014-06-13 15:00 UTC
tags: 
- Atomic
- Docker
- oVirt
- RDO
- cloud computing
categories:
- Blog
---
With [DockerCon wrapping up earlier this week](http://www.projectatomic.io/blog/2014/06/new-fedora-based-atomic-image-available-with-docker-1-0/), it's little surprise that containers are getting a lot of attention in the Web-o-sphere these days.

One of the better articles I have seen in a while that covers container technology is [Rami Rosen's piece on Linux Journal](http://www.linuxjournal.com/content/linux-containers-and-future-cloud). This is a great primer that gets into the guts of containers, explaining not only how they work but why they are beneficial: 

> "Due to the fact that containers are more lightweight than VMs, you can achieve higher densities with containers than with VMs on the same host (practically speaking, you can deploy more instances of containers than of VMs on the same host)... Another advantage of containers over VMs is that starting and shutting down a container is much faster than starting and shutting down a VM."

It is easy to see the focus on containers as some sort of threat to virtual machines. Application-centric containers, after all sound like a much easier technology to manage than a whole VM. In some respects, that's some truth to that. Developers, after all, would love nothing more than not having to deal with OS updates changing libraries out from under their applications. 

## The Place For Virtualization

But don't count VMs out yet; [just like operating systems](http://www.projectatomic.io/blog/2014/05/why-the-operating-system-will-never-die/), VMs will still have a place in IT. Running Project Atomic hosts can be done on bare metal to be sure, but running the Atomic hosts as VMs that can be orchestrated and managed on the virtualization level can give admins a huge amount of flexibility.

It's not just applications that can benefit from containers, mind you, cloud infrastructure itself can be transformed by containers. There is a real push to package OpenStack services as containers, either on bare metal or atop multi-service KVM machines. Ideally, this would reduce the complexity found in OpenStack usage and packaging. It's pretty cool to imagine some of the many scenarios: Atomic Host virtual machines running containers with [RDO OpenStack](http://openstack.redhat.com/) services to deploy your applications in true cloud fashion. Manage those Host VMs with a data center manager like [oVirt](http://www.ovirt.org), and you've got superior flexibility for your IT configuration.

The day is coming, sooner than you can imagine.

