---
title: Fedora 27 Atomic Host February 28th Release
author: dustymabe
date: 2018-02-28 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

Fedora Atomic Host 27.93 is available. We have a new kernel (4.15), [ostree](https://github.com/ostreedev/ostree/releases/tag/v2018.2), and [rpm-ostree](https://github.com/projectatomic/rpm-ostree/releases/tag/v2018.3) in this release.

It is also worth noting that now the `rpm-ostree status` output will prefix the remote:ref with `ostree://` in order to denote the system is following an ostree repository remote (see example below). This is in preparation of some upstream changes related to [rpm-ostree rojig](https://github.com/projectatomic/rpm-ostree/issues/1081), where updates can be delivered via a special rpm in a yum repo rather than an ostree server/remote.

READMORE

See the [release announcement](https://github.com/projectatomic/rpm-ostree/releases/tag/v2018.2) for more information.

We are now at **Version: 27.93**.

* Commit(x86_64): da0bd968610aa1e29c5bb37065649407fbbfffa53e63831afdadbd34a3b05327
* Commit(aarch64): 6607b02ff08bd0f0fc488772b398c25de28345a0bda0508ef45b433b91839ccd
* Commit(ppc64le): 848b618bd36e8b03bbcedf2d9ff881450440d8434f62cdb80006d3e899ebaa28

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade`.


```
[root@vanilla-f27atomic ~]# rpm-ostree status
State: idle; auto updates disabled
Deployments:
? ostree://fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.93 (2018-02-25 20:49:19)
                    Commit: da0bd968610aa1e29c5bb37065649407fbbfffa53e63831afdadbd34a3b05327
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
```

An example of the diff between this and the previous released version (for x86_64) is:

* ostree diff commit old: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
* ostree diff commit new: da0bd968610aa1e29c5bb37065649407fbbfffa53e63831afdadbd34a3b05327

Upgraded:

* bash 4.4.12-13.fc27 -> 4.4.19-1.fc27
* ca-certificates 2017.2.20-1.0.fc27 -> 2018.2.22-1.0.fc27
* container-selinux 2:2.44-1.fc27 -> 2:2.48-1.fc27
* coreutils 8.27-19.fc27 -> 8.27-20.fc27
* coreutils-common 8.27-19.fc27 -> 8.27-20.fc27
* findutils 1:4.6.0-14.fc27 -> 1:4.6.0-16.fc27
* freetype 2.8-7.fc27 -> 2.8-8.fc27
* glusterfs 3.12.5-1.fc27 -> 3.12.6-2.fc27
* glusterfs-client-xlators 3.12.5-1.fc27 -> 3.12.6-2.fc27
* glusterfs-fuse 3.12.5-1.fc27 -> 3.12.6-2.fc27
* glusterfs-libs 3.12.5-1.fc27 -> 3.12.6-2.fc27
* gnutls 3.5.17-1.fc27 -> 3.5.18-2.fc27
* grub2-common 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-efi-x64 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-pc 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-pc-modules 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-tools 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-tools-extra 1:2.02-19.fc27 -> 1:2.02-22.fc27
* grub2-tools-minimal 1:2.02-19.fc27 -> 1:2.02-22.fc27
* ima-evm-utils 1.0-2.fc27 -> 1.0-3.fc27
* iproute 4.14.1-4.fc27 -> 4.15.0-1.fc27
* iproute-tc 4.14.1-4.fc27 -> 4.15.0-1.fc27
* kernel 4.14.18-300.fc27 -> 4.15.4-300.fc27
* kernel-core 4.14.18-300.fc27 -> 4.15.4-300.fc27
* kernel-modules 4.14.18-300.fc27 -> 4.15.4-300.fc27
* krb5-libs 1.15.2-4.fc27 -> 1.15.2-7.fc27
* ostree 2018.1-1.fc27 -> 2018.2-1.fc27
* ostree-grub2 2018.1-1.fc27 -> 2018.2-1.fc27
* ostree-libs 2018.1-1.fc27 -> 2018.2-1.fc27
* python2 2.7.14-6.fc27 -> 2.7.14-7.fc27
* python2-libs 2.7.14-6.fc27 -> 2.7.14-7.fc27
* python3 3.6.4-7.fc27 -> 3.6.4-8.fc27
* python3-libs 3.6.4-7.fc27 -> 3.6.4-8.fc27
* rpm-ostree 2018.1-2.fc27 -> 2018.3-1.fc27
* rpm-ostree-libs 2018.1-2.fc27 -> 2018.3-1.fc27
* skopeo 0.1.27-1.git93876ac.fc27 -> 0.1.28-1.git0270e56.fc27
* skopeo-containers 0.1.27-1.git93876ac.fc27 -> 0.1.28-1.git0270e56.fc27
* strace 4.20-1.fc27 -> 4.21-1.fc27
* vim-minimal 2:8.0.1478-1.fc27 -> 2:8.0.1527-1.fc27
Removed:
* compat-openssl10-1:1.0.2m-1.fc27.x86_64

Corresponding image media for new installations can be downloaded from [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180226.0.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180226.0.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180226.0.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180226.0.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/aarch64/images/Fedora-Atomic-27-20180226.0.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180226.0.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/ppc64le/images/Fedora-Atomic-27-20180226.0.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180226.0.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/x86_64/images/Fedora-Atomic-27-20180226.0.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180226.0.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180226.0.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/aarch64/iso/Fedora-Atomic-27-20180226.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20180226.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/Atomic/x86_64/iso/Fedora-Atomic-27-20180226.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20180226.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180226.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180226.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20180226.0-x86_64-CHECKSUM)

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

The Vagrant Cloud page with the new atomic host:

* https://app.vagrantup.com/fedora/boxes/27-atomic-host
* https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180226.0

For posterity the AMIs for this release are:

* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-northeast-1) ami-2b1e594d hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-southeast-1) ami-ab541cd7 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-southeast-2) ami-4b844229 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (eu-central-1)   ami-3d1e7352 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (eu-west-1)      ami-273f455e hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (sa-east-1)      ami-dbd79fb7 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-east-1)      ami-068b627b hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-west-1)      ami-202d2640 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-west-2)      ami-5840c920 hvm standard
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-northeast-1) ami-ed1d5a8b hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-southeast-1) ami-cd551db1 hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (ap-southeast-2) ami-4884422a hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (eu-central-1)   ami-911c71fe hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (eu-west-1)      ami-983a40e1 hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (sa-east-1)      ami-86d59dea hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-east-1)      ami-2b8d6456 hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-west-1)      ami-242d2644 hvm gp2
* Fedora-Atomic-27-20180226.0.x86_64 EC2 (us-west-2)      ami-dd4fc6a5 hvm gp2
