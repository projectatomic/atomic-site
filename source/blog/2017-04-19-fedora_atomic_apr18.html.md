---
title: Fedora Atomic April 18 Release
author: jberkus
date: 2017-04-19 14:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 9f0b576461f4baa2b5749003a8628fbf0a456942f37e17a9ceabdb29fc014b0e
Version: 25.108
```

This release replaces the scheduled release from last week that was delayed
due to a kernel regression. We plan to return to our regularly scheduled release
process by performing a release next week as well.

READMORE

This release contains the following changes since last release:

* ostree diff commit old: 6a71adb06bc296c19839e951c38dc0b71ee5d7a82262fef9612f256f0c2a70da
* ostree diff commit new: 9f0b576461f4baa2b5749003a8628fbf0a456942f37e17a9ceabdb29fc014b0e

Upgraded:

* GeoIP 1.6.9-2.fc24.x86_64 -> 1.6.10-1.fc25.x86_64
* GeoIP-GeoLite-data 2017.01-1.fc25.noarch -> 2017.04-1.fc25.noarch
* audit 2.7.3-1.fc25.x86_64 -> 2.7.5-1.fc25.x86_64
* audit-libs 2.7.3-1.fc25.x86_64 -> 2.7.5-1.fc25.x86_64
* audit-libs-python 2.7.3-1.fc25.x86_64 -> 2.7.5-1.fc25.x86_64
* audit-libs-python3 2.7.3-1.fc25.x86_64 -> 2.7.5-1.fc25.x86_64
* ca-certificates 2017.2.11-1.0.fc25.noarch -> 2017.2.11-1.1.fc25.noarch
* cloud-init 0.7.8-6.fc25.noarch -> 0.7.9-4.fc25.noarch
* cockpit-bridge 135-1.fc25.x86_64 -> 137-1.fc25.x86_64
* cockpit-docker 135-1.fc25.x86_64 -> 137-1.fc25.x86_64
* cockpit-networkmanager 135-1.fc25.noarch -> 137-1.fc25.noarch
* cockpit-ostree 135-1.fc25.x86_64 -> 137-1.fc25.x86_64
* cockpit-system 135-1.fc25.noarch -> 137-1.fc25.noarch
* curl 7.51.0-4.fc25.x86_64 -> 7.51.0-6.fc25.x86_64
* dbus 1:1.11.10-1.fc25.x86_64 -> 1:1.11.12-1.fc25.x86_64
* dbus-libs 1:1.11.10-1.fc25.x86_64 -> 1:1.11.12-1.fc25.x86_64
* file 5.29-3.fc25.x86_64 -> 5.29-4.fc25.x86_64
* file-libs 5.29-3.fc25.x86_64 -> 5.29-4.fc25.x86_64
* gdbm 1.12-1.fc25.x86_64 -> 1.13-1.fc25.x86_64
* glusterfs 3.10.0-1.fc25.x86_64 -> 3.10.1-1.fc25.x86_64
* glusterfs-client-xlators 3.10.0-1.fc25.x86_64 -> 3.10.1-1.fc25.x86_64
* glusterfs-fuse 3.10.0-1.fc25.x86_64 -> 3.10.1-1.fc25.x86_64
* glusterfs-libs 3.10.0-1.fc25.x86_64 -> 3.10.1-1.fc25.x86_64
* gssproxy 0.7.0-2.fc25.x86_64 -> 0.7.0-3.fc25.x86_64
* kernel 4.9.14-200.fc25.x86_64 -> 4.10.10-200.fc25.x86_64
* kernel-core 4.9.14-200.fc25.x86_64 -> 4.10.10-200.fc25.x86_64
* kernel-modules 4.9.14-200.fc25.x86_64 -> 4.10.10-200.fc25.x86_64
* libcurl 7.51.0-4.fc25.x86_64 -> 7.51.0-6.fc25.x86_64
* libidn2 0.16-1.fc25.x86_64 -> 2.0.0-1.fc25.x86_64
* libsolv 0.6.26-1.fc25.x86_64 -> 0.6.26-3.fc25.x86_64
* linux-firmware 20161205-69.git91ddce49.fc25.noarch -> 20170313-72.git695f2d6d.fc25.noarch
* make 1:4.1-5.fc24.x86_64 -> 1:4.1-6.fc25.x86_64
* nfs-utils 1:2.1.1-2.rc1.fc25.x86_64 -> 1:2.1.1-3.rc1.fc25.x86_64
* nss 3.28.3-1.1.fc25.x86_64 -> 3.29.3-1.1.fc25.x86_64
* nss-pem 1.0.3-2.fc25.x86_64 -> 1.0.3-3.fc25.x86_64
* nss-softokn 3.28.3-1.1.fc25.x86_64 -> 3.29.3-1.0.fc25.x86_64
* nss-softokn-freebl 3.28.3-1.1.fc25.x86_64 -> 3.29.3-1.0.fc25.x86_64
* nss-sysinit 3.28.3-1.1.fc25.x86_64 -> 3.29.3-1.1.fc25.x86_64
* nss-tools 3.28.3-1.1.fc25.x86_64 -> 3.29.3-1.1.fc25.x86_64
* nss-util 3.28.3-1.0.fc25.x86_64 -> 3.29.3-1.1.fc25.x86_64
* openldap 2.4.44-7.fc25.x86_64 -> 2.4.44-10.fc25.x86_64
* os-prober 1.71-1.fc25.x86_64 -> 1.74-1.fc25.x86_64
* p11-kit 0.23.2-2.fc24.x86_64 -> 0.23.2-3.fc25.x86_64
* p11-kit-trust 0.23.2-2.fc24.x86_64 -> 0.23.2-3.fc25.x86_64
* pcre 8.40-5.fc25.x86_64 -> 8.40-6.fc25.x86_64
* policycoreutils 2.5-19.fc25.x86_64 -> 2.5-20.fc25.x86_64
* policycoreutils-python 2.5-19.fc25.x86_64 -> 2.5-20.fc25.x86_64
* policycoreutils-python-utils 2.5-19.fc25.x86_64 -> 2.5-20.fc25.x86_64
* policycoreutils-python3 2.5-19.fc25.x86_64 -> 2.5-20.fc25.x86_64
* polkit 0.113-5.fc24.x86_64 -> 0.113-8.fc25.x86_64
* polkit-libs 0.113-5.fc24.x86_64 -> 0.113-8.fc25.x86_64
* sos 3.3-1.fc25.noarch -> 3.4-1.fc25.noarch
* sudo 1.8.18p1-1.fc25.x86_64 -> 1.8.19p2-1.fc25.x86_64
* tzdata 2017a-1.fc25.noarch -> 2017b-1.fc25.noarch
* vim-minimal 2:8.0.502-1.fc25.x86_64 -> 2:8.0.562-1.fc25.x86_64

This includes a fix to the kernel for [BZ#1441310](https://bugzilla.redhat.com/show_bug.cgi?id=1441310). Another notable change
is the new version of cloud-init.

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170418.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170418.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170418.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170418.0-x86_64-CHECKSUM)

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
