---
author: walters
layout: post
title: First atomic upgrade for Fedora 21 Atomic
date: 2014-12-20 23:07 UTC
tags:
- Fedora
- Docker
- Upgrade
categories:
- Blog
---
There was an update earlier that was broken due to [a bug in rpm-ostree](https://github.com/projectatomic/rpm-ostree/commit/3e84cb249acbaa1b664aeb30e6534a3ebc6bb23e). This is fixed by [a new release of rpm-ostree](https://admin.fedoraproject.org/updates/rpm-ostree-2014.114-2.fc21?_csrf_token=9c9be2b07813e17db050fbbec3533d5abf005ebb).

You should now be able to "atomic upgrade."  The delta you should see as of today from gold follows.  Things to call out specifically:

 - Lots of CVE fixes, notably to docker
 - Major new version of kubernetes

READMORE

Note that this update *adds* flannel.  This is a key aspect of the "image-like" feel of rpm-ostree.  With [this commit](https://git.fedorahosted.org/cgit/fedora-atomic.git/commit/?h=f21&id=9e4082f9ce8506cd8b2138e986358b5e533767b5) it was added to the tree. (And conversely, if a package is removed there, it's removed when you upgrade.)  

For the new Kubernetes, I recommend looking at [this blog entry](http://www.projectatomic.io/blog/2014/11/testing-kubernetes-with-an-atomic-host/). [This repository has Ansible scripts](https://github.com/eparis/kubernetes-ansible) that are a useful reference for Flannel set up as well.

**Upgraded:**

 - NetworkManager-1:0.9.10.0-14.git20140704.fc21.x86_64
 - NetworkManager-glib-1:0.9.10.0-14.git20140704.fc21.x86_64
 - PackageKit-glib-1.0.3-4.fc21.x86_64
 - avahi-autoipd-0.6.31-30.fc21.x86_64
 - avahi-libs-0.6.31-30.fc21.x86_64
 - cpio-2.11-33.fc21.x86_64
 - curl-7.37.0-11.fc21.x86_64
 - dbus-1:1.8.12-1.fc21.x86_64
 - dbus-libs-1:1.8.12-1.fc21.x86_64
 - docker-io-1.4.0-1.fc21.x86_64
 - dracut-038-31.git20141204.fc21.x86_64
 - dracut-config-generic-038-31.git20141204.fc21.x86_64
 - filesystem-3.2-28.fc21.x86_64
 - grep-2.21-1.fc21.x86_64
 - hawkey-0.5.2-1.fc21.x86_64
 - hwdata-0.272-1.fc21.noarch
 - initscripts-9.56.1-5.fc21.x86_64
 - kernel-3.17.6-300.fc21.x86_64
 - kernel-core-3.17.6-300.fc21.x86_64
 - kernel-modules-3.17.6-300.fc21.x86_64
 - kmod-19-1.fc21.x86_64
 - kmod-libs-19-1.fc21.x86_64
 - kubernetes-0.6-4.0.git993ef88.fc21.x86_64
 - libblkid-2.25.2-2.fc21.x86_64
 - libcurl-7.37.0-11.fc21.x86_64
 - libdrm-2.4.58-3.fc21.x86_64
 - libmount-2.25.2-2.fc21.x86_64
 - libreport-filesystem-2.3.0-5.fc21.x86_64
 - libsmartcols-2.25.2-2.fc21.x86_64
 - libuuid-2.25.2-2.fc21.x86_64
 - libyaml-0.1.6-6.fc21.x86_64
 - net-tools-2.0-0.31.20141124git.fc21.x86_64
 - nss-3.17.3-1.fc21.x86_64
 - nss-softokn-3.17.3-1.fc21.x86_64
 - nss-softokn-freebl-3.17.3-1.fc21.x86_64
 - nss-sysinit-3.17.3-1.fc21.x86_64
 - nss-tools-3.17.3-1.fc21.x86_64
 - nss-util-3.17.3-1.fc21.x86_64
 - openssh-6.6.1p1-9.fc21.x86_64
 - openssh-clients-6.6.1p1-9.fc21.x86_64
 - openssh-server-6.6.1p1-9.fc21.x86_64
 - pcre-8.35-8.fc21.x86_64
 - ppp-2.4.7-5.fc21.x86_64
 - rpcbind-0.2.2-0.0.fc21.x86_64
 - rpm-4.12.0.1-4.fc21.x86_64
 - rpm-build-libs-4.12.0.1-4.fc21.x86_64
 - rpm-libs-4.12.0.1-4.fc21.x86_64
 - rpm-ostree-2014.114-2.fc21.x86_64
 - rpm-plugin-selinux-4.12.0.1-4.fc21.x86_64
 - rpm-python-4.12.0.1-4.fc21.x86_64
 - selinux-policy-3.13.1-103.fc21.noarch
 - selinux-policy-targeted-3.13.1-103.fc21.noarch
 - sqlite-3.8.7.2-1.fc21.x86_64
 - sudo-1.8.11p2-1.fc21.x86_64
 - tcpdump-14:4.6.2-2.fc21.x86_64
 - tzdata-2014j-1.fc21.noarch
 - util-linux-2.25.2-2.fc21.x86_64

**Added:**

 - flannel-0.1.0-8.gita7b435a.fc21.x86_64
