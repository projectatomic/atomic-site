---
title: Fedora Atomic communications changes
author: jberkus
date: 2017-07-31 14:00:00 UTC
tags: atomic host, fedora, community
comments: false
published: true
---

The [Fedora Atomic Working Group](https://fedoraproject.org/wiki/Atomic_WG), a major part of Project Atomic, is changing where to join and participate, including mailing lists, IRC, and where to work on Kubernetes integration. Among other things, the Fedora team is becoming more tightly integrated with the rest of Atomic ... and vice-versa.  Read on for details.

## The Atomic WG and Fedora Cloud

The Atomic Working Group is responsible for Fedora's Fedora Atomic Host and the [Fedora Layered Images Build System](https://fedoraproject.org/wiki/Changes/Layered_Docker_Image_Build_Service) & [Repository](https://fedoraproject.org/wiki/Atomic/FLIBS_Catalog) (FLIBS).  As Atomic is now one of the three primary spins for Fedora, the WG spends most of its time on releases and integrating new container technologies into the OS.

At Flock to Fedora 2016, the Atomic WG was split off from the Cloud Working Group, and became its own team with its own PRD.  However, we continued to use the #fedora-cloud IRC channel and the cloud@ mailing list, as we gradually transitioned responsibility for the cloud images to a smaller, [dedicated Cloud WG](https://fedoraproject.org/wiki/Cloud).  Having separated responsibilities entirely, it's now time for us to start using our own channels to communicate.

## New Channels to Reach Us

The Fedora Atomic WG will now be using ProjectAtomic channels for primary discussion.  This will have the benefit of both reducing the number of channels in the Atomic ecosystem overall to make them simpler for new members, and encouraging discussion across Atomic projects.  If you want to participate in Fedora Atomic, here's the primary places to reach us:

IRC: channel [#atomic](irc://irc.freenode.net/atomic), irc.freenode.net

Mailing List: [atomic-devel@projectatomic.io list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)

Issues: [Atomic-WG Pagure](https://pagure.io/atomic-wg)

The Atomic WG also has several other mailing lists and channels, but if you're participating in Fedora Atomic for the first time, start with the ones above.  The cloud@lists.fedoraproject.org and #fedora-cloud channels will now be dedicated entirely to supporting the Cloud Base images.

Related to this, we will be encouraging users of all Atomic projects to communicate on atomic-devel@, rather than atomic@ as in the past.  If the volume of discussion on atomic-devel@ increases in the future, we will split the lists again, but for now it's much simpler to have one list.  Partly to facilitate these moves, the @projectatomic.io mailing lists are being moved to Fedora infrastructure.

## New SIG for Kubernetes

In order for folks from the Kubernetes and CentOS communities to collaborate with Fedora on supporting Kubernetes on Atomic, we have [created a SIG](https://pagure.io/atomic/kubernetes-sig).  This group will focus on Kubernetes deployment and releases for Atomic, both built-in versions and system containers.  If you use Kubernetes on Fedora, you might want to join the group, which is led by Jason Brooks.  They're just getting started, though, so give them some time to get organized.

Thanks, and we hope to see you in the Atomic community!
