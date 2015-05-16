---
author: jzb
comments: true
layout: post
title: CentOS 7 Alpha Builds for Atomic
date: 2014-08-28 17:48 UTC
tags:
- CentOS
- Atomic
- Testing
categories:
- Blog
---
Yesterday, Karanbir Singh [announced an alpha-quality build of CentOS 7 Atomic](http://lists.centos.org/pipermail/centos-devel/2014-August/011784.html) that's suitable for developing rpm-ostree tools and helping the SIG get started.

As KB points out, the images contain unsigned content that's produced outside the CentOS.org build system. You should be able to run Docker containers just fine, but it doesn't yet include Cockpit or Kubernetes packages. 

Also, there's not an upstream ostree repo yet, but KB plans to set up a repo set up under cloud.centos.org soon. Even better, he plans to start running builds every two days as the content stabilizes, and eventually get the builds up on CentOS.org.

Please give it a whirl, though, and report any problems found to the [CentOS-devel](http://lists.centos.org/mailman/listinfo/centos-devel) mailing list. 
