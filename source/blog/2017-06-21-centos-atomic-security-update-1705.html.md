---
title: CentOS Atomic Host 1705.1 Security Update
author: jbrooks
date: 2017-06-21 18:00:00 UTC
tags: centos, atomic host
comments: true
published: true
---

We've upgraded the ostree repository for CentOS Atomic Host  (v7.1705.1) to
include updates of the packages affected by [the "Stack Guard" vulnerability](https://access.redhat.com/security/vulnerabilities/stackguard).

Please update your CentOS Atomic Host at the next opportunity, with the command:

```
atomic host upgrade --reboot
```

READMORE

Upgraded:

*  ca-certificates 2017.2.11-70.1.el7_3 -> 2017.2.14-70.1.el7_3
*  glibc 2.17-157.el7_3.2 -> 2.17-157.el7_3.4
*  glibc-common 2.17-157.el7_3.2 -> 2.17-157.el7_3.4
*  kernel 3.10.0-514.21.1.el7 -> 3.10.0-514.21.2.el7
*  python-perf 3.10.0-514.21.1.el7 -> 3.10.0-514.21.2.el7
*  rpcbind 0.2.0-38.el7_3 -> 0.2.0-38.el7_3.1
