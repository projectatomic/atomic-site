---
title: Fedora Atomic May 15 Release
author: jberkus
date: 2017-05-23 20:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: cdd359911de49f3a8199ffd41a9894019562001d6cf9be66e1894c31b6fa1c66
Version: 25.127
```

This release returns us to our normal 2-week schedule after some delays with the last two releases.

Notable updates are the kernel, ostree, and selinux-policy.

READMORE

This release contains the following changes since last release:

* ostree diff commit old: 3fd888c674c6d69907eabc665103341e01ebe3a04c3876af6cac673b0bf43662
* ostree diff commit new: cdd359911de49f3a8199ffd41a9894019562001d6cf9be66e1894c31b6fa1c66

Upgraded:

* fedora-release 25-1.noarch -> 25-2.noarch
* fedora-release-atomichost 25-1.noarch -> 25-2.noarch
* fedora-repos 25-3.noarch -> 25-4.noarch
* gnutls 3.5.11-1.fc25.x86_64 -> 3.5.12-2.fc25.x86_64
* kernel 4.10.14-200.fc25.x86_64 -> 4.10.15-200.fc25.x86_64
* kernel-core 4.10.14-200.fc25.x86_64 -> 4.10.15-200.fc25.x86_64
* kernel-modules 4.10.14-200.fc25.x86_64 -> 4.10.15-200.fc25.x86_64
* less 481-6.fc25.x86_64 -> 481-7.fc25.x86_64
* libtirpc 1.0.1-3.rc3.fc25.x86_64 -> 1.0.1-4.rc3.fc25.x86_64
* ostree 2017.5-2.fc25.x86_64 -> 2017.6-2.fc25.x86_64
* ostree-grub2 2017.5-2.fc25.x86_64 -> 2017.6-2.fc25.x86_64
* ostree-libs 2017.5-2.fc25.x86_64 -> 2017.6-2.fc25.x86_64
* python 2.7.13-1.fc25.x86_64 -> 2.7.13-2.fc25.x86_64
* python-libs 2.7.13-1.fc25.x86_64 -> 2.7.13-2.fc25.x86_64
* python3 3.5.3-5.fc25.x86_64 -> 3.5.3-6.fc25.x86_64
* python3-libs 3.5.3-5.fc25.x86_64 -> 3.5.3-6.fc25.x86_64
* rpcbind 0.2.4-5.fc25.x86_64 -> 0.2.4-6.rc1.fc25.x86_64
* selinux-policy 3.13.1-225.13.fc25.noarch -> 3.13.1-225.16.fc25.noarch
* selinux-policy-targeted 3.13.1-225.13.fc25.noarch -> 3.13.1-225.16.fc25.noarch
* system-python 3.5.3-5.fc25.x86_64 -> 3.5.3-6.fc25.x86_64
* system-python-libs 3.5.3-5.fc25.x86_64 -> 3.5.3-6.fc25.x86_64
* vim-minimal 2:8.0.586-1.fc25.x86_64 -> 2:8.0.596-1.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170522.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170522.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170522.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170522.0-x86_64-CHECKSUM)

For direct download, the "latest" targets are always available at the following URLs:

* [Latest ISO](https://getfedora.org/atomic_iso_latest)
* [Latest QCOW](https://getfedora.org/atomic_qcow2_latest)
* [Latest raw image](https://getfedora.org/atomic_raw_latest)
* [Latest LibVirt VM](https://getfedora.org/atomic_vagrant_libvirt_latest)
* [Latest VirtualBox VM](https://getfedora.org/atomic_vagrant_virtualbox_latest)

Filename fetching URLs for downloading to remote systems are available by querying the following links:

* [ISO](https://getfedora.org/atomic_iso_latest_filename)
* [QCOW](https://getfedora.org/atomic_qcow2_latest_filename)
* [raw](https://getfedora.org/atomic_raw_latest_filename)
* [LibVirt](https://getfedora.org/atomic_vagrant_libvirt_latest_filename)
* [VirtualBox](https://getfedora.org/atomic_vagrant_virtualbox_latest_filename)

For more information about the latest targets, please reference [the Fedora
Cloud Wiki space](https://fedoraproject.org/wiki/Cloud#Quick_Links).

The Vagrant Atlas page with the new atomic host:

* [All Fedora boxes](https://atlas.hashicorp.com/fedora/boxes/)
* [Fedora Atomic 25](https://atlas.hashicorp.com/fedora/boxes/25-atomic-host/versions/20170418)

```
vagrant init fedora/25-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/25-atomic-host
```
