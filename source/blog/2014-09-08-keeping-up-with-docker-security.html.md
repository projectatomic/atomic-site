---
author: dwalsh
layout: post
title: Keeping Up with Docker Security
date: 2014-09-08 19:15 UTC
tags:
- Docker
- Security
- SELinux
categories:
- Blog
---
I've been working on the Project Atomic team at Red Hat on Security for Docker containers. In order to get the word out I have been writing a series of blogs on Docker Security for OpenSource.com. I've written two so far, and hope to have the third done soon.
 
The [first post](http://opensource.com/business/14/7/docker-security-selinux) covers the fact that a privileged process within a container is the same from a security point of view as the security of a privileged process outside of a container.  The idea I am trying to get across is to set up your application services the same way inside of containers as out, and **don't rely on container technology to protect you**.

The [second post](https://opensource.com/business/14/9/security-for-docker) covers everything that has been put into Docker to try to control the privileged and unprivileged processes within a container. We have things like Read Only File Systems, Dropped capabilities, SELinux, Control over device nodes *etc.* The cool part of this is it adds a lots of nice new security over the containerized service, but (see "Are Docker containers really secure?"), you still want to only use trusted applications and drop privileges as quickly as possible.
 
The last post on OpenSource.com will cover the next group of features we want to add to Docker to make it more secure.
 
After publishing the first two articles SDTimes contacted me to do an interview on Docker Security, which they published [today as "How Red Hat and the open-source community are fortifying Docker"](http://sdtimes.com/red-hat-open-source-community-fortifying-docker/).

Finally, the presentation I gave at DockerCon discussing [Docker and SELinux](https://www.youtube.com/watch?v=zWGFqMuEHdw) is available on YouTube. Continue watching here for additional Docker security information!
