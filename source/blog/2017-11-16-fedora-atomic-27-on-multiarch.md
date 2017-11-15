---
title: Fedora 27 Atomic Host Availability on Multiple Architectures
author: sinnykumari
date: 2017-11-16 11:00:00 UTC
published: true
comments: false
tags: atomic, fedora, multi-arch, ppc64le, aarch64
---

![Picture of OverDrive1000 ARM64 system, loaned to Project Atomic by the ARM coalition](overdrive1000.png)

We are proud to announce that multiple architectures are now supported with Fedora 27 Atomic Host release! Now, along with x86_64 architecture, Atomic Host is also available on 64 bit ARM (AArch64) and PowerPC Little Endian (ppc64le). Both aarch64 and ppc64le architectures will receive Atomic OSTree updates in the same way x86_64 does.

READMORE

*Photo: Overdrive1000 aarch64 system provided by ARM Coalition for testing*

# Download
Fedora Atomic Host for aarch64 and ppc64le are available as both ISOs and cloudImages:

- aarch64
    - [ISO](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/aarch64/iso/Fedora-Atomic-ostree-aarch64-27-20171110.1.iso)
    - [QCOW](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/aarch64/images/Fedora-Atomic-27-20171110.1.aarch64.qcow2)
    - [Raw image](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/aarch64/images/Fedora-Atomic-27-20171110.1.aarch64.raw.xz)

- ppc64le
    - [ISO](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/Atomic/ppc64le/iso/Fedora-Atomic-ostree-ppc64le-27-20171110.1.iso)
    - [QCOW](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20171110.1.ppc64le.qcow2)
    - [Raw image](https://download.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-27-20171110.1/CloudImages/ppc64le/images/Fedora-Atomic-27-20171110.1.ppc64le.raw.xz)

# Installation

Atomic Host can be installed everywhere regular OSes can: on bare metal, virtual machine, or public or private cloud. If you have some aarch64 or ppc64le hardware, we'd love for you to take Atomic Host for a spin. If you don't want to reformat the machine, one quick way is to run `virt-install` on your box.

`virt-install` is a command line tool which will create a virtual machine based on QEMU emulator with KVM hardware acceleration managed by libvirt on top. Install the appropriate virtualizaton packages for your system, to create and access guest VMs using virt-install in both graphical and console mode.  For example, on Fedora do:

```
$ sudo dnf install @virtualization
```

The above command will install a group of packages: virt-install, qemu-kvm, libvirt-daemon-config-network, libvirt-daemon-kvm, virt-manager and virt-viewer, along with their dependencies. Then, start the libvirtd service if not already running:

```
$ sudo systemctl start libvirtd
```

We can now use the `virt-install` command to run Atomic Host image

```
$ sudo virt-install --name fedora-27-atomic --ram 2048 --vcpus 2 \
  --disk path=/var/lib/libvirt/images/Fedora-Atomic-27.<arch>.qcow2 \
  --os-type linux --os-variant fedora26 --network bridge=virbr0 \
  --graphics vnc,listen=127.0.0.1,port=5901 \
  --cdrom /var/lib/libvirt/images/init.iso --noautoconsole

```

Here, we have assumed that Fedora Atomic qcow2 image and init.iso file are available in `/var/lib/libvirt/images/` directory.

The file `init.iso` is a metadata ISO to provide critical data when Atomic Host boots. Check out [Prep the cloud-init source ISO](http://www.projectatomic.io/docs/quickstart/) to easily create it.
You might need to make other adjustments to the `virt-install` command line above depending upon your requirement.

## Limitations with aarch64

64-bit ARM are available on variations of hardware and installation should work as expected on a server class hardware. However, thre are two major limitations:

- Atomic Host ISOs can be installed only in UEFI mode
- Single board computers (e.g. RPi3, Pine64) are not supported yet

## Features

Atomic Host provides various features, some of them are:

* `Immutable Host`
* `Package Layering` - Additional package(s) can be installed on top of base Atomic Host using package layering.

```
$ sudo rpm-ostree install elfutils
```

* `Running containers` - One can easily run a container image available locally or from a registry. For example, running hello-world container image from docker.io registry on ppc64le machine:

```
$ sudo docker run --rm docker.io/ppc64le/hello-world
```

* `Atomic Update and Rollback` - Atomic Host receives update in the form of a new Atomic OSTree.

```
$ sudo rpm-ostree upgrade
```

Since each operation is atomic, it is also possible to undo changes by using rollback feature.

```
$ sudo rpm-ostree rollback
```

## Reaching out for help

Go ahead and try it out! If you run into issues, you can reach us via:

- Mailing List - [atomic-devel@projectatomic.io](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
- IRC channel - #atomic on Freenode
