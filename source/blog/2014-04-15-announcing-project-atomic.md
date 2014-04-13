---
author: jzb
comments: true
layout: post
title: "Announcing Project Atomic: An Operating System Concept for Running Docker Containers"
date: 2014-04-15 17:00 UTC
tags:
- Atomic
categories:
- Blog
---

As most folks know, Red Hat has [already been working hard on Docker support](http://developerblog.redhat.com/2013/11/26/rhel6-5-ga/) in Red Hat Enterprise Linux. Today we're taking the wraps off a new operating system concept for running Docker containers called [Project Atomic](http://www.projectatomic.io/). This concept, known as an Atomic Host, will provide users with a familiar host environment for Docker containers that allows atomic updates to the host OS as well as containerized applications.

The [CentOS Project](http://centos.org), [Fedora Project](http://fedoraproject.org), and [Red Hat](http://redhat.com/) will be taking the technologies developed under Project Atomic to deliver Atomic Hosts for running containerized applications. [Red Hat Enterprise Linux Atomic Host](FIXME) and the Fedora Project's [Atomic Initiative](http://rpm-ostree.cloud.fedoraproject.org/#/) have evaluation builds available today, with CentOS images coming soon.

## The Elements of Atomic

The Atomic Host comprises a set of packages from an operating system such as Fedora, CentOS, or Red Hat Enterprise Linux, pulled together with [rpm-ostree] to create a filesystem tree that can be deployed, and updated, as an atomic unit. This means that the entire base OS is updated simultaneously, and (just as with Docker containers) can be rolled back if needed.

The Atomic Host inherits features of the base distribution crucial to running Docker containers, but brings along only the essential components to streamlined application delivery. The result is a Host OS with just the right tools, such as [systemd](http://www.freedesktop.org/wiki/Software/systemd/) for managing container dependencies and fault recovery, journald for secure aggregation and attribution of container logs, and SELinux for isolating containers to enable separation of applications and to allow multi-tenant systems. 

Basing the Atomic Host on RPMs used for Fedora, CentOS, or Red Hat Enterprise Linux gives users the ability to deploy hosts that behave like the the rest of their operating systems, and have packages that have undergone extensive testing in general production, but are optimized for Docker deployments.

## Atomic Fusion

Rather than supplanting upstream development, Project Atomic will serve as a community hub for development of the technologies and tools used to create and optimize the Atomic Host for running Docker containers. 

As you can see, some of these elements have been baking for years at all levels of the stack, even long before Docker (but not much of its underlying container technology) was announced. For example, Colin Waters started work on OSTree (the progenitor to rpm-ostree) [years ago to make it simpler for GNOME developers and users](https://lwn.net/Articles/511877/#walters). Our work in systemd, with control groups, and with SELinux also goes back years, and now we're able to pull this together to match the need for a host OS optimized for streamlined application delivery.

Red Hat also has been active in upstream Docker development, with patches accepted recently for SELinux and systemd cgroup integration. We're committed to ensuring that we provide the best experience in running Docker containers, and carry all the related work upstream to Docker. 

## Dig In

Project Atomic is still in early days, but we already have Fedora and Red Hat Enterprise Linux images to test out, and discussion channels for learning more about using and deploying Atomic Hosts. To keep up with our work, be sure to sign up for the announce list, follow us on Twitter, and keep an eye on the Project Atomic blog. Have questions? Send them our way on [Ask.ProjectAtomic.io](http://ask.projectatomic.io).

We're excited to get this work in front of the community and start working with you to improve Project Atomic's features and help you be successful in deploying the technology. 
