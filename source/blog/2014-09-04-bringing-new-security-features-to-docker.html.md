---
author: jzb
layout: post
comments: true
title: Bringing new security features to Docker
date: 2014-09-04 21:44 UTC
tags:
- Docker
- SELinux
- RHEL
categories:
- Blog
---
A great follow-up to my post about [Jérôme Petazzoni's post on Docker and security](http://www.projectatomic.io/blog/2014/08/is-it-safe-a-look-at-docker-and-security-from-linuxcon/), Dan Walsh has a post up on OpenSource.com explaining just what's being done about Docker security.

Says Dan, "Docker, Red Hat, and the open source community are working together to make Docker more secure. When I look at security containers, I am looking to protect the host from the processes within the container, and I'm also looking to protect containers from each other. With Docker we are using the layered security approach, which is 'the practice of combining multiple mitigating security controls to protect resources and data.'

Basically, we want to put in as many security barriers as possible to prevent a break out. If a privileged process can break out of one containment mechanism, we want to block them with the next. With Docker, we want to take advantage of as many security mechanisms of Linux as possible."

[Read the full post over on OpenSource.com. &raquo;](http://opensource.com/business/14/9/security-for-docker)
