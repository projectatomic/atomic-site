---
title: Fedora 27 Atomic Host January 4th Security Release
author: dustymabe
date: 2018-01-04 14:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit.  This update contains an important security patch.

```
Version: 27.47
Commit(x86_64): 397e907961adafaeff11b807ceade8da5783134072406fcdba627f1195e0db76
Commit(aarch64): 25965b64256417d7dfed37511ffe0cf842ebe64bd6adc8c57a3c603dcfd79885
Commit(ppc64le): c0d0a28a01fd363dfc317e3418935efae6d728a718320dfb3709c4282160f20f
```

This is a security related release of Fedora Atomic Host to
address [CVE-2017-5754](https://access.redhat.com/security/cve/cve-2017-5754) (Meltdown). This release does not
yet handle the "Spectre" vulnerabilities, [CVE-2017-5753](https://access.redhat.com/security/cve/cve-2017-5753) and [CVE-2017-5715](https://access.redhat.com/security/cve/cve-2017-5715). Those will
come in a future update. For more information see the [Red Hat
knowledgebase article](https://access.redhat.com/security/vulnerabilities/speculativeexecution).

kernel-4.14.11-300.fc27.x86_64 fixes [BZ1530826](https://bugzilla.redhat.com/show_bug.cgi?id=1530826) related to
CVE-2017-5754. It also fixes some other CVEs as well. See [the
attached bugs to the bodhi update](https://bodhi.fedoraproject.org/updates/kernel-4.14.11-300.fc27) for more information.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: b5845ebd002b2ec829c937d68645400aa163e7265936b3e91734c6f33a510473
* ostree diff commit new: 397e907961adafaeff11b807ceade8da5783134072406fcdba627f1195e0db76

Upgraded:

* container-selinux 2:2.36-1.fc27.noarch -> 2:2.37-1.fc27.noarch
* glibc 2.26-20.fc27.x86_64 -> 2.26-21.fc27.x86_64
* glibc-all-langpacks 2.26-20.fc27.x86_64 -> 2.26-21.fc27.x86_64
* glibc-common 2.26-20.fc27.x86_64 -> 2.26-21.fc27.x86_64
* kernel 4.14.8-300.fc27.x86_64 -> 4.14.11-300.fc27.x86_64
* kernel-core 4.14.8-300.fc27.x86_64 -> 4.14.11-300.fc27.x86_64
* kernel-modules 4.14.8-300.fc27.x86_64 -> 4.14.11-300.fc27.x86_64
* libcrypt-nss 2.26-20.fc27.x86_64 -> 2.26-21.fc27.x86_64
* oci-register-machine 0-5.11.gitcd1e331.fc27.x86_64 -> 0-5.12.git3c01f0b.fc27.x86_64
* oci-systemd-hook 1:0.1.13-1.gitafe4b4a.fc27.x86_64 -> 1:0.1.15-1.git2d0b8a3.fc27.x86_64
* oci-umount 2:2.3.0-1.git51e7c50.fc27.x86_64 -> 2:2.3.2-1.git3025b19.fc27.x86_64
* os-prober 1.74-3.fc27.x86_64 -> 1.74-4.fc27.x86_64
* selinux-policy 3.13.1-283.17.fc27.noarch -> 3.13.1-283.19.fc27.noarch
* selinux-policy-targeted 3.13.1-283.17.fc27.noarch -> 3.13.1-283.19.fc27.noarch
* vim-minimal 2:8.0.1386-1.fc27.x86_64 -> 2:8.0.1427-1.fc27.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 26 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](/blog/2017/11/fedora-atomic-26-to-27-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/Atomic/aarch64/iso/Fedora-Atomic-27-20180104.5-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/Atomic/ppc64le/iso/Fedora-Atomic-27-20180104.5-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/Atomic/x86_64/iso/Fedora-Atomic-27-20180104.5-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/CloudImages/aarch64/images/Fedora-CloudImages-27-20180104.5-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180104.5-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180104.5/CloudImages/x86_64/images/Fedora-CloudImages-27-20180104.5-x86_64-CHECKSUM)


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
