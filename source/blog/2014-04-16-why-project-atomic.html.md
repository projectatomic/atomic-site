---
author: jzb
layout: post
comments: yes
title: "Why Project Atomic?"
date: 2014-04-16 17:25 UTC
tags:
- Atomic
- GearD
- Cockpit
- SELinux
- Kernel
categories:
- Blog
---
The response to the Project Atomic launch has been overwhelming, and we're getting a lot of interest &ndash; and [questions](http://ask.projectatomic.io/en/questions/) &ndash; about the project. In particular, many developers and admins want to know what sets Atomic apart from other Docker-focused offerings. 

## A Distribution You Know and Trust

One of the most compelling reasons for users of Fedora, CentOS, and Red Hat Enterprise Linux is that the Atomic host *brings the advantages of its base distribution*. 

The packages are used to create an Atomic host bring the same advantages of the base distribution &ndash; you get the base features you'd get with Fedora, CentOS, or RHEL (like SELinux, filesystem options, kernel tuning, and so forth). For RHEL customers, there's also the certification and training ecosystem you can rely on with Red Hat Enterprise Linux Atomic Host. 

Tools like Anaconda, which many admins and developers depend on for deploying and managing systems, will be available with Atomic hosts. This means Kickstart support, for instance, carries forward with Atomic hosts.

## RPM Ecosystem

Because Atomic hosts are built with rpm-ostree, they benefit from the RPM ecosystem and will let projects and vendors distribute updates concurrently with the mainline distribution. So, for instance, when Fedora sends out an OpenSSL update the same RPMs used to deliver the update to users of the traditional Fedora distribution can be quickly used to generate a new tree for Atomic users. 

What's more, users will have the ability to roll back updates when necessary.

Want to roll your own custom Atomic hosts? Want to do something crazy like including GNU Emacs on the Atomic Host? You can use the rpm-ostree technology to do just that.

## GearD Support

A major feature that will be integrated into Atomic hosts is [GearD](http://openshift.github.io/geard/), technology we've pulled in from the OpenShift Origin project, which helps bind systemd and Docker to make containers easier to configure and manage. 

## Cockpit Support

Finally, Atomic hosts feature [Cockpit](http://cockpit-project.org/), a server manager that makes managing hosts, services, and containers easier. Cockpit is also coming to Fedora, CentOS, and RHEL, giving you another standard tool to work with for all of your systems.

## We're Open

We are excited to show this work to the larger community, and to invite you to not only use Atomic &ndash; but we're also excited about working with the larger community to make Atomic hosts the best way to run Docker containers. Join our [developer community](http://www.projectatomic.io/community/), and let's make Atomic even better.
