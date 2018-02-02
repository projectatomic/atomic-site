---
title: Fedora 27 Atomic Host February 2nd Release
author: dustymabe
date: 2018-02-02 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

In this week's release of Fedora Atomic Host we have a new kernel,
ostree/rpm-ostree, glibc, and cloud-utils-growpart (fixes for aarch64
[partition resize issues](https://pagure.io/atomic-wg/issue/382)).

The new Fedora Atomic Host update is available via an OSTree update:

**Version: 27.72**

* Commit(x86_64): 39848372585a65dc63fb3052f997139b8b30d6b55ce378337db3664177489d28
* Commit(aarch64): 8048d384f231f90a7479cf94bfe94053970fb9a0f196ba4485d779696db81fa1
* Commit(ppc64le): 3fce2908406e41e2ffe533908e840f44311576befe7e49396d1894407341aef9

We are releasing images from multiple architectures but please note that x86_64 architecture is the only one that undergoes automated testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or `atomic host deploy`.

READMORE

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old: 772ab185b0752b0d6bc8b2096d08955660d80ed95579e13e136e6a54e3559ca9
* ostree diff commit new: 39848372585a65dc63fb3052f997139b8b30d6b55ce378337db3664177489d28

Upgraded:

  * NetworkManager 1:1.8.4-7.fc27.x86_64 -> 1:1.8.6-1.fc27.x86_64
  * NetworkManager-libnm 1:1.8.4-7.fc27.x86_64 -> 1:1.8.6-1.fc27.x86_64
  * NetworkManager-team 1:1.8.4-7.fc27.x86_64 -> 1:1.8.6-1.fc27.x86_64
  * cloud-utils-growpart 0.27-18.fc27.noarch -> 0.30-1.fc27.noarch
  * cockpit-bridge 159-1.fc27.x86_64 -> 160-1.fc27.x86_64
  * cockpit-docker 159-1.fc27.x86_64 -> 160-1.fc27.x86_64
  * cockpit-networkmanager 159-1.fc27.noarch -> 160-1.fc27.noarch
  * cockpit-ostree 159-1.fc27.x86_64 -> 160-1.fc27.x86_64
  * cockpit-system 159-1.fc27.noarch -> 160-1.fc27.noarch
  * container-selinux 2:2.38-1.fc27.noarch -> 2:2.42-1.fc27.noarch
  * coreutils 8.27-17.fc27.x86_64 -> 8.27-19.fc27.x86_64
  * coreutils-common 8.27-17.fc27.x86_64 -> 8.27-19.fc27.x86_64
  * curl 7.55.1-8.fc27.x86_64 -> 7.55.1-9.fc27.x86_64
  * dnsmasq 2.78-1.fc27.x86_64 -> 2.78-2.fc27.x86_64
  * gdbm 1.14-1.fc27.x86_64 -> 1:1.13-6.fc27.x86_64
  * glib2 2.54.2-1.fc27.x86_64 -> 2.54.3-2.fc27.x86_64
  * glibc 2.26-21.fc27.x86_64 -> 2.26-24.fc27.x86_64
  * glibc-all-langpacks 2.26-21.fc27.x86_64 -> 2.26-24.fc27.x86_64
  * glibc-common 2.26-21.fc27.x86_64 -> 2.26-24.fc27.x86_64
  * gnutls 3.5.16-4.fc27.x86_64 -> 3.5.17-1.fc27.x86_64
  * kernel 4.14.13-300.fc27.x86_64 -> 4.14.14-300.fc27.x86_64
  * kernel-core 4.14.13-300.fc27.x86_64 -> 4.14.14-300.fc27.x86_64
  * kernel-modules 4.14.13-300.fc27.x86_64 -> 4.14.14-300.fc27.x86_64
  * libassuan 2.4.3-6.fc27.x86_64 -> 2.5.1-1.fc27.x86_64
  * libcrypt-nss 2.26-21.fc27.x86_64 -> 2.26-24.fc27.x86_64
  * libcurl 7.55.1-8.fc27.x86_64 -> 7.55.1-9.fc27.x86_64
  * libgcrypt 1.8.1-3.fc27.x86_64 -> 1.8.2-1.fc27.x86_64
  * libnfsidmap 1:2.2.1-3.rc2.fc27.x86_64 -> 1:2.2.1-4.rc2.fc27.x86_64
  * libtasn1 4.12-3.fc27.x86_64 -> 4.13-1.fc27.x86_64
  * libxml2 2.9.5-2.fc27.x86_64 -> 2.9.7-1.fc27.x86_64
  * nfs-utils 1:2.2.1-3.rc2.fc27.x86_64 -> 1:2.2.1-4.rc2.fc27.x86_64
  * ostree 2017.15-1.fc27.x86_64 -> 2018.1-1.fc27.x86_64
  * ostree-grub2 2017.15-1.fc27.x86_64 -> 2018.1-1.fc27.x86_64
  * ostree-libs 2017.15-1.fc27.x86_64 -> 2018.1-1.fc27.x86_64
  * python2 2.7.14-5.fc27.x86_64 -> 2.7.14-6.fc27.x86_64
  * python2-libs 2.7.14-5.fc27.x86_64 -> 2.7.14-6.fc27.x86_64
  * python3 3.6.3-2.fc27.x86_64 -> 3.6.4-6.fc27.x86_64
  * python3-libs 3.6.3-2.fc27.x86_64 -> 3.6.4-6.fc27.x86_64
  * python3-libxml2 2.9.5-2.fc27.x86_64 -> 2.9.7-1.fc27.x86_64
  * rpm-ostree 2017.11-1.fc27.x86_64 -> 2018.1-2.fc27.x86_64
  * rpm-ostree-libs 2017.11-1.fc27.x86_64 -> 2018.1-2.fc27.x86_64
  * sed 4.4-3.fc27.x86_64 -> 4.4-4.fc27.x86_64
  * timedatex 0.4-5.fc27.x86_64 -> 0.5-2.fc27.x86_64
  * vim-minimal 2:8.0.1427-1.fc27.x86_64 -> 2:8.0.1438-1.fc27.x86_64

Removed:

  * python-rhsm-certificates-1.20.1-3.fc27.x86_64

Added:

  * subscription-manager-rhsm-certificates-1.21.1-1.fc27.x86_64

Corresponding image media for new installations can be downloaded from: [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:
* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180201.0.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180201.0.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180201.0.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180201.0.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180201.0.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180201.0.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180201.0.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180201.0.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180201.0.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180201.0.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180201.0.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:
* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/aarch64/iso/Fedora-Atomic-27-20180201.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20180201.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/Atomic/x86_64/iso/Fedora-Atomic-27-20180201.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20180201.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180201.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180201.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20180201.0-x86_64-CHECKSUM)

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

For more information about the latest targets, please reference the [Fedora Atomic Wiki](https://fedoraproject.org/wiki/Atomic_WG#Fedora_Atomic_Image_Download_Links) space.

*Do note that it can take some of the mirrors up to 12 hours to "check-in" at
their own discretion.*

The Vagrant Cloud page with the new Atomic Host:

* https://app.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180201.0

For posterity the AMIs for this release are:

* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-northeast-1) ami-234e2545    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-southeast-1) ami-cd7236b1    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-southeast-2) ami-46827a24    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (eu-central-1)   ami-e0b9238f    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (eu-west-1)      ami-32b4d94b    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (sa-east-1)      ami-035b146f    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-east-1)      ami-97ebeced    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-west-1)      ami-854b44e5    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-west-2)      ami-d075cea8    hvm  standard
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-northeast-1) ami-e24c2784    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-southeast-1) ami-d27236ae    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (ap-southeast-2) ami-47827a25    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (eu-central-1)   ami-adb822c2    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (eu-west-1)      ami-fdb0dd84    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (sa-east-1)      ami-325c135e    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-east-1)      ami-56e2e52c    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-west-1)      ami-f84c4398    hvm  gp2
* Fedora-Atomic-27-20180201.0.x86_64  EC2 (us-west-2)      ami-b66ad1ce    hvm  gp2
