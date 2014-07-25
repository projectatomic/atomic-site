---
comments: true
layout: post
author: bkp
title: "Upstream Atomic: Vagrant Support for Kubernetes"
date: 2014-07-25 16:49 UTC
tags: 
- Atomic
- Kubernetes
- Vagrant
- Google
- orchestration
categories:
- Blog
---

One of the most interesting things about Project Atomic is how much work is going on, even as the project seems to be standing still. After the discussions Joe and I have had at OSCON this past week, I can safely say the work around containers is moving so fast that it almost seems that if you blink you will miss it.

Atomic is not the usual open source project, in that there's not really code to download and install as a separate package. Rather, Project Atomic a combination of a lot of upstream projects that will be integrated within CentOS and Fedora. And, of course, Red Hat plans to build and distribute its own Red Hat Enterprise Linux Atomic Host.

Because Atomic's small but growing community is using upstream projects like [Apache Mesos](http://mesos.apache.org/), Google's [Kubernetes](https://github.com/GoogleCloudPlatform/kubernetes), and [Docker](https://www.docker.com/), community members are submitting new code and features to those projects on almost a daily basis.

Case in point: yesterday Red Hat's [Derek Carr](https://github.com/derekwaynecarr) let us know that a new feature he was working on for Kubernetes had been merged into that project: the capability to [manage Vagrant clusters with Kubernetes](https://github.com/GoogleCloudPlatform/kubernetes/pull/550).

Kubernetes is just one of the orchestration tools that will be included in Atomic for container management, and the inclusion of Vagrant support is a key move to get more developer involvement. While developers have long coded Linux applications, many programmers prefer Apple's hardware for their needs. Vagrant is very useful tool enabling them to have the best of both worlds.

Specifically, Kubernetes users will be able to spin up a local [Vagrant](http://www.vagrantup.com/) cluster of Fedora machines running a single master with *N* minions. Kubernetes will reuse existing Salt configuration scripts to provision master and minions. Carr has also added support to run on Red Hat-based operating systems, where systemd manages installed services. 

Carr has tested this on Vagrant 1.6.2, and it is recommended that users who want to test this feature use this version or higher of Vagrant. Head on over to GitHub and test this new feature today.
