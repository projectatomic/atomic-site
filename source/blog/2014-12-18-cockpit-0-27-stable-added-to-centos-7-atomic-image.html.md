---
author: jzb
layout: post
title: "Docker 1.4, Cockpit 0.27 (stable) added to CentOS 7 Atomic"
date: 2014-12-18 22:08 UTC
tags:
- Cockpit
- Docker
categories:
- Blog
---
If you're running the [CentOS Atomic Host](http://buildlogs.centos.org/monthly/7/) images, you'll want to do an `atomic upgrade` right about now. The update includes a bump for Docker to 1.4, and brings Cockpit to 0.27, and pulls in a few additional package updates. 

As you've probably read, Docker 1.4 [includes a few bug fixes](http://docs.docker.com/release-notes/), security fixes, and several new features. 

Cockpit 0.27 is the most recent *stable* release from the Cockpit Project. This release of the [Cockpit server manager](http://cockpit-project.org/) is the same used for Fedora 21 Atomic Host, and includes a lot of stability and feature improvements since 0.24.

## What's in that update?!

You can see all the packages updated by using `atomic db diff commit1 commit2`. (And you can see the commit hashes for the two trees with `atomic status`.) 

## Cockpit Hackfest ahead of DevConf.cz

Going to [DevConf.cz](http://www.devconf.cz/)? Or just happen to be close to the Czech Republic and have a strong interest in Cockpit? You can learn how to hack on Cockpit, build plugins or prototypes, and much more! 

The Hackfest will be held in Room A113, Brno University of Technology, on [Friday 6 February from 2:10 to 5:10 CET](http://community.redhat.com/events/#devconfcz). Of course, you should check out DevConf.cz too, it's free to attend and you'll have dozens of fantastic presentations to choose from related to free software. Also, keep an eye on [Red Hat's Community Calendar](http://community.redhat.com/events/) for other free and open source related events that may be of interest.

Hope to see you there! 
