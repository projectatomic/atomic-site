---
title: Fedora Atomic March 15 Release
author: jberkus
date: 2017-03-16 16:00:00 UTC
published: true
comments: true
tags: atomic, fedora, vagrant
---

The latest Fedora Atomic Host update is now available via an OSTree commit:

* Commit: 24d4499420ffb2cc49681020bbe5aa6780d780d2b811eab1f5ffea6446b5a4c5
* Version: 25.80

As well as numerous package updates, this release fixes the ["space leak from false ref"](https://pagure.io/atomic-wg/issue/251) issue.

READMORE

This release contains the following changes since last release from
ba95a4665776b58d342ad9cc367111179f9b8fcf19c6606f8964a8ec1622cadc to
24d4499420ffb2cc49681020bbe5aa6780d780d2b811eab1f5ffea6446b5a4c5

Upgraded:

* atomic-devmode 0.3.3-1.fc25 -> 0.3.6-1.fc25
* bind99-libs 9.9.9-4.P5.fc25 -> 9.9.9-4.P6.fc25
* bind99-license 9.9.9-4.P5.fc25 -> 9.9.9-4.P6.fc25
* cockpit-bridge 131-1.fc25 -> 134-1.fc25
* cockpit-docker 131-1.fc25 -> 134-1.fc25
* cockpit-networkmanager 131-1.fc25 -> 134-1.fc25
* cockpit-ostree 131-1.fc25 -> 134-1.fc25
* cockpit-system 131-1.fc25 -> 134-1.fc25
* container-selinux 2:2.6-1.fc25 -> 2:2.10-1.fc25
* coreutils 8.25-15.fc25 -> 8.25-16.fc25
* coreutils-common 8.25-15.fc25 -> 8.25-16.fc25
* fedora-repos 25-2 -> 25-3
* freetype 2.6.5-1.fc25 -> 2.6.5-3.fc25
* gnutls 3.5.9-2.fc25 -> 3.5.10-1.fc25
* gssproxy 0.6.1-2.fc25 -> 0.7.0-1.fc25
* kernel 4.9.12-200.fc25 -> 4.9.13-201.fc25
* kernel-core 4.9.12-200.fc25 -> 4.9.13-201.fc25
* kernel-modules 4.9.12-200.fc25 -> 4.9.13-201.fc25
* krb5-libs 1.14.4-4.fc25 -> 1.14.4-7.fc25
* libseccomp 2.3.1-1.fc25 -> 2.3.2-1.fc25
* libsss_idmap 1.14.2-2.fc25 -> 1.15.1-1.fc25
* libsss_nss_idmap 1.14.2-2.fc25 -> 1.15.1-1.fc25
* libsss_sudo 1.14.2-2.fc25 -> 1.15.1-1.fc25
* nss 3.28.1-1.3.fc25 -> 3.28.3-1.0.fc25
* nss-pem 1.0.2-2.fc25 -> 1.0.3-2.fc25
* nss-softokn 3.28.1-1.0.fc25 -> 3.28.3-1.1.fc25
* nss-softokn-freebl 3.28.1-1.0.fc25 -> 3.28.3-1.1.fc25
* nss-sysinit 3.28.1-1.3.fc25 -> 3.28.3-1.0.fc25
* nss-tools 3.28.1-1.3.fc25 -> 3.28.3-1.0.fc25
* nss-util 3.28.1-1.0.fc25 -> 3.28.3-1.0.fc25
* oci-systemd-hook 0.1.4-4.git15c2f48.fc25 -> 1:0.1.5-1.git16f7c8a.fc25
* openssh 7.4p1-3.fc25 -> 7.4p1-4.fc25
* openssh-clients 7.4p1-3.fc25 -> 7.4p1-4.fc25
* openssh-server 7.4p1-3.fc25 -> 7.4p1-4.fc25
* pcre 8.40-4.fc25 -> 8.40-5.fc25
* python3-rpm 4.13.0-6.fc25 -> 4.13.0.1-1.fc25
* python3-sssdconfig 1.14.2-2.fc25 -> 1.15.1-1.fc25
* rpm 4.13.0-6.fc25 -> 4.13.0.1-1.fc25
* rpm-build-libs 4.13.0-6.fc25 -> 4.13.0.1-1.fc25
* rpm-libs 4.13.0-6.fc25 -> 4.13.0.1-1.fc25
* rpm-plugin-selinux 4.13.0-6.fc25 -> 4.13.0.1-1.fc25
* screen 4.5.0-1.fc25 -> 4.5.1-1.fc25
* selinux-policy 3.13.1-225.10.fc25 -> 3.13.1-225.11.fc25
* selinux-policy-targeted 3.13.1-225.10.fc25 -> 3.13.1-225.11.fc25
* sssd-client 1.14.2-2.fc25 -> 1.15.1-1.fc25
* vim-minimal 2:8.0.347-2.fc25 -> 2:8.0.425-1.fc25

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

The Vagrant Atlas page with the new atomic host:
* [All Fedora boxes](https://atlas.hashicorp.com/fedora/boxes/)
* [Fedora Atomic 25](https://atlas.hashicorp.com/fedora/boxes/25-atomic-host/versions/20170314)

```
vagrant init fedora/25-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/25-atomic-host
```
