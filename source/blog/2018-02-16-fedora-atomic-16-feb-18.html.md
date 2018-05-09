---
title: Fedora 27 Atomic Host February 16th Release
author: dustymabe
date: 2018-02-16 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

In this week's release of Fedora Atomic Host we have a new kernel, Atomic CLI, and runc.

A new Fedora Atomic Host update is available via an OSTree update:

**Version: 27.81**

* Commit(x86_64): b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
* Commit(aarch64): bb5bc5afbf27333a70c1f3bf8d0117baa45e862e0440be5c779cd5f0bb35aab4
* Commit(ppc64le): e484af3c5a5c88c0de486eee195dff4c6c7ef41d07c41b5d356305db237066d7

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.

READMORE

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old: 39848372585a65dc63fb3052f997139b8b30d6b55ce378337db3664177489d28
* ostree diff commit new: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742

Upgraded:

* atomic 1.20.1-9.fc27 -> 1.21.1-1.fc27
* atomic-registries 1.20.1-9.fc27 -> 1.21.1-1.fc27
* cockpit-bridge 160-1.fc27 -> 161-1.fc27
* cockpit-docker 160-1.fc27 -> 161-1.fc27
* cockpit-networkmanager 160-1.fc27 -> 161-1.fc27
* cockpit-ostree 160-1.fc27 -> 161-1.fc27
* cockpit-system 160-1.fc27 -> 161-1.fc27
* container-selinux 2:2.42-1.fc27 -> 2:2.44-1.fc27
* criu 3.6-1.fc27 -> 3.7-3.fc27
* gnupg2 2.2.3-1.fc27 -> 2.2.4-1.fc27
* gnupg2-smime 2.2.3-1.fc27 -> 2.2.4-1.fc27
* kernel 4.14.14-300.fc27 -> 4.14.18-300.fc27
* kernel-core 4.14.14-300.fc27 -> 4.14.18-300.fc27
* kernel-modules 4.14.14-300.fc27 -> 4.14.18-300.fc27
* libgcc 7.2.1-2.fc27 -> 7.3.1-2.fc27
* libgomp 7.2.1-2.fc27 -> 7.3.1-2.fc27
* libsolv 0.6.30-2.fc27 -> 0.6.31-1.fc27
* libsss_idmap 1.16.0-5.fc27 -> 1.16.0-6.fc27
* libsss_nss_idmap 1.16.0-5.fc27 -> 1.16.0-6.fc27
* libsss_sudo 1.16.0-5.fc27 -> 1.16.0-6.fc27
* libstdc++ 7.2.1-2.fc27 -> 7.3.1-2.fc27
* net-tools 2.0-0.45.20160912git.fc27 -> 2.0-0.46.20160912git.fc27
* oci-register-machine 0-5.12.git3c01f0b.fc27 -> 0-6.1.git66fa845.fc27
* oci-umount 2:2.3.2-1.git3025b19.fc27 -> 2:2.3.3-1.gite3c9055.fc27
* openssh 7.6p1-3.fc27 -> 7.6p1-5.fc27
* openssh-clients 7.6p1-3.fc27 -> 7.6p1-5.fc27
* openssh-server 7.6p1-3.fc27 -> 7.6p1-5.fc27
* pcre 8.41-4.fc27 -> 8.41-5.fc27
* pcre2 10.30-5.fc27 -> 10.30-6.fc27
* python3 3.6.4-6.fc27 -> 3.6.4-7.fc27
* python3-libs 3.6.4-6.fc27 -> 3.6.4-7.fc27
* python3-rpm 4.14.0-2.fc27 -> 4.14.1-1.fc27
* python3-sssdconfig 1.16.0-5.fc27 -> 1.16.0-6.fc27
* rpm 4.14.0-2.fc27 -> 4.14.1-1.fc27
* rpm-build-libs 4.14.0-2.fc27 -> 4.14.1-1.fc27
* rpm-libs 4.14.0-2.fc27 -> 4.14.1-1.fc27
* rpm-plugin-selinux 4.14.0-2.fc27 -> 4.14.1-1.fc27
* rsync 3.1.2-7.fc27 -> 3.1.3-2.fc27
* runc 2:1.0.0-15.rc4.gite6516b3.fc27 -> 2:1.0.0-17.rc4.git9f9c962.fc27
* selinux-policy 3.13.1-283.21.fc27 -> 3.13.1-283.24.fc27
* selinux-policy-targeted 3.13.1-283.21.fc27 -> 3.13.1-283.24.fc27
* sssd-client 1.16.0-5.fc27 -> 1.16.0-6.fc27
* tzdata 2017c-1.fc27 -> 2018c-1.fc27
* vim-minimal 2:8.0.1438-1.fc27 -> 2:8.0.1478-1.fc27

