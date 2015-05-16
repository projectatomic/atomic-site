---
author: bkp
comments: true
layout: post
title: Why The Operating System Will Never Die
date: 2014-05-23 14:35 UTC
tags:
- Atomic
- RHEL
- Enterprise
- Docker
- OpenShift
categories:
- Blog
---
A strange thing is going on in IT these days, an unintentional fake out that on the surface could lead people to wonder if operating systems are becoming more and more irrelevant--when actually the opposite is going on.

In 2011, I [addressed this topic from the perspective of the desktop](http://www.itworld.com/it-managementstrategy/230479/return-operating-system), arguing that while the software as a service (SaaS) way of doing things would seem to suggest that applications that run in the browser don't really need to care about the desktop operating system, the then-rising app-store model of application deployment made the choice of operating system all the more important. Native apps installed on operating systems kept the notion of operating systems alive (even if those apps were merely tricked-up portals to the same web services to which a browser could link).

READMORE

Interestingly, three years later I hear many familiar-sounding arguments about operating systems when it comes to platform as a service (PaaS) and DevOps. Get enough consistency in your operating systems, the arguments go, and then, for most intents and purposes, the operating system becomes more abstracted.

And when you get into containers, that argument becomes even more compelling: containers hold the applications and just the libraries and tools those applications need to work. That could be a whole operating system inside that container or (more likely) a smaller set of tools that is more portable for sysadmins to work with and more stable and easier to code for developers. 

Big or small, containers are application-centric and would seem to free both sides of the DevOps equation from the shackles of operating systems. 

Has the arrival of containers heralded the departure of operating systems?

As you might expect from someone working for a company that distributes an operating system, the answer is pretty much "no."

While it is difficult to unwind the need for self-preservation from this discussion, there is a huge reason why operating systems are not going to fade into nothing: they are the foundation on which all of these powerful tools must run.

Yes, containers can abstract the operating system away from developers and system administrators, but containers can't run on bare metal. There has to be something on which they sit. Or, in the case of Atomic, something on which [geard](http://openshift.github.io/geard/) can sit and manage containers alongside [Cockpit](http://cockpit-project.org/) and [SELinux](http://selinuxproject.org/).

The missing element here is innovation. Containers are great for creating individual applications and services, but for broader frameworks, we still very much need stable operating systems to put those frameworks together. In other words, I can cook a meal in my cast-iron skillet, but there still needs to be a foundry to cast that skillet in the first place. And engineers and craftsworkers to create better skillets.

Operating systems may be taking less of a role in day-to-day IT operations, and that's a good thing sometimes, because you just need to code fast and deploy faster without worrying about what the latest security update did to your libraries.

There will always be a place for operating systems in our IT environments, to help create the Next New Thing. Container technology itself, for instance, is not derived solely from the efforts of [Docker](https://www.docker.io/) for their containers and [OpenShift](https://www.openshift.com/) for their gears. The core foundation for containers lies directly within the Linux kernel, where technologies like OpenShift, Docker, and [LXC](https://linuxcontainers.org/) can make use of it.

Operating systems are not going away; the emphasis on them is changing. But their presence is needed just as much as before, running the latest and greatest software to keep information flowing.
