---
title: Fedora Atomic June 6 Release
author: jberkus
date: 2017-06-07 20:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 0ed61d7441eddf96e6a98de4f10f4675268c7888b6d2b8a405b8c21fe6c92d23
Version: 25.137
```
Notable updates are the kernel, systemd, bubblewrap, and runc.

READMORE

This release contains the following changes since last release:

* ostree diff commit old: cdd359911de49f3a8199ffd41a9894019562001d6cf9be66e1894c31b6fa1c66
* ostree diff commit new: 0ed61d7441eddf96e6a98de4f10f4675268c7888b6d2b8a405b8c21fe6c92d23

Upgraded:

* acl 2.2.52-11.fc24.x86_64 -> 2.2.52-12.fc25.x86_64
* atomic 1.17.1-4.fc25.x86_64 -> 1.17.2-1.fc25.x86_64
* bubblewrap 0.1.7-1.fc25.x86_64 -> 0.1.8-1.fc25.x86_64
* container-selinux 2:2.10-1.fc25.noarch -> 2:2.14-1.fc25.noarch
* dhcp-client 12:4.3.5-1.fc25.x86_64 -> 12:4.3.5-2.fc25.x86_64
* dhcp-common 12:4.3.5-1.fc25.noarch -> 12:4.3.5-2.fc25.noarch
* dhcp-libs 12:4.3.5-1.fc25.x86_64 -> 12:4.3.5-2.fc25.x86_64
* freetype 2.6.5-7.fc25.x86_64 -> 2.6.5-9.fc25.x86_64
* glusterfs 3.10.1-1.fc25.x86_64 -> 3.10.2-1.fc25.x86_64
* glusterfs-client-xlators 3.10.1-1.fc25.x86_64 -> 3.10.2-1.fc25.x86_64
* glusterfs-fuse 3.10.1-1.fc25.x86_64 -> 3.10.2-1.fc25.x86_64
* glusterfs-libs 3.10.1-1.fc25.x86_64 -> 3.10.2-1.fc25.x86_64
* gssproxy 0.7.0-3.fc25.x86_64 -> 0.7.0-9.fc25.x86_64
* kernel 4.10.15-200.fc25.x86_64 -> 4.11.3-200.fc25.x86_64
* kernel-core 4.10.15-200.fc25.x86_64 -> 4.11.3-200.fc25.x86_64
* kernel-modules 4.10.15-200.fc25.x86_64 -> 4.11.3-200.fc25.x86_64
* libacl 2.2.52-11.fc24.x86_64 -> 2.2.52-12.fc25.x86_64
* libsolv 0.6.27-1.fc25.x86_64 -> 0.6.27-2.fc25.x86_64
* lua-libs 5.3.4-1.fc25.x86_64 -> 5.3.4-3.fc25.x86_64
* nss 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.1.fc25.x86_64
* nss-sysinit 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.1.fc25.x86_64
* nss-tools 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.1.fc25.x86_64
* p11-kit 0.23.2-3.fc25.x86_64 -> 0.23.2-4.fc25.x86_64
* p11-kit-trust 0.23.2-3.fc25.x86_64 -> 0.23.2-4.fc25.x86_64
* runc 1:1.0.0-5.rc2.gitc91b5be.fc25.x86_64 -> 1:1.0.0-6.git75f8da7.fc25.1.x86_64
* screen 4.5.1-1.fc25.x86_64 -> 4.5.1-2.fc25.x86_64
* strace 4.16-1.fc25.x86_64 -> 4.17-1.fc25.x86_64
* sudo 1.8.19p2-1.fc25.x86_64 -> 1.8.20p2-1.fc25.x86_64
* systemd 231-14.fc25.x86_64 -> 231-15.fc25.x86_64
* systemd-container 231-14.fc25.x86_64 -> 231-15.fc25.x86_64
* systemd-libs 231-14.fc25.x86_64 -> 231-15.fc25.x86_64
* systemd-pam 231-14.fc25.x86_64 -> 231-15.fc25.x86_64
* systemd-udev 231-14.fc25.x86_64 -> 231-15.fc25.x86_64
* vim-minimal 2:8.0.596-1.fc25.x86_64 -> 2:8.0.600-1.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170605.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170605.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170605.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170605.0-x86_64-CHECKSUM)

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
* [Fedora Atomic 25](https://atlas.hashicorp.com/fedora/boxes/25-atomic-host/versions/20170605)

```
vagrant init fedora/25-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/25-atomic-host
```
