---
title: Fedora 27 Atomic Host November 30th Release
author: jberkus
date: 2017-12-01 13:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Version: 27.16
Commit(x86_64): 86727cdbc928b7f7dd0e32f62d3b973a8395d61e0ff751cfea7cc0bc5222142f
Commit(aarch64): 49f9b422bc53b30aea3074c75a15e8322ed1d14980ff0b5f9c694089598b4f2f
Commit(ppc64le): 600955d77630fec6d1d3a76af31d872f2fed8af1495399256a0dfff013a518f3
```

This is a large update as it is the first update in Fedora 27. Included
are new kernel, systemd, ostree, rpm-ostree, and atomic CLI. Future updates
should be quite a bit smaller than this.

We are releasing images from multiple architectures but please note
that x86_64 architecture is the only one that undergoes automated
testing at this time.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: d428d3ad8ecf44e53d138042bad56a10308883a0c5d64b9c51eff27fdc9da82c
* ostree diff commit new: 86727cdbc928b7f7dd0e32f62d3b973a8395d61e0ff751cfea7cc0bc5222142f

Upgraded:

* NetworkManager 1:1.8.4-2.fc27.x86_64 -> 1:1.8.4-7.fc27.x86_64
* NetworkManager-libnm 1:1.8.4-2.fc27.x86_64 -> 1:1.8.4-7.fc27.x86_64
* NetworkManager-team 1:1.8.4-2.fc27.x86_64 -> 1:1.8.4-7.fc27.x86_64
* atomic 1.19.1-1.fc27.x86_64 -> 1.20.1-3.fc27.x86_64
* atomic-registries 1.19.1-1.fc27.x86_64 -> 1.20.1-3.fc27.x86_64
* audit 2.7.8-1.fc27.x86_64 -> 2.8.1-1.fc27.x86_64
* audit-libs 2.7.8-1.fc27.x86_64 -> 2.8.1-1.fc27.x86_64
* audit-libs-python 2.7.8-1.fc27.x86_64 -> 2.8.1-1.fc27.x86_64
* audit-libs-python3 2.7.8-1.fc27.x86_64 -> 2.8.1-1.fc27.x86_64
* bind99-libs 9.9.11-2.fc27.x86_64 -> 9.9.11-3.fc27.x86_64
* bind99-license 9.9.11-2.fc27.noarch -> 9.9.11-3.fc27.noarch
* bubblewrap 0.1.8-3.fc27.x86_64 -> 0.2.0-2.fc27.x86_64
* cockpit-bridge 151-2.fc27.x86_64 -> 155-1.fc27.x86_64
* cockpit-docker 151-2.fc27.x86_64 -> 155-1.fc27.x86_64
* cockpit-networkmanager 151-2.fc27.noarch -> 155-1.fc27.noarch
* cockpit-ostree 151-2.fc27.x86_64 -> 155-1.fc27.x86_64
* cockpit-system 151-2.fc27.noarch -> 155-1.fc27.noarch
* compat-openssl10 1:1.0.2j-9.fc27.x86_64 -> 1:1.0.2m-1.fc27.x86_64
* container-selinux 2:2.28-1.fc27.noarch -> 2:2.29-1.fc27.noarch
* container-storage-setup 0.8.0-1.git1d27ecf.fc27.noarch -> 0.8.0-2.git1d27ecf.fc27.noarch
* coreutils 8.27-16.fc27.x86_64 -> 8.27-17.fc27.x86_64
* coreutils-common 8.27-16.fc27.x86_64 -> 8.27-17.fc27.x86_64
* criu 3.5-1.fc27.x86_64 -> 3.6-1.fc27.x86_64
* crypto-policies 20170816-1.git2618a6c.fc27.noarch -> 20170816-2.gite0a4066.fc27.noarch
* curl 7.55.1-5.fc27.x86_64 -> 7.55.1-7.fc27.x86_64
* dbus 1:1.11.20-1.fc27.x86_64 -> 1:1.12.0-1.fc27.x86_64
* dbus-libs 1:1.11.20-1.fc27.x86_64 -> 1:1.12.0-1.fc27.x86_64
* device-mapper 1.02.142-4.fc27.x86_64 -> 1.02.144-1.fc27.x86_64
* device-mapper-event 1.02.142-4.fc27.x86_64 -> 1.02.144-1.fc27.x86_64
* device-mapper-event-libs 1.02.142-4.fc27.x86_64 -> 1.02.144-1.fc27.x86_64
* device-mapper-libs 1.02.142-4.fc27.x86_64 -> 1.02.144-1.fc27.x86_64
* device-mapper-persistent-data 0.7.0-0.6.rc6.fc27.x86_64 -> 0.7.5-1.fc27.x86_64
* docker 2:1.13.1-26.gitb5e3294.fc27.x86_64 -> 2:1.13.1-42.git4402c09.fc27.x86_64
* docker-common 2:1.13.1-26.gitb5e3294.fc27.x86_64 -> 2:1.13.1-42.git4402c09.fc27.x86_64
* docker-rhel-push-plugin 2:1.13.1-26.gitb5e3294.fc27.x86_64 -> 2:1.13.1-42.git4402c09.fc27.x86_64
* efivar 31-3.fc27.x86_64 -> 32-2.fc27.x86_64
* efivar-libs 31-3.fc27.x86_64 -> 32-2.fc27.x86_64
* expat 2.2.4-1.fc27.x86_64 -> 2.2.5-1.fc27.x86_64
* gawk 4.1.4-7.fc27.x86_64 -> 4.1.4-8.fc27.x86_64
* glib-networking 2.54.0-1.fc27.x86_64 -> 2.54.1-1.fc27.x86_64
* glib2 2.54.1-1.fc27.x86_64 -> 2.54.2-1.fc27.x86_64
* glibc 2.26-15.fc27.x86_64 -> 2.26-16.fc27.x86_64
* glibc-all-langpacks 2.26-15.fc27.x86_64 -> 2.26-16.fc27.x86_64
* glibc-common 2.26-15.fc27.x86_64 -> 2.26-16.fc27.x86_64
* glusterfs 3.12.1-2.fc27.x86_64 -> 3.12.3-1.fc27.x86_64
* glusterfs-client-xlators 3.12.1-2.fc27.x86_64 -> 3.12.3-1.fc27.x86_64
* glusterfs-fuse 3.12.1-2.fc27.x86_64 -> 3.12.3-1.fc27.x86_64
* glusterfs-libs 3.12.1-2.fc27.x86_64 -> 3.12.3-1.fc27.x86_64
* gnupg2 2.2.0-1.fc27.x86_64 -> 2.2.3-1.fc27.x86_64
* gnupg2-smime 2.2.0-1.fc27.x86_64 -> 2.2.3-1.fc27.x86_64
* gnutls 3.5.15-1.fc27.x86_64 -> 3.5.16-3.fc27.x86_64
* gperftools-libs 2.6.1-3.fc27.x86_64 -> 2.6.1-5.fc27.x86_64
* grub2-common 1:2.02-18.fc27.noarch -> 1:2.02-19.fc27.noarch
* grub2-efi-x64 1:2.02-18.fc27.x86_64 -> 1:2.02-19.fc27.x86_64
* grub2-pc 1:2.02-18.fc27.x86_64 -> 1:2.02-19.fc27.x86_64
* grub2-pc-modules 1:2.02-18.fc27.noarch -> 1:2.02-19.fc27.noarch
* grub2-tools 1:2.02-18.fc27.x86_64 -> 1:2.02-19.fc27.x86_64
* grub2-tools-extra 1:2.02-18.fc27.x86_64 -> 1:2.02-19.fc27.x86_64
* grub2-tools-minimal 1:2.02-18.fc27.x86_64 -> 1:2.02-19.fc27.x86_64
* gssproxy 0.7.0-12.fc27.x86_64 -> 0.7.0-24.fc27.x86_64
* ima-evm-utils 1.0-1.fc27.x86_64 -> 1.0-2.fc27.x86_64
* initscripts 9.77-1.fc27.x86_64 -> 9.78-1.fc27.x86_64
* iproute 4.12.0-3.fc27.x86_64 -> 4.13.0-1.fc27.x86_64
* iproute-tc 4.12.0-3.fc27.x86_64 -> 4.13.0-1.fc27.x86_64
* kernel 4.13.9-300.fc27.x86_64 -> 4.13.15-300.fc27.x86_64
* kernel-core 4.13.9-300.fc27.x86_64 -> 4.13.15-300.fc27.x86_64
* kernel-modules 4.13.9-300.fc27.x86_64 -> 4.13.15-300.fc27.x86_64
* kpartx 0.7.1-6.git847cc43.fc27.x86_64 -> 0.7.1-8.git847cc43.fc27.x86_64
* krb5-libs 1.15.2-2.fc27.x86_64 -> 1.15.2-4.fc27.x86_64
* libbasicobjects 0.1.1-33.fc27.x86_64 -> 0.1.1-36.fc27.x86_64
* libcollection 0.7.0-33.fc27.x86_64 -> 0.7.0-36.fc27.x86_64
* libcrypt-nss 2.26-15.fc27.x86_64 -> 2.26-16.fc27.x86_64
* libcurl 7.55.1-5.fc27.x86_64 -> 7.55.1-7.fc27.x86_64
* libini_config 1.3.0-33.fc27.x86_64 -> 1.3.1-36.fc27.x86_64
* libnfsidmap 0.27-3.fc27.x86_64 -> 1:2.2.1-1.rc1.fc27.x86_64
* libnl3 3.3.0-3.fc27.x86_64 -> 3.4.0-1.fc27.x86_64
* libnl3-cli 3.3.0-3.fc27.x86_64 -> 3.4.0-1.fc27.x86_64
* libpath_utils 0.2.1-33.fc27.x86_64 -> 0.2.1-36.fc27.x86_64
* libpkgconf 1.3.9-1.fc27.x86_64 -> 1.3.10-1.fc27.x86_64
* libref_array 0.1.5-33.fc27.x86_64 -> 0.1.5-36.fc27.x86_64
* libreport-filesystem 2.9.2-1.fc27.x86_64 -> 2.9.3-1.fc27.x86_64
* libsolv 0.6.29-2.fc27.x86_64 -> 0.6.30-2.fc27.x86_64
* libsss_idmap 1.15.3-5.fc27.x86_64 -> 1.16.0-2.fc27.x86_64
* libsss_nss_idmap 1.15.3-5.fc27.x86_64 -> 1.16.0-2.fc27.x86_64
* libsss_sudo 1.15.3-5.fc27.x86_64 -> 1.16.0-2.fc27.x86_64
* libtirpc 1.0.2-3.fc27.x86_64 -> 1.0.2-4.fc27.x86_64
* libunwind 1.2-3.fc27.x86_64 -> 1.2.1-3.fc27.x86_64
* libzstd 1.3.1-1.fc27.x86_64 -> 1.3.2-1.fc27.x86_64
* linux-firmware 20171009-78.gitbf04291.fc27.noarch -> 20171123-79.git90436ce.fc27.noarch
* lua-libs 5.3.4-5.fc27.x86_64 -> 5.3.4-6.fc27.x86_64
* lvm2 2.02.173-4.fc27.x86_64 -> 2.02.175-1.fc27.x86_64
* lvm2-libs 2.02.173-4.fc27.x86_64 -> 2.02.175-1.fc27.x86_64
* microcode_ctl 2:2.1-18.fc27.x86_64 -> 2:2.1-19.fc27.x86_64
* net-tools 2.0-0.44.20160912git.fc27.x86_64 -> 2.0-0.45.20160912git.fc27.x86_64
* nettle 3.3-5.fc27.x86_64 -> 3.4-1.fc27.x86_64
* nfs-utils 1:2.1.1-6.rc5.fc27.x86_64 -> 1:2.2.1-1.rc1.fc27.x86_64
* nss 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* nss-pem 1.0.3-5.fc27.x86_64 -> 1.0.3-6.fc27.x86_64
* nss-softokn 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* nss-softokn-freebl 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* nss-sysinit 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* nss-tools 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* nss-util 3.33.0-1.0.fc27.x86_64 -> 3.34.0-1.0.fc27.x86_64
* oci-umount 2:2.0.0-2.gitf90b64c.fc27.x86_64 -> 2:2.3.0-1.git51e7c50.fc27.x86_64
* openssl 1:1.1.0f-9.fc27.x86_64 -> 1:1.1.0g-1.fc27.x86_64
* openssl-libs 1:1.1.0f-9.fc27.x86_64 -> 1:1.1.0g-1.fc27.x86_64
* ostree 2017.12-2.fc27.x86_64 -> 2017.13-3.fc27.x86_64
* ostree-grub2 2017.12-2.fc27.x86_64 -> 2017.13-3.fc27.x86_64
* ostree-libs 2017.12-2.fc27.x86_64 -> 2017.13-3.fc27.x86_64
* p11-kit 0.23.8-1.fc27.x86_64 -> 0.23.9-2.fc27.x86_64
* p11-kit-trust 0.23.8-1.fc27.x86_64 -> 0.23.9-2.fc27.x86_64
* pcre 8.41-1.fc27.2.x86_64 -> 8.41-3.fc27.x86_64
* pcre2 10.30-1.fc27.x86_64 -> 10.30-2.fc27.x86_64
* pkgconf 1.3.9-1.fc27.x86_64 -> 1.3.10-1.fc27.x86_64
* pkgconf-m4 1.3.9-1.fc27.noarch -> 1.3.10-1.fc27.noarch
* pkgconf-pkg-config 1.3.9-1.fc27.x86_64 -> 1.3.10-1.fc27.x86_64
* publicsuffix-list-dafsa 20170828-1.fc27.noarch -> 20171028-1.fc27.noarch
* python2 2.7.13-17.fc27.x86_64 -> 2.7.14-2.fc27.x86_64
* python2-asn1crypto 0.22.0-4.fc27.noarch -> 0.23.0-1.fc27.noarch
* python2-cryptography 2.0.2-2.fc27.x86_64 -> 2.0.2-3.fc27.x86_64
* python2-libs 2.7.13-17.fc27.x86_64 -> 2.7.14-2.fc27.x86_64
* python3 3.6.2-13.fc27.x86_64 -> 3.6.3-2.fc27.x86_64
* python3-asn1crypto 0.22.0-4.fc27.noarch -> 0.23.0-1.fc27.noarch
* python3-cryptography 2.0.2-2.fc27.x86_64 -> 2.0.2-3.fc27.x86_64
* python3-docker 2.5.1-2.fc27.noarch -> 2.6.1-1.fc27.noarch
* python3-gobject-base 3.26.0-1.fc27.x86_64 -> 3.26.1-1.fc27.x86_64
* python3-libs 3.6.2-13.fc27.x86_64 -> 3.6.3-2.fc27.x86_64
* python3-sssdconfig 1.15.3-5.fc27.noarch -> 1.16.0-2.fc27.noarch
* rpm-ostree 2017.9-1.fc27.x86_64 -> 2017.10-2.fc27.x86_64
* rpm-ostree-libs 2017.9-1.fc27.x86_64 -> 2017.10-2.fc27.x86_64
* runc 1:1.0.1-3.gitc5ec254.fc27.x86_64 -> 2:1.0.0-11.rc4.gitaea4f21.fc27.x86_64
* screen 4.6.1-3.fc27.x86_64 -> 4.6.2-1.fc27.x86_64
* selinux-policy 3.13.1-283.14.fc27.noarch -> 3.13.1-283.17.fc27.noarch
* selinux-policy-targeted 3.13.1-283.14.fc27.noarch -> 3.13.1-283.17.fc27.noarch
* skopeo 0.1.23-6.git1bbd87f.fc27.x86_64 -> 0.1.26-1.git2e8377a.fc27.x86_64
* skopeo-containers 0.1.23-6.git1bbd87f.fc27.x86_64 -> 0.1.26-1.git2e8377a.fc27.x86_64
* sos 3.4-2.fc27.noarch -> 3.5-1.fc27.noarch
* sssd-client 1.15.3-5.fc27.x86_64 -> 1.16.0-2.fc27.x86_64
* strace 4.19-1.fc27.x86_64 -> 4.20-1.fc27.x86_64
* systemd 234-8.fc27.x86_64 -> 234-9.fc27.x86_64
* systemd-container 234-8.fc27.x86_64 -> 234-9.fc27.x86_64
* systemd-libs 234-8.fc27.x86_64 -> 234-9.fc27.x86_64
* systemd-pam 234-8.fc27.x86_64 -> 234-9.fc27.x86_64
* systemd-udev 234-8.fc27.x86_64 -> 234-9.fc27.x86_64
* tzdata 2017b-2.fc27.noarch -> 2017c-1.fc27.noarch
* vim-minimal 2:8.0.1176-1.fc27.x86_64 -> 2:8.0.1322-1.fc27.x86_64

Removed:

* python-backports-1.0-11.fc27.x86_64

Added:

* python2-backports-1.0-12.fc27.x86_64
* python3-pytoml-0.1.14-2.git7dea353.fc27.noarch

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 26 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](/blog/2017/11/fedora-atomic-26-to-27-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [aarch64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/Atomic/aarch64/iso/Fedora-Atomic-27-20171129.0-aarch64-CHECKSUM)
* [ppc64le ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/Atomic/ppc64le/iso/Fedora-Atomic-27-20171129.0-ppc64le-CHECKSUM)
* [x86_64 ISO](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/Atomic/x86_64/iso/Fedora-Atomic-27-20171129.0-x86_64-CHECKSUM)
* [aarch64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/CloudImages/aarch64/images/Fedora-CloudImages-27-20171129.0-aarch64-CHECKSUM)
* [ppc64le Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/CloudImages/ppc64le/images/Fedora-CloudImages-27-20171129.0-ppc64le-CHECKSUM)
* [x86_64 Cloud Image](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171129.0/CloudImages/x86_64/images/Fedora-CloudImages-27-20171129.0-x86_64-CHECKSUM)

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
