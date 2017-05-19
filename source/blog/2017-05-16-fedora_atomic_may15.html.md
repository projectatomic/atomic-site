---
title: Fedora Atomic May 15 Release
author: jberkus
date: 2017-05-16 15:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 3fd888c674c6d69907eabc665103341e01ebe3a04c3876af6cac673b0bf43662
Version: 25.122
```

Unfortunately we had some release engineering hiccups last week. Which caused us
to not have a release candidate with all the fixes we needed until Friday. We will
get back on track next week.

Notable updates are the atomic CLI, ostree and rpm-ostree.

READMORE

This release contains the following changes since last release:

* ostree diff commit old: 3492546bc1ef6bca1bc7801ed6bb0414f90cc96668e067996dba3dee0d83e6c3
* ostree diff commit new: 3fd888c674c6d69907eabc665103341e01ebe3a04c3876af6cac673b0bf43662

Upgraded software:

* NetworkManager 1:1.4.4-4.fc25.x86_64 -> 1:1.4.4-5.fc25.x86_64
* NetworkManager-libnm 1:1.4.4-4.fc25.x86_64 -> 1:1.4.4-5.fc25.x86_64
* NetworkManager-team 1:1.4.4-4.fc25.x86_64 -> 1:1.4.4-5.fc25.x86_64
* atomic 1.15.1-1.fc25.x86_64 -> 1.17.1-4.fc25.x86_64
* ca-certificates 2017.2.11-1.1.fc25.noarch -> 2017.2.14-1.0.fc25.noarch
* coreutils 8.25-16.fc25.x86_64 -> 8.25-17.fc25.x86_64
* coreutils-common 8.25-16.fc25.x86_64 -> 8.25-17.fc25.x86_64
* cryptsetup 1.7.4-1.fc25.x86_64 -> 1.7.5-1.fc25.x86_64
* cryptsetup-libs 1.7.4-1.fc25.x86_64 -> 1.7.5-1.fc25.x86_64
* elfutils-default-yama-scope 0.168-1.fc25.noarch -> 0.169-1.fc25.noarch
* elfutils-libelf 0.168-1.fc25.x86_64 -> 0.169-1.fc25.x86_64
* elfutils-libs 0.168-1.fc25.x86_64 -> 0.169-1.fc25.x86_64
* emacs-filesystem 1:25.1-3.fc25.noarch -> 1:25.2-2.fc25.noarch
* freetype 2.6.5-3.fc25.x86_64 -> 2.6.5-7.fc25.x86_64
* kernel 4.10.11-200.fc25.x86_64 -> 4.10.14-200.fc25.x86_64
* kernel-core 4.10.11-200.fc25.x86_64 -> 4.10.14-200.fc25.x86_64
* kernel-modules 4.10.11-200.fc25.x86_64 -> 4.10.14-200.fc25.x86_64
* libidn2 2.0.0-1.fc25.x86_64 -> 2.0.2-1.fc25.x86_64
* libsolv 0.6.26-3.fc25.x86_64 -> 0.6.27-1.fc25.x86_64
* libsss_idmap 1.15.2-2.fc25.x86_64 -> 1.15.2-3.fc25.x86_64
* libsss_nss_idmap 1.15.2-2.fc25.x86_64 -> 1.15.2-3.fc25.x86_64
* libsss_sudo 1.15.2-2.fc25.x86_64 -> 1.15.2-3.fc25.x86_64
* nfs-utils 1:2.1.1-4.rc2.fc25.x86_64 -> 1:2.1.1-5.rc2.fc25.x86_64
* nspr 4.13.1-1.fc25.x86_64 -> 4.14.0-2.fc25.x86_64
* nss 3.29.3-1.1.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* nss-softokn 3.29.5-1.0.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* nss-softokn-freebl 3.29.5-1.0.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* nss-sysinit 3.29.3-1.1.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* nss-tools 3.29.3-1.1.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* nss-util 3.29.5-1.0.fc25.x86_64 -> 3.30.2-1.0.fc25.x86_64
* oci-systemd-hook 1:0.1.6-1.gitfe22236.fc25.x86_64 -> 1:0.1.7-1.git1788cf2.fc25.x86_64
* ostree 2017.3-2.fc25.x86_64 -> 2017.5-2.fc25.x86_64
* ostree-grub2 2017.3-2.fc25.x86_64 -> 2017.5-2.fc25.x86_64
* ostree-libs 2017.3-2.fc25.x86_64 -> 2017.5-2.fc25.x86_64
* publicsuffix-list-dafsa 20170206-1.fc25.noarch -> 20170424-1.fc25.noarch
* python3 3.5.3-4.fc25.x86_64 -> 3.5.3-5.fc25.x86_64
* python3-libs 3.5.3-4.fc25.x86_64 -> 3.5.3-5.fc25.x86_64
* python3-sssdconfig 1.15.2-2.fc25.noarch -> 1.15.2-3.fc25.noarch
* rpm-ostree 2017.4-2.fc25.x86_64 -> 2017.5-2.fc25.x86_64
* rsync 3.1.2-2.fc24.x86_64 -> 3.1.2-3.fc25.x86_64
* sssd-client 1.15.2-2.fc25.x86_64 -> 1.15.2-3.fc25.x86_64
* system-python 3.5.3-4.fc25.x86_64 -> 3.5.3-5.fc25.x86_64
* system-python-libs 3.5.3-4.fc25.x86_64 -> 3.5.3-5.fc25.x86_64
* vim-minimal 2:8.0.562-1.fc25.x86_64 -> 2:8.0.586-1.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170512.2/CloudImages/x86_64/images/Fedora-CloudImages-25-20170512.2-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170512.2/Atomic/x86_64/iso/Fedora-Atomic-25-20170512.2-x86_64-CHECKSUM)

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
