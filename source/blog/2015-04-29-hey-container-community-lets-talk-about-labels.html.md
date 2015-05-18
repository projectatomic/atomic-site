---
title: Hey Container Community, Let's Talk about Labels
author: dwalsh
date: 2015-04-29 15:08:06 UTC
tags: Docker, Labels
comments: true
published: true
---

We have added a new tool called atomic [which I announced last week. ](
http://developerblog.redhat.com/2015/04/21/introducing-the-atomic-command/)

The Atomic tool currently takes advantage of the Label patch in docker that allows developers shipping applications as container images, to add arbitrary labels to the images json data.  We chose to use some top level names for identifiers. Right now, Labels support free-form text without any restrictions. This is good in that it's flexible, but bad in that we want containers to be portable and tools like Atomic that make use of the Label should co-exist with other tools that may also use the Label.

READMORE

We do not want to namespace these names for the atomic tool since we believe that we should build a *de facto* standard for these names.  Then other tools could take advantage of the labels.

We were [encouraged to invite our competitors to participate in this conversation](https://twitter.com/solomonstre/status/590996458440011776) so, we have put together a GitHub page with some suggested top level label IDs. We're hoping to bring together folks from all the interested projects and come up with a Generic Label proposal/standard that works for all of us.

See [the ContainerApplicationGenericLabels repository on GitHub](https://github.com/projectatomic/ContainerApplicationGenericLabels) for our first take. Please open issues if you have points to discuss, and pull requests to modify the document.

We actually want Labels to be agnostic of the container tools, so they could be used in other container frameworks/tools like CoreOS and systemd-nspawn. The applications spec introduced by CoreOS has the concept of Annotations, which could take advantage of these names.

The goal of these labels is to give software delivery engineers a somewhat standard way of describing the application they are delivering.

We welcome suggestions from anyone in the containers community, including (but not limited to!) CoreOS, Docker, VMware, IBM, Microsoft, Google, Amazon, RackSpace, SUSE, Canonical, and any other projects or companies doing work that might benefit from top-level label IDs.