---
title: Fedora Atomic 26 Released
author: jberkus
date: 2017-07-11 18:00:00 UTC
published: true
comments: true
tags: atomic, fedora, fedora 26
---

Fedora Atomic 26 is now generally available.  This contains updated package versions to match all of the content in Fedora Server 26, as well as updates to the container platforms.  While we release updates every 2 weeks, this release contains a collection of major improvements including:

* latest rpm-ostree with improvements in package layering
* default to Overlay2 filesystem for better container storage
* Docker version 1.13.1
* Latest versions of Cockpit and Atomic CLI

We're all very excited about the steps forward Atomic Host is taking with this major release.  We hope you're just as excited to try them.  Read on for information about software, upgrading, and more.

READMORE

## Upgrading

This is the first release for Fedora 26 Atomic Host coming only a week after the last release of Fedora 25 Atomic Host. Our next release will be in 3 weeks. Before you [upgrade your Fedora Atomic 25 machines](https://fedoraproject.org/wiki/Atomic_Host_upgrade) there are some things you should know.

* Please make sure your root filesystem has a few gigabytes of free space. If your root filesystem never got extended to larger than 3GiB (the default on AWS), then you should resize it before attempting an upgrade.

* If you use the Kubernetes software within Atomic Host then please wait until our next release of Atomic Host to upgrade. There is a [bug that is preventing the API server from starting](https://bugzilla.redhat.com/show_bug.cgi?id=1441218). If you don't rely on the built-in Kubernetes (e.g. you run containerized Kubernetes or OpenShift) this should not affect you. Before the next release we will publish a guide to upgrading your atomic host and making any configuration changes for the new version of kubernetes.

* The storage driver now defaults to overlay2 instead of devicemapper for container storage.  This will not change existing installations.

* The url for the F26 ostree 'remote' is [https://kojipkgs.fedoraproject.org/atomic/26/](https://kojipkgs.fedoraproject.org/atomic/26/)

* We updated our ref for this release to shorten it some and remove the mention of a specific container runtime. In Fedora 25 we had `fedora-atomic/25/x86_64/docker-host`. In Fedora 26 the ref we now have is`fedora/26/x86_64/atomic-host`.

* Because of the way the Fedora release processes work with
  regards to freezing around major release time some versions
  of software from the last release of Fedora 25 to this first
  release of Fedora 26 go backwards. The next two week release
  will not have that problem.

We will write blog posts and documentation over the next few weeks
to show you new features and guide how to upgrade your existing hosts.

## Updated Software

This release contains the following changes since last release:

* ostree diff commit old: ce555fa89da934e6eef23764fb40e8333234b8b60b6f688222247c958e5ebd5b
* ostree diff commit new: 2e4fcaff52c18cf705a2ecfa47d2ca60958f7443177974f24cc9ce07494b3317

Upgraded:

* GeoIP 1.6.11-1.fc25.x86_64 -> 1.6.11-1.fc26.x86_64
* GeoIP-GeoLite-data 2017.04-1.fc25.noarch -> 2017.06-1.fc26.noarch
* NetworkManager 1:1.4.4-5.fc25.x86_64 -> 1:1.8.0-6.fc26.x86_64
* NetworkManager-libnm 1:1.4.4-5.fc25.x86_64 -> 1:1.8.0-6.fc26.x86_64
* NetworkManager-team 1:1.4.4-5.fc25.x86_64 -> 1:1.8.0-6.fc26.x86_64
* acl 2.2.52-13.fc25.x86_64 -> 2.2.52-15.fc26.x86_64
* atomic 1.18.1-2.fc25.x86_64 -> 1.18.1-5.fc26.x86_64
* atomic-devmode 0.3.6-1.fc25.noarch -> 0.3.7-1.fc26.noarch
* attr 2.4.47-16.fc24.x86_64 -> 2.4.47-18.fc26.x86_64
* audit 2.7.7-1.fc25.x86_64 -> 2.7.7-1.fc26.x86_64
* audit-libs 2.7.7-1.fc25.x86_64 -> 2.7.7-1.fc26.x86_64
* audit-libs-python 2.7.7-1.fc25.x86_64 -> 2.7.7-1.fc26.x86_64
* audit-libs-python3 2.7.7-1.fc25.x86_64 -> 2.7.7-1.fc26.x86_64
* authconfig 6.2.10-14.fc25.x86_64 -> 7.0.1-1.fc26.x86_64
* basesystem 11-2.fc24.noarch -> 11-3.fc26.noarch
* bash 4.3.43-4.fc25.x86_64 -> 4.4.12-5.fc26.x86_64
* bash-completion 1:2.5-1.fc25.noarch -> 1:2.5-2.fc26.noarch
* bind99-libs 9.9.9-4.P8.fc25.x86_64 -> 9.9.9-5.P8.fc26.x86_64
* bind99-license 9.9.9-4.P8.fc25.noarch -> 9.9.9-5.P8.fc26.noarch
* boost-iostreams 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* boost-program-options 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* boost-random 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* boost-regex 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* boost-system 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* boost-thread 1.60.0-10.fc25.x86_64 -> 1.63.0-5.fc26.x86_64
* bridge-utils 1.5-13.fc24.x86_64 -> 1.5-14.fc26.x86_64
* btrfs-progs 4.6.1-1.fc25.x86_64 -> 4.9.1-2.fc26.x86_64
* bubblewrap 0.1.8-1.fc25.x86_64 -> 0.1.8-1.fc26.x86_64
* bzip2 1.0.6-21.fc25.x86_64 -> 1.0.6-22.fc26.x86_64
* bzip2-libs 1.0.6-21.fc25.x86_64 -> 1.0.6-22.fc26.x86_64
* ca-certificates 2017.2.14-1.0.fc25.noarch -> 2017.2.14-1.0.fc26.noarch
* ceph-common 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* checkpolicy 2.5-8.fc25.x86_64 -> 2.6-1.fc26.x86_64
* chkconfig 1.8-1.fc25.x86_64 -> 1.10-1.fc26.x86_64
* chrony 2.4.1-1.fc25.x86_64 -> 3.1-4.fc26.x86_64
* cloud-init 0.7.9-4.fc25.noarch -> 0.7.9-7.fc26.noarch
* cloud-utils-growpart 0.27-16.fc25.noarch -> 0.27-17.fc26.noarch
* cockpit-bridge 137-1.fc25.x86_64 -> 143-1.fc26.x86_64
* cockpit-docker 137-1.fc25.x86_64 -> 143-1.fc26.x86_64
* cockpit-networkmanager 137-1.fc25.noarch -> 143-1.fc26.noarch
* cockpit-ostree 137-1.fc25.x86_64 -> 143-1.fc26.x86_64
* cockpit-system 137-1.fc25.noarch -> 143-1.fc26.noarch
* conntrack-tools 1.4.3-1.fc25.x86_64 -> 1.4.4-3.fc26.x86_64
* container-selinux 2:2.19-1.fc25.noarch -> 2:2.19-1.fc26.noarch
* coreutils 8.25-17.fc25.x86_64 -> 8.27-5.fc26.x86_64
* coreutils-common 8.25-17.fc25.x86_64 -> 8.27-5.fc26.x86_64
* cpio 2.12-3.fc24.x86_64 -> 2.12-4.fc26.x86_64
* cracklib 2.9.6-4.fc25.x86_64 -> 2.9.6-5.fc26.x86_64
* cracklib-dicts 2.9.6-4.fc25.x86_64 -> 2.9.6-5.fc26.x86_64
* criu 2.12-1.fc25.x86_64 -> 3.0-1.fc26.x86_64
* crypto-policies 20160921-4.gitf3018dd.fc25.noarch -> 20170606-1.git7c32281.fc26.noarch
* cryptsetup 1.7.5-1.fc25.x86_64 -> 1.7.5-1.fc26.x86_64
* cryptsetup-libs 1.7.5-1.fc25.x86_64 -> 1.7.5-1.fc26.x86_64
* curl 7.51.0-7.fc25.x86_64 -> 7.53.1-7.fc26.x86_64
* cyrus-sasl-lib 2.1.26-26.2.fc24.x86_64 -> 2.1.26-32.fc26.x86_64
* dbus-glib 0.108-1.fc25.x86_64 -> 0.108-2.fc26.x86_64
* device-mapper 1.02.136-3.fc25.x86_64 -> 1.02.137-6.fc26.x86_64
* device-mapper-event 1.02.136-3.fc25.x86_64 -> 1.02.137-6.fc26.x86_64
* device-mapper-event-libs 1.02.136-3.fc25.x86_64 -> 1.02.137-6.fc26.x86_64
* device-mapper-libs 1.02.136-3.fc25.x86_64 -> 1.02.137-6.fc26.x86_64
* device-mapper-persistent-data 0.6.3-1.fc25.x86_64 -> 0.6.3-5.fc26.x86_64
* dhcp-client 12:4.3.5-2.fc25.x86_64 -> 12:4.3.5-6.fc26.x86_64
* dhcp-common 12:4.3.5-2.fc25.noarch -> 12:4.3.5-6.fc26.noarch
* dhcp-libs 12:4.3.5-2.fc25.x86_64 -> 12:4.3.5-6.fc26.x86_64
* diffutils 3.3-13.fc24.x86_64 -> 3.5-3.fc26.x86_64
* dnsmasq 2.76-2.fc25.x86_64 -> 2.76-3.fc26.x86_64
* docker 2:1.12.6-6.gitae7d637.fc25.x86_64 -> 2:1.13.1-19.git27e468e.fc26.x86_64
* docker-common 2:1.12.6-6.gitae7d637.fc25.x86_64 -> 2:1.13.1-19.git27e468e.fc26.x86_64
* dracut 044-78.fc25.x86_64 -> 044-183.fc26.x86_64
* dracut-config-generic 044-78.fc25.x86_64 -> 044-183.fc26.x86_64
* dracut-network 044-78.fc25.x86_64 -> 044-183.fc26.x86_64
* e2fsprogs 1.43.3-1.fc25.x86_64 -> 1.43.4-2.fc26.x86_64
* e2fsprogs-libs 1.43.3-1.fc25.x86_64 -> 1.43.4-2.fc26.x86_64
* efibootmgr 14-3.fc25.x86_64 -> 14-3.fc26.x86_64
* efivar-libs 30-4.fc25.x86_64 -> 30-4.fc26.x86_64
* elfutils-default-yama-scope 0.169-1.fc25.noarch -> 0.169-1.fc26.noarch
* elfutils-libelf 0.169-1.fc25.x86_64 -> 0.169-1.fc26.x86_64
* elfutils-libs 0.169-1.fc25.x86_64 -> 0.169-1.fc26.x86_64
* emacs-filesystem 1:25.2-2.fc25.noarch -> 1:25.2-2.fc26.noarch
* etcd 3.1.3-1.fc25.x86_64 -> 3.1.3-1.fc26.x86_64
* expat 2.2.0-1.fc25.x86_64 -> 2.2.0-2.fc26.x86_64
* fcgi 2.4.0-29.fc24.x86_64 -> 2.4.0-30.fc26.x86_64
* fedora-logos 22.0.0-3.fc24.x86_64 -> 26.0.1-1.fc26.x86_64
* fedora-release 25-2.noarch -> 26-1.noarch
* fedora-release-atomichost 25-2.noarch -> 26-1.noarch
* fedora-repos 25-4.noarch -> 26-1.noarch
* file 5.29-4.fc25.x86_64 -> 5.30-6.fc26.x86_64
* file-libs 5.29-4.fc25.x86_64 -> 5.30-6.fc26.x86_64
* filesystem 3.2-37.fc24.x86_64 -> 3.2-40.fc26.x86_64
* findutils 1:4.6.0-8.fc25.x86_64 -> 1:4.6.0-12.fc26.x86_64
* fipscheck 1.4.1-11.fc25.x86_64 -> 1.5.0-1.fc26.x86_64
* fipscheck-lib 1.4.1-11.fc25.x86_64 -> 1.5.0-1.fc26.x86_64
* flannel 0.7.0-2.fc25.x86_64 -> 0.7.0-3.fc26.x86_64
* freetype 2.6.5-9.fc25.x86_64 -> 2.7.1-9.fc26.x86_64
* fuse 2.9.7-1.fc25.x86_64 -> 2.9.7-2.fc26.x86_64
* fuse-libs 2.9.7-1.fc25.x86_64 -> 2.9.7-2.fc26.x86_64
* gawk 4.1.3-8.fc25.x86_64 -> 4.1.4-3.fc26.x86_64
* gc 7.4.4-1.fc25.x86_64 -> 7.6.0-2.fc26.x86_64
* gdbm 1.13-1.fc25.x86_64 -> 1.13-1.fc26.x86_64
* gettext 0.19.8.1-3.fc25.x86_64 -> 0.19.8.1-9.fc26.x86_64
* gettext-libs 0.19.8.1-3.fc25.x86_64 -> 0.19.8.1-9.fc26.x86_64
* glib-networking 2.50.0-1.fc25.x86_64 -> 2.50.0-2.fc26.x86_64
* glib2 2.50.3-1.fc25.x86_64 -> 2.52.3-1.fc26.x86_64
* glibc 2.24-8.fc25.x86_64 -> 2.25-6.fc26.x86_64
* glibc-all-langpacks 2.24-8.fc25.x86_64 -> 2.25-6.fc26.x86_64
* glibc-common 2.24-8.fc25.x86_64 -> 2.25-6.fc26.x86_64
* glusterfs 3.10.3-1.fc25.x86_64 -> 3.10.3-1.fc26.x86_64
* glusterfs-client-xlators 3.10.3-1.fc25.x86_64 -> 3.10.3-1.fc26.x86_64
* glusterfs-fuse 3.10.3-1.fc25.x86_64 -> 3.10.3-1.fc26.x86_64
* glusterfs-libs 3.10.3-1.fc25.x86_64 -> 3.10.3-1.fc26.x86_64
* gmp 1:6.1.1-1.fc25.x86_64 -> 1:6.1.2-4.fc26.x86_64
* gnupg 1.4.21-1.fc25.x86_64 -> 1.4.21-2.fc26.x86_64
* gnupg2 2.1.13-2.fc25.x86_64 -> 2.1.21-2.fc26.x86_64
* gnupg2-smime 2.1.13-2.fc25.x86_64 -> 2.1.21-2.fc26.x86_64
* gnutls 3.5.13-1.fc25.x86_64 -> 3.5.13-1.fc26.x86_64
* gobject-introspection 1.50.0-1.fc25.x86_64 -> 1.52.1-1.fc26.x86_64
* gomtree 0.3.1-1.fc25.x86_64 -> 0.3.1-1.fc26.x86_64
* gperftools-libs 2.5-2.fc25.x86_64 -> 2.5.93-1.fc26.x86_64
* gpgme 1.8.0-10.fc25.x86_64 -> 1.8.0-12.fc26.x86_64
* grep 2.27-2.fc25.x86_64 -> 3.0-1.fc26.x86_64
* grub2 1:2.02-0.38.fc25.x86_64 -> 1:2.02-0.40.fc26.x86_64
* grub2-efi 1:2.02-0.38.fc25.x86_64 -> 1:2.02-0.40.fc26.x86_64
* grub2-tools 1:2.02-0.38.fc25.x86_64 -> 1:2.02-0.40.fc26.x86_64
* grubby 8.40-3.fc24.x86_64 -> 8.40-4.fc26.x86_64
* gsettings-desktop-schemas 3.22.0-1.fc25.x86_64 -> 3.24.0-1.fc26.x86_64
* gssproxy 0.7.0-9.fc25.x86_64 -> 0.7.0-9.fc26.x86_64
* guile 5:2.0.13-1.fc25.x86_64 -> 5:2.0.14-1.fc26.x86_64
* gzip 1.8-1.fc25.x86_64 -> 1.8-2.fc26.x86_64
* hardlink 1:1.1-1.fc25.x86_64 -> 1:1.3-1.fc26.x86_64
* hostname 3.15-8.fc25.x86_64 -> 3.18-2.fc26.x86_64
* info 6.1-4.fc25.x86_64 -> 6.3-3.fc26.x86_64
* initscripts 9.69-1.fc25.x86_64 -> 9.72-1.fc26.x86_64
* ipcalc 0.1.8-1.fc25.x86_64 -> 0.2.0-1.fc26.x86_64
* iproute 4.11.0-1.fc25.x86_64 -> 4.11.0-1.fc26.x86_64
* iproute-tc 4.11.0-1.fc25.x86_64 -> 4.11.0-1.fc26.x86_64
* iptables 1.6.0-3.fc25.x86_64 -> 1.6.1-2.fc26.x86_64
* iptables-libs 1.6.0-3.fc25.x86_64 -> 1.6.1-2.fc26.x86_64
* iptables-services 1.6.0-3.fc25.x86_64 -> 1.6.1-2.fc26.x86_64
* iputils 20161105-1.fc25.x86_64 -> 20161105-2.fc26.x86_64
* iscsi-initiator-utils 6.2.0.873-34.git4c1f2d9.fc25.x86_64 -> 6.2.0.874-3.git86e8892.fc26.x86_64
* iscsi-initiator-utils-iscsiuio 6.2.0.873-34.git4c1f2d9.fc25.x86_64 -> 6.2.0.874-3.git86e8892.fc26.x86_64
* jansson 2.10-2.fc25.x86_64 -> 2.10-2.fc26.x86_64
* json-glib 1.2.6-1.fc25.x86_64 -> 1.2.6-1.fc26.x86_64
* kernel 4.11.8-200.fc25.x86_64 -> 4.11.8-300.fc26.x86_64
* kernel-core 4.11.8-200.fc25.x86_64 -> 4.11.8-300.fc26.x86_64
* kernel-modules 4.11.8-200.fc25.x86_64 -> 4.11.8-300.fc26.x86_64
* keyutils 1.5.9-8.fc24.x86_64 -> 1.5.10-1.fc26.x86_64
* keyutils-libs 1.5.9-8.fc24.x86_64 -> 1.5.10-1.fc26.x86_64
* kmod 23-1.fc25.x86_64 -> 24-1.fc26.x86_64
* kmod-libs 23-1.fc25.x86_64 -> 24-1.fc26.x86_64
* kpartx 0.4.9-83.fc25.x86_64 -> 0.4.9-88.fc26.x86_64
* krb5-libs 1.14.4-7.fc25.x86_64 -> 1.15.1-8.fc26.x86_64
* kubernetes 1.5.3-1.fc25.x86_64 -> 1.5.3-1.fc26.x86_64
* kubernetes-client 1.5.3-1.fc25.x86_64 -> 1.5.3-1.fc26.x86_64
* kubernetes-master 1.5.3-1.fc25.x86_64 -> 1.5.3-1.fc26.x86_64
* kubernetes-node 1.5.3-1.fc25.x86_64 -> 1.5.3-1.fc26.x86_64
* less 481-7.fc25.x86_64 -> 487-3.fc26.x86_64
* libacl 2.2.52-13.fc25.x86_64 -> 2.2.52-15.fc26.x86_64
* libaio 0.3.110-6.fc24.x86_64 -> 0.3.110-7.fc26.x86_64
* libarchive 3.2.2-2.fc25.x86_64 -> 3.2.2-4.fc26.x86_64
* libassuan 2.4.3-1.fc25.x86_64 -> 2.4.3-2.fc26.x86_64
* libatomic_ops 7.4.4-1.fc25.x86_64 -> 7.4.4-2.fc26.x86_64
* libattr 2.4.47-16.fc24.x86_64 -> 2.4.47-18.fc26.x86_64
* libbabeltrace 1.4.0-3.fc25.x86_64 -> 1.5.2-2.fc26.x86_64
* libbasicobjects 0.1.1-29.fc25.x86_64 -> 0.1.1-30.fc26.x86_64
* libblkid 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* libcap 2.25-2.fc25.x86_64 -> 2.25-5.fc26.x86_64
* libcap-ng 0.7.8-1.fc25.x86_64 -> 0.7.8-3.fc26.x86_64
* libcephfs1 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* libcgroup 0.41-9.fc25.x86_64 -> 0.41-11.fc26.x86_64
* libcollection 0.7.0-29.fc25.x86_64 -> 0.7.0-30.fc26.x86_64
* libcom_err 1.43.3-1.fc25.x86_64 -> 1.43.4-2.fc26.x86_64
* libcroco 0.6.11-3.fc25.x86_64 -> 0.6.12-1.fc26.x86_64
* libcrypt-nss 2.24-8.fc25.x86_64 -> 2.25-6.fc26.x86_64
* libcurl 7.51.0-7.fc25.x86_64 -> 7.53.1-7.fc26.x86_64
* libdaemon 0.14-10.fc24.x86_64 -> 0.14-11.fc26.x86_64
* libdb 5.3.28-21.fc25.x86_64 -> 5.3.28-21.fc26.x86_64
* libdb-utils 5.3.28-21.fc25.x86_64 -> 5.3.28-21.fc26.x86_64
* libedit 3.1-16.20160618cvs.fc25.x86_64 -> 3.1-17.20160618cvs.fc26.x86_64
* libev 4.24-1.fc25.x86_64 -> 4.24-2.fc26.x86_64
* libevent 2.0.22-1.fc25.x86_64 -> 2.0.22-3.fc26.x86_64
* libfdisk 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* libffi 3.1-9.fc24.x86_64 -> 3.1-11.fc26.x86_64
* libgcc 6.3.1-1.fc25.x86_64 -> 7.1.1-3.fc26.x86_64
* libgomp 6.3.1-1.fc25.x86_64 -> 7.1.1-3.fc26.x86_64
* libgpg-error 1.24-1.fc25.x86_64 -> 1.25-2.fc26.x86_64
* libicu 57.1-5.fc25.x86_64 -> 57.1-6.fc26.x86_64
* libidn 1.33-1.fc25.x86_64 -> 1.33-2.fc26.x86_64
* libidn2 2.0.2-1.fc25.x86_64 -> 2.0.2-1.fc26.x86_64
* libini_config 1.3.0-29.fc25.x86_64 -> 1.3.0-30.fc26.x86_64
* libksba 1.3.5-1.fc25.x86_64 -> 1.3.5-3.fc26.x86_64
* libmetalink 0.1.3-1.fc25.x86_64 -> 0.1.3-2.fc26.x86_64
* libmnl 1.0.4-1.fc25.x86_64 -> 1.0.4-2.fc26.x86_64
* libmodman 2.0.1-12.fc24.x86_64 -> 2.0.1-13.fc26.x86_64
* libmount 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* libndp 1.6-1.fc25.x86_64 -> 1.6-2.fc26.x86_64
* libnet 1.1.6-11.fc24.x86_64 -> 1.1.6-12.fc26.x86_64
* libnetfilter_conntrack 1.0.6-2.fc25.x86_64 -> 1.0.6-2.fc26.x86_64
* libnetfilter_cthelper 1.0.0-9.fc24.x86_64 -> 1.0.0-10.fc26.x86_64
* libnetfilter_cttimeout 1.0.0-7.fc24.x86_64 -> 1.0.0-8.fc26.x86_64
* libnetfilter_queue 1.0.2-7.fc24.x86_64 -> 1.0.2-8.fc26.x86_64
* libnfnetlink 1.0.1-8.fc24.x86_64 -> 1.0.1-9.fc26.x86_64
* libnfsidmap 0.27-1.fc25.x86_64 -> 0.27-1.fc26.x86_64
* libnghttp2 1.13.0-2.fc25.x86_64 -> 1.21.1-1.fc26.x86_64
* libnl3 3.2.29-3.fc25.x86_64 -> 3.3.0-1.fc26.x86_64
* libnl3-cli 3.2.29-3.fc25.x86_64 -> 3.3.0-1.fc26.x86_64
* libpath_utils 0.2.1-29.fc25.x86_64 -> 0.2.1-30.fc26.x86_64
* libpcap 14:1.7.4-2.fc24.x86_64 -> 14:1.8.1-3.fc26.x86_64
* libpng 2:1.6.27-1.fc25.x86_64 -> 2:1.6.28-2.fc26.x86_64
* libproxy 0.4.14-1.fc25.x86_64 -> 0.4.15-1.fc26.x86_64
* libpsl 0.17.0-1.fc25.x86_64 -> 0.17.0-2.fc26.x86_64
* libpwquality 1.3.0-6.fc25.x86_64 -> 1.3.0-8.fc26.x86_64
* librados2 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* libradosstriper1 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* librbd1 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* libref_array 0.1.5-29.fc25.x86_64 -> 0.1.5-30.fc26.x86_64
* librepo 1.7.18-3.fc25.x86_64 -> 1.7.20-3.fc26.x86_64
* libreport-filesystem 2.8.0-1.fc25.x86_64 -> 2.9.1-2.fc26.x86_64
* librgw2 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* libseccomp 2.3.2-1.fc25.x86_64 -> 2.3.2-1.fc26.x86_64
* libsecret 0.18.5-2.fc25.x86_64 -> 0.18.5-3.fc26.x86_64
* libselinux 2.5-13.fc25.x86_64 -> 2.6-6.fc26.x86_64
* libselinux-python 2.5-13.fc25.x86_64 -> 2.6-6.fc26.x86_64
* libselinux-python3 2.5-13.fc25.x86_64 -> 2.6-6.fc26.x86_64
* libselinux-utils 2.5-13.fc25.x86_64 -> 2.6-6.fc26.x86_64
* libsemanage 2.5-9.fc25.x86_64 -> 2.6-4.fc26.x86_64
* libsemanage-python 2.5-9.fc25.x86_64 -> 2.6-4.fc26.x86_64
* libsemanage-python3 2.5-9.fc25.x86_64 -> 2.6-4.fc26.x86_64
* libsepol 2.5-10.fc25.x86_64 -> 2.6-1.fc26.x86_64
* libsigsegv 2.10-10.fc24.x86_64 -> 2.11-1.fc26.x86_64
* libsmartcols 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* libsolv 0.6.27-2.fc25.x86_64 -> 0.6.27-2.fc26.x86_64
* libsoup 2.56.0-2.fc25.x86_64 -> 2.58.1-1.fc26.x86_64
* libss 1.43.3-1.fc25.x86_64 -> 1.43.4-2.fc26.x86_64
* libssh2 1.8.0-1.fc25.x86_64 -> 1.8.0-2.fc26.x86_64
* libsss_idmap 1.15.2-5.fc25.x86_64 -> 1.15.2-5.fc26.x86_64
* libsss_nss_idmap 1.15.2-5.fc25.x86_64 -> 1.15.2-5.fc26.x86_64
* libsss_sudo 1.15.2-5.fc25.x86_64 -> 1.15.2-5.fc26.x86_64
* libstdc++ 6.3.1-1.fc25.x86_64 -> 7.1.1-3.fc26.x86_64
* libtasn1 4.12-1.fc25.x86_64 -> 4.12-1.fc26.x86_64
* libteam 1.27-1.fc25.x86_64 -> 1.27-1.fc26.x86_64
* libtirpc 1.0.1-4.rc3.fc25.x86_64 -> 1.0.1-4.rc3.fc26.x86_64
* libtomcrypt 1.17-29.fc25.x86_64 -> 1.17-30.fc26.x86_64
* libtommath 1.0-4.fc24.x86_64 -> 1.0-5.fc26.x86_64
* libtool-ltdl 2.4.6-13.fc25.x86_64 -> 2.4.6-17.fc26.x86_64
* libunistring 0.9.4-3.fc24.x86_64 -> 0.9.7-1.fc26.x86_64
* libunwind 1.2-1.fc25.x86_64 -> 1.2-1.fc26.x86_64
* libusb 1:0.1.5-7.fc24.x86_64 -> 1:0.1.5-8.fc26.x86_64
* libusbx 1.0.21-1.fc25.x86_64 -> 1.0.21-2.fc26.x86_64
* libuser 0.62-4.fc25.x86_64 -> 0.62-6.fc26.x86_64
* libutempter 1.1.6-8.fc24.x86_64 -> 1.1.6-9.fc26.x86_64
* libuuid 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* libverto 0.2.6-6.fc24.x86_64 -> 0.2.6-7.fc26.x86_64
* libverto-libev 0.2.6-6.fc24.x86_64 -> 0.2.6-7.fc26.x86_64
* libxkbcommon 0.7.1-1.fc25.x86_64 -> 0.7.1-3.fc26.x86_64
* libxml2 2.9.4-2.fc25.x86_64 -> 2.9.4-2.fc26.x86_64
* libyaml 0.1.6-8.fc24.x86_64 -> 0.1.7-2.fc26.x86_64
* linux-atm-libs 2.5.1-14.fc24.x86_64 -> 2.5.1-17.fc26.x86_64
* linux-firmware 20170605-74.git37857004.fc25.noarch -> 20170622-75.gita3a26af2.fc26.noarch
* lsof 4.89-4.fc25.x86_64 -> 4.89-5.fc26.x86_64
* lttng-ust 2.8.1-2.fc25.x86_64 -> 2.9.0-2.fc26.x86_64
* lua-libs 5.3.4-3.fc25.x86_64 -> 5.3.4-3.fc26.x86_64
* lvm2 2.02.167-3.fc25.x86_64 -> 2.02.168-6.fc26.x86_64
* lvm2-libs 2.02.167-3.fc25.x86_64 -> 2.02.168-6.fc26.x86_64
* lzo 2.08-8.fc24.x86_64 -> 2.08-9.fc26.x86_64
* make 1:4.1-6.fc25.x86_64 -> 1:4.2.1-2.fc26.x86_64
* mdadm 3.4-2.fc25.x86_64 -> 4.0-1.fc26.x86_64
* mokutil 1:0.3.0-3.fc25.x86_64 -> 1:0.3.0-4.fc26.x86_64
* mozjs17 17.0.0-16.fc25.x86_64 -> 17.0.0-18.fc26.x86_64
* mpfr 3.1.5-1.fc25.x86_64 -> 3.1.5-3.fc26.x86_64
* ncurses 6.0-6.20160709.fc25.x86_64 -> 6.0-8.20170212.fc26.x86_64
* ncurses-base 6.0-6.20160709.fc25.noarch -> 6.0-8.20170212.fc26.noarch
* ncurses-libs 6.0-6.20160709.fc25.x86_64 -> 6.0-8.20170212.fc26.x86_64
* net-tools 2.0-0.40.20160329git.fc25.x86_64 -> 2.0-0.42.20160912git.fc26.x86_64
* nettle 3.3-1.fc25.x86_64 -> 3.3-2.fc26.x86_64
* nfs-utils 1:2.1.1-5.rc4.fc25.x86_64 -> 1:2.1.1-5.rc4.fc26.x86_64
* nmap-ncat 2:7.40-1.fc25.x86_64 -> 2:7.40-2.fc26.x86_64
* npth 1.3-1.fc25.x86_64 -> 1.5-1.fc26.x86_64
* nspr 4.14.0-2.fc25.x86_64 -> 4.14.0-2.fc26.x86_64
* nss 3.30.2-1.1.fc25.x86_64 -> 3.30.2-1.1.fc26.x86_64
* nss-altfiles 2.18.1-7.fc24.x86_64 -> 2.18.1-8.fc26.x86_64
* nss-pem 1.0.3-3.fc25.x86_64 -> 1.0.3-3.fc26.x86_64
* nss-softokn 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.0.fc26.x86_64
* nss-softokn-freebl 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.0.fc26.x86_64
* nss-sysinit 3.30.2-1.1.fc25.x86_64 -> 3.30.2-1.1.fc26.x86_64
* nss-tools 3.30.2-1.1.fc25.x86_64 -> 3.30.2-1.1.fc26.x86_64
* nss-util 3.30.2-1.0.fc25.x86_64 -> 3.30.2-1.0.fc26.x86_64
* oci-register-machine 0-3.7.gitbb20b00.fc25.x86_64 -> 0-3.7.gitbb20b00.fc26.x86_64
* oci-systemd-hook 1:0.1.7-1.git1788cf2.fc25.x86_64 -> 1:0.1.7-1.git1788cf2.fc26.x86_64
* oddjob 0.34.3-2.fc24.x86_64 -> 0.34.4-1.fc26.x86_64
* oddjob-mkhomedir 0.34.3-2.fc24.x86_64 -> 0.34.4-1.fc26.x86_64
* openldap 2.4.44-10.fc25.x86_64 -> 2.4.44-10.fc26.x86_64
* openssh 7.4p1-4.fc25.x86_64 -> 7.5p1-2.fc26.x86_64
* openssh-clients 7.4p1-4.fc25.x86_64 -> 7.5p1-2.fc26.x86_64
* openssh-server 7.4p1-4.fc25.x86_64 -> 7.5p1-2.fc26.x86_64
* openssl 1:1.0.2k-1.fc25.x86_64 -> 1:1.1.0f-4.fc26.x86_64
* openssl-libs 1:1.0.2k-1.fc25.x86_64 -> 1:1.1.0f-4.fc26.x86_64
* os-prober 1.74-1.fc25.x86_64 -> 1.74-1.fc26.x86_64
* ostree 2017.7-2.fc25.x86_64 -> 2017.7-2.fc26.x86_64
* ostree-grub2 2017.7-2.fc25.x86_64 -> 2017.7-2.fc26.x86_64
* ostree-libs 2017.7-2.fc25.x86_64 -> 2017.7-2.fc26.x86_64
* p11-kit 0.23.2-4.fc25.x86_64 -> 0.23.5-3.fc26.x86_64
* p11-kit-trust 0.23.2-4.fc25.x86_64 -> 0.23.5-3.fc26.x86_64
* pam 1.3.0-1.fc25.x86_64 -> 1.3.0-2.fc26.x86_64
* passwd 0.79-8.fc24.x86_64 -> 0.79-9.fc26.x86_64
* pcre 8.40-7.fc25.x86_64 -> 8.40-7.fc26.x86_64
* pigz 2.3.4-1.fc25.x86_64 -> 2.3.4-2.fc26.x86_64
* pinentry 0.9.7-2.fc24.x86_64 -> 0.9.7-3.fc26.x86_64
* policycoreutils 2.5-20.fc25.x86_64 -> 2.6-5.fc26.x86_64
* policycoreutils-python 2.5-20.fc25.x86_64 -> 2.6-5.fc26.x86_64
* policycoreutils-python-utils 2.5-20.fc25.x86_64 -> 2.6-5.fc26.x86_64
* policycoreutils-python3 2.5-20.fc25.x86_64 -> 2.6-5.fc26.x86_64
* polkit 0.113-8.fc25.x86_64 -> 0.113-8.fc26.x86_64
* polkit-libs 0.113-8.fc25.x86_64 -> 0.113-8.fc26.x86_64
* polkit-pkla-compat 0.1-7.fc24.x86_64 -> 0.1-8.fc26.x86_64
* popt 1.16-7.fc24.x86_64 -> 1.16-8.fc26.x86_64
* procps-ng 3.3.10-11.fc24.x86_64 -> 3.3.10-13.fc26.x86_64
* protobuf-c 1.2.1-1.fc25.x86_64 -> 1.2.1-4.fc26.x86_64
* psmisc 22.21-8.fc24.x86_64 -> 22.21-9.fc26.x86_64
* publicsuffix-list-dafsa 20170424-1.fc25.noarch -> 20170424-1.fc26.noarch
* python-IPy 0.81-16.fc25.noarch -> 0.81-18.fc26.noarch
* python-IPy-python3 0.81-16.fc25.noarch -> 0.81-18.fc26.noarch
* python-backports 1.0-8.fc25.x86_64 -> 1.0-9.fc26.x86_64
* python-backports-ssl_match_hostname 3.5.0.1-3.fc25.noarch -> 3.5.0.1-4.fc26.noarch
* python-cephfs 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* python-chardet 2.3.0-1.fc25.noarch -> 2.3.0-3.fc26.noarch
* python-docker-py 1.10.6-1.fc25.noarch -> 1:1.10.6-3.fc26.noarch
* python-ipaddress 1.0.16-3.fc25.noarch -> 1.0.16-4.fc26.noarch
* python-rados 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* python-rbd 1:10.2.4-2.fc25.x86_64 -> 1:10.2.7-2.fc26.x86_64
* python-websocket-client 0.37.0-2.fc25.noarch -> 0.40.0-1.fc26.noarch
* python2-docker-pycreds 0.2.1-2.fc25.noarch -> 0.2.1-4.fc26.noarch
* python2-pysocks 1.5.6-5.fc25.noarch -> 1.5.7-4.fc26.noarch
* python2-requests 2.10.0-4.fc25.noarch -> 2.13.0-1.fc26.noarch
* python2-setuptools 25.1.1-1.fc25.noarch -> 36.0.1-1.fc26.noarch
* python2-urllib3 1.15.1-3.fc25.noarch -> 1.20-1.fc26.noarch
* python3 3.5.3-6.fc25.x86_64 -> 3.6.1-8.fc26.x86_64
* python3-PyYAML 3.11-13.fc25.x86_64 -> 3.12-3.fc26.x86_64
* python3-chardet 2.3.0-1.fc25.noarch -> 2.3.0-3.fc26.noarch
* python3-configobj 5.0.6-5.fc25.noarch -> 5.0.6-8.fc26.noarch
* python3-crypto 2.6.1-13.fc25.x86_64 -> 2.6.1-14.fc26.x86_64
* python3-dateutil 1:2.6.0-1.fc25.noarch -> 1:2.6.0-3.fc26.noarch
* python3-dbus 1.2.4-2.fc25.x86_64 -> 1.2.4-6.fc26.x86_64
* python3-decorator 4.0.11-1.fc25.noarch -> 4.0.11-2.fc26.noarch
* python3-docker-pycreds 0.2.1-2.fc25.noarch -> 0.2.1-4.fc26.noarch
* python3-gobject-base 3.22.0-1.fc25.x86_64 -> 3.24.1-1.fc26.x86_64
* python3-jinja2 2.8.1-1.fc25.noarch -> 2.9.6-1.fc26.noarch
* python3-jsonpatch 1.2-9.fc25.noarch -> 1.14-3.fc26.noarch
* python3-jsonpointer 1.10-3.fc25.noarch -> 1.10-6.fc26.noarch
* python3-libs 3.5.3-6.fc25.x86_64 -> 3.6.1-8.fc26.x86_64
* python3-libxml2 2.9.4-2.fc25.x86_64 -> 2.9.4-2.fc26.x86_64
* python3-markupsafe 0.23-10.fc25.x86_64 -> 0.23-13.fc26.x86_64
* python3-oauthlib 1.0.3-3.fc25.noarch -> 1.0.3-5.fc26.noarch
* python3-pip 8.1.2-2.fc25.noarch -> 9.0.1-9.fc26.noarch
* python3-prettytable 0.7.2-8.fc25.noarch -> 0.7.2-10.fc26.noarch
* python3-pyserial 3.1.1-1.fc25.noarch -> 3.1.1-3.fc26.noarch
* python3-pysocks 1.5.6-5.fc25.noarch -> 1.5.7-4.fc26.noarch
* python3-requests 2.10.0-4.fc25.noarch -> 2.13.0-1.fc26.noarch
* python3-rpm 4.13.0.1-1.fc25.x86_64 -> 4.13.0.1-4.fc26.x86_64
* python3-setuptools 25.1.1-1.fc25.noarch -> 36.0.1-1.fc26.noarch
* python3-six 1.10.0-3.fc25.noarch -> 1.10.0-8.fc26.noarch
* python3-slip 0.6.4-4.fc25.noarch -> 0.6.4-6.fc26.noarch
* python3-slip-dbus 0.6.4-4.fc25.noarch -> 0.6.4-6.fc26.noarch
* python3-sssdconfig 1.15.2-5.fc25.noarch -> 1.15.2-5.fc26.noarch
* python3-urllib3 1.15.1-3.fc25.noarch -> 1.20-1.fc26.noarch
* python3-websocket-client 0.37.0-2.fc25.noarch -> 0.40.0-1.fc26.noarch
* qrencode-libs 3.4.4-1.fc25.x86_64 -> 3.4.4-1.fc26.x86_64
* quota 1:4.03-7.fc25.x86_64 -> 1:4.03-8.fc26.x86_64
* quota-nls 1:4.03-7.fc25.noarch -> 1:4.03-8.fc26.noarch
* readline 6.3-8.fc24.x86_64 -> 7.0-5.fc26.x86_64
* rootfiles 8.1-19.fc24.noarch -> 8.1-20.fc26.noarch
* rpcbind 0.2.4-6.rc2.fc25.x86_64 -> 0.2.4-7.rc2.fc26.x86_64
* rpm 4.13.0.1-1.fc25.x86_64 -> 4.13.0.1-4.fc26.x86_64
* rpm-build-libs 4.13.0.1-1.fc25.x86_64 -> 4.13.0.1-4.fc26.x86_64
* rpm-libs 4.13.0.1-1.fc25.x86_64 -> 4.13.0.1-4.fc26.x86_64
* rpm-ostree 2017.6-3.fc25.x86_64 -> 2017.6-3.fc26.x86_64
* rpm-plugin-selinux 4.13.0.1-1.fc25.x86_64 -> 4.13.0.1-4.fc26.x86_64
* rsync 3.1.2-4.fc25.x86_64 -> 3.1.2-4.fc26.x86_64
* runc 1:1.0.0-6.git75f8da7.fc25.1.x86_64 -> 1:1.0.0-9.git6394544.fc26.x86_64
* screen 4.5.1-2.fc25.x86_64 -> 4.5.1-2.fc26.x86_64
* sed 4.2.2-15.fc24.x86_64 -> 4.4-1.fc26.x86_64
* selinux-policy 3.13.1-225.18.fc25.noarch -> 3.13.1-259.fc26.noarch
* selinux-policy-targeted 3.13.1-225.18.fc25.noarch -> 3.13.1-259.fc26.noarch
* setools-console 3.3.8-12.fc25.x86_64 -> 4.1.0-3.fc26.x86_64
* setup 2.10.4-1.fc25.noarch -> 2.10.5-2.fc26.noarch
* shadow-utils 2:4.2.1-11.fc25.x86_64 -> 2:4.3.1-3.fc26.x86_64
* shared-mime-info 1.8-1.fc25.x86_64 -> 1.8-2.fc26.x86_64
* socat 1.7.3.2-1.fc25.x86_64 -> 1.7.3.2-2.fc26.x86_64
* sos 3.4-1.fc25.noarch -> 3.4-1.fc26.noarch
* sqlite-libs 3.14.2-1.fc25.x86_64 -> 3.19.1-1.fc26.x86_64
* sssd-client 1.15.2-5.fc25.x86_64 -> 1.15.2-5.fc26.x86_64
* strace 4.17-1.fc25.x86_64 -> 4.17-1.fc26.x86_64
* sudo 1.8.20p2-1.fc25.x86_64 -> 1.8.20p2-1.fc26.x86_64
* system-python 3.5.3-6.fc25.x86_64 -> 3.6.1-8.fc26.x86_64
* system-python-libs 3.5.3-6.fc25.x86_64 -> 3.6.1-8.fc26.x86_64
* systemd 231-17.fc25.x86_64 -> 233-6.fc26.x86_64
* systemd-bootchart 231-2.fc25.x86_64 -> 231-3.fc26.x86_64
* systemd-container 231-17.fc25.x86_64 -> 233-6.fc26.x86_64
* systemd-libs 231-17.fc25.x86_64 -> 233-6.fc26.x86_64
* systemd-pam 231-17.fc25.x86_64 -> 233-6.fc26.x86_64
* systemd-udev 231-17.fc25.x86_64 -> 233-6.fc26.x86_64
* tar 2:1.29-3.fc25.x86_64 -> 2:1.29-4.fc26.x86_64
* tcp_wrappers 7.6-83.fc25.x86_64 -> 7.6-85.fc26.x86_64
* tcp_wrappers-libs 7.6-83.fc25.x86_64 -> 7.6-85.fc26.x86_64
* tcpdump 14:4.9.0-1.fc25.x86_64 -> 14:4.9.0-2.fc26.x86_64
* teamd 1.27-1.fc25.x86_64 -> 1.27-1.fc26.x86_64
* timedatex 0.4-2.fc24.x86_64 -> 0.4-3.fc26.x86_64
* tmux 2.2-3.fc25.x86_64 -> 2.3-2.fc26.x86_64
* trousers 0.3.13-6.fc24.x86_64 -> 0.3.13-7.fc26.x86_64
* trousers-lib 0.3.13-6.fc24.x86_64 -> 0.3.13-7.fc26.x86_64
* tzdata 2017b-1.fc25.noarch -> 2017b-1.fc26.noarch
* userspace-rcu 0.9.2-2.fc25.x86_64 -> 0.9.3-2.fc26.x86_64
* ustr 1.0.4-21.fc24.x86_64 -> 1.0.4-22.fc26.x86_64
* util-linux 2.28.2-2.fc25.x86_64 -> 2.29.1-2.fc26.x86_64
* which 2.21-1.fc25.x86_64 -> 2.21-2.fc26.x86_64
* xfsprogs 4.9.0-1.fc25.x86_64 -> 4.10.0-1.fc26.x86_64
* xkeyboard-config 2.20-2.fc25.noarch -> 2.21-1.fc26.noarch
* xz 5.2.2-2.fc24.x86_64 -> 5.2.3-2.fc26.x86_64
* xz-libs 5.2.2-2.fc24.x86_64 -> 5.2.3-2.fc26.x86_64
* yajl 2.1.0-5.fc24.x86_64 -> 2.1.0-6.fc26.x86_64
* zlib 1.2.8-10.fc24.x86_64 -> 1.2.11-2.fc26.x86_64

Downgraded:

* dbus 1:1.11.14-1.fc25.x86_64 -> 1:1.11.12-1.fc26.x86_64
* dbus-libs 1:1.11.14-1.fc25.x86_64 -> 1:1.11.12-1.fc26.x86_64
* libgcrypt 1.7.8-1.fc25.x86_64 -> 1.7.7-1.fc26.x86_64
* skopeo 0.1.22-1.git5d24b67.fc25.x86_64 -> 0.1.19-1.dev.git0224d8c.fc26.x86_64
* skopeo-containers 0.1.22-1.git5d24b67.fc25.x86_64 -> 0.1.19-1.dev.git0224d8c.fc26.x86_64
* vim-minimal 2:8.0.679-1.fc25.x86_64 -> 2:8.0.662-1.fc26.x86_64

Removed:

* libgudev-230-3.fc24.x86_64
* newt-0.52.19-2.fc25.x86_64
* newt-python3-0.52.19-2.fc25.x86_64
* plymouth-0.9.3-0.6.20160620git0e65b86c.fc25.x86_64
* plymouth-core-libs-0.9.3-0.6.20160620git0e65b86c.fc25.x86_64
* plymouth-scripts-0.9.3-0.6.20160620git0e65b86c.fc25.x86_64
* ppp-2.4.7-9.fc24.x86_64

Obsolesced due to name changes:

* lz4-1.7.5-1.fc25.x86_64
* pkgconfig-1:0.29.1-1.fc25.x86_64
* python-2.7.13-2.fc25.x86_64
* python-libs-2.7.13-2.fc25.x86_64
* python-pip-8.1.2-2.fc25.noarch
* python-six-1.10.0-3.fc25.noarch
* python3-docker-py-1.10.6-1.fc25.noarch
* setools-libs-3.3.8-12.fc25.x86_64
* slang-2.3.0-7.fc25.x86_64
* sqlite-3.14.2-1.fc25.x86_64

Added:

* atomic-registries-1.18.1-5.fc26.x86_64
* container-storage-setup-0.5.0-1.git9b77bcb.fc26.noarch
* docker-rhel-push-plugin-2:1.13.1-19.git27e468e.fc26.x86_64
* libpkgconf-1.3.7-1.fc26.x86_64
* lz4-libs-1.7.5-3.fc26.x86_64
* oci-umount-2:1.13.1-19.git27e468e.fc26.x86_64
* parted-3.2-24.fc26.x86_64
* pcre2-10.23-8.fc26.x86_64
* pkgconf-1.3.7-1.fc26.x86_64
* pkgconf-m4-1.3.7-1.fc26.noarch
* pkgconf-pkg-config-1.3.7-1.fc26.x86_64
* python-enum34-1.1.6-1.fc26.noarch
* python-rhsm-certificates-1.19.4-1.fc26.x86_64
* python2-2.7.13-10.fc26.x86_64
* python2-cffi-1.9.1-2.fc26.x86_64
* python2-cryptography-1.7.2-1.fc26.x86_64
* python2-idna-2.5-1.fc26.noarch
* python2-libs-2.7.13-10.fc26.x86_64
* python2-pip-9.0.1-9.fc26.noarch
* python2-ply-3.9-3.fc26.noarch
* python2-pyOpenSSL-16.2.0-4.fc26.noarch
* python2-pyasn1-0.2.3-1.fc26.noarch
* python2-pycparser-2.14-10.fc26.noarch
* python2-six-1.10.0-8.fc26.noarch
* python3-cffi-1.9.1-2.fc26.x86_64
* python3-cryptography-1.7.2-1.fc26.x86_64
* python3-docker-2.3.0-1.fc26.noarch
* python3-idna-2.5-1.fc26.noarch
* python3-ply-3.9-3.fc26.noarch
* python3-pyOpenSSL-16.2.0-4.fc26.noarch
* python3-pyasn1-0.2.3-1.fc26.noarch
* python3-pycparser-2.14-10.fc26.noarch
* setools-python-4.1.0-3.fc26.x86_64
* setools-python3-4.1.0-3.fc26.x86_64

Existing systems can be upgraded [using rebase](https://fedoraproject.org/wiki/Atomic_Host_upgrade).

Corresponding image media for new installations can be [downloaded from GetFedora.org](https://getfedora.org/en/atomic/download/).

Respective signed CHECKSUM files can be found here:

* [Cloud image checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170707.1/CloudImages/x86_64/images/Fedora-CloudImages-26-20170707.1-x86_64-CHECKSUM)
* [ISO Checksum](https://alt.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-26-20170707.1/Atomic/x86_64/iso/Fedora-Atomic-26-20170707.1-x86_64-CHECKSUM)
