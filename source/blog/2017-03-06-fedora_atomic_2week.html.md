---
title: Fedora Atomic March 1 Release and Security Fix
author: jberkus
date: 2017-03-06 19:00:00 UTC
published: true
comments: true
tags: atomic, fedora, security
---

The latest Fedora Atomic Host bi-weekly release now available.  Per the prior [Fedora Atomic blog post](/blog/2017/02/matching-fedora-ostree-released-content-with-each-2week-atomic-release/), OSTree updates and biweekly releases are now fully synchronized.  We have also added "latest" links to make downloading the most current version simple.

As this release contains a security update, users of Atomic Host are urged to update their systems as soon as they can. It fixes [CVE-2017-6074: DCCP double-free vulnerability](https://access.redhat.com/security/cve/cve-2017-6074).

READMORE

On existing Atomic Host systems, users may update to the following OSTree commit:

```
Commit: ba95a4665776b58d342ad9cc367111179f9b8fcf19c6606f8964a8ec1622cadc
Version: 25.67
```

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be downloaded from [getfedora.org](https://getfedora.org/en/cloud/download/atomic.html).

Respective signed CHECKSUM files can be found here:

* [ISO checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170228.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170228.0-x86_64-CHECKSUM)
* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170228.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170228.0-x86_64-CHECKSUM)

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

This release contains the following changes since last release from
5a9de04163a60c5f2771b3d307601fa4e2234f12b662c97e28290b7bcbdb43f0 to
ba95a4665776b58d342ad9cc367111179f9b8fcf19c6606f8964a8ec1622cadc

Changed:

* audit 2.7.2-2.fc25 -> 2.7.3-1.fc25
* audit-libs 2.7.2-2.fc25 -> 2.7.3-1.fc25
* audit-libs-python 2.7.2-2.fc25 -> 2.7.3-1.fc25
* audit-libs-python3 2.7.2-2.fc25 -> 2.7.3-1.fc25
* cockpit-bridge 130-1.fc25 -> 131-1.fc25
* cockpit-docker 130-1.fc25 -> 131-1.fc25
* cockpit-networkmanager 130-1.fc25 -> 131-1.fc25
* cockpit-ostree 130-1.fc25 -> 131-1.fc25
* cockpit-system 130-1.fc25 -> 131-1.fc25
* container-selinux 2:2.5-1.fc25 -> 2:2.6-1.fc25
* crypto-policies 20160921-2.git75b9b04.fc25 -> 20160921-4.gitf3018dd.fc25
* dbus 1:1.11.8-1.fc25 -> 1:1.11.10-1.fc25
* dbus-libs 1:1.11.8-1.fc25 -> 1:1.11.10-1.fc25
* fedora-repos 25-1 -> 25-2
* glib2 2.50.2-1.fc25 -> 2.50.3-1.fc25
* gnutls 3.5.8-2.fc25 -> 3.5.9-2.fc25
* gomtree 0.3.0-1.fc25 -> 0.3.1-1.fc25
* grep 2.27-1.fc25 -> 2.27-2.fc25
* iptables 1.6.0-2.fc25 -> 1.6.0-3.fc25
* iptables-libs 1.6.0-2.fc25 -> 1.6.0-3.fc25
* iptables-services 1.6.0-2.fc25 -> 1.6.0-3.fc25
* kernel 4.9.9-200.fc25 -> 4.9.12-200.fc25
* kernel-core 4.9.9-200.fc25 -> 4.9.12-200.fc25
* kernel-modules 4.9.9-200.fc25 -> 4.9.12-200.fc25
* libblkid 2.28.2-1.fc25 -> 2.28.2-2.fc25
* libfdisk 2.28.2-1.fc25 -> 2.28.2-2.fc25
* libmount 2.28.2-1.fc25 -> 2.28.2-2.fc25
* libnetfilter_conntrack 1.0.4-6.fc24 -> 1.0.6-2.fc25
* libsmartcols 2.28.2-1.fc25 -> 2.28.2-2.fc25
* libsolv 0.6.25-1.fc25 -> 0.6.26-1.fc25
* libuuid 2.28.2-1.fc25 -> 2.28.2-2.fc25
* nfs-utils 1:2.1.1-1.fc25 -> 1:2.1.1-2.rc1.fc25
* openssh 7.4p1-2.fc25 -> 7.4p1-3.fc25
* openssh-clients 7.4p1-2.fc25 -> 7.4p1-3.fc25
* openssh-server 7.4p1-2.fc25 -> 7.4p1-3.fc25
* ostree 2017.1-2.fc25 -> 2017.2-3.fc25
* ostree-grub2 2017.1-2.fc25 -> 2017.2-3.fc25
* pcre 8.40-1.fc25 -> 8.40-4.fc25
* publicsuffix-list-dafsa 20170116-1.fc25 -> 20170206-1.fc25
* rpm-ostree 2016.13-1.fc25 -> 2017.2-2.fc25
* selinux-policy 3.13.1-225.6.fc25 -> 3.13.1-225.10.fc25
* selinux-policy-targeted 3.13.1-225.6.fc25 -> 3.13.1-225.10.fc25
* sos 3.2-4.fc25 -> 3.3-1.fc25
* strace 4.15-1.fc25 -> 4.16-1.fc25
* systemd 231-12.fc25 -> 231-14.fc25
* systemd-container 231-12.fc25 -> 231-14.fc25
* systemd-libs 231-12.fc25 -> 231-14.fc25
* systemd-pam 231-12.fc25 -> 231-14.fc25
* systemd-udev 231-12.fc25 -> 231-14.fc25
* util-linux 2.28.2-1.fc25 -> 2.28.2-2.fc25
* vim-minimal 2:8.0.324-1.fc25 -> 2:8.0.347-2.fc25

Added:

* ostree-libs-2017.2-3.fc25.x86_64

Note that this release contains kernel-4.9.12-200.fc25 which contains
the fix for CVE-2017-6074: DCCP double-free vulnerability.
