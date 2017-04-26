---
title: Fedora Atomic April 26 Release
author: jberkus
date: 2017-04-26 18:00:00 UTC
published: true
comments: true
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 3492546bc1ef6bca1bc7801ed6bb0414f90cc96668e067996dba3dee0d83e6c3
Version: 25.113
```

This release is only a week after [the last release](/blog/2017/04/fedora_atomic_apr18/), because we are returning to our regular release schedule.  It also fixes [CVE-2017-5461](https://access.redhat.com/security/cve/cve-2017-5461), a critical vulnerability in NSS, so all users should upgrade their hosts and container base images as soon as reasonable.

READMORE

Notable updates are nss-util and nss-softokn for CVE-2017-5461, as well as an
update to NetworkManager to better support static networking from cloud-init. Also
included is an update to skopeo and rpm-ostree.

Other changes since last release:

```
ostree diff commit old: 9f0b576461f4baa2b5749003a8628fbf0a456942f37e17a9ceabdb29fc014b0e
ostree diff commit new: 3492546bc1ef6bca1bc7801ed6bb0414f90cc96668e067996dba3dee0d83e6c3
```

Upgraded:

* NetworkManager 1:1.4.4-3.fc25.x86_64 -> 1:1.4.4-4.fc25.x86_64
* NetworkManager-libnm 1:1.4.4-3.fc25.x86_64 -> 1:1.4.4-4.fc25.x86_64
* NetworkManager-team 1:1.4.4-3.fc25.x86_64 -> 1:1.4.4-4.fc25.x86_64
* audit 2.7.5-1.fc25.x86_64 -> 2.7.6-1.fc25.x86_64
* audit-libs 2.7.5-1.fc25.x86_64 -> 2.7.6-1.fc25.x86_64
* audit-libs-python 2.7.5-1.fc25.x86_64 -> 2.7.6-1.fc25.x86_64
* audit-libs-python3 2.7.5-1.fc25.x86_64 -> 2.7.6-1.fc25.x86_64
* bind99-libs 9.9.9-4.P6.fc25.x86_64 -> 9.9.9-4.P8.fc25.x86_64
* bind99-license 9.9.9-4.P6.fc25.noarch -> 9.9.9-4.P8.fc25.noarch
* gnutls 3.5.10-1.fc25.x86_64 -> 3.5.11-1.fc25.x86_64
* kernel 4.10.10-200.fc25.x86_64 -> 4.10.11-200.fc25.x86_64
* kernel-core 4.10.10-200.fc25.x86_64 -> 4.10.11-200.fc25.x86_64
* kernel-modules 4.10.10-200.fc25.x86_64 -> 4.10.11-200.fc25.x86_64
* libarchive 3.2.2-1.fc25.x86_64 -> 3.2.2-2.fc25.x86_64
* libicu 57.1-4.fc25.x86_64 -> 57.1-5.fc25.x86_64
* libnl3 3.2.29-2.fc25.x86_64 -> 3.2.29-3.fc25.x86_64
* libnl3-cli 3.2.29-2.fc25.x86_64 -> 3.2.29-3.fc25.x86_64
* libsemanage 2.5-8.fc25.x86_64 -> 2.5-9.fc25.x86_64
* libsemanage-python 2.5-8.fc25.x86_64 -> 2.5-9.fc25.x86_64
* libsemanage-python3 2.5-8.fc25.x86_64 -> 2.5-9.fc25.x86_64
* libsss_idmap 1.15.2-1.fc25.x86_64 -> 1.15.2-2.fc25.x86_64
* libsss_nss_idmap 1.15.2-1.fc25.x86_64 -> 1.15.2-2.fc25.x86_64
* libsss_sudo 1.15.2-1.fc25.x86_64 -> 1.15.2-2.fc25.x86_64
* libxml2 2.9.3-4.fc25.x86_64 -> 2.9.4-2.fc25.x86_64
* nfs-utils 1:2.1.1-3.rc1.fc25.x86_64 -> 1:2.1.1-4.rc2.fc25.x86_64
* nss-softokn 3.29.3-1.0.fc25.x86_64 -> 3.29.5-1.0.fc25.x86_64
* nss-softokn-freebl 3.29.3-1.0.fc25.x86_64 -> 3.29.5-1.0.fc25.x86_64
* nss-util 3.29.3-1.1.fc25.x86_64 -> 3.29.5-1.0.fc25.x86_64
* pcre 8.40-6.fc25.x86_64 -> 8.40-7.fc25.x86_64
* python3-libxml2 2.9.3-4.fc25.x86_64 -> 2.9.4-2.fc25.x86_64
* python3-sssdconfig 1.15.2-1.fc25.noarch -> 1.15.2-2.fc25.noarch
* rpm-ostree 2017.3-2.fc25.x86_64 -> 2017.4-2.fc25.x86_64
* selinux-policy 3.13.1-225.11.fc25.noarch -> 3.13.1-225.13.fc25.noarch
* selinux-policy-targeted 3.13.1-225.11.fc25.noarch -> 3.13.1-225.13.fc25.noarch
* skopeo 0.1.17-1.dev.git2b3af4a.fc25.x86_64 -> 0.1.19-1.dev.git0224d8c.fc25.x86_64
* skopeo-containers 0.1.17-1.dev.git2b3af4a.fc25.x86_64 -> 0.1.19-1.dev.git0224d8c.fc25.x86_64
* sssd-client 1.15.2-1.fc25.x86_64 -> 1.15.2-2.fc25.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170426.0/Atomic/x86_64/iso/Fedora-Atomic-25-20170426.0-x86_64-CHECKSUM)

* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-25-20170426.0/CloudImages/x86_64/images/Fedora-CloudImages-25-20170426.0-x86_64-CHECKSUM)

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
* [Fedora Atomic 25](https://atlas.hashicorp.com/fedora/boxes/25-atomic-host/versions/20170426)
