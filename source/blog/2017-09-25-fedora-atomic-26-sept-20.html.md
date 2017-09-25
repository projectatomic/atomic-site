---
title: Fedora 26 Atomic Host September 20 Release
author: jberkus
date: 2017-09-25 18:00:00 UTC
published: true
comments: false
tags: atomic, fedora
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 98088cb6ed2a4b3f7e4e7bf6d34f9e137c296bc43640b4c1967631f22fe1802f
Version: 26.131
```

This release mostly includes routine updates to packages.  Highlighted updates include a new kernel, runc, and container-storage-setup.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 0b0127864022dd6ffad1a183241fbd5482ef5a1642ff3c8751c2e6cae6070b1a
* ostree diff commit new: 98088cb6ed2a4b3f7e4e7bf6d34f9e137c296bc43640b4c1967631f22fe1802f

Upgraded:

* boost-iostreams 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* boost-program-options 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* boost-random 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* boost-regex 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* boost-system 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* boost-thread 1.63.0-6.fc26.x86_64 -> 1.63.0-7.fc26.x86_64
* cockpit-bridge 147-1.fc26.x86_64 -> 150-1.fc26.x86_64
* cockpit-docker 147-1.fc26.x86_64 -> 150-1.fc26.x86_64
* cockpit-networkmanager 147-1.fc26.noarch -> 150-1.fc26.noarch
* cockpit-ostree 147-1.fc26.x86_64 -> 150-1.fc26.x86_64
* cockpit-system 147-1.fc26.noarch -> 150-1.fc26.noarch
* container-selinux 2:2.21-1.fc26.noarch -> 2:2.22-1.fc26.noarch
* container-storage-setup 0.6.0-1.giteb688d4.fc26.noarch -> 0.7.0-1.git4ca59c5.fc26.noarch
* emacs-filesystem 1:25.2-3.fc26.noarch -> 1:25.3-3.fc26.noarch
* file 5.30-10.fc26.x86_64 -> 5.30-11.fc26.x86_64
* file-libs 5.30-10.fc26.x86_64 -> 5.30-11.fc26.x86_64
* gawk 4.1.4-3.fc26.x86_64 -> 4.1.4-5.fc26.x86_64
* gnupg2 2.1.22-1.fc26.x86_64 -> 2.2.0-1.fc26.x86_64
* gnupg2-smime 2.1.22-1.fc26.x86_64 -> 2.2.0-1.fc26.x86_64
* gnutls 3.5.14-1.fc26.x86_64 -> 3.5.15-1.fc26.x86_64
* kernel 4.12.9-300.fc26.x86_64 -> 4.12.13-300.fc26.x86_64
* kernel-core 4.12.9-300.fc26.x86_64 -> 4.12.13-300.fc26.x86_64
* kernel-modules 4.12.9-300.fc26.x86_64 -> 4.12.13-300.fc26.x86_64
* krb5-libs 1.15.1-25.fc26.x86_64 -> 1.15.1-28.fc26.x86_64
* libgcc 7.1.1-3.fc26.x86_64 -> 7.2.1-2.fc26.x86_64
* libgomp 7.1.1-3.fc26.x86_64 -> 7.2.1-2.fc26.x86_64
* libsolv 0.6.28-5.fc26.x86_64 -> 0.6.29-1.fc26.x86_64
* libsss_idmap 1.15.3-1.fc26.x86_64 -> 1.15.3-3.fc26.x86_64
* libsss_nss_idmap 1.15.3-1.fc26.x86_64 -> 1.15.3-3.fc26.x86_64
* libsss_sudo 1.15.3-1.fc26.x86_64 -> 1.15.3-3.fc26.x86_64
* libstdc++ 7.1.1-3.fc26.x86_64 -> 7.2.1-2.fc26.x86_64
* linux-firmware 20170622-75.gita3a26af2.fc26.noarch -> 20170828-76.gitb78acc9.fc26.noarch
* publicsuffix-list-dafsa 20170809-1.fc26.noarch -> 20170828-1.fc26.noarch
* python2 2.7.13-11.fc26.x86_64 -> 2.7.13-12.fc26.x86_64
* python2-libs 2.7.13-11.fc26.x86_64 -> 2.7.13-12.fc26.x86_64
* python2-pyOpenSSL 16.2.0-4.fc26.noarch -> 16.2.0-5.fc26.noarch
* python2-pysocks 1.5.7-4.fc26.noarch -> 1.6.7-1.fc26.noarch
* python3-docker 2.4.2-3.fc26.noarch -> 2.5.1-1.fc26.noarch
* python3-pyOpenSSL 16.2.0-4.fc26.noarch -> 16.2.0-5.fc26.noarch
* python3-pysocks 1.5.7-4.fc26.noarch -> 1.6.7-1.fc26.noarch
* python3-sssdconfig 1.15.3-1.fc26.noarch -> 1.15.3-3.fc26.noarch
* rpcbind 0.2.4-7.rc2.fc26.x86_64 -> 0.2.4-8.rc2.fc26.x86_64
* runc 1:1.0.1-1.gitc5ec254.fc26.x86_64 -> 2:1.0.0-10.rc4.gitaea4f21.fc26.x86_64
* setools-console 4.1.0-3.fc26.x86_64 -> 4.1.0-5.fc26.x86_64
* setools-python 4.1.0-3.fc26.x86_64 -> 4.1.0-5.fc26.x86_64
* setools-python3 4.1.0-3.fc26.x86_64 -> 4.1.0-5.fc26.x86_64
* sssd-client 1.15.3-1.fc26.x86_64 -> 1.15.3-3.fc26.x86_64
* strace 4.18-1.fc26.x86_64 -> 4.19-1.fc26.x86_64
* vim-minimal 2:8.0.1030-1.fc26.x86_64 -> 2:8.0.1097-1.fc26.x86_64
* xkeyboard-config 2.21-1.fc26.noarch -> 2.21-3.fc26.noarch


Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](http://www.projectatomic.io/blog/2017/08/fedora-atomic-25-to-26-upgrade/)
for more details.

Corresponding image media for new installations can be
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksums](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170920.0/Atomic/x86_64/iso/Fedora-Atomic-26-20170920.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170920.0/CloudImages/x86_64/images/Fedora-CloudImages-26-20170920.0-x86_64-CHECKSUM)

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
