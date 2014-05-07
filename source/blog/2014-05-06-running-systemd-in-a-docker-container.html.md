---
author: jzb
layout: post
comments: true
title: Running systemd in a Docker Container
date: 2014-05-06 19:50 UTC
tags:
- systemd
- Docker
- cgroups
categories:
- Blog
---
Ever wondered if you can get `systemd` running in a Docker container? Apparently Dan Walsh did, [and spent some time getting it to work](http://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/).

> While working with Docker, I looked at the great work that Scott Collier was doing for getting services to run within a container.  Scott provides the fedora-dockerfiles package in docker with lots of “Dockerfile” examples. You can build Docker images by running “docker build” on these examples.

> It seemed a little difficult, and wondered if getting systemd to run within a docker container, as I did with virt-sandbox-service, might make this simpler.

> The Docker Model suggests that it is better to run a single service within a container.  If you wanted to build an application that required an Apache service and a MariaDB database, you should generate two different containers.   Some people insist on running multiple services within a container, and for this Docker suggested using the supervisord tool.  In RHEL we do not want to support supervisord, since it is written in Python, and do not want to pull a Python requirement into containers, and it is just a package used to monitor multiple services.  We already have a tool for monitoring multiple services called systemd.

After a little trial and error, Dan got `systemd` working within a container on Fedora Rawhide, and expects it will work on Fedora 20 or RHEL 7 (when it's released). Give it a spin and [let Dan know](http://rhatdan.wordpress.com/2014/04/30/running-systemd-within-a-docker-container/) how it works out for you.
