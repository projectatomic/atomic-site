---
title: Fedora 26 Atomic Host October 30 Release
author: jberkus
date: 2017-10-31 18:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
26.157
c099633883cd8d06895e32a14c63f6672072430c151de882223e4abe20efa7ca
```

*This release of Fedora 26 Atomic Host will be our last Fedora 26 based
release. We will start releasing Fedora 27 based Atomic Hosts from this
point forward.*

The most notable changes in this release are a new version of the kernel
and ostree.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: d518b37c348eb814093249f035ae852e7723840521b4bcb4a271a80b5988c44a
* ostree diff commit new: c099633883cd8d06895e32a14c63f6672072430c151de882223e4abe20efa7ca

Upgraded:

* audit 2.7.8-1.fc26.x86_64 -> 2.8.1-1.fc26.x86_64
* audit-libs 2.7.8-1.fc26.x86_64 -> 2.8.1-1.fc26.x86_64
* audit-libs-python 2.7.8-1.fc26.x86_64 -> 2.8.1-1.fc26.x86_64
* audit-libs-python3 2.7.8-1.fc26.x86_64 -> 2.8.1-1.fc26.x86_64
* container-selinux 2:2.24-1.fc26.noarch -> 2:2.28-1.fc26.noarch
* curl 7.53.1-10.fc26.x86_64 -> 7.53.1-11.fc26.x86_64
* glibc 2.25-10.fc26.x86_64 -> 2.25-12.fc26.x86_64
* glibc-all-langpacks 2.25-10.fc26.x86_64 -> 2.25-12.fc26.x86_64
* glibc-common 2.25-10.fc26.x86_64 -> 2.25-12.fc26.x86_64
* glusterfs 3.10.5-1.fc26.x86_64 -> 3.10.6-3.fc26.x86_64
* glusterfs-client-xlators 3.10.5-1.fc26.x86_64 -> 3.10.6-3.fc26.x86_64
* glusterfs-fuse 3.10.5-1.fc26.x86_64 -> 3.10.6-3.fc26.x86_64
* glusterfs-libs 3.10.5-1.fc26.x86_64 -> 3.10.6-3.fc26.x86_64
* gnupg2 2.2.0-1.fc26.x86_64 -> 2.2.1-1.fc26.x86_64
* gnupg2-smime 2.2.0-1.fc26.x86_64 -> 2.2.1-1.fc26.x86_64
* gnutls 3.5.15-1.fc26.x86_64 -> 3.5.16-1.fc26.x86_64
* kernel 4.13.5-200.fc26.x86_64 -> 4.13.9-200.fc26.x86_64
* kernel-core 4.13.5-200.fc26.x86_64 -> 4.13.9-200.fc26.x86_64
* kernel-modules 4.13.5-200.fc26.x86_64 -> 4.13.9-200.fc26.x86_64
* libbasicobjects 0.1.1-30.fc26.x86_64 -> 0.1.1-34.fc26.x86_64
* libcollection 0.7.0-30.fc26.x86_64 -> 0.7.0-34.fc26.x86_64
* libcrypt-nss 2.25-10.fc26.x86_64 -> 2.25-12.fc26.x86_64
* libcurl 7.53.1-10.fc26.x86_64 -> 7.53.1-11.fc26.x86_64
* libini_config 1.3.0-30.fc26.x86_64 -> 1.3.1-34.fc26.x86_64
* libpath_utils 0.2.1-30.fc26.x86_64 -> 0.2.1-34.fc26.x86_64
* libref_array 0.1.5-30.fc26.x86_64 -> 0.1.5-34.fc26.x86_64
* libsss_idmap 1.15.3-4.fc26.x86_64 -> 1.15.3-5.fc26.x86_64
* libsss_nss_idmap 1.15.3-4.fc26.x86_64 -> 1.15.3-5.fc26.x86_64
* libsss_sudo 1.15.3-4.fc26.x86_64 -> 1.15.3-5.fc26.x86_64
* nmap-ncat 2:7.40-7.fc26.x86_64 -> 2:7.40-8.fc26.x86_64
* nss-softokn 3.33.0-1.0.fc26.x86_64 -> 3.33.0-1.1.fc26.x86_64
* nss-softokn-freebl 3.33.0-1.0.fc26.x86_64 -> 3.33.0-1.1.fc26.x86_64
* ostree 2017.11-1.fc26.x86_64 -> 2017.12-2.fc26.x86_64
* ostree-grub2 2017.11-1.fc26.x86_64 -> 2017.12-2.fc26.x86_64
* ostree-libs 2017.11-1.fc26.x86_64 -> 2017.12-2.fc26.x86_64
* p11-kit 0.23.8-1.fc26.x86_64 -> 0.23.9-2.fc26.x86_64
* p11-kit-trust 0.23.8-1.fc26.x86_64 -> 0.23.9-2.fc26.x86_64
* popt 1.16-8.fc26.x86_64 -> 1.16-12.fc26.x86_64
* python-rhsm-certificates 1.20.1-1.fc26.x86_64 -> 1.20.2-1.fc26.x86_64
* python2-asn1crypto 0.22.0-4.fc26.noarch -> 0.23.0-1.fc26.noarch
* python3-asn1crypto 0.22.0-4.fc26.noarch -> 0.23.0-1.fc26.noarch
* python3-sssdconfig 1.15.3-4.fc26.noarch -> 1.15.3-5.fc26.noarch
* selinux-policy 3.13.1-260.10.fc26.noarch -> 3.13.1-260.13.fc26.noarch
* selinux-policy-targeted 3.13.1-260.10.fc26.noarch -> 3.13.1-260.13.fc26.noarch
* sssd-client 1.15.3-4.fc26.x86_64 -> 1.15.3-5.fc26.x86_64
* vim-minimal 2:8.0.1176-1.fc26.x86_64 -> 2:8.0.1187-1.fc26.x86_64

Removed:

* libsoup-2.58.2-1.fc26.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](http://www.projectatomic.io/blog/2017/08/fedora-atomic-25-to-26-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksums](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171030.0/CloudImages/x86_64/images/Fedora-CloudImages-26-20171030.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171030.0/Atomic/x86_64/iso/Fedora-Atomic-26-20171030.0-x86_64-CHECKSUM)

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
Atomic Wiki space](https://fedoraproject.org/wiki/Atomic_WG#Fedora_Atomic_Image_Download_Links).

The Vagrant Cloud page with the new atomic host:

* [All Fedora boxes](https://app.vagrantup.com/fedora/)
* [Fedora Atomic Host 26](https://app.vagrantup.com/fedora/boxes/26-atomic-host/versions/26.20170905.0)

To provision using vagrant:

```
vagrant init fedora/26-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/26-atomic-host
```
