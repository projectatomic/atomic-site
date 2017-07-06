---
title: Fedora Atomic July 5 Release
author: jberkus
date: 2017-07-06 17:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: ce555fa89da934e6eef23764fb40e8333234b8b60b6f688222247c958e5ebd5b
Version: 25.154
```

IMPORTANT: *This release of Fedora 25 Atomic Host will be our final release based on Fedora 25. We will start releasing Fedora 26-based Atomic Hosts from this point forward.*

Information about [Fedora Atomic Host upgrade policy](https://fedoramagazine.org/upcoming-fedora-atomic-lifecycle-changes/) can be found in Fedora Magazine.

READMORE

This update contains the following changes:

*  ostree diff commit old: f136ff5370c0f77d9c1f4fd3ecb8e1815650d8aaf834e41a5e995a13494407e9
* ostree diff commit new: ce555fa89da934e6eef23764fb40e8333234b8b60b6f688222247c958e5ebd5b

Upgraded:

* dbus 1:1.11.12-1.fc25.x86_64 -> 1:1.11.14-1.fc25.x86_64
* dbus-libs 1:1.11.12-1.fc25.x86_64 -> 1:1.11.14-1.fc25.x86_64
* hostname 3.15-7.fc24.x86_64 -> 3.15-8.fc25.x86_64
* kernel 4.11.6-201.fc25.x86_64 -> 4.11.8-200.fc25.x86_64
* kernel-core 4.11.6-201.fc25.x86_64 -> 4.11.8-200.fc25.x86_64
* kernel-modules 4.11.6-201.fc25.x86_64 -> 4.11.8-200.fc25.x86_64
* libgcrypt 1.6.6-1.fc25.x86_64 -> 1.7.8-1.fc25.x86_64
* nfs-utils 1:2.1.1-5.rc3.fc25.x86_64 -> 1:2.1.1-5.rc4.fc25.x86_64
* rsync 3.1.2-3.fc25.x86_64 -> 3.1.2-4.fc25.x86_64
* skopeo 0.1.19-1.dev.git0224d8c.fc25.x86_64 -> 0.1.22-1.git5d24b67.fc25.x86_64
* skopeo-containers 0.1.19-1.dev.git0224d8c.fc25.x86_64 -> 0.1.22-1.git5d24b67.fc25.x86_64
* systemd 231-15.fc25.x86_64 -> 231-17.fc25.x86_64
* systemd-container 231-15.fc25.x86_64 -> 231-17.fc25.x86_64
* systemd-libs 231-15.fc25.x86_64 -> 231-17.fc25.x86_64
* systemd-pam 231-15.fc25.x86_64 -> 231-17.fc25.x86_64
* systemd-udev 231-15.fc25.x86_64 -> 231-17.fc25.x86_64
* vim-minimal 2:8.0.642-1.fc25.x86_64 -> 2:8.0.679-1.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170705.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170705.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170705.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170705.0-x86_64-CHECKSUM)

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
