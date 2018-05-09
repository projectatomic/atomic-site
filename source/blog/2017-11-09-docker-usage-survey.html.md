---
title: Atomic Host and Docker Survey
author: jberkus
date: 2017-11-8 14:00:00 UTC
published: true
comments: false
tags: atomic, fedora, docker, CRI-O
---

The Fedora Atomic Working Group needs your help to decide how Docker will be included in Fedora Atomic Host in the future.  If you're already familiar with this issue, you can [skip straight to the survey](https://goo.gl/forms/2WTX3EHTX6IxVldp1).  Otherwise, read on for some background.

READMORE

Currently, the Docker container runtime and tools ship as a part of Fedora Atomic Host in the base cloud image and ISO.  Docker is also part of the base OSTree and thus gets included in all atomic updates to the system (`atomic host upgrade`).  This has clearly been useful to a lot of people, but there's some problems with it:

* Docker and its dependencies add around 180MB to the base image;
* Upstream updates to Docker increase the number of updates users need to apply to the base OS;
* No one version of Docker satisfies all users;
* Some users don't want Docker at all, they want CRI-O or containerd or just runc;
* Docker upgrades complicate Fedora Atomic's plan to move to rolling upgrades.

The potential alternative to this is removing Docker from the base image and OSTree, and instead having users install it as a system container.  This would mean, on each new Fedora Atomic Host, adding the extra step of running:

```
atomic install --system docker
```

... for each system.  Updates to Docker would also be on an independent cycle from the base OS, which is both extra work for admins, and an advantage for those who want to update Docker frequently.  There are some other disadvantages to moving to Docker in system containers:

* The upgrade from Fedora 27 Atomic Host to Fedora 28 Atomic Host would be more complicated;
* It would be up to the user to keep kernel versions and Docker versions compatible;
* Rollback of a bad Docker upgrade would require more steps;
* Admins who have Atomic Host in production will need to update all their system automation.

Given this tradeoff, we need to know how this possible change would affect Atomic Host users.  Will it make life simpler for you, not affect you at all, or blow up your infrastructure and cause you to migrate to RancherOS?  Let us know by filling out our [survey]() on your Docker and Atomic Host usage.

If you want to express additional opinions about this change, you can talk to Atomic Host developers directly, either on channel [#atomic on irc.freenode.net](https://webchat.freenode.net/), or on email at [atomic-devel@projectatomic.io](https://lists.projectatomic.io/mailman/listinfo/atomic-devel).  Or you can comment on [this Pagure issue](https://pagure.io/atomic-wg/issue/360).

*Note that we are currently only discussing this change for Fedora Atomic Host.  CentOS Atomic Host and Red Hat Atomic host might or might not adopt the same change at some later date, depending on their strategies.  To support this change, we would also simplify the commands for installing system containers.*
