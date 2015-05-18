---
title: The Problem with Containers
author: johnmark
date: 2015-05-08 18:23:25 UTC
tags: docker, rkt, appc, composite applications
comments: true
published: true
---

Our own [Daniel Riek](http://rhelblog.redhat.com/author/danielriek/) wrote a [great blog post](http://rhelblog.redhat.com/2015/05/05/rkt-appc-and-docker-a-take-on-the-linux-container-upstream/) about CoreOS's current efforts around the [appc specification](https://github.com/appc/), rkt, and the significant work that remains. 

This is where it gets interesting:

READMORE

> As it is today, appc only covers a very small part of what needs to be sorted out for a container-based, application-centric model. The impact of containerization in redefining the enterprise OS is still vastly underestimated by most; it is a departure from the traditional model of a single-instance, monolithic, UNIX user space in favor of a multi-instance, multi-version environment using containers and aggregate packaging. We are talking about nothing less than changing some of the core paradigms on which the software industry has been working for the last 20 – if not 40 – years.

In other words: change is hard, and the entire computing world as we know it is turning upside down. This necessarily means re-learning how to do some things that we take for granted. Like, how to build applications that's not a manual construction process involving bailing wire and duct tape. Appc covers important territory around defining how containers are expected to work, but it leaves out a lot about how they're supposed to work in concert.

> Another important scope issue is primarily induced by the name “Application” - at this point, appc covers individual containers up to a pod. Unfortunately... there are very few applications that consist of only a single container / single pod. 

Sure, one can stand up a container, maybe a few at a time, customize some pods, install some software, throw Kubernetes in it, and voila! What do you have? You just hand-crafted a solution that Works For You (tm) but is impossible to manage, won't survive the next technology culling, doesn't integrate with your existing management tooling, and probably cannot be easily repeated. 

This is not to downplay the work that is taking place right now on appc. After all, we have to start somewhere, and walking must be perfected before running or flying. However, Daniel brings up one more point that should give us pause when considering the current container landscape:

> It’s important to note that an even bigger concern than the early stage of appc, is that rkt also introduces its own container package format in addition to supporting a compatibility interface to the docker model... At the end of the day, it will mean fragmentation of the ecosystem... 

> The elephant in the room is that appc does not have the support of Docker, the company that leads in mindshare and controls the format that has quickly become the defacto standard for container packaging. They were not even represented at the panel to share their point of view.

This means that those of us who make up the greater container community will have to work extra hard to make sure we don't end up with a fragmented ecosystem where individual companies protect their turf at the expense of the vast expanse of users and developers who just want things to work. The Unix wars have long been cited as "how not to do it," so let's not go back to that. 