Corresponding image media for new installations can be downloaded from: [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180212.2.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180212.2.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180212.2.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/aarch64/images/Fedora-Atomic-27-20180212.2.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/aarch64/images/Fedora-Atomic-27-20180212.2.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/ppc64le/images/Fedora-Atomic-27-20180212.2.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/ppc64le/images/Fedora-Atomic-27-20180212.2.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/x86_64/images/Fedora-Atomic-27-20180212.2.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/x86_64/images/Fedora-Atomic-27-20180212.2.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180212.2.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180212.2.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/aarch64/iso/Fedora-Atomic-27-20180212.2-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/ppc64le/iso/Fedora-Atomic-27-20180212.2-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/Atomic/x86_64/iso/Fedora-Atomic-27-20180212.2-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/aarch64/images/Fedora-CloudImages-27-20180212.2-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180212.2-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180212.2/CloudImages/x86_64/images/Fedora-CloudImages-27-20180212.2-x86_64-CHECKSUM)

For direct download, the "latest" targets are always available here:

* [ISO](https://getfedora.org/atomic_iso_latest)
* [QCOW](https://getfedora.org/atomic_qcow2_latest)
* [raw](https://getfedora.org/atomic_raw_latest)
* [LibVirt](https://getfedora.org/atomic_vagrant_libvirt_latest)
* [VirtualBox](https://getfedora.org/atomic_vagrant_virtualbox_latest)

Filename fetching URLs are available here:

* [ISO](https://getfedora.org/atomic_iso_latest_filename)
* [QCOW](https://getfedora.org/atomic_qcow2_latest_filename)
* [raw](https://getfedora.org/atomic_raw_latest_filename)
* [LibVirt](https://getfedora.org/atomic_vagrant_libvirt_latest_filename)
* [VirtualBox](https://getfedora.org/atomic_vagrant_virtualbox_latest_filename)

For more information about the latest targets, please reference the [Fedora Atomic Wiki space](https://fedoraproject.org/wiki/Atomic_WG#Fedora_Atomic_Image_Download_Links).

*Do note that it can take some of the mirrors up to 12 hours to "check-in" at their own discretion.*

The Vagrant Cloud page with the new Atomic Host:

* https://app.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180212.2

For posterity the AMIs for this release are:

* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-northeast-1) ami-afa4d6c9  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-southeast-1) ami-f72c6e8b  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-southeast-2) ami-135ba171  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (eu-central-1)   ami-dda4c2b2  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (eu-west-1)      ami-e8304191  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (sa-east-1)      ami-6efab402  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-east-1)      ami-481e0d32  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-west-1)      ami-7a4f461a  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-west-2)      ami-4ef37336  hvm     standard
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-northeast-1) ami-3fa6d459  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-southeast-1) ami-f22c6e8e  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (ap-southeast-2) ami-7a5ea418  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (eu-central-1)   ami-86a7c1e9  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (eu-west-1)      ami-57ccba2e  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (sa-east-1)      ami-fdfbb591  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-east-1)      ami-aa1c0fd0  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-west-1)      ami-7e4f461e  hvm     gp2
* Fedora-Atomic-27-20180212.2.x86_64  EC2  (us-west-2)      ami-59f67621  hvm     gp2
