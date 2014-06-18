---
comments: true
layout: post
author: bkp
title: Exploring the Atomic in Project Atomic
date: 2014-06-18 19:51 UTC
tags: 
- Atomic
- Docker
- ostree
- rpm-ostree
- packages
categories:
- Blog
---
As Project Atomic continues to lift off, a lot of attention has been focused on the container aspects of Atomic, and our consumption of the popular Docker container technology. Atomic, however, is not just about container technology, nor is it solely about the [GearD](http://openshift.github.io/geard/) container management that will also be a part of Project Atomic host. Nor just about about [Cockpit](http://cockpit-project.org/). It's about all of those technologies and more.

But what makes Atomic "atomic"? I've had some people come up to me and ask if we are making a word-play on the container/size thing and using the label Atomic to describe container technology. In actuality, the "atomic" in Atomic describes the one bit of technology that makes Project Atomic very unique: [rpm-ostree](https://github.com/projectatomic/rpm-ostree).

READMORE

While Docker is all about delivering applications, rpm-ostree is about updating the Project Atomic host itself. If you aren't familiar with rpm-ostree, it's the brainchild of Colin Walters, Senior Software Engineer in Red Hat's Server Experience group. Walters has described this project, which was recently relocated to [Project Atomic's GitHub](https://github.com/projectatomic) repository set, as "git for operating system binaries."

To understand rpm-ostree, it's important to understand there is more than one layer to this new approach. At the core is ostree, which deviates from the traditional package-by-package update model found in modern operating systems. Instead of package by package, ostree delivers a complete filesystem tree as an update. This is easy to roll out, and also very easy to roll back if something goes wrong with your update.

## A Package Lovely as a Tree

"Trees," in this context, are also somewhat new to many peoples' understanding. Walters explains software update systems these days as parts of a spectrum. On one end of the spectrum, there are package systems (such as RPM and DEB), which are very flexible and independent of storage filesystems. You can install RPMs on btrfs, XFS, or ext4, whatever you like. On the other end of the spectrum, there are image-based updates, but these will be locked into a partition layout. 

The trees of ostree are between. Trees are like packages in that they are filesystem and block independent, but they are like image updates in that you get a tree all as one unit instead of package by package. It's this "one unit" idea that forms the idea of "atomic"--one solid unit of updates delivered atomically.

But ostree is not enough, because it just delivers content in a rote fashion, much like rsync does for files--ostree just replicates content from a compose server. Generating unique content is where rpm-ostree comes in: users can select a compose server's RPMs--any RPMs that are needed--and commit them to a tree. From which clients can just replicate.

For Walters, this is the best of both worlds, because all of the effort and work that went into creating the packages is preserved, but now there is a more efficient delivery system to push the software out to servers and clients. This is an important distinction, because rpm-ostree is not meant to supplant RPMs and package systems in general.

## Seeing the Forest for the Trees

rpm-ostree was not invented just for Project Atomic, though it's a very strong compliment to other tools in the Atomic software. 

rpm-ostree is something Walters has been working on for quite some time. ostree had its origins from a project known as [gnome-continuous](https://wiki.gnome.org/Projects/GnomeContinuous), where it was a high-performance continuous-delivery system that would ensure that a couple of minutes after a git commit, GNOME developers would be testing the changes that had landed in GNOME. 

But Walters had always kept ostree as a separate layer so anyone could feed RPM content into it. And not just RPMs, there's are people feeding DEB packages into ostree as well. The core ostree, in actuality, is very content independent.

Atomic also compliments some aspects of rpm-ostree that could be seen as short-term limitations. One such trade off with the ostree model is that once a tree is replicated, that tree is immutable in the client. ostree itself doesn't give you a way to add or remove packages within the tree on the client side; rpm-ostree is what does that, and only from the compose server. Docker, then, is a way to add or remove apps dynamically, where you can get applications as an image inside a container. Systemd will facilitate starting and stopping these containers, and GearD will enable orchestration of these containers.

Project Atomic is about best practices for deployment of servers and applications on servers. That is what the combination of these particular tools is all about.
