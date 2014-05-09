---
author: jzb
comments: true
layout: post
title: Moving an RHSCL app to Docker on Atomic
date: 2014-05-09 19:44 UTC
tags:
- SCL
- Software Collections
- SoftwareCollections.org
categories:
- Blog
---
As I've mentioned a number of times when I've spoken about [Software Collections](http://softwarecollections.org) (SCLs), containers and SCLs are *not* mutually exclusive. In fact, SCLs promise to be really important for a lot of developers in building containers for production. 

Langdon White has written up a [great post on how to move an RHSCL app to Docker](http://developerblog.redhat.com/2014/05/07/moving-app-to-docker-on-atomic/) using an Atomic host:

> Ok, now that Atomic is installed, I need to go make a container. After a few fits and starts, mostly related to pathing issues while using the "RUN" command, I got a decent Dockerfile working. You "run" this file by using the 'docker build' command. Later, you "make the app go" with the 'docker run' command. 

Check out the rest of Langdon's post on [the Red Hat Developer Blog](http://developerblog.redhat.com/2014/05/07/moving-app-to-docker-on-atomic/).
