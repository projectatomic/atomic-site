---
title: Fedora 27 Atomic Host March 15th Release
author: sinnykumari
date: 2018-03-15 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

Fedora Atomic Host **Version: 27.100** is available.

* Commit(x86_64): 326f62b93a5cc836c97d31e73a71b6b6b6955c0f225f7651b52a693718e6aa91
* Commit(aarch64): ba2aa19d99466c53e614651f014c8b97ae1940f87885b7c7dfed1fb62ae91567
* Commit(ppc64le): ca0ea3a6e15b6270aefe3c7b55ffbee3c8bd27707fd6d979cc66b39fc18fa5f4

READMORE

We are releasing images from multiple architectures but please note that x86_64 architecture is the only one that undergoes automated testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade`.

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old: da0bd968610aa1e29c5bb37065649407fbbfffa53e63831afdadbd34a3b05327
* ostree diff commit new: 326f62b93a5cc836c97d31e73a71b6b6b6955c0f225f7651b52a693718e6aa91

Upgraded:

* atomic 1.21.1-1.fc27 -> 1.22.1-1.fc27
* atomic-registries 1.21.1-1.fc27 -> 1.22.1-1.fc27
* audit 2.8.2-1.fc27 -> 2.8.3-1.fc27
* audit-libs 2.8.2-1.fc27 -> 2.8.3-1.fc27
* audit-libs-python 2.8.2-1.fc27 -> 2.8.3-1.fc27
* audit-libs-python3 2.8.2-1.fc27 -> 2.8.3-1.fc27
* bridge-utils 1.5-16.fc27 -> 1.6-1.fc27
* ceph-common 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* cockpit-bridge 161-1.fc27 -> 163-1.fc27
* cockpit-docker 161-1.fc27 -> 163-1.fc27
* cockpit-networkmanager 161-1.fc27 -> 163-1.fc27
* dhcp-client 12:4.3.6-8.fc27 -> 12:4.3.6-9.fc27
* dhcp-common 12:4.3.6-8.fc27 -> 12:4.3.6-9.fc27
* dhcp-libs 12:4.3.6-8.fc27 -> 12:4.3.6-9.fc27
* dnsmasq 2.78-2.fc27 -> 2.78-6.fc27
* fedora-gpg-keys 27-1 -> 27-2
* fedora-repos 27-1 -> 27-2
* glibc 2.26-24.fc27 -> 2.26-27.fc27
* glibc-all-langpacks 2.26-24.fc27 -> 2.26-27.fc27
* glibc-common 2.26-24.fc27 -> 2.26-27.fc27
* gnupg2 2.2.4-1.fc27 -> 2.2.5-1.fc27
* gnupg2-smime 2.2.4-1.fc27 -> 2.2.5-1.fc27
* ima-evm-utils 1.0-3.fc27 -> 1.1-2.fc27
* kernel 4.15.4-300.fc27 -> 4.15.8-300.fc27
* kernel-core 4.15.4-300.fc27 -> 4.15.8-300.fc27
* kernel-modules 4.15.4-300.fc27 -> 4.15.8-300.fc27
* libblkid 2.30.2-1.fc27 -> 2.30.2-2.fc27
* libcephfs2 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* libcrypt-nss 2.26-24.fc27 -> 2.26-27.fc27
* libfdisk 2.30.2-1.fc27 -> 2.30.2-2.fc27
* libgcc 7.3.1-2.fc27 -> 7.3.1-5.fc27
* libgomp 7.3.1-2.fc27 -> 7.3.1-5.fc27
* libidn2 2.0.4-1.fc27 -> 2.0.4-3.fc27
* libmount 2.30.2-1.fc27 -> 2.30.2-2.fc27
* librados2 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* libradosstriper1 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* librbd1 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* libreport-filesystem 2.9.3-1.fc27 -> 2.9.3-2.fc27
* librgw2 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* libsmartcols 2.30.2-1.fc27 -> 2.30.2-2.fc27
* libsolv 0.6.31-1.fc27 -> 0.6.33-1.fc27
* libsss_idmap 1.16.0-6.fc27 -> 1.16.0-8.fc27
* libsss_nss_idmap 1.16.0-6.fc27 -> 1.16.0-8.fc27
* libsss_sudo 1.16.0-6.fc27 -> 1.16.0-8.fc27
* libstdc++ 7.3.1-2.fc27 -> 7.3.1-5.fc27
* libunistring 0.9.7-3.fc27 -> 0.9.9-1.fc27
* libuuid 2.30.2-1.fc27 -> 2.30.2-2.fc27
* mpfr 3.1.5-5.fc27 -> 3.1.6-1.fc27
* nspr 4.17.0-1.fc27 -> 4.18.0-1.fc27
* nss 3.34.0-1.0.fc27 -> 3.35.0-1.1.fc27
* nss-softokn 3.34.0-1.0.fc27 -> 3.35.0-1.0.fc27
* nss-softokn-freebl 3.34.0-1.0.fc27 -> 3.35.0-1.0.fc27
* nss-sysinit 3.34.0-1.0.fc27 -> 3.35.0-1.1.fc27
* nss-tools 3.34.0-1.0.fc27 -> 3.35.0-1.1.fc27
* nss-util 3.34.0-1.0.fc27 -> 3.35.0-1.0.fc27
* p11-kit 0.23.9-2.fc27 -> 0.23.10-1.fc27
* p11-kit-trust 0.23.9-2.fc27 -> 0.23.10-1.fc27
* pcre 8.41-5.fc27 -> 8.41-6.fc27
* pcre2 10.30-6.fc27 -> 10.31-1.fc27
* policycoreutils 2.7-4.fc27 -> 2.7-5.fc27
* policycoreutils-python 2.7-4.fc27 -> 2.7-5.fc27
* policycoreutils-python-utils 2.7-4.fc27 -> 2.7-5.fc27
* policycoreutils-python3 2.7-4.fc27 -> 2.7-5.fc27
* publicsuffix-list-dafsa 20171228-1.fc27 -> 20180223-1.fc27
* python-cephfs 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* python-rados 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* python-rbd 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* python-rgw 1:12.2.2-1.fc27 -> 1:12.2.3-1.fc27
* python2 2.7.14-7.fc27 -> 2.7.14-8.fc27
* python2-libs 2.7.14-7.fc27 -> 2.7.14-8.fc27
* python3-sssdconfig 1.16.0-6.fc27 -> 1.16.0-8.fc27
* runc 2:1.0.0-17.rc4.git9f9c962.fc27 -> 2:1.0.0-19.rc5.git4bb1fe4.fc27
* selinux-policy 3.13.1-283.24.fc27 -> 3.13.1-283.26.fc27
* selinux-policy-targeted 3.13.1-283.24.fc27 -> 3.13.1-283.26.fc27
* sssd-client 1.16.0-6.fc27 -> 1.16.0-8.fc27
* subscription-manager-rhsm-certificates 1.21.1-1.fc27 -> 1.21.2-3.fc27
* systemd 234-9.fc27 -> 234-10.git5f8984e.fc27
* systemd-container 234-9.fc27 -> 234-10.git5f8984e.fc27
* systemd-libs 234-9.fc27 -> 234-10.git5f8984e.fc27
* systemd-pam 234-9.fc27 -> 234-10.git5f8984e.fc27
* systemd-udev 234-9.fc27 -> 234-10.git5f8984e.fc27
* util-linux 2.30.2-1.fc27 -> 2.30.2-2.fc27
* vim-minimal 2:8.0.1527-1.fc27 -> 2:8.0.1573-1.fc27
* xfsprogs 4.12.0-4.fc27 -> 4.15.1-1.fc27

Removed:

* cockpit-system-161-1.fc27.noarch

Added:

* cockpit-ostree-163-1.fc27.noarch

Corresponding image media for new installations can be downloaded from [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180314.0.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180314.0.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180314.0.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180314.0.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180314.0.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180314.0.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180314.0.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180314.0.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180314.0.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180314.0.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180314.0.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/aarch64/iso/Fedora-Atomic-27-20180314.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20180314.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/Atomic/x86_64/iso/Fedora-Atomic-27-20180314.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20180314.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180314.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180314.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20180314.0-x86_64-CHECKSUM)

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

* https://app.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180314.0

The AMIs for this release are here:

* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-west-2)      ami-a468f8dc
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-west-1)      ami-c20612a2
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-east-1)      ami-a112d1dc
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (sa-east-1)      ami-8d5401e1
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (eu-west-1)      ami-e3a8e19a
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (eu-central-1)   ami-452e452a
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-southeast-2) ami-c022e1a2
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-southeast-1) ami-432d7d3f
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-northeast-1) ami-0a5e146c
* hvm standard
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-west-2)      ami-916afae9 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-west-1)      ami-30071350 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (us-east-1)      ami-3e16d543 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (sa-east-1)      ami-d75702bb hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (eu-west-1)      ami-31a8e148 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (eu-central-1)   ami-bd2f44d2 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-southeast-2) ami-c623e0a4 hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-southeast-1) ami-f32f7f8f hvm gp2
* Fedora-Atomic-27-20180314.0.x86_64 EC2 (ap-northeast-1) ami-c85d17ae hvm gp2
