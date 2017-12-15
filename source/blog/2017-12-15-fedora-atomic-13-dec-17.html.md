---
title: Fedora 27 Atomic Host December 13th Release
author: jberkus
date: 2017-12-15 14:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Version: 27.25
Commit(x86_64): a2b80278eea897eb1fec7d008b18ef74941ff5a54f86b447a2f4da0451c4291a
Commit(aarch64): 0a7bd764394cc4e1afa6e35b20ed20a00dc8b449fc9563624fb47d9940af6a1d
Commit(ppc64le): 46dfc00f165aa29b030acc5fdc5603de0084a1e6fc71005e82ccc3d5145d168d
```

This is the 3rd release of Fedora 27 Atomic Host, including mulit-architecture artifacts.
It includes a new kernel (4.13->4.14), rpm-ostree, and atomic CLI.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 86727cdbc928b7f7dd0e32f62d3b973a8395d61e0ff751cfea7cc0bc5222142f
* ostree diff commit new: a2b80278eea897eb1fec7d008b18ef74941ff5a54f86b447a2f4da0451c4291a

Upgraded:

* atomic 1.20.1-3.fc27.x86_64 -> 1.20.1-6.fc27.x86_64
* atomic-registries 1.20.1-3.fc27.x86_64 -> 1.20.1-6.fc27.x86_64
* ca-certificates 2017.2.16-4.fc27.noarch -> 2017.2.20-1.0.fc27.noarch
* container-selinux 2:2.29-1.fc27.noarch -> 2:2.36-1.fc27.noarch
* curl 7.55.1-7.fc27.x86_64 -> 7.55.1-8.fc27.x86_64
* gssproxy 0.7.0-24.fc27.x86_64 -> 0.7.0-25.fc27.x86_64
* kernel 4.13.15-300.fc27.x86_64 -> 4.14.3-300.fc27.x86_64
* kernel-core 4.13.15-300.fc27.x86_64 -> 4.14.3-300.fc27.x86_64
* kernel-modules 4.13.15-300.fc27.x86_64 -> 4.14.3-300.fc27.x86_64
* libcurl 7.55.1-7.fc27.x86_64 -> 7.55.1-8.fc27.x86_64
* libsss_idmap 1.16.0-2.fc27.x86_64 -> 1.16.0-4.fc27.x86_64
* libsss_nss_idmap 1.16.0-2.fc27.x86_64 -> 1.16.0-4.fc27.x86_64
* libsss_sudo 1.16.0-2.fc27.x86_64 -> 1.16.0-4.fc27.x86_64
* linux-firmware 20171123-79.git90436ce.fc27.noarch -> 20171126-80.git17e62881.fc27.noarch
* openssh 7.5p1-5.fc27.x86_64 -> 7.6p1-2.fc27.x86_64
* openssh-clients 7.5p1-5.fc27.x86_64 -> 7.6p1-2.fc27.x86_64
* openssh-server 7.5p1-5.fc27.x86_64 -> 7.6p1-2.fc27.x86_64
* pcre2 10.30-2.fc27.x86_64 -> 10.30-3.fc27.x86_64
* python2-pip 9.0.1-11.fc27.noarch -> 9.0.1-13.fc27.noarch
* python2-setuptools 36.2.0-7.fc27.noarch -> 37.0.0-1.fc27.noarch
* python2-urllib3 1.22-2.fc27.noarch -> 1.22-3.fc27.noarch
* python3-pip 9.0.1-11.fc27.noarch -> 9.0.1-13.fc27.noarch
* python3-setuptools 36.2.0-7.fc27.noarch -> 37.0.0-1.fc27.noarch
* python3-sssdconfig 1.16.0-2.fc27.noarch -> 1.16.0-4.fc27.noarch
* python3-urllib3 1.22-2.fc27.noarch -> 1.22-3.fc27.noarch
* rpm-ostree 2017.10-2.fc27.x86_64 -> 2017.10-3.fc27.x86_64
* rpm-ostree-libs 2017.10-2.fc27.x86_64 -> 2017.10-3.fc27.x86_64
* skopeo 0.1.26-1.git2e8377a.fc27.x86_64 -> 0.1.27-1.git93876ac.fc27.x86_64
* skopeo-containers 0.1.26-1.git2e8377a.fc27.x86_64 -> 0.1.27-1.git93876ac.fc27.x86_64
* sssd-client 1.16.0-2.fc27.x86_64 -> 1.16.0-4.fc27.x86_64
* vim-minimal 2:8.0.1322-1.fc27.x86_64 -> 2:8.0.1360-1.fc27.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 26 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](/blog/2017/11/fedora-atomic-26-to-27-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:
* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/Atomic/aarch64/iso/Fedora-Atomic-27-20171211.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20171211.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/Atomic/x86_64/iso/Fedora-Atomic-27-20171211.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20171211.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20171211.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171211.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20171211.0-x86_64-CHECKSUM)

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
* [Fedora Atomic Host 27](https://app.vagrantup.com/fedora/boxes/27-atomic-host)

To provision using vagrant:

```
vagrant init fedora/27-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/27-atomic-host
```
