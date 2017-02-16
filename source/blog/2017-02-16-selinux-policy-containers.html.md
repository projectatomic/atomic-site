---
title: 'Tightening Up SELinux Policy for Containers'
author: dwalsh
date: 2017-02-16 14:00:00 UTC
tags: selinux, docker, atomic, security
published: true
comments: true
---

I wrote a blog post a couple of weeks ago [explaining how SELinux can block breakout](http://rhelblog.redhat.com/2017/01/13/selinux-mitigates-container-vulnerability/) of processes in containers using when exploiting a vulnerability in the `/usr/bin/docker-runc` or `/usr/bin/runc` executable.  At the time, I explained that the policy for `container_t` was blocked from writing to most parts of the OS other the container content labeled `container_file_t`. Despite blocking writes, though, it still allowed reads of some files.

A few people were alarmed when they realized that SELinux would block the breakout on writes but there is a chance for information leakage into the container. The usual example was the ability to read /etc/passwd from the host. But this isn't unlimited access to the host. If the same container processes tried to read /etc/shadow on the hosts, or content in users home directories, or database data in /var, they would be blocked.

READMORE

## Why is that allowed?

When writing SELinux policy for a general purpose process type, you always have a battle between security and usability.  If you make the policy too tight, no one will use it. If you make it too loose, then it provides little additional security. Finding the sweet spot in the middle is difficult. The default SELinux policy allows this access for two main reasons.

The original policy for containers was written before docker for virt-sandbox. virt-sandbox was an effort to use libvirt-lxc tooling for splitting up the host OS Into several containers. Our idea at the time was to allow you to run multiple containers with a shared /usr and perhaps a shared /etc, but have each container have its own /var.  The thinking was read only content in /etc is shared with unprivileged users, and an admin should control the data available in /etc. Think of having hundreds of containers each running the same apache services off of the host OS.  Each one having their own private writable directories under /var.
When docker came along, we decided to use the same policy mainly to allow people do things like:

```
docker run -v /etc/passwd:/etc/passwd rhel7 sh
```

Or

```
docker run -d -v /usr:/usr rhel7 /usr/bin/foobar
```

Also we saw people volume mounting in things like /etc/resolv.conf, /etc/hosts, /etc/localtime ...

This allowed us flexibility on labeling, with limited exposure to information leak. Upstream docker now has the ability to relabel content on the host when running inside of a container.

Executing a command like the following:

```
docker run -d -v /var/lib/mariadb:/var/lib/madiadb:Z mariadb
```

Will cause the docker daemon to relabel the /var/lib/mariadb on the host to match the label of the container.  But you would not want to do this with shared content in /etc.

Using the ‘:Z’ on /etc/passwd would be a bad idea.

```
docker run -v /etc/passwd:/etc/passwd:Z rhel7 sh
```

This command relabels /etc/passwd to a label that blocks access to other confined applications, potentially breaking those applications.

Since these issues have been pointed out I have decided to tighten the default policy by eliminating the container process types' ability to read default labels in /etc.  This will prevent a container process from being able to read /etc/passwd and other default files, but may cause certain issues when people want to volume mount in content from the hosts /etc directory.  We will try this out in Rawhide and Fedora 26, and see if it does not cause issues, eventually back port it to RHEL.
