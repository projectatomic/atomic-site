---
title: Fedora 27 Atomic Host March 28th Release
author: sinnykumari
date: 2018-03-28 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

Fedora Atomic Host **Version 27.105** update is available via an OSTree update:

* Commit(x86_64): c4015063c00515ddbbaa4c484573d38376db270b09adb22a4859faa0a39d5d93
* Commit(aarch64): 69bd8187bb519483f275dc1456434cc18eec961ab53d965fd50516865ded3c25
* Commit(ppc64le): ae9104933a70342d2b2b08c8ff9f07f2e883b6e18abf2b06c6a3e7be3685af66

In this week's release of Fedora Atomic Host we have a new release of [cockpit](https://github.com/cockpit-project/cockpit/releases/tag/164).

READMORE

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade`.

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old: 326f62b93a5cc836c97d31e73a71b6b6b6955c0f225f7651b52a693718e6aa91
* ostree diff commit new: c4015063c00515ddbbaa4c484573d38376db270b09adb22a4859faa0a39d5d93

Upgraded:

* ceph-common 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* cockpit-bridge 163-1.fc27 -> 164-1.fc27
* cockpit-docker 163-1.fc27 -> 164-1.fc27
* cockpit-networkmanager 163-1.fc27 -> 164-1.fc27
* cockpit-ostree 163-1.fc27 -> 164-1.fc27
* cockpit-system 163-1.fc27 -> 164-1.fc27
* container-selinux 2:2.48-1.fc27 -> 2:2.52-1.fc27
* curl 7.55.1-9.fc27 -> 7.55.1-10.fc27
* elfutils-default-yama-scope 0.170-1.fc27 -> 0.170-10.fc27
* elfutils-libelf 0.170-1.fc27 -> 0.170-10.fc27
* elfutils-libs 0.170-1.fc27 -> 0.170-10.fc27
* jansson 2.10-4.fc27 -> 2.11-1.fc27
* kernel 4.15.8-300.fc27 -> 4.15.10-300.fc27
* kernel-core 4.15.8-300.fc27 -> 4.15.10-300.fc27
* kernel-modules 4.15.8-300.fc27 -> 4.15.10-300.fc27
* libcephfs2 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* libcurl 7.55.1-9.fc27 -> 7.55.1-10.fc27
* librados2 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* libradosstriper1 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* librbd1 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* librgw2 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* libsss_idmap 1.16.0-8.fc27 -> 1.16.1-1.fc27
* libsss_nss_idmap 1.16.0-8.fc27 -> 1.16.1-1.fc27
* libsss_sudo 1.16.0-8.fc27 -> 1.16.1-1.fc27
* libtirpc 1.0.2-4.fc27 -> 1.0.3-0.fc27
* microcode_ctl 2:2.1-20.fc27 -> 2:2.1-22.fc27
* nspr 4.18.0-1.fc27 -> 4.19.0-1.fc27
* nss 3.35.0-1.1.fc27 -> 3.36.0-1.0.fc27
* nss-softokn 3.35.0-1.0.fc27 -> 3.36.0-1.0.fc27
* nss-softokn-freebl 3.35.0-1.0.fc27 -> 3.36.0-1.0.fc27
* nss-sysinit 3.35.0-1.1.fc27 -> 3.36.0-1.0.fc27
* nss-tools 3.35.0-1.1.fc27 -> 3.36.0-1.0.fc27
* nss-util 3.35.0-1.0.fc27 -> 3.36.0-1.0.fc27
* pcre2 10.31-1.fc27 -> 10.31-3.fc27
* python-cephfs 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* python-rados 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* python-rbd 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* python-rgw 1:12.2.3-1.fc27 -> 1:12.2.4-1.fc27
* python2 2.7.14-8.fc27 -> 2.7.14-10.fc27
* python2-libs 2.7.14-8.fc27 -> 2.7.14-10.fc27
* python3 3.6.4-8.fc27 -> 3.6.4-9.fc27
* python3-libs 3.6.4-8.fc27 -> 3.6.4-9.fc27
* python3-sssdconfig 1.16.0-8.fc27 -> 1.16.1-1.fc27
* selinux-policy 3.13.1-283.26.fc27 -> 3.13.1-283.28.fc27
* selinux-policy-targeted 3.13.1-283.26.fc27 -> 3.13.1-283.28.fc27
* shared-mime-info 1.9-1.fc27 -> 1.9-2.fc27
* sssd-client 1.16.0-8.fc27 -> 1.16.1-1.fc27

Corresponding image media for new installations can be downloaded from [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180326.1.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180326.1.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180326.1.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/aarch64/images/Fedora-Atomic-27-20180326.1.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/aarch64/images/Fedora-Atomic-27-20180326.1.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20180326.1.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20180326.1.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/x86_64/images/Fedora-Atomic-27-20180326.1.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/x86_64/images/Fedora-Atomic-27-20180326.1.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180326.1.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180326.1.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/aarch64/iso/Fedora-Atomic-27-20180326.1-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/ppc64le/iso/Fedora-Atomic-27-20180326.1-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/Atomic/x86_64/iso/Fedora-Atomic-27-20180326.1-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/aarch64/images/Fedora-CloudImages-27-20180326.1-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180326.1-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180326.1/CloudImages/x86_64/images/Fedora-CloudImages-27-20180326.1-x86_64-CHECKSUM)

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

*Do note that it can take some of the mirrors up to 12 hours to "check-in" at their own discretion.*

The Vagrant Cloud page with the new Atomic Host:

* p.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180326.1

The AMIs for this release are here:

* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-west-2)      ami-8260f9fa hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-west-1)      ami-69c9df09 hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-east-1)      ami-3abd6247 hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (sa-east-1)      ami-431c4b2f hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (eu-west-1)      ami-cf5303b6 hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (eu-central-1)   ami-8660326d hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-southeast-2) ami-96e824f4 hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-southeast-1) ami-806836fc hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-northeast-1) ami-834e47ff hvm standard
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-west-2)      ami-dd60f9a5 hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-west-1)      ami-bef6e0de hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (us-east-1)      ami-1bb16e66 hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (sa-east-1)      ami-391e4955 hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (eu-west-1)      ami-152f7f6c hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (eu-central-1)   ami-3b6634d0 hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-southeast-2) ami-b5ef23d7 hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-southeast-1) ami-826836fe hvm gp2
* Fedora-Atomic-27-20180326.1.x86_64 EC2 (ap-northeast-1) ami-a04c45dc hvm gp2
