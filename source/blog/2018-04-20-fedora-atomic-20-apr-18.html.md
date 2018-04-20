---
title: Fedora 27 Atomic Host April 20th Release
author: dustymabe
date: 2018-04-20 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

Fedora Atomic Host **Version 27.122** update is available via an OSTree update:

* Commit(x86_64): 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
* Commit(aarch64): 837cd0c5e3a5656316ebf6142315ac107c8592d5c8d64a02e8a62919eee9f46f
* Commit(ppc64le): a1f565d73f1f1b6f6d7ef992251f21a704c4a8de40c41fc62be69c5ec2a65329

We apologize for the delay in getting this release out the door. As a bonus for the wait we have AMIs that are available in additional regions (ap-northeast-2, ap-south-1). We'll be adding additional regions (the remaining missing regions) next release.

Additionally, this will most likely be our last release of Fedora 27 Atomic Host. Very soon Fedora 28 will be released and we will be picking up with our releases in the Fedora 28 stream. We will have plenty of announcements and content around Fedora 28 release time so watch this space for that!

READMORE

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade`.

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old:
c4015063c00515ddbbaa4c484573d38376db270b09adb22a4859faa0a39d5d93
* ostree diff commit new:
931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99

Upgraded:

* GeoIP-GeoLite-data 2018.01-1.fc27 -> 2018.04-1.fc27
* chrony 3.2-1.fc27 -> 3.3-1.fc27
* cockpit-bridge 164-1.fc27 -> 165-1.fc27
* cockpit-docker 164-1.fc27 -> 165-1.fc27
* cockpit-networkmanager 164-1.fc27 -> 165-1.fc27
* cockpit-ostree 164-1.fc27 -> 165-1.fc27
* cockpit-system 164-1.fc27 -> 165-1.fc27
* container-selinux 2:2.52-1.fc27 -> 2:2.55-1.fc27
* criu 3.7-3.fc27 -> 3.8.1-1.fc27
* dnsmasq 2.78-6.fc27 -> 2.79-1.fc27
* docker 2:1.13.1-44.git584d391.fc27 -> 2:1.13.1-51.git4032bd5.fc27
* docker-common 2:1.13.1-44.git584d391.fc27 -> 2:1.13.1-51.git4032bd5.fc27
* docker-rhel-push-plugin 2:1.13.1-44.git584d391.fc27 -> 2:1.13.1-51.git4032bd5.fc27
* glusterfs 3.12.6-2.fc27 -> 3.12.8-1.fc27
* glusterfs-client-xlators 3.12.6-2.fc27 -> 3.12.8-1.fc27
* glusterfs-fuse 3.12.6-2.fc27 -> 3.12.8-1.fc27
* glusterfs-libs 3.12.6-2.fc27 -> 3.12.8-1.fc27
* gnupg2 2.2.5-1.fc27 -> 2.2.6-1.fc27
* gnupg2-smime 2.2.5-1.fc27 -> 2.2.6-1.fc27
* grubby 8.40-7.fc27 -> 8.40-8.fc27
* kernel 4.15.10-300.fc27 -> 4.15.17-300.fc27
* kernel-core 4.15.10-300.fc27 -> 4.15.17-300.fc27
* kernel-modules 4.15.10-300.fc27 -> 4.15.17-300.fc27
* krb5-libs 1.15.2-7.fc27 -> 1.15.2-8.fc27
* libblkid 2.30.2-2.fc27 -> 2.30.2-3.fc27
* libfdisk 2.30.2-2.fc27 -> 2.30.2-3.fc27
* libidn 1.33-4.fc27 -> 1.34-1.fc27
* libidn2 2.0.4-3.fc27 -> 2.0.4-4.fc27
* libmount 2.30.2-2.fc27 -> 2.30.2-3.fc27
* libreport-filesystem 2.9.3-2.fc27 -> 2.9.3-3.fc27
* libsmartcols 2.30.2-2.fc27 -> 2.30.2-3.fc27
* libsolv 0.6.33-1.fc27 -> 0.6.34-1.fc27
* libsss_idmap 1.16.1-1.fc27 -> 1.16.1-2.fc27
* libsss_nss_idmap 1.16.1-1.fc27 -> 1.16.1-2.fc27
* libsss_sudo 1.16.1-1.fc27 -> 1.16.1-2.fc27
* libtirpc 1.0.3-0.fc27 -> 1.0.3-1.fc27
* libuuid 2.30.2-2.fc27 -> 2.30.2-3.fc27
* libzstd 1.3.3-1.fc27 -> 1.3.4-1.fc27
* nmap-ncat 2:7.60-7.fc27 -> 2:7.60-8.fc27
* openssl 1:1.1.0g-1.fc27 -> 1:1.1.0h-3.fc27
* openssl-libs 1:1.1.0g-1.fc27 -> 1:1.1.0h-3.fc27
* ostree 2018.2-1.fc27 -> 2018.3-2.fc27
* ostree-grub2 2018.2-1.fc27 -> 2018.3-2.fc27
* ostree-libs 2018.2-1.fc27 -> 2018.3-2.fc27
* passwd 0.79-12.fc27 -> 0.80-2.fc27
* pcre 8.41-6.fc27 -> 8.42-1.fc27
* pcre2 10.31-3.fc27 -> 10.31-4.fc27
* policycoreutils 2.7-5.fc27 -> 2.7-6.fc27
* policycoreutils-python 2.7-5.fc27 -> 2.7-6.fc27
* policycoreutils-python-utils 2.7-5.fc27 -> 2.7-6.fc27
* policycoreutils-python3 2.7-5.fc27 -> 2.7-6.fc27
* publicsuffix-list-dafsa 20180223-1.fc27 -> 20180328-1.fc27
* python2-pip 9.0.1-14.fc27 -> 9.0.3-1.fc27
* python3 3.6.4-9.fc27 -> 3.6.5-1.fc27
* python3-jwt 1.5.3-1.fc27 -> 1.6.1-1.fc27
* python3-libs 3.6.4-9.fc27 -> 3.6.5-1.fc27
* python3-pip 9.0.1-14.fc27 -> 9.0.3-1.fc27
* python3-sssdconfig 1.16.1-1.fc27 -> 1.16.1-2.fc27
* python3-websocket-client 0.40.0-2.fc27 -> 0.47.0-1.fc27
* rpm-ostree 2018.3-1.fc27 -> 2018.4-1.fc27
* rpm-ostree-libs 2018.3-1.fc27 -> 2018.4-1.fc27
* selinux-policy 3.13.1-283.28.fc27 -> 3.13.1-283.30.fc27
* selinux-policy-targeted 3.13.1-283.28.fc27 -> 3.13.1-283.30.fc27
* skopeo 0.1.28-1.git0270e56.fc27 -> 0.1.29-1.git7add6fc.fc27
* skopeo-containers 0.1.28-1.git0270e56.fc27 -> 0.1.29-1.git7add6fc.fc27
* sqlite-libs 3.20.1-1.fc27 -> 3.20.1-2.fc27
* sssd-client 1.16.1-1.fc27 -> 1.16.1-2.fc27
* strace 4.21-1.fc27 -> 4.22-1.fc27
* tzdata 2018c-1.fc27 -> 2018d-1.fc27
* util-linux 2.30.2-2.fc27 -> 2.30.2-3.fc27
* vim-minimal 2:8.0.1573-1.fc27 -> 2:8.0.1704-1.fc27
Removed:

* python-websocket-client-0.40.0-2.fc27.noarch

Added:

* python2-websocket-client-0.47.0-1.fc27.noarch

Corresponding image media for new installations can be downloaded from [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180419.0.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180419.0.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180419.0.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180419.0.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180419.0.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180419.0.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180419.0.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180419.0.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180419.0.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180419.0.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180419.0.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/aarch64/iso/Fedora-Atomic-27-20180419.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20180419.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/Atomic/x86_64/iso/Fedora-Atomic-27-20180419.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20180419.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180419.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180419.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20180419.0-x86_64-CHECKSUM)

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

The Vagrant Cloud page with the new atomic host:

* https://app.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180419.0

The AMIs for this release are here:

* Fedora-Atomic-27-20180419.0.x86_64 us-west-2        ami-a87718d0 hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 us-west-1        ami-e69e8c86 hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 us-east-1        ami-5ab51925 hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 sa-east-1        ami-1197c77d hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 eu-west-1        ami-924a6aeb hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 eu-central-1     ami-20f6d3cb hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 ap-southeast-2   ami-b60ec5d4 hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 ap-southeast-1   ami-6007251c hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 ap-south-1       ami-2343654c hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 ap-northeast-2   ami-5046e83e hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 ap-northeast-1   ami-f1100b8d hvm standard
* Fedora-Atomic-27-20180419.0.x86_64 us-west-2        ami-7f751a07 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 us-west-1        ami-3b998b5b hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 us-east-1        ami-4eb01c31 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 sa-east-1        ami-d99cccb5 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 eu-west-1        ami-6c4c6c15 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 eu-central-1     ami-b1f7d25a hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 ap-southeast-2   ami-c901caab hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 ap-southeast-1   ami-ad0527d1 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 ap-south-1       ami-ac4c6ac3 hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 ap-northeast-2   ami-a146e8cf hvm gp2
* Fedora-Atomic-27-20180419.0.x86_64 ap-northeast-1   ami-b2170cce hvm gp2
