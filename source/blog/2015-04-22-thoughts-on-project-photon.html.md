---
title: Thoughts on Project Photon
author: jzb
date: 2015-04-22 21:19:07 UTC
tags: Open Source, Docker, Rocket, VMware
comments: true
published: true
---

Earlier this week, VMware launched its lightweight operating system tailored for running Linux containers. Naturally, I was interested to see what VMware was cooking up, since that's the same target we have for Project Atomic.

First, it's great to see more interest in solving the problem of running Linux containers at scale. Even better, VMware seems to be interested in doing its work in the open. It's always great to see companies that traditionally lean towards proprietary software taking steps towards doing more open source work. More open source work, even when it's similar to other projects, is almost always a Good Thing&trade;.

That said, I'd like to encourage VMware to consider whether they need to start from scratch with Project Photon. Creating an operating system from scratch is not trivial in the least, and there's a lot of work that could be shared between Photon and Atomic.

## A Common Base?

Naturally, I took Photon for a spin when it was announced Monday. It’s an RPM-based system, which is something we have a lot of experience in delivering -- and we even make all of our tools for Fedora (e.g., Koji) public for folks who want to do it themselves. 

Looking at the source on GitHub and a running instance of Photon, it seems that VMware has taken on the task of packaging and maintaining a lot of components that add no value to Photon. What I mean by this is that they probably could re-use upwards of 85% of CentOS or Fedora packages (or even openSUSE packages) and still customize the components that they feel are strategic or have a need to diverge from the rest of the distribution.

They also seem interested in rpm-ostree (judging by the fact it's installed, though not currently used), so why not join in the work we're already doing there? It'd be fantastic to have VMware (and others) working with us on rpm-ostree and having it more widely deployed. We can accomplish more together!

## Join Us in Making Atomic Even Better

I’d like to specifically invite VMware to join forces with us on Atomic. Maybe it's not clear, but we welcome *anybody* who wants to build on our open source work in Project Atomic, Fedora, CentOS, etc. Whether that consists of working directly with us to improve a shared project that everybody uses as shipped, or whether that consists of taking and making something like a [Fedora Remix](https://fedoraproject.org/wiki/Remix) that uses most of the stock Fedora package set with some additional packages and customizations. We consider it a win when another community or company builds on the work we've done, even if that work winds up in a product that competes with Red Hat's commercial offerings.

Though Red Hat and VMware are competitors, we can (and should) stand shoulder to shoulder when doing work in the community. While we compete, we share a lot of users, and I’m sure they’d like to see us working together.

When it makes sense, we're not shy about adopting excellent open source software being developed in the open &ndash; whether it's something led by a competitor to Red Hat or not. By the same token, we'd encourage VMware and others to join us in building Atomic (and other tools) rather than having to wrestle with problems we've already solved.

One of the core tenets of open source is sharing your work so others don't have to re-do it, freeing people up to tackle new and interesting problems. Building an operating system? That's something we've spent quite a lot of time getting right. That is why we chose to utilize Fedora, CentOS, and Red Hat Enterprise Linux to build Atomic Hosts instead of starting from scratch. Looking at the beginnings of Project Photon, it seems to me that VMware would be able to do its interesting work on top of a Fedora or CentOS set of packages rather than carrying that set on its own and duplicating our effort.

It might sound crazy if you're used to proprietary development, having a competitor extend a hand and say &quot;hey, let's work together!&quot; But that's what open source is really about &ndash; being open to collaboration with a diverse community for the greater good, even while knowing the work you're doing will be shipped by other companies.