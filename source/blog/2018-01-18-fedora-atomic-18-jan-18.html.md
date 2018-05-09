---
title: Fedora 27 Atomic Host January 18th Release
author: dustymabe
date: 2018-01-18 16:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

In this week's release of Fedora Atomic Host we have an updated kernel (the [spectre patches](https://fedoramagazine.org/update-ongoing-meltdown-spectre-work/) are slowly working their way out), and an [updated docker with a security fix](https://bugzilla.redhat.com/show_bug.cgi?id=1510351). We also are *including* [firewalld in the ostree](https://pagure.io/atomic-wg/issue/372) now, but we are *not* enabling it by default. I'll post a follow up blog post on this topic in the next day or two.

The new Fedora Atomic Host update is available via an OSTree update:

***Version: 27.61***

* Commit(x86_64): 772ab185b0752b0d6bc8b2096d08955660d80ed95579e13e136e6a54e3559ca9
* Commit(aarch64): 598626fd61dc6ed4b702159e50b6029ee70a527e855fce7d8e61a870b141f893
* Commit(ppc64le): 16ce78ee689066f582dbfc0672dab1706051fefab496fcebd8109d58738eb8fe

We are releasing images from multiple architectures but please note that x86_64 architecture is the only one that undergoes automated testing at this time.

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or `atomic host deploy`. Systems on Fedora Atomic 26 can be upgraded using `rpm-ostree rebase`. Refer to the [upgrade guide](/blog/2017/11/fedora-atomic-26-to-27-upgrade/) for more details.

READMORE

Upgraded:

* GeoIP-GeoLite-data 2017.10-1.fc27.noarch -> 2018.01-1.fc27.noarch
* bash 4.4.12-12.fc27.x86_64 -> 4.4.12-13.fc27.x86_64
* cockpit-bridge 158-1.fc27.x86_64 -> 159-1.fc27.x86_64
* cockpit-docker 158-1.fc27.x86_64 -> 159-1.fc27.x86_64
* cockpit-networkmanager 158-1.fc27.noarch -> 159-1.fc27.noarch
* cockpit-ostree 158-1.fc27.x86_64 -> 159-1.fc27.x86_64
* cockpit-system 158-1.fc27.noarch -> 159-1.fc27.noarch
* container-selinux 2:2.37-1.fc27.noarch -> 2:2.38-1.fc27.noarch
* dhcp-client 12:4.3.6-7.fc27.x86_64 -> 12:4.3.6-8.fc27.x86_64
* dhcp-common 12:4.3.6-7.fc27.noarch -> 12:4.3.6-8.fc27.noarch
* dhcp-libs 12:4.3.6-7.fc27.x86_64 -> 12:4.3.6-8.fc27.x86_64
* docker 2:1.13.1-42.git4402c09.fc27.x86_64 -> 2:1.13.1-44.git584d391.fc27.x86_64
* docker-common 2:1.13.1-42.git4402c09.fc27.x86_64 -> 2:1.13.1-44.git584d391.fc27.x86_64
* docker-rhel-push-plugin 2:1.13.1-42.git4402c09.fc27.x86_64 -> 2:1.13.1-44.git584d391.fc27.x86_64
* dracut 046-5.fc27.x86_64 -> 046-8.git20180105.fc27.x86_64
* dracut-config-generic 046-5.fc27.x86_64 -> 046-8.git20180105.fc27.x86_64
* dracut-network 046-5.fc27.x86_64 -> 046-8.git20180105.fc27.x86_64
* gdbm 1.13-3.fc27.x86_64 -> 1.14-1.fc27.x86_64
* gettext 0.19.8.1-11.fc27.x86_64 -> 0.19.8.1-12.fc27.x86_64
* gettext-libs 0.19.8.1-11.fc27.x86_64 -> 0.19.8.1-12.fc27.x86_64
* glusterfs 3.12.4-1.fc27.x86_64 -> 3.12.5-1.fc27.x86_64
* glusterfs-client-xlators 3.12.4-1.fc27.x86_64 -> 3.12.5-1.fc27.x86_64
* glusterfs-fuse 3.12.4-1.fc27.x86_64 -> 3.12.5-1.fc27.x86_64
* glusterfs-libs 3.12.4-1.fc27.x86_64 -> 3.12.5-1.fc27.x86_64
* initscripts 9.78-1.fc27.x86_64 -> 9.79-1.fc27.x86_64
* iproute 4.13.0-1.fc27.x86_64 -> 4.14.1-4.fc27.x86_64
* iproute-tc 4.13.0-1.fc27.x86_64 -> 4.14.1-4.fc27.x86_64
* kernel 4.14.11-300.fc27.x86_64 -> 4.14.13-300.fc27.x86_64
* kernel-core 4.14.11-300.fc27.x86_64 -> 4.14.13-300.fc27.x86_64
* kernel-modules 4.14.11-300.fc27.x86_64 -> 4.14.13-300.fc27.x86_64
* kmod 24-3.fc27.x86_64 -> 25-1.fc27.x86_64
* kmod-libs 24-3.fc27.x86_64 -> 25-1.fc27.x86_64
* libpkgconf 1.3.12-1.fc27.x86_64 -> 1.3.12-2.fc27.x86_64
* libseccomp 2.3.2-5.fc27.x86_64 -> 2.3.3-1.fc27.x86_64
* linux-firmware 20171215-81.git2451bb22.fc27.noarch -> 20171215-82.git2451bb22.fc27.noarch
* microcode_ctl 2:2.1-19.fc27.x86_64 -> 2:2.1-20.fc27.x86_64
* pcre 8.41-3.fc27.x86_64 -> 8.41-4.fc27.x86_64
* pcre2 10.30-3.fc27.x86_64 -> 10.30-5.fc27.x86_64
* pigz 2.3.4-3.fc27.x86_64 -> 2.4-1.fc27.x86_64
* pkgconf 1.3.12-1.fc27.x86_64 -> 1.3.12-2.fc27.x86_64
* pkgconf-m4 1.3.12-1.fc27.noarch -> 1.3.12-2.fc27.noarch
* pkgconf-pkg-config 1.3.12-1.fc27.x86_64 -> 1.3.12-2.fc27.x86_64
* publicsuffix-list-dafsa 20171028-1.fc27.noarch -> 20171228-1.fc27.noarch
* python2 2.7.14-4.fc27.x86_64 -> 2.7.14-5.fc27.x86_64
* python2-libs 2.7.14-4.fc27.x86_64 -> 2.7.14-5.fc27.x86_64
* runc 2:1.0.0-12.rc4.gitaea4f21.fc27.x86_64 -> 2:1.0.0-15.rc4.gite6516b3.fc27.x86_64
* selinux-policy 3.13.1-283.19.fc27.noarch -> 3.13.1-283.21.fc27.noarch
* selinux-policy-targeted 3.13.1-283.19.fc27.noarch -> 3.13.1-283.21.fc27.noarch

Added:

* ebtables-2.0.10-24.fc27.x86_64
* firewalld-0.4.4.5-3.fc27.noarch
* firewalld-filesystem-0.4.4.5-3.fc27.noarch
* ipset-6.32-1.fc27.x86_64
* ipset-libs-6.32-1.fc27.x86_64
* python3-firewall-0.4.4.5-3.fc27.noarch

Corresponding image media for new installations can be downloaded from [Fedora Downloads](https://getfedora.org/en/atomic/download/).

Alternatively, image artifacts can be found at the following links:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20180117.1.iso)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20180117.1.iso)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/x86_64/iso/Fedora-Atomic-ostree-x86_64-27-20180117.1.iso)
* [aarch64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/aarch64/images/Fedora-Atomic-27-20180117.1.aarch64.qcow2)
* [aarch64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/aarch64/images/Fedora-Atomic-27-20180117.1.aarch64.raw.xz)
* [ppc64le Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20180117.1.ppc64le.qcow2)
* [ppc64le Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20180117.1.ppc64le.raw.xz)
* [x86_64 Cloud Image QCOW](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/x86_64/images/Fedora-Atomic-27-20180117.1.x86_64.qcow2)
* [x86_64 Cloud Image raw](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/x86_64/images/Fedora-Atomic-27-20180117.1.x86_64.raw.xz)
* [x86_64 Cloud Image LibVirt](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180117.1.x86_64.vagrant-libvirt.box)
* [x86_64 Cloud Image VirtualBox](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/x86_64/images/Fedora-Atomic-Vagrant-27-20180117.1.x86_64.vagrant-virtualbox.box)

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/aarch64/iso/Fedora-Atomic-27-20180117.1-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/ppc64le/iso/Fedora-Atomic-27-20180117.1-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/Atomic/x86_64/iso/Fedora-Atomic-27-20180117.1-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/aarch64/images/Fedora-CloudImages-27-20180117.1-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/ppc64le/images/Fedora-CloudImages-27-20180117.1-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20180117.1/CloudImages/x86_64/images/Fedora-CloudImages-27-20180117.1-x86_64-CHECKSUM)

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

For more information about the latest targets, please reference the [Fedora Atomic Wiki](https://fedoraproject.org/wiki/Atomic_WG#Fedora_Atomic_Image_Download_Links).

*Do note that it can take some of the mirrors up to 12 hours to "check-in" at
their own discretion.*

Vagrant Cloud page: [new Atomic Host](https://app.vagrantup.com/fedora/boxes/27-atomic-host/versions/27.20180117.1)

For posterity the AMIs for this release are:

* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-northeast-1) ami-047b1d62    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-southeast-1) ami-df6a15a3    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-southeast-2) ami-a6b34cc4    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (eu-central-1)   ami-88b926e7    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (eu-west-1)      ami-9b0a93e2    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (sa-east-1)      ami-0e6b2662    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-east-1)      ami-6a98b410    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-west-1)      ami-27313347    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-west-2)      ami-ee952696    hvm   standard
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-northeast-1) ami-1846207e    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-southeast-1) ami-6666191a    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (ap-southeast-2) ami-bab14ed8    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (eu-central-1)   ami-76b62919    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (eu-west-1)      ami-a8069fd1    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (sa-east-1)      ami-006a276c    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-east-1)      ami-6593bf1f    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-west-1)      ami-29323049    hvm   gp2
* Fedora-Atomic-27-20180117.1.x86_64  EC2 (us-west-2)      ami-7c9f2c04    hvm   gp2
