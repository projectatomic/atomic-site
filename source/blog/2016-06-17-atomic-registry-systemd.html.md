---
title: Atomic Registry Deployment Update
author: aweiteka
date: 2016-06-17
tags: atomic registry, systemd
published: true
comments: true
---

Since Atomic Registry was [announced](blog/2016/04/atomic-registry-intro/) as *the* enterprise, 100% open source private docker registry, we have been responding to feedback from the community to make it great. The [Cockpit](http://cockpit-project.org/) team has been working hard to improve the console interface and general user experience. The [OpenShift](https://www.openshift.org/) team has been tirelessly updating the backend to make the registry more stable, usable and easier to deploy and maintain.

Some of the feedback we received suggested the deployment method was difficult to understand. As part of OpenShift it pulled in a lot of dependencies that were not essential for running the registry. The OpenShift features are terrific for running clustered container workloads but it can be a barrier to some administrators for just running a standalone registry.

We've tried to strike a balance between ease of deployment, configuration and maintenance while retaining architectural flexibility to support scale, distributed configuration and container best practices. We're doing this through using systemd.

## Why Systemd?

There are several benefits to managing containers with Systemd.

- Mature process management that supports dependencies, logical restart, etc.
- Ease of configuration that matches a traditional sysadmin experience.
- Native system logging to journald.

With this approach we leverage docker packaging to deliver applications that *just work*.

Check out the new [systemd deployment](https://github.com/openshift/origin/tree/master/examples/atomic-registry/systemd) for Atomic Registry. The unit files and setup script have been [packaged as an install container](https://hub.docker.com/r/projectatomic/atomic-registry-install/) so you can quickly pull it down and try it out.

## Open Source. Open Process.

As a Red Hat-sponsored project we see the benefits in practicing **open source** as well as **open process**. We committed to this and worked hard to share our public [Trello organization](https://trello.com/atomicopenshift). The [Atomic Registry roadmap card](https://trello.com/c/0hsX6B4G) aggregates all of the planned and in-progress development work. I've been excited about progress on these specific items:

* Unauthenticated docker pull ([Trello card](https://trello.com/c/Ev8y3pC4))
* Image Signing prototype ([Trello aggregate card](https://trello.com/c/SApLBoLC))
* Support for federated image remotes so ISVs can retain control of their layers without distributing base image layers ([Trello card](https://trello.com/c/DLaMPAoh))
