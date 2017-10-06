---
title: Fedora 26 Atomic Host October 5 Release
author: jberkus
date: 2017-10-05 21:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 541abd650d1ffb3929e2ba8114436a0b04ee41da76a691af669dd037589a1421
Version: 26.141
```

A couple of notes about this release:

- This release does not include fixes for the dnsmasq security
  vulnerabilities. Please help us test out the patched rpms by
  rebasing to our testing tree:

```
    rpm-ostree rebase fedora/26/x86_64/testing/atomic-host
```

- During testing for this release we found [an isolated hardware
  issue](https://pagure.io/atomic-wg/issue/345). This mostly affects the minnowboard hardware platform.



READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 98088cb6ed2a4b3f7e4e7bf6d34f9e137c296bc43640b4c1967631f22fe1802f
* ostree diff commit new: 541abd650d1ffb3929e2ba8114436a0b04ee41da76a691af669dd037589a1421

Upgraded:

* audit 2.7.7-1.fc26.x86_64 -> 2.7.8-1.fc26.x86_64
* audit-libs 2.7.7-1.fc26.x86_64 -> 2.7.8-1.fc26.x86_64
* audit-libs-python 2.7.7-1.fc26.x86_64 -> 2.7.8-1.fc26.x86_64
* audit-libs-python3 2.7.7-1.fc26.x86_64 -> 2.7.8-1.fc26.x86_64
* boost-iostreams 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* boost-program-options 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* boost-random 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* boost-regex 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* boost-system 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* boost-thread 1.63.0-7.fc26.x86_64 -> 1.63.0-8.fc26.x86_64
* cockpit-bridge 150-1.fc26.x86_64 -> 151-1.fc26.x86_64
* cockpit-docker 150-1.fc26.x86_64 -> 151-1.fc26.x86_64
* cockpit-networkmanager 150-1.fc26.noarch -> 151-1.fc26.noarch
* cockpit-ostree 150-1.fc26.x86_64 -> 151-1.fc26.x86_64
* cockpit-system 150-1.fc26.noarch -> 151-1.fc26.noarch
* container-selinux 2:2.22-1.fc26.noarch -> 2:2.24-1.fc26.noarch
* dbus 1:1.11.16-1.fc26.x86_64 -> 1:1.11.18-1.fc26.x86_64
* dbus-libs 1:1.11.16-1.fc26.x86_64 -> 1:1.11.18-1.fc26.x86_64
* etcd 3.1.3-1.fc26.x86_64 -> 3.1.9-1.fc26.x86_64
* gsettings-desktop-schemas 3.24.0-1.fc26.x86_64 -> 3.24.1-1.fc26.x86_64
* kernel 4.12.13-300.fc26.x86_64 -> 4.12.14-300.fc26.x86_64
* kernel-core 4.12.13-300.fc26.x86_64 -> 4.12.14-300.fc26.x86_64
* kernel-modules 4.12.13-300.fc26.x86_64 -> 4.12.14-300.fc26.x86_64
* libblkid 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64
* libfdisk 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64
* libmount 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64
* libpkgconf 1.3.8-1.fc26.x86_64 -> 1.3.9-1.fc26.x86_64
* libreport-filesystem 2.9.1-2.fc26.x86_64 -> 2.9.1-3.fc26.x86_64
* libsmartcols 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64
* libsolv 0.6.29-1.fc26.x86_64 -> 0.6.29-2.fc26.x86_64
* libssh2 1.8.0-2.fc26.x86_64 -> 1.8.0-5.fc26.x86_64
* libsss_idmap 1.15.3-3.fc26.x86_64 -> 1.15.3-4.fc26.x86_64
* libsss_nss_idmap 1.15.3-3.fc26.x86_64 -> 1.15.3-4.fc26.x86_64
* libsss_sudo 1.15.3-3.fc26.x86_64 -> 1.15.3-4.fc26.x86_64
* libuuid 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64
* linux-firmware 20170828-76.gitb78acc9.fc26.noarch -> 20170828-77.gitb78acc9.fc26.noarch
* nss 3.32.0-1.1.fc26.x86_64 -> 3.32.1-1.0.fc26.x86_64
* nss-sysinit 3.32.0-1.1.fc26.x86_64 -> 3.32.1-1.0.fc26.x86_64
* nss-tools 3.32.0-1.1.fc26.x86_64 -> 3.32.1-1.0.fc26.x86_64
* oci-register-machine 0-3.10.gitcbf1b8f.fc26.x86_64 -> 0-5.11.gitcd1e331.fc26.x86_64
* ostree 2017.10-2.fc26.x86_64 -> 2017.11-1.fc26.x86_64
* ostree-grub2 2017.10-2.fc26.x86_64 -> 2017.11-1.fc26.x86_64
* ostree-libs 2017.10-2.fc26.x86_64 -> 2017.11-1.fc26.x86_64
* pkgconf 1.3.8-1.fc26.x86_64 -> 1.3.9-1.fc26.x86_64
* pkgconf-m4 1.3.8-1.fc26.noarch -> 1.3.9-1.fc26.noarch
* pkgconf-pkg-config 1.3.8-1.fc26.x86_64 -> 1.3.9-1.fc26.x86_64
* python2-pyOpenSSL 16.2.0-5.fc26.noarch -> 16.2.0-6.fc26.noarch
* python3 3.6.2-5.fc26.x86_64 -> 3.6.2-7.fc26.x86_64
* python3-docker 2.5.1-1.fc26.noarch -> 2.5.1-2.fc26.noarch
* python3-libs 3.6.2-5.fc26.x86_64 -> 3.6.2-7.fc26.x86_64
* python3-pyOpenSSL 16.2.0-5.fc26.noarch -> 16.2.0-6.fc26.noarch
* python3-sssdconfig 1.15.3-3.fc26.noarch -> 1.15.3-4.fc26.noarch
* selinux-policy 3.13.1-260.8.fc26.noarch -> 3.13.1-260.10.fc26.noarch
* selinux-policy-targeted 3.13.1-260.8.fc26.noarch -> 3.13.1-260.10.fc26.noarch
* sssd-client 1.15.3-3.fc26.x86_64 -> 1.15.3-4.fc26.x86_64
* system-python 3.6.2-5.fc26.x86_64 -> 3.6.2-7.fc26.x86_64
* system-python-libs 3.6.2-5.fc26.x86_64 -> 3.6.2-7.fc26.x86_64
* util-linux 2.30.1-1.fc26.x86_64 -> 2.30.2-1.fc26.x86_64

Removed:

* compat-openssl10-1:1.0.2j-9.fc26.x86_64

Added:

* libsoup-2.58.2-1.fc26.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](http://www.projectatomic.io/blog/2017/08/fedora-atomic-25-to-26-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksums](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171003.0/CloudImages/x86_64/images/Fedora-CloudImages-26-20171003.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20171003.0/Atomic/x86_64/iso/Fedora-Atomic-26-20171003.0-x86_64-CHECKSUM)

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
