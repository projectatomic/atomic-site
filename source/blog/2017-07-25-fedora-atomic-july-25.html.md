---
title: Fedora Atomic 26 July 25 Release
author: dustymabe
date: 2017-07-25 16:00:00 UTC
published: true
comments: true
tags: atomic, fedora, kubernetes
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: 0715ce81064c30d34ed52ef811a3ad5e5d6a34da980bf35b19312489b32d9b83
Version: 26.91
```

This is the second release for Fedora 26 Atomic Host. This contains a newer version of Kubernetes with fixes for the bug that was in the
original release of the Fedora Atomic 26 tree.

Users of built-in Kubernetes on Fedora Atomic Host can now rebase onto the version 26 ref.  We will be releasing a few blogs shortly about upgrading your existing hosts.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 2e4fcaff52c18cf705a2ecfa47d2ca60958f7443177974f24cc9ce07494b3317
* ostree diff commit new: 0715ce81064c30d34ed52ef811a3ad5e5d6a34da980bf35b19312489b32d9b83

Upgraded:

* NetworkManager 1:1.8.0-6.fc26.x86_64 -> 1:1.8.2-1.fc26.x86_64
* NetworkManager-libnm 1:1.8.0-6.fc26.x86_64 -> 1:1.8.2-1.fc26.x86_64
* NetworkManager-team 1:1.8.0-6.fc26.x86_64 -> 1:1.8.2-1.fc26.x86_64
* authconfig 7.0.1-1.fc26.x86_64 -> 7.0.1-2.fc26.x86_64
* bash 4.4.12-5.fc26.x86_64 -> 4.4.12-6.fc26.x86_64
* bash-completion 1:2.5-2.fc26.noarch -> 1:2.6-1.fc26.noarch
* bind99-libs 9.9.9-5.P8.fc26.x86_64 -> 9.9.10-1.P2.fc26.x86_64
* bind99-license 9.9.9-5.P8.fc26.noarch -> 9.9.10-1.P2.fc26.noarch
* container-selinux 2:2.19-1.fc26.noarch -> 2:2.20-2.fc26.noarch
* container-storage-setup 0.5.0-1.git9b77bcb.fc26.noarch -> 0.6.0-1.giteb688d4.fc26.noarch
* criu 3.0-1.fc26.x86_64 -> 3.2.1-2.fc26.x86_64
* curl 7.53.1-7.fc26.x86_64 -> 7.53.1-8.fc26.x86_64
* dbus 1:1.11.12-1.fc26.x86_64 -> 1:1.11.14-1.fc26.x86_64
* dbus-libs 1:1.11.12-1.fc26.x86_64 -> 1:1.11.14-1.fc26.x86_64
* dhcp-client 12:4.3.5-6.fc26.x86_64 -> 12:4.3.5-7.fc26.x86_64
* dhcp-common 12:4.3.5-6.fc26.noarch -> 12:4.3.5-7.fc26.noarch
* dhcp-libs 12:4.3.5-6.fc26.x86_64 -> 12:4.3.5-7.fc26.x86_64
* efibootmgr 14-3.fc26.x86_64 -> 15-1.fc26.x86_64
* efivar-libs 30-4.fc26.x86_64 -> 31-1.fc26.x86_64
* emacs-filesystem 1:25.2-2.fc26.noarch -> 1:25.2-3.fc26.noarch
* expat 2.2.0-2.fc26.x86_64 -> 2.2.1-1.fc26.x86_64
* glibc 2.25-6.fc26.x86_64 -> 2.25-7.fc26.x86_64
* glibc-all-langpacks 2.25-6.fc26.x86_64 -> 2.25-7.fc26.x86_64
* glibc-common 2.25-6.fc26.x86_64 -> 2.25-7.fc26.x86_64
* glusterfs 3.10.3-1.fc26.x86_64 -> 3.10.4-1.fc26.x86_64
* glusterfs-client-xlators 3.10.3-1.fc26.x86_64 -> 3.10.4-1.fc26.x86_64
* glusterfs-fuse 3.10.3-1.fc26.x86_64 -> 3.10.4-1.fc26.x86_64
* glusterfs-libs 3.10.3-1.fc26.x86_64 -> 3.10.4-1.fc26.x86_64
* gnutls 3.5.13-1.fc26.x86_64 -> 3.5.14-1.fc26.x86_64
* grep 3.0-1.fc26.x86_64 -> 3.1-1.fc26.x86_64
* kernel 4.11.8-300.fc26.x86_64 -> 4.11.11-300.fc26.x86_64
* kernel-core 4.11.8-300.fc26.x86_64 -> 4.11.11-300.fc26.x86_64
* kernel-modules 4.11.8-300.fc26.x86_64 -> 4.11.11-300.fc26.x86_64
* krb5-libs 1.15.1-8.fc26.x86_64 -> 1.15.1-15.fc26.x86_64
* kubernetes 1.5.3-1.fc26.x86_64 -> 1.6.7-1.fc26.x86_64
* kubernetes-client 1.5.3-1.fc26.x86_64 -> 1.6.7-1.fc26.x86_64
* kubernetes-master 1.5.3-1.fc26.x86_64 -> 1.6.7-1.fc26.x86_64
* kubernetes-node 1.5.3-1.fc26.x86_64 -> 1.6.7-1.fc26.x86_64
* libblkid 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* libcrypt-nss 2.25-6.fc26.x86_64 -> 2.25-7.fc26.x86_64
* libcurl 7.53.1-7.fc26.x86_64 -> 7.53.1-8.fc26.x86_64
* libdb 5.3.28-21.fc26.x86_64 -> 5.3.28-24.fc26.x86_64
* libdb-utils 5.3.28-21.fc26.x86_64 -> 5.3.28-24.fc26.x86_64
* libfdisk 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* libffi 3.1-11.fc26.x86_64 -> 3.1-12.fc26.x86_64
* libgcrypt 1.7.7-1.fc26.x86_64 -> 1.7.8-1.fc26.x86_64
* libmount 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* libpkgconf 1.3.7-1.fc26.x86_64 -> 1.3.8-1.fc26.x86_64
* libproxy 0.4.15-1.fc26.x86_64 -> 0.4.15-2.fc26.x86_64
* libsmartcols 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* libsolv 0.6.27-2.fc26.x86_64 -> 0.6.28-1.fc26.x86_64
* libtirpc 1.0.1-4.rc3.fc26.x86_64 -> 1.0.2-0.fc26.x86_64
* libtomcrypt 1.17-30.fc26.x86_64 -> 1.17-31.20160123git912eff4.fc26.x86_64
* libtommath 1.0-5.fc26.x86_64 -> 1.0-8.fc26.x86_64
* libuuid 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* lz4-libs 1.7.5-3.fc26.x86_64 -> 1.7.5-4.fc26.x86_64
* mokutil 1:0.3.0-4.fc26.x86_64 -> 1:0.3.0-5.fc26.x86_64
* nmap-ncat 2:7.40-2.fc26.x86_64 -> 2:7.40-5.fc26.x86_64
* oci-register-machine 0-3.7.gitbb20b00.fc26.x86_64 -> 0-3.8.gitbf6b0f2.fc26.x86_64
* oci-systemd-hook 1:0.1.7-1.git1788cf2.fc26.x86_64 -> 1:0.1.11-1.git1ac958a.fc26.x86_64
* openldap 2.4.44-10.fc26.x86_64 -> 2.4.45-1.fc26.x86_64
* openssh 7.5p1-2.fc26.x86_64 -> 7.5p1-3.fc26.x86_64
* openssh-clients 7.5p1-2.fc26.x86_64 -> 7.5p1-3.fc26.x86_64
* openssh-server 7.5p1-2.fc26.x86_64 -> 7.5p1-3.fc26.x86_64
* openssl 1:1.1.0f-4.fc26.x86_64 -> 1:1.1.0f-7.fc26.x86_64
* openssl-libs 1:1.1.0f-4.fc26.x86_64 -> 1:1.1.0f-7.fc26.x86_64
* ostree 2017.7-2.fc26.x86_64 -> 2017.8-3.fc26.x86_64
* ostree-grub2 2017.7-2.fc26.x86_64 -> 2017.8-3.fc26.x86_64
* ostree-libs 2017.7-2.fc26.x86_64 -> 2017.8-3.fc26.x86_64
* pcre 8.40-7.fc26.x86_64 -> 8.41-1.fc26.x86_64
* pkgconf 1.3.7-1.fc26.x86_64 -> 1.3.8-1.fc26.x86_64
* pkgconf-m4 1.3.7-1.fc26.noarch -> 1.3.8-1.fc26.noarch
* pkgconf-pkg-config 1.3.7-1.fc26.x86_64 -> 1.3.8-1.fc26.x86_64
* python2 2.7.13-10.fc26.x86_64 -> 2.7.13-11.fc26.x86_64
* python2-libs 2.7.13-10.fc26.x86_64 -> 2.7.13-11.fc26.x86_64
* python2-setuptools 36.0.1-1.fc26.noarch -> 36.2.0-1.fc26.noarch
* python2-six 1.10.0-8.fc26.noarch -> 1.10.0-9.fc26.noarch
* python3 3.6.1-8.fc26.x86_64 -> 3.6.2-1.fc26.x86_64
* python3-docker 2.3.0-1.fc26.noarch -> 2.4.2-1.fc26.noarch
* python3-libs 3.6.1-8.fc26.x86_64 -> 3.6.2-1.fc26.x86_64
* python3-rpm 4.13.0.1-4.fc26.x86_64 -> 4.13.0.1-5.fc26.x86_64
* python3-setuptools 36.0.1-1.fc26.noarch -> 36.2.0-1.fc26.noarch
* python3-six 1.10.0-8.fc26.noarch -> 1.10.0-9.fc26.noarch
* quota 1:4.03-8.fc26.x86_64 -> 1:4.03-9.fc26.x86_64
* quota-nls 1:4.03-8.fc26.noarch -> 1:4.03-9.fc26.noarch
* rpm 4.13.0.1-4.fc26.x86_64 -> 4.13.0.1-5.fc26.x86_64
* rpm-build-libs 4.13.0.1-4.fc26.x86_64 -> 4.13.0.1-5.fc26.x86_64
* rpm-libs 4.13.0.1-4.fc26.x86_64 -> 4.13.0.1-5.fc26.x86_64
* rpm-plugin-selinux 4.13.0.1-4.fc26.x86_64 -> 4.13.0.1-5.fc26.x86_64
* rsync 3.1.2-4.fc26.x86_64 -> 3.1.2-5.fc26.x86_64
* screen 4.5.1-2.fc26.x86_64 -> 4.6.1-1.fc26.x86_64
* selinux-policy 3.13.1-259.fc26.noarch -> 3.13.1-260.1.fc26.noarch
* selinux-policy-targeted 3.13.1-259.fc26.noarch -> 3.13.1-260.1.fc26.noarch
* skopeo 0.1.19-1.dev.git0224d8c.fc26.x86_64 -> 0.1.22-1.git5d24b67.fc26.x86_64
* skopeo-containers 0.1.19-1.dev.git0224d8c.fc26.x86_64 -> 0.1.22-1.git5d24b67.fc26.x86_64
* sqlite-libs 3.19.1-1.fc26.x86_64 -> 3.19.3-1.fc26.x86_64
* strace 4.17-1.fc26.x86_64 -> 4.18-1.fc26.x86_64
* system-python 3.6.1-8.fc26.x86_64 -> 3.6.2-1.fc26.x86_64
* system-python-libs 3.6.1-8.fc26.x86_64 -> 3.6.2-1.fc26.x86_64
* tar 2:1.29-4.fc26.x86_64 -> 2:1.29-5.fc26.x86_64
* util-linux 2.29.1-2.fc26.x86_64 -> 2.30.1-1.fc26.x86_64
* vim-minimal 2:8.0.662-1.fc26.x86_64 -> 2:8.0.728-1.fc26.x86_64

Removed:

* libsoup-2.58.1-1.fc26.x86_64

Added:

* compat-openssl10-1:1.0.2j-6.fc26.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`, or wait for more detailed instructions in an upcoming blog post.

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170723.0/Atomic/x86_64/iso/Fedora-Atomic-26-20170723.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170723.0/Atomic/x86_64/iso/Fedora-Atomic-26-20170723.0-x86_64-CHECKSUM)

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
Cloud Wiki space](https://fedoraproject.org/wiki/Cloud#Quick_Links).

The Vagrant Cloud page with the new atomic host:

* [All Fedora boxes](https://app.vagrantup.com/fedora/)
* [Fedora Atomic 26](https://app.vagrantup.com/fedora/boxes/26-atomic-host/versions/26.20170723.0)


```
vagrant init fedora/26-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/26-atomic-host
```
