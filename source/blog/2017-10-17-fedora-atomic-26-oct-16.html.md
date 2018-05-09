---
title: Fedora 26 Atomic Host October 16 Release
author: jberkus
date: 2017-10-17 18:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: d518b37c348eb814093249f035ae852e7723840521b4bcb4a271a80b5988c44a
Version: 26.150
```

The most notable changes in this release are a new version of the kernel,
kubernetes, rpm-ostree and dnsmasq. The dnsmasq update fixes quite a few
CVEs.  Click through for a complete list.

READMORE

* [CVE-2017-14491](https://bugzilla.redhat.com/show_bug.cgi?id=1495409) dnsmasq: heap overflow in the code responsible for building DNS replies
* [CVE-2017-14492](https://bugzilla.redhat.com/show_bug.cgi?id=1495410) dnsmasq: heap overflow in the IPv6 router advertisement code
* [CVE-2017-14493](https://bugzilla.redhat.com/show_bug.cgi?id=1495411) dnsmasq: stack buffer overflow in the DHCPv6 code
* [CVE-2017-14494](https://bugzilla.redhat.com/show_bug.cgi?id=1495412) dnsmasq: information leak in the DHCPv6 relay code
* [CVE-2017-14495](https://bugzilla.redhat.com/show_bug.cgi?id=1495415) dnsmasq: memory exhaustion vulnerability in the EDNS0 code
* [CVE-2017-14496](https://bugzilla.redhat.com/show_bug.cgi?id=1495416) dnsmasq: integer underflow leading to buffer over-read in the EDNS0 code



READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 541abd650d1ffb3929e2ba8114436a0b04ee41da76a691af669dd037589a1421
* ostree diff commit new: d518b37c348eb814093249f035ae852e7723840521b4bcb4a271a80b5988c44a

Upgraded:

* GeoIP-GeoLite-data 2017.07-1.fc26.noarch -> 2017.10-1.fc26.noarch
* boost-iostreams 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* boost-program-options 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* boost-random 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* boost-regex 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* boost-system 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* boost-thread 1.63.0-8.fc26.x86_64 -> 1.63.0-9.fc26.x86_64
* cockpit-bridge 151-1.fc26.x86_64 -> 151-2.fc26.x86_64
* cockpit-docker 151-1.fc26.x86_64 -> 151-2.fc26.x86_64
* cockpit-networkmanager 151-1.fc26.noarch -> 151-2.fc26.noarch
* cockpit-ostree 151-1.fc26.x86_64 -> 151-2.fc26.x86_64
* cockpit-system 151-1.fc26.noarch -> 151-2.fc26.noarch
* container-storage-setup 0.7.0-1.git4ca59c5.fc26.noarch -> 0.8.0-1.git1d27ecf.fc26.noarch
* criu 3.3-2.fc26.x86_64 -> 3.5-1.fc26.x86_64
* dnsmasq 2.76-3.fc26.x86_64 -> 2.76-5.fc26.x86_64
* kernel 4.12.14-300.fc26.x86_64 -> 4.13.5-200.fc26.x86_64
* kernel-core 4.12.14-300.fc26.x86_64 -> 4.13.5-200.fc26.x86_64
* kernel-modules 4.12.14-300.fc26.x86_64 -> 4.13.5-200.fc26.x86_64
* kubernetes 1.6.7-1.fc26.x86_64 -> 1.7.3-1.fc26.x86_64
* kubernetes-client 1.6.7-1.fc26.x86_64 -> 1.7.3-1.fc26.x86_64
* kubernetes-master 1.6.7-1.fc26.x86_64 -> 1.7.3-1.fc26.x86_64
* kubernetes-node 1.6.7-1.fc26.x86_64 -> 1.7.3-1.fc26.x86_64
* nspr 4.16.0-1.fc26.x86_64 -> 4.17.0-1.fc26.x86_64
* nss 3.32.1-1.0.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* nss-softokn 3.32.0-1.2.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* nss-softokn-freebl 3.32.0-1.2.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* nss-sysinit 3.32.1-1.0.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* nss-tools 3.32.1-1.0.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* nss-util 3.32.0-1.0.fc26.x86_64 -> 3.33.0-1.0.fc26.x86_64
* python3 3.6.2-7.fc26.x86_64 -> 3.6.2-8.fc26.x86_64
* python3-libs 3.6.2-7.fc26.x86_64 -> 3.6.2-8.fc26.x86_64
* rpm-ostree 2017.8-2.fc26.x86_64 -> 2017.9-1.fc26.x86_64
* rpm-ostree-libs 2017.8-2.fc26.x86_64 -> 2017.9-1.fc26.x86_64
* sudo 1.8.20p2-1.fc26.x86_64 -> 1.8.21p2-1.fc26.x86_64
* system-python 3.6.2-7.fc26.x86_64 -> 3.6.2-8.fc26.x86_64
* system-python-libs 3.6.2-7.fc26.x86_64 -> 3.6.2-8.fc26.x86_64
* vim-minimal 2:8.0.1097-1.fc26.x86_64 -> 2:8.0.1176-1.fc26.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](http://www.projectatomic.io/blog/2017/08/fedora-atomic-25-to-26-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksums](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171016.0/CloudImages/x86_64/images/Fedora-CloudImages-26-20171016.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171016.0/Atomic/x86_64/iso/Fedora-Atomic-26-20171016.0-x86_64-CHECKSUM)

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
* [Fedora Atomic Host 26](https://app.vagrantup.com/fedora/boxes/26-atomic-host/versions/26.20170905.0)

To provision using vagrant:

```
vagrant init fedora/26-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/26-atomic-host
```
