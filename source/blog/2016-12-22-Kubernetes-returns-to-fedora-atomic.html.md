---
title: 'Kubernetes is back in Fedora Atomic 25 base'
author: jberkus
date: 2016-12-22 18:00:00 UTC
tags: fedora, atomic, kubernetes
published: true
comments: true
---

**TL;DR**: If you are a production user of Kubernetes on Fedora Atomic Host, you
can now upgrade to Fedora Atomic Host 25.  Kubernetes 1.4 is part of the base
image now.

Per [our previous announcement](/blog/2016/12/notice-to-kubernetes-atomic-users/), we wanted to make a change to Fedora Atomic Host,
and in concert with the Kubernetes community move to an entirely containerized
install of Kubernetes, which would make it easier for users to choose their
Kubernetes version or distribution.  However, some of the upstream technical
issues with that change will take longer than we expected to resolve.  As such,
we have added Kubernetes and Flannel back into the base image for Fedora
Atomic 25, as of today's OStree.

If you are a production user of Fedora Atomic 24 with Kubernetes, you may now
[rebase and upgrade](/blog/2016/11/fedora-atomic-25-released/).  Please make sure to go directly to the 2016-12-21 or later
OSTree image, skipping any earlier ones for version 25.

Do note that the version of Kubernetes which ships with
version 25 is Kubernetes 1.4.6.  As such, you should test to make sure no
incompatibilities have been introduced by the Kubernetes upgrade before rebasing
production servers.  While the goal of the Kubernetes project it to maintain
complete backwards compatibility, there may be minor exceptions, especially for
specific addons.

At this point, we plan to transition to containerized Kubernetes for Fedora
Atomic Host 26, in mid-2017.  At that point, we expect the bugs to be worked out,
and will be providing a migration guide.  If you can help with testing and
feedback, please do so through our [online community](/community/).

Users of Fedora Atomic Host who do not use Kubernetes or Flannel will be
largely unaffected by these changes.
