---
title: New CentOS Atomic Host with Package Layering Support
author: jbrooks
date: 2016-08-30 18:38:04 UTC
tags: centos, rpm-ostree
published: false
comments: true
---

Last week, the CentOS Atomic SIG [released](https://seven.centos.org/2016/08/announcing-a-new-release-of-centos-atomic-host-2/) an updated version of CentOS Atomic Host (tree version 7.20160818), featuring support for rpm-ostree package layering. 

CentOS Atomic Host is available as a VirtualBox or libvirt-formatted Vagrant box, or as an installable ISO, qcow2 or Amazon Machine image. Check out the [CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) for download links and installation instructions, or read on to learn more about what’s new in this release.

CentOS Atomic Host includes these core component versions:

* docker-1.10.3-46.el7.centos.10.x86_64
* kubernetes-1.2.0-0.13.gitec7364b.el7.x86_64
* kernel-3.10.0-327.28.2.el7.x86_64
* atomic-1.10.5-7.el7.x86_64
* flannel-0.5.3-9.el7.x86_64
* ostree-2016.7-2.atomic.el7.x86_64
* etcd-2.3.7-2.el7.x86_64
* cloud-init-0.7.5-10.el7.centos.1.x86_64

## Package Layering

Using the command rpm-ostree pkg-add, it’s now possible to layer new packages into an installed image that persist across reboots and upgrades, a topic that [Jonathan Lebon](https://github.com/jlebon) [covered in some detail](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host/) in a post last month.

For instance, if I wanted to install ansible on an atomic host:

```
# rpm-ostree pkg-add epel-release
# reboot
# rpm-ostree pkg-add ansible
# reboot
# ansible --version
ansible 2.1.1.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = Default w/o overrides
```

I first installed the `epel-release` package because ansible lives in EPEL. The intermediate reboot was required to boot into the new EPEL-i-fied tree. I could have instead added the repo file for EPEL in my `/etc/yum.repos.d/` directory, and skipped the extra install and reboot operations. To learn about the work going on to make package layering more "live," check out [this issue](https://bugzilla.gnome.org/show_bug.cgi?id=767977).

There are limitations to package layering. For instance, I've [written in the past](http://www.projectatomic.io/blog/2015/01/running-ovirt-guest-agent-as-privileged-container/) about running oVirt's guest agent (which is not part of the standard atomic host image) in a docker container. Package layering won't work for this scenario, because installing packages which contain files owned by users other than root is currently not supported:

```
# rpm-ostree pkg-add ovirt-guest-agent-common
notice: pkg-add is a preview command and subject to change.

Downloading metadata: [================================================] 100%
Resolving dependencies... done
Will download: 3 packages (209.2 kB)

  Downloading from epel: [=============================================] 100%

  Downloading from base: [=============================================] 100%

Importing: [===================                                        ]  33%
error: Unpacking ovirt-guest-agent-common-1.0.12-3.el7.noarch: Non-root ownership currently unsupported: path "/var/log/ovirt-guest-agent" marked as ovirtagent:ovirtagent)
```

## CentOS Atomic Host Alpha

While it's not yet possible to pkg-add packages with files owned by users other than root on the current CentOS Atomic Host release, the host's [Alpha stream ](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) includes a newer version of rpm-ostree that works just fine with these sorts of packages.

Apart from its newer rpm-ostree version, the Alpha release of CentOS Atomic Host now features a [much slimmer package list](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2016-August/msg00104.html), as the project begins to move toward containerization or package layering for system components such as kubernetes, flannel, and etcd.