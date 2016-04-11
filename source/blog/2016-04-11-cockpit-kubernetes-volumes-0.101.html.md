---
title: Cockpit Does Kubernetes Data Volumes
author: stef
date: 2016-04-11 15:45:32 UTC
tags: cockpit, linux, technical, kubernetes
published: true
comments: true
---

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.101 release.

### Kubernetes Volumes

You can now set up Kubernetes [persistent volume claims](http://kubernetes.io/docs/user-guide/persistent-volumes/) through the Cockpit cluster admin interface. These volumes are used to store persistent container data and possibly share them between containers. Each container pod declares the volumes it needs, and when deploying such an application admins configure the locations to store the data in those volumes.

READMORE

Take a look:

<iframe width="640" height="360" src="https://www.youtube.com/embed/rlWeO_MsJOA?rel=0" frameborder="0" allowfullscreen></iframe>

### Show SELinux Failure Messages Properly

As a follow up from last week, several bug fixes landed in the new SELinux troubleshooting support.

### Try It Out

Cockpit 0.101 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.101)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.101-1.fc24)
 * [COPR for Fedora 23, CentOS, and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)
