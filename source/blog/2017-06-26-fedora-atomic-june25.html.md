---
title: Fedora Atomic June 26 Release
author: jberkus
date: 2017-06-26 20:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: f136ff5370c0f77d9c1f4fd3ecb8e1815650d8aaf834e41a5e995a13494407e9
Version: 25.148
```

This release contains fixes for two security issues.  Users are urged to upgrade promptly.

READMORE

CVEs for the patched security issues are as follows:

* [CVE-2017-1000364](https://access.redhat.com/security/cve/CVE-2017-1000364) [fixed by kernel-4.11.6-201.fc25](https://bugzilla.redhat.com/show_bug.cgi?id=1462819)
* [CVE-2017-1000366](https://access.redhat.com/security/cve/CVE-2017-1000366) [fixed by glibc-2.24-8.fc25](https://bugzilla.redhat.com/show_bug.cgi?id=1462820).

This update also contains the following changes:

* ostree diff commit old: 0ed61d7441eddf96e6a98de4f10f4675268c7888b6d2b8a405b8c21fe6c92d23
* ostree diff commit new: f136ff5370c0f77d9c1f4fd3ecb8e1815650d8aaf834e41a5e995a13494407e9

Upgraded software:

* GeoIP 1.6.10-1.fc25.x86_64 -> 1.6.11-1.fc25.x86_64
* acl 2.2.52-12.fc25.x86_64 -> 2.2.52-13.fc25.x86_64
* atomic 1.17.2-1.fc25.x86_64 -> 1.18.1-2.fc25.x86_64
* audit 2.7.6-1.fc25.x86_64 -> 2.7.7-1.fc25.x86_64
* audit-libs 2.7.6-1.fc25.x86_64 -> 2.7.7-1.fc25.x86_64
* audit-libs-python 2.7.6-1.fc25.x86_64 -> 2.7.7-1.fc25.x86_64
* audit-libs-python3 2.7.6-1.fc25.x86_64 -> 2.7.7-1.fc25.x86_64
* container-selinux 2:2.14-1.fc25.noarch -> 2:2.19-1.fc25.noarch
* curl 7.51.0-6.fc25.x86_64 -> 7.51.0-7.fc25.x86_64
* glibc 2.24-4.fc25.x86_64 -> 2.24-8.fc25.x86_64
* glibc-all-langpacks 2.24-4.fc25.x86_64 -> 2.24-8.fc25.x86_64
* glibc-common 2.24-4.fc25.x86_64 -> 2.24-8.fc25.x86_64
* glusterfs 3.10.2-1.fc25.x86_64 -> 3.10.3-1.fc25.x86_64
* glusterfs-client-xlators 3.10.2-1.fc25.x86_64 -> 3.10.3-1.fc25.x86_64
* glusterfs-fuse 3.10.2-1.fc25.x86_64 -> 3.10.3-1.fc25.x86_64
* glusterfs-libs 3.10.2-1.fc25.x86_64 -> 3.10.3-1.fc25.x86_64
* gnutls 3.5.12-2.fc25.x86_64 -> 3.5.13-1.fc25.x86_64
* iproute 4.10.0-1.fc25.x86_64 -> 4.11.0-1.fc25.x86_64
* iproute-tc 4.10.0-1.fc25.x86_64 -> 4.11.0-1.fc25.x86_64
* jansson 2.9-1.fc25.x86_64 -> 2.10-2.fc25.x86_64
* kernel 4.11.3-200.fc25.x86_64 -> 4.11.6-201.fc25.x86_64
* kernel-core 4.11.3-200.fc25.x86_64 -> 4.11.6-201.fc25.x86_64
* kernel-modules 4.11.3-200.fc25.x86_64 -> 4.11.6-201.fc25.x86_64
* libacl 2.2.52-12.fc25.x86_64 -> 2.2.52-13.fc25.x86_64
* libcrypt-nss 2.24-4.fc25.x86_64 -> 2.24-8.fc25.x86_64
* libcurl 7.51.0-6.fc25.x86_64 -> 7.51.0-7.fc25.x86_64
* libdb 5.3.28-16.fc25.x86_64 -> 5.3.28-21.fc25.x86_64
* libdb-utils 5.3.28-16.fc25.x86_64 -> 5.3.28-21.fc25.x86_64
* libsss_idmap 1.15.2-3.fc25.x86_64 -> 1.15.2-5.fc25.x86_64
* libsss_nss_idmap 1.15.2-3.fc25.x86_64 -> 1.15.2-5.fc25.x86_64
* libsss_sudo 1.15.2-3.fc25.x86_64 -> 1.15.2-5.fc25.x86_64
* libtasn1 4.10-1.fc25.x86_64 -> 4.12-1.fc25.x86_64
* libteam 1.26-1.fc25.x86_64 -> 1.27-1.fc25.x86_64
* libunwind 1.1-11.fc24.x86_64 -> 1.2-1.fc25.x86_64
* linux-firmware 20170313-72.git695f2d6d.fc25.noarch -> 20170605-74.git37857004.fc25.noarch
* nfs-utils 1:2.1.1-5.rc2.fc25.x86_64 -> 1:2.1.1-5.rc3.fc25.x86_64
* ostree 2017.6-2.fc25.x86_64 -> 2017.7-2.fc25.x86_64
* ostree-grub2 2017.6-2.fc25.x86_64 -> 2017.7-2.fc25.x86_64
* ostree-libs 2017.6-2.fc25.x86_64 -> 2017.7-2.fc25.x86_64
* python3-sssdconfig 1.15.2-3.fc25.noarch -> 1.15.2-5.fc25.noarch
* qrencode-libs 3.4.2-6.fc24.x86_64 -> 3.4.4-1.fc25.x86_64
* rpcbind 0.2.4-6.rc1.fc25.x86_64 -> 0.2.4-6.rc2.fc25.x86_64
* rpm-ostree 2017.5-2.fc25.x86_64 -> 2017.6-3.fc25.x86_64
* selinux-policy 3.13.1-225.16.fc25.noarch -> 3.13.1-225.18.fc25.noarch
* selinux-policy-targeted 3.13.1-225.16.fc25.noarch -> 3.13.1-225.18.fc25.noarch
* sssd-client 1.15.2-3.fc25.x86_64 -> 1.15.2-5.fc25.x86_64
* teamd 1.26-1.fc25.x86_64 -> 1.27-1.fc25.x86_64
* vim-minimal 2:8.0.600-1.fc25.x86_64 -> 2:8.0.642-1.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170626.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170626.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170626.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170626.0-x86_64-CHECKSUM)

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
