---
title: Download and Get Involved with Fedora Atomic 24
author: jbrooks
date: 2016-07-28 07:00:00 UTC
tags: fedora, docker, kubernetes
published: false
comments: true
---

This week, the Fedora Project released updated images for its Fedora 24-based Atomic Host. Fedora Atomic Host is a leading edge operating system designed around Kubernetes and Docker containers.

Fedora Atomic Host images are updated roughly every two weeks, rather than on the main six-month Fedora cadence. Because development is moving quickly, only the latest major Fedora release is supported.

_Note: Due to an issue with the image-building process, the current Fedora Atomic Host images include an older version of the system tree. Be sure to `atomic host upgrade` to  get the latest set of components. The next two-week media refresh will include an up-to-date tree._

Fedora Atomic Host includes these core component versions:

* kernel-4.6.4-301.fc24.x86_64
* docker-1.10.3-24.git29066b4.fc24.x86_64
* kubernetes-1.2.0-0.24.git4a3f9c5.fc24.x86_64
* atomic-1.10.5-1.gitce09e40.fc24.x86_64
* rpm-ostree-2016.4-2.fc24.x86_64
* flannel-0.5.5-6.fc24.x86_64
* etcd-2.2.5-5.fc24.x86_64
* cloud-init-0.7.6-8.20150813bzr1137.fc24.noarch

READMORE

### Upgrading 

Upgrading from an existing Atomic Host to Fedora Atomic 24 involves replacing the Fedora 23-based fedora-atomic remote with the current one, and then rebasing on the new tree. Due to [this issue](https://bugzilla.redhat.com/show_bug.cgi?id=1309075), it may be necessary to put SELinux into permissive mode for the rebase operation:
 
```
$ sudo setenforce 0
$ sudo ostree remote delete fedora-atomic
$ sudo ostree remote add fedora-atomic --set=gpg-verify=false https://dl.fedoraproject.org/pub/fedora/linux/atomic/24
$ sudo rpm-ostree rebase fedora-atomic:fedora-atomic/24/x86_64/docker-host
$ sudo reboot
```

### Atomic Images 

Fedora Atomic Host is available as a virtualbox or libvirt vagrant image, as an installable iso image, as a raw or qcow2-formatted cloud image, or as an Amazon AMI.

To bring up Fedora Atomic Host in a vagrant box, issue a command like:

```
vagrant init fedora/24-atomic-host && vagrant up
```

If you've previously used vagrant to run a Fedora Atomic 24 VM, first run `vagrant box update --box=fedora/24-atomic-host` to ensure that you have the latest version.

NOTE: Due to [this issue](https://pagure.io/pungi-fedora/issue/26), you'll need to add a line to your Vagrantfile like `config.vm.synced_folder "./", "/vagrant", disabled: 'true'` to disable folder sync.

Fedora Atomic Host is available as a [qcow2 or raw-formatted image](https://getfedora.org/en/cloud/download/atomic.html), both of which require a cloud-init data source, be it from your cloud or virtualization provider, or from a [local source](http://www.projectatomic.io/blog/2014/10/getting-started-with-cloud-init/).

The Fedora Project maintains Atomic Host images for Amazon EC2 in both GP2 (SSD-based) and standard formats. Check out the atomic host [download page](https://getfedora.org/en/cloud/download/atomic.html) for AMI IDs specific to your desired region.

There's also an anaconda-based [ISO installer](https://getfedora.org/en/cloud/download/atomic.html) for use with bare metal or as an alternative to configuring cloud-init for virtual machines.

### Get Involved

To get involved with Fedora Atomic Host, get in touch with the [Fedora Cloud SIG](https://fedoraproject.org/wiki/Cloud_SIG). The SIG meets each week on Wednesdays at 17:00 UTC in the #fedora-meetings-1 channel, and hangs out in the #fedora-cloud channel and on the [Fedora Cloud mailing list](http://lists.fedoraproject.org/pipermail/cloud/).

One of the best ways help out with Fedora Atomic is to participate in testing core atomic host components using Fedora's [Bodhi](https://fedoraproject.org/wiki/Bodhi). Following [this link](https://bodhi.fedoraproject.org/updates/?packages=kubernetes%20docker%20rpm-ostree%20atomic%20flannel%20etcd%20cloud-init&status=testing&release=F24) will provide a list of key atomic packages currently in need of testing for Fedora 24. 

The Fedora Project maintains a version of the Fedora Atomic system tree that includes packages from the updates-testing repo. Rebasing an atomic host to this tree is a handy way to run the latest packages in need of testing:

```
$ sudo rpm-ostree rebase fedora-atomic:fedora-atomic/24/x86_64/testing/docker-host
$ sudo systemctl reboot
```

If you have questions about how best to test one of these packages, ask on the Fedora Cloud mailing list or in the #fedora-cloud in irc.