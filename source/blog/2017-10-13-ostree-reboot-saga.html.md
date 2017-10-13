---
title: Rolling Back Bad Kernel Updates
author: jberkus
date: 2017-10-13 14:00:00 UTC
published: true
comments: false
tags: atomic, fedora, ostree
---

One of main features of Atomic Host is the ability to roll back bad updates.  This includes bad kernel updates.  Since Fedora Atomic follows Linux kernel releases fairly closely, we've seen a few of these, such as the [one which took out my minnowboard test cluster on August 22](/blog/2017/09/fedora-atomic-26-120/).

READMORE

This is my rolling test cluster, so it already had Fedora Atomic on it, originally the August 6th release:

```
-bash-4.4# rpm-ostree status
State: idle
Deployments:
● fedora-atomic-26:fedora/26/x86_64/atomic-host
                   Version: 26.101 (2017-08-06 21:27:14)
                    Commit: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D

  fedora-atomic-26:fedora/26/x86_64/updates/atomic-host
                   Version: 26.114 (2017-08-24 15:05:44)
                    Commit: 59bc8e66abe22c4338aecbd300b5343f0e44537204496dc25f0541b079b28b4d
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
```

I used `rpm-ostree upgrade` to bring it up to date with the August 20th release, planning to test [Kubernetes in system containers](/blog/2017/09/running-kubernetes-on-fedora-atomic-26/) on it.  After running the upgrade, I restarted and ... uh-oh.

Instead of booting, after the grub prompt I just got a blinking cursor: no OS and it refused to proceed.  I'd hit an issue which affected minnowboards in the kernel which came with this release. On regular Fedora Server, I might have no choice at this point except to re-install ... but this is Atomic.

I manually rebooted, and saw this grub menu:

```
Fedora 26 (Atomic Host) 26.110 (OStree)
Fedora 26 (Atomic Host) 26.101 (OStree)
```

This menu lists the last two ostree releases I'd booted.  By default, the most recent one is going to boot. But I grabbed a keyboard and selected the prior release, `26.101`, instead.

This time the system booted up fine, into the version of Atomic I'd been running before the upgrade:

```
-bash-4.4# rpm-ostree status
State: idle
Deployments:
  fedora-atomic-26:fedora/26/x86_64/atomic-host
                   Version: 26.110 (2017-08-20 18:10:09)
                    Commit: 13ed0f241c9945fd5253689ccd081b5478e5841a71909020e719437bbeb74424
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D

● fedora-atomic-26:fedora/26/x86_64/atomic-host
                   Version: 26.101 (2017-08-06 21:27:14)
                    Commit: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
```

So you can see here that `26.110` is still present on the system, but we're booted into `26.101`.  Which means that my work wasn't done; if I rebooted the system for some reason, it would try to boot into the bad release.  I needed to remove that release, using `rpm-ostree cleanup -p`, which removes the "pending" release.

At this point, I was back to my starting state before the bad kernel update:

```
-bash-4.4# rpm-ostree status
State: idle
Deployments:
● fedora-atomic-26:fedora/26/x86_64/atomic-host
                   Version: 26.101 (2017-08-06 21:27:14)
                    Commit: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
```

After that, I waited a few days for the issue I reported to be patched.  Once it was, on August 24th, I was able to safely `rpm-ostree upgrade` the machine:

```
[atomic@node4 ~]$ rpm-ostree status
State: idle
Deployments:
● fedora-atomic-26:fedora/26/x86_64/updates/atomic-host
                   Version: 26.114 (2017-08-24 15:05:44)
                    Commit: 59bc8e66abe22c4338aecbd300b5343f0e44537204496dc25f0541b079b28b4d
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D

  fedora-atomic-26:fedora/26/x86_64/atomic-host
                   Version: 26.101 (2017-08-06 21:27:14)
                    Commit: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
```

Thanks to Ostree and Atomic, I was able to keep testing on my minnowboard cluster without a complete reinstall.  Which was a good thing, because [a month later it happened again](/blog/2017/10/fedora-atomic-26-oct-5/).

Maybe I need to donate a testing minnowboard to kernel.org?
