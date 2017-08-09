---
title: Fedora 26 Atomic Host August 08 Release
author: dustymabe
date: 2017-08-09 22:00:00 UTC
published: true
comments: true
tags: atomic, fedora, kubernetes
---

A new Fedora Atomic Host update is available via an OSTree commit:

```
Commit: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6
Version: 26.101
```

In this release we have fixed [an issue](https://pagure.io/atomic-wg/issue/307)
with our qcow and vagrant images from the 20170723 images. If you used the qcow 
or vagrant images from that release then please make sure you are
following the `fedora/26/x86_64/atomic-host` ref. See [this](https://pagure.io/atomic-wg/issue/307)
Atomic Working Group issue for more details.

READMORE

The diff between this and the previous released version is:

* ostree diff commit old: 0715ce81064c30d34ed52ef811a3ad5e5d6a34da980bf35b19312489b32d9b83
* ostree diff commit new: f6331bcd14577e0ee43db3ba5a44e0f63f74a86e3955604c20542df0b7ad8ad6

Upgraded:

* GeoIP-GeoLite-data 2017.06-1.fc26.noarch -> 2017.07-1.fc26.noarch
* cockpit-bridge 143-1.fc26.x86_64 -> 147-1.fc26.x86_64
* cockpit-docker 143-1.fc26.x86_64 -> 147-1.fc26.x86_64
* cockpit-networkmanager 143-1.fc26.noarch -> 147-1.fc26.noarch
* cockpit-ostree 143-1.fc26.x86_64 -> 147-1.fc26.x86_64
* cockpit-system 143-1.fc26.noarch -> 147-1.fc26.noarch
* container-selinux 2:2.20-2.fc26.noarch -> 2:2.21-1.fc26.noarch
* criu 3.2.1-2.fc26.x86_64 -> 3.3-2.fc26.x86_64
* curl 7.53.1-8.fc26.x86_64 -> 7.53.1-9.fc26.x86_64
* dbus 1:1.11.14-1.fc26.x86_64 -> 1:1.11.16-1.fc26.x86_64
* dbus-libs 1:1.11.14-1.fc26.x86_64 -> 1:1.11.16-1.fc26.x86_64
* dhcp-client 12:4.3.5-7.fc26.x86_64 -> 12:4.3.5-9.fc26.x86_64
* dhcp-common 12:4.3.5-7.fc26.noarch -> 12:4.3.5-9.fc26.noarch
* dhcp-libs 12:4.3.5-7.fc26.x86_64 -> 12:4.3.5-9.fc26.x86_64
* file 5.30-6.fc26.x86_64 -> 5.30-8.fc26.x86_64
* file-libs 5.30-6.fc26.x86_64 -> 5.30-8.fc26.x86_64
* glusterfs 3.10.4-1.fc26.x86_64 -> 3.10.4-2.fc26.x86_64
* glusterfs-client-xlators 3.10.4-1.fc26.x86_64 -> 3.10.4-2.fc26.x86_64
* glusterfs-fuse 3.10.4-1.fc26.x86_64 -> 3.10.4-2.fc26.x86_64
* glusterfs-libs 3.10.4-1.fc26.x86_64 -> 3.10.4-2.fc26.x86_64
* gnupg 1.4.21-2.fc26.x86_64 -> 1.4.22-1.fc26.x86_64
* gomtree 0.3.1-1.fc26.x86_64 -> 0.4.0-1.fc26.x86_64
* iputils 20161105-2.fc26.x86_64 -> 20161105-5.fc26.x86_64
* krb5-libs 1.15.1-15.fc26.x86_64 -> 1.15.1-17.fc26.x86_64
* libcurl 7.53.1-8.fc26.x86_64 -> 7.53.1-9.fc26.x86_64
* libidn2 2.0.2-1.fc26.x86_64 -> 2.0.3-1.fc26.x86_64
* libselinux 2.6-6.fc26.x86_64 -> 2.6-7.fc26.x86_64
* libselinux-python 2.6-6.fc26.x86_64 -> 2.6-7.fc26.x86_64
* libselinux-python3 2.6-6.fc26.x86_64 -> 2.6-7.fc26.x86_64
* libselinux-utils 2.6-6.fc26.x86_64 -> 2.6-7.fc26.x86_64
* libsepol 2.6-1.fc26.x86_64 -> 2.6-2.fc26.x86_64
* libsolv 0.6.28-1.fc26.x86_64 -> 0.6.28-5.fc26.x86_64
* libsss_idmap 1.15.2-5.fc26.x86_64 -> 1.15.3-1.fc26.x86_64
* libsss_nss_idmap 1.15.2-5.fc26.x86_64 -> 1.15.3-1.fc26.x86_64
* libsss_sudo 1.15.2-5.fc26.x86_64 -> 1.15.3-1.fc26.x86_64
* nfs-utils 1:2.1.1-5.rc4.fc26.x86_64 -> 1:2.1.1-5.rc5.fc26.x86_64
* nmap-ncat 2:7.40-5.fc26.x86_64 -> 2:7.40-7.fc26.x86_64
* nspr 4.14.0-2.fc26.x86_64 -> 4.15.0-1.fc26.x86_64
* nss 3.30.2-1.1.fc26.x86_64 -> 3.31.0-1.1.fc26.x86_64
* nss-softokn 3.30.2-1.0.fc26.x86_64 -> 3.31.0-1.0.fc26.x86_64
* nss-softokn-freebl 3.30.2-1.0.fc26.x86_64 -> 3.31.0-1.0.fc26.x86_64
* nss-sysinit 3.30.2-1.1.fc26.x86_64 -> 3.31.0-1.1.fc26.x86_64
* nss-tools 3.30.2-1.1.fc26.x86_64 -> 3.31.0-1.1.fc26.x86_64
* nss-util 3.30.2-1.0.fc26.x86_64 -> 3.31.0-1.0.fc26.x86_64
* oci-register-machine 0-3.8.gitbf6b0f2.fc26.x86_64 -> 0-3.10.gitcbf1b8f.fc26.x86_64
* ostree 2017.8-3.fc26.x86_64 -> 2017.9-2.fc26.x86_64
* ostree-grub2 2017.8-3.fc26.x86_64 -> 2017.9-2.fc26.x86_64
* ostree-libs 2017.8-3.fc26.x86_64 -> 2017.9-2.fc26.x86_64
* pcre2 10.23-8.fc26.x86_64 -> 10.23-9.fc26.x86_64
* policycoreutils 2.6-5.fc26.x86_64 -> 2.6-6.fc26.x86_64
* policycoreutils-python 2.6-5.fc26.x86_64 -> 2.6-6.fc26.x86_64
* policycoreutils-python-utils 2.6-5.fc26.x86_64 -> 2.6-6.fc26.x86_64
* policycoreutils-python3 2.6-5.fc26.x86_64 -> 2.6-6.fc26.x86_64
* python3-sssdconfig 1.15.2-5.fc26.noarch -> 1.15.3-1.fc26.noarch
* rpm-ostree 2017.6-3.fc26.x86_64 -> 2017.7-1.fc26.x86_64
* runc 1:1.0.0-9.git6394544.fc26.x86_64 -> 1:1.0.1-1.gitc5ec254.fc26.x86_64
* selinux-policy 3.13.1-260.1.fc26.noarch -> 3.13.1-260.3.fc26.noarch
* selinux-policy-targeted 3.13.1-260.1.fc26.noarch -> 3.13.1-260.3.fc26.noarch
* skopeo 0.1.22-1.git5d24b67.fc26.x86_64 -> 0.1.23-2.git1bbd87f.fc26.x86_64
* skopeo-containers 0.1.22-1.git5d24b67.fc26.x86_64 -> 0.1.23-2.git1bbd87f.fc26.x86_64
* sssd-client 1.15.2-5.fc26.x86_64 -> 1.15.3-1.fc26.x86_64
* tmux 2.3-2.fc26.x86_64 -> 2.5-1.fc26.x86_64
* vim-minimal 2:8.0.728-1.fc26.x86_64 -> 2:8.0.823-1.fc26.x86_64

Existing systems can be upgraded in place via e.g. `atomic host upgrade` or
`atomic host deploy`.  Systems on Fedora Atomic 25 can be upgraded using `rpm-ostree rebase`.
Refer to the [upgrade guide](http://www.projectatomic.io/blog/2017/08/fedora-atomic-25-to-26-upgrade/)
for more details.

Corresponding image media for new installations can be 
[downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170807.0/Atomic/x86_64/iso/Fedora-Atomic-26-20170807.0-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170807.0/Atomic/x86_64/iso/Fedora-Atomic-26-20170807.0-x86_64-CHECKSUM)

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
* [Fedora Atomic 26](https://app.vagrantup.com/fedora/boxes/26-atomic-host/versions/26.20170807.0)


```
vagrant init fedora/26-atomic-host; vagrant up
```

or, if you already have the box, to get the new one:

```
vagrant box update --box fedora/26-atomic-host
```
