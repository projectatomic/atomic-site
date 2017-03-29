---
title: Fedora Atomic March 28 Release
author: jberkus
date: 2017-03-29 15:00:00 UTC
published: true
comments: true
tags: atomic, fedora, etcd, ostree
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 6a71adb06bc296c19839e951c38dc0b71ee5d7a82262fef9612f256f0c2a70da
Version: 25.89
```

This includes fixes for an [rpm-ostree CVE](https://bugzilla.redhat.com/show_bug.cgi?id=1422157) and an [etcd bug](https://bugzilla.redhat.com/show_bug.cgi?id=1431222), as well as
new versions of cockpit, kubernetes, and more.

READMORE

This release contains the following changes since last release from
24d4499420ffb2cc49681020bbe5aa6780d780d2b811eab1f5ffea6446b5a4c5 to
6a71adb06bc296c19839e951c38dc0b71ee5d7a82262fef9612f256f0c2a70da

Upgraded:

* cloud-init 0.7.8-5.fc25 -> 0.7.8-6.fc25
* cockpit-bridge 134-1.fc25 -> 135-1.fc25
* cockpit-docker 134-1.fc25 -> 135-1.fc25
* cockpit-networkmanager 134-1.fc25 -> 135-1.fc25
* cockpit-ostree 134-1.fc25 -> 135-1.fc25
* cockpit-system 134-1.fc25 -> 135-1.fc25
* criu 2.10-1.fc25 -> 2.12-1.fc25
* cryptsetup 1.7.2-3.fc25 -> 1.7.4-1.fc25
* cryptsetup-libs 1.7.2-3.fc25 -> 1.7.4-1.fc25
* etcd 3.0.17-1.fc25 -> 3.1.3-1.fc25
* glusterfs 3.9.1-1.fc25 -> 3.10.0-1.fc25
* glusterfs-client-xlators 3.9.1-1.fc25 -> 3.10.0-1.fc25
* glusterfs-fuse 3.9.1-1.fc25 -> 3.10.0-1.fc25
* glusterfs-libs 3.9.1-1.fc25 -> 3.10.0-1.fc25
* gssproxy 0.7.0-1.fc25 -> 0.7.0-2.fc25
* info 6.1-3.fc25 -> 6.1-4.fc25
* iproute 4.6.0-6.fc25 -> 4.10.0-1.fc25
* iproute-tc 4.6.0-6.fc25 -> 4.10.0-1.fc25
* json-glib 1.2.2-1.fc25 -> 1.2.6-1.fc25
* kernel 4.9.13-201.fc25 -> 4.9.14-200.fc25
* kernel-core 4.9.13-201.fc25 -> 4.9.14-200.fc25
* kernel-modules 4.9.13-201.fc25 -> 4.9.14-200.fc25
* kubernetes 1.5.2-2.fc25 -> 1.5.3-1.fc25
* kubernetes-client 1.5.2-2.fc25 -> 1.5.3-1.fc25
* kubernetes-master 1.5.2-2.fc25 -> 1.5.3-1.fc25
* kubernetes-node 1.5.2-2.fc25 -> 1.5.3-1.fc25
* libsss_idmap 1.15.1-1.fc25 -> 1.15.2-1.fc25
* libsss_nss_idmap 1.15.1-1.fc25 -> 1.15.2-1.fc25
* libsss_sudo 1.15.1-1.fc25 -> 1.15.2-1.fc25
* nss 3.28.3-1.0.fc25 -> 3.28.3-1.1.fc25
* nss-sysinit 3.28.3-1.0.fc25 -> 3.28.3-1.1.fc25
* nss-tools 3.28.3-1.0.fc25 -> 3.28.3-1.1.fc25
* oci-register-machine 0-2.7.gitbb20b00.fc25 -> 0-3.7.gitbb20b00.fc25
* oci-systemd-hook 1:0.1.5-1.git16f7c8a.fc25 -> 1:0.1.6-1.gitfe22236.fc25
* ostree 2017.2-3.fc25 -> 2017.3-2.fc25
* ostree-grub2 2017.2-3.fc25 -> 2017.3-2.fc25
* ostree-libs 2017.2-3.fc25 -> 2017.3-2.fc25
* python3 3.5.2-4.fc25 -> 3.5.3-4.fc25
* python3-libs 3.5.2-4.fc25 -> 3.5.3-4.fc25
* python3-sssdconfig 1.15.1-1.fc25 -> 1.15.2-1.fc25
* rpcbind 0.2.4-4.fc25 -> 0.2.4-5.fc25
* rpm-ostree 2017.2-2.fc25 -> 2017.3-2.fc25
* sssd-client 1.15.1-1.fc25 -> 1.15.2-1.fc25
* system-python 3.5.2-4.fc25 -> 3.5.3-4.fc25
* system-python-libs 3.5.2-4.fc25 -> 3.5.3-4.fc25
* tzdata 2016j-2.fc25 -> 2017a-1.fc25
* vim-minimal 2:8.0.425-1.fc25 -> 2:8.0.502-1.fc25

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
* [Fedora Atomic 25](https://atlas.hashicorp.com/fedora/boxes/25-atomic-host/versions/20170327)

```
vagrant init fedora/25-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/25-atomic-host
```
