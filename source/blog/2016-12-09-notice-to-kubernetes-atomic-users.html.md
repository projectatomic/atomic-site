---
title: 'Important Notice for Users of Kubernetes on Fedora Atomic'
author: jberkus
date: 2016-12-09 16:00:00 UTC
tags: fedora, atomic, kubernetes
published: true
comments: true
---

**TL;DR**: If you are a production user of Kubernetes on Fedora Atomic Host, please
don't rebase to Fedora Atomic 25 yet.

One of the features of the [Fedora Atomic Host 25](/blog/2016/11/fedora-atomic-25-released/)
release was decoupling Kubernetes
from the base ostree for Atomic (this is true of the current CentOS Atomic Host
as well).  That is, Kubernetes is no longer in the base install, you need to
add it in as system containers and/or an overlay.  This is a step forwards for
Atomic because it means that users can continuously update Atomic, and update
Kubernetes on a different schedule which works for their cluster.  Since Kubernetes
gets released four times a year, this lets developers update to the latest
version, and production users stay on their production version.

However, when we released Fedora Atomic 25, the containerized install wasn't
quite ready, and there were [issues with installing Kubernetes using package
layering](https://github.com/projectatomic/rpm-ostree/issues/462)
which we hadn't anticipated.  At the time, we expected those issues to
be resolved within a few days.  Instead, some have taken longer than expected
and are still unresolved or waiting on PR review.

The Fedora Atomic team is hard at work on getting a solution out for Kubernetes
users and expect to have one before the holidays.  If you are able to help with
building or testing, please speak up on the Atomic Development mailing list; we
could use your help.  If you can't help, wait for us to publish documentation
of the new containerized Kubernetes before you rebase to 25.  Bug fixes are
still available for the Fedora 24 tree.

If you use Fedora Atomic, but do not use Kubernetes, this issue does not affect
you.  If you are using Kubernetes based on a containerized install already
(via Kubeadm or Hyperkube), this issue is also not a problem for you.  Unaffected
users should [rebase to Fedora Atomic 25](blog/2016/11/fedora-atomic-25-released/)
for updated libraries and platforms,
including the latest OpenShift and Docker support.

Thanks for your patience, and we'll see you on the
[mailing lists](https://lists.projectatomic.io/mailman/listinfo/atomic) and IRC with
any other issues.
