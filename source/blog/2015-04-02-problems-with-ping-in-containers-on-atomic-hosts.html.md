---
author: dwalsh
layout: post 
title: Addressing Problems with Ping in Containers on Atomic Hosts
date: 2015-04-02 15:44 UTC
tags:
- Ping
- RHEL Atomic
- Docker
categories:
- Blog
---

Having problems with `ping` in your containers? It might not be what you think! 

## Problem Statement

We received a bug report the other day with the following comment:

On a RHEL 7 host (registered and subscribed), I can use Yum to install additional packages from `docker run ...` or in a Docker file.  If I install the `iputils` package (and any dependencies), the basic `ping` command does not work.  However, if I use the `busybox` image from the public Docker index, its ping command works perfectly fine (on same RHEL 7 host).

# Steps to Reproduce:
```
# docker run -i -t registry.access.redhat.com/rhel7:0-21 bash
# yum install -y iputils
# ping 127.0.0.1
bash: /usr/bin/ping: Operation not permitted
```

```
# docker run -ti --rm busybox /bin/sh
# editor
# ping google.com
PING google.com (74.125.226.4): 56 data bytes
64 bytes from 74.125.226.4: seq=0 ttl=52 time=44.923 ms
64 bytes from 74.125.226.4: seq=1 ttl=52 time=46.181 ms
^C
```

## Don't Blame SELinux!

This was not an SELinux issue, since it happened if you put the machine in permissive mode.

My first idea when I saw this was that ping needs a set of capabilities enabled: `net_raw` and `net_admin`. By default our containers run without the net_admin capability.

What if I added `net_admin` capability, would the container work?

```
# docker run -i -t --cap-add net_raw --cap-add net_admin registry.access.redhat.com/rhel7:0-21 bash
# ping google.com
PING google.com (74.125.228.3) 56(84) bytes of data.
64 bytes from iad23s05-in-f3.1e100.net (74.125.228.3): icmp_seq=1 ttl=47 time=11.0 ms
64 bytes from iad23s05-in-f3.1e100.net (74.125.228.3): icmp_seq=2 ttl=47 time=11.1 ms
^C
```

But I really do not want to have to run a `privileged` container, just so ping will work. But then we got more information on the bugzilla, where someone just copied the executable to another name and it worked.

Then another engineer tried to just copy the ping command to another name, **and it worked**!

```
# docker run -i -t registry.access.redhat.com/rhel7:0-21 bash
# yum install -y iputils
# ping 127.0.0.1
bash: /usr/bin/ping: Operation not permitted
# mkdir -p /opt/ping
# cp /usr/bin/ping /opt/ping/
# /opt/ping/ping -c1 10.3.1.1
PING 10.3.1.1 (10.3.1.1) 56(84) bytes of data.
64 bytes from 10.3.1.1: icmp_seq=1 ttl=62 time=0.358 ms
...
```

This told us their must be something about the permissions on the `ping` command itself.

We eventually figured out the problem was caused by using with File Capabilities.

In Red Hat based distributions we are using File Capabilties which allow applications to start up with a limited number of capabilities, even if launched by root. In other distributions like busybox and Ubuntu, the ping command is shipped as setuid root.  If we executed `chcon 4755 /usr/bin/ping` in the container, ping would start to work.

```
# getcap  /usr/bin/ping
/usr/bin/ping = cap_net_admin,cap_net_raw+ep
```

Let's take a look at the man page to see what it has to say about capabilities:

```
man capabilities
...
   File capabilities
       Since kernel 2.6.24, the kernel supports associating capability sets with an executable file using setcap(8).  The file capability sets are stored in an extended attribute (see setxattr(2)) named security.capability.  Writing  to  this  extended  attribute  requires  the CAP_SETFCAP capability.  The file capability sets, in conjunction with the capability sets of the thread, determine the capabilities of a thread after an execve(2).

       The three file capability sets are:

       Permitted (formerly known as forced):
              These capabilities are automatically permitted to the thread, regardless of the thread's inheritable capabilities.

       Inheritable (formerly known as allowed):
              This set is ANDed with the thread's inheritable set to determine which inheritable capabilities are enabled in the permitted set of the thread after the execve(2).

       Effective:
              This is not a set, but rather just a single bit.  If this bit is set, then during an execve(2) all of the new permitted capabilities for the thread are also raised in the effective set.  If this bit is not set, then after an execve(2),  none  of  the  new permitted capabilities is in the new effective set.
```

By setting the file capabilities on ping to `cap_net_admin,cap_net_raw+ep`, this means when a user executes the ping command the kernel will attempt to gain cap_net_admin and cap_net_raw capabilities when it gets executed. If both capabilities are not available to the user, the execution will fail.  

It's the `execve()` of `/usr/bin/ping` in the first place that is failing:

```
# strace ping -h
execve("/usr/bin/ping", ["ping", "-h"], [/* 12 vars */]) = -1 EPERM (Operation not permitted)
```

If however we removed the `Effective` bit, the application will execute and would only fail if it tried to execute a system call that requires the `cap_net_raw` capability, due to it attempting to raise capabilities that are not available.


```
# setcap cap_net_raw,cap_net_admin+p /usr/bin/ping
# ping -c1 10.3.1.1
PING 10.3.1.1 (10.3.1.1) 56(84) bytes of data.
64 bytes from 10.3.1.1: icmp_seq=1 ttl=62 time=0.358 ms
...
```

## Remove +e from binaries calling "capset()"

The short answer is, +e should be removed from all binaries which call `capset()`.  

There is no need for the kernel to automatically add those capabilities on `execve()`.  The ping application is doing that step itself.

We have opened up Bugzilla on iputils to fix this in the package for RHEL and Fedora. In the meantime, if your application is blowing up for strange reasons within a container, you might want to check out its file capabilities.
