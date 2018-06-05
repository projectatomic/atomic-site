---
title: Building Kernel Modules with Podman
author: jdoss
date: 2018-06-06
layout: post
comments: true
categories:
- Blog
tags:
- atomic
- containers
- fedora
- kernel modules
- libpod
- podman
---

# Building Kernel Modules on Atomic with Podman

The goal of this post is to explain how to build and load a kernel module inside a container using Podman.

Building and using third party kernel modules on Atomic is a challenging task. There are a handful of methods for supporting kernel modules on a Linux system such as kmods, akmods, DKMS, and manually building them by hand. Digging into all of the technical hurdles Atomic faces with each method is a very large topic and a bit out of scope for this blog post, so we will focus on DKMS for the time being.

Using [DKMS](https://github.com/dell/dkms) on Atomic does not work as [expected](https://github.com/projectatomic/rpm-ostree/issues/1091). This means using popular third party kernel modules such as NVidia drivers, VirtualBox, and WireGuard via their supported install methods will not work as a result, but I will explain how we can work around these limitations in this blog post.

READMORE

## Fedora Atomic and Kernel Modules

There are a few technical reasons on why building a kernel module inside of a container is a quick path for getting a third party kernel module built and loaded on Fedora Atomic Host.

The first is all kernel modules must be built to match the version of the current running kernel,  meaning we have to ensure that the kernel module is built consistently for every new kernel for it to work correctly.

The second is the fact that most of the file system on Atomic is read only.  Most third party kernel modules have their source stored in `/usr/src` and once they are built, they are stored in `/usr/lib/modules`. Since both paths are immutable, this makes using a container ideal to build and store the kernel module.

The last surrounds how packages are created in the bi-weekly Fedora Atomic Host composes. The `kernel-devel` packages sometimes do not match up with the kernel that is being shipped in these bi-weekly updates. This means consistently getting the correct `kernel-devel` packages can be challenging. If we build the kernel module inside a container, we can pull in the correct `kernel-devel` packages from [Koji](https://koji.fedoraproject.org/koji/packageinfo?packageID=8) for the booted kernel to build the module.

## Building a Kernel Module with Podman

In this example we are building the [WireGuard](https://www.wireguard.com) kernel module, which is an extremely simple yet fast and modern VPN. For non-Atomic Fedora/CentOS/RHEL based installs, you can use the `wireguard-dkms` [RPM](https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/). It uses DKMS to build and load the kernel module on boot. This doesn't help us get WireGuard running on Atomic as it will only result in failure. This leads us to building the kernel module inside of a container.

Let's Check out the Dockerfile below:

```
FROM fedora as builder
MAINTAINER "Joe Doss" <joe@solidadmin.com>

ARG WIREGUARD_VERSION
ARG WIREGUARD_KERNEL_VERSION
ARG WIREGUARD_SHA256

WORKDIR /tmp

RUN dnf update -y && dnf install \
        libmnl-devel elfutils-libelf-devel findutils binutils boost-atomic boost-chrono \
        boost-date-time boost-system boost-thread cpp dyninst efivar-libs gc \
        gcc glibc-devel glibc-headers guile koji isl libatomic_ops libdwarf libmpc \
        libpkgconf libtool-ltdl libxcrypt-devel make mokutil pkgconf pkgconf-m4 \
        pkgconf-pkg-config unzip zip /usr/bin/pkg-config xz -y && \
        koji download-build --rpm --arch=x86_64 kernel-core-${WIREGUARD_KERNEL_VERSION} && \
        koji download-build --rpm --arch=x86_64 kernel-devel-${WIREGUARD_KERNEL_VERSION} && \
        koji download-build --rpm --arch=x86_64 kernel-modules-${WIREGUARD_KERNEL_VERSION} && \
        dnf install kernel-core-${WIREGUARD_KERNEL_VERSION}.rpm \
        kernel-devel-${WIREGUARD_KERNEL_VERSION}.rpm \
        kernel-modules-${WIREGUARD_KERNEL_VERSION}.rpm -y && \
        dnf clean all && \
        curl -LS https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${WIREGUARD_VERSION}.tar.xz | \
        { t="$(mktemp)"; trap "rm -f '$t'" INT TERM EXIT; cat >| "$t"; sha256sum --quiet -c <<<"${WIREGUARD_SHA256} $t" \
        || exit 1; cat "$t"; } | tar xJf -

WORKDIR /tmp/WireGuard-${WIREGUARD_VERSION}/src

RUN KERNELDIR=/usr/lib/modules/${WIREGUARD_KERNEL_VERSION}/build make -j$(nproc) && make install
```

Stepping through the above, we are going to point out the key aspects. At the very start, we pass in three `ARG` directives. These are `WIREGUARD_VERSION`, `WIREGUARD_KERNEL_VERSION` and `WIREGUARD_SHA256`. We use these to pass in three variables: the booted kernel version of the Fedora 28 Atomic Host node, the version of WireGuard to build, and the SHA265 sum of the WireGuard source tarball.

The `RUN` directive installs all of the packages required to build the WireGuard kernel module. It also uses `koji` to download the correct package versions of `kernel-core`, `kernel-devel`, and `kernel-modules` and it then installs them so it matches the current booted kernel of the Fedora Atomic Host node. From there it checks the SHA256 on the WireGuard source archive and extracts the it to `/usr/src`. Finally, it builds and installs the kernel module inside the container.

Since Podman supports multi-stage Dockerfiles, we use a second stage without all of the extra installed packages that were required to build the kernel module and we copy over the `wireguard.ko` file and the `wg` binary to be used in the final container image.

```
FROM fedora
MAINTAINER "Joe Doss" <joe@solidadmin.com>

ARG WIREGUARD_KERNEL_VERSION

WORKDIR /tmp

RUN dnf update -y && dnf install kmod koji -y && \
        koji download-build --rpm --arch=x86_64 kernel-core-${WIREGUARD_KERNEL_VERSION} && \
        koji download-build --rpm --arch=x86_64 kernel-modules-${WIREGUARD_KERNEL_VERSION} && \
        dnf install /tmp/kernel-core-${WIREGUARD_KERNEL_VERSION}.rpm \
        kernel-devel-${WIREGUARD_KERNEL_VERSION}.rpm \
        kernel-modules-${WIREGUARD_KERNEL_VERSION}.rpm -y && \
        dnf clean all && rm -f /tmp/*.rpm

COPY --from=builder /usr/lib/modules/${WIREGUARD_KERNEL_VERSION}/extra/wireguard.ko \
                    /usr/lib/modules/${WIREGUARD_KERNEL_VERSION}/extra/wireguard.ko

COPY --from=builder /usr/bin/wg /usr/bin/wg

CMD /usr/bin/wg
```

Using `podman build` we can pass in the required variables using `--build-arg` to build the container and tag it with the `WIREGUARD_VERSION`. To save time, we are using the `podman build` feature to pull the Dockerfile from a [git repository](https://github.com/projectatomic/libpod/blob/master/docs/podman-build.1.md#building-an-image-using-a-git-repository). This will checkout the git repo to a temporary location and use the Dockerfile in the project root for the build context.

```
export WIREGUARD_VERSION=0.0.20180531
export WIREGUARD_KERNEL_VERSION=$(uname -r)
export WIREGUARD_SHA256=ff653095cc0e4c491ab6cd095ddf5d1db207f48f947fb92873a73220363f423c

sudo podman build --build-arg WIREGUARD_VERSION=${WIREGUARD_VERSION} \
    --build-arg WIREGUARD_SHA256=${WIREGUARD_SHA256} \
    --build-arg WIREGUARD_KERNEL_VERSION=${WIREGUARD_KERNEL_VERSION} \
    -t wireguard:${WIREGUARD_VERSION} git://github.com/jdoss/atomic-wireguard
```

Once the kernel module is done building you can view the container using `podman images`.

```
$ sudo podman images
REPOSITORY                 TAG            IMAGE ID       CREATED              SIZE
docker.io/library/fedora   latest         cc510acfcd70   4 weeks ago          263MB
localhost/wireguard        0.0.20180531   c035e1bd76da   About a minute ago   741MB
```

You can now load the kernel module on Fedora Atomic Host using the following:

```
export WIREGUARD_VERSION=0.0.20180531
export WIREGUARD_KERNEL_VERSION=$(uname -r)

sudo podman run --name wireguard -e "WIREGUARD_VERSION=${WIREGUARD_VERSION}" \
     -e "WIREGUARD_KERNEL_VERSION=${WIREGUARD_KERNEL_VERSION}" --rm --privileged \
     wireguard:${WIREGUARD_VERSION} modprobe udp_tunnel

sudo podman run --name wireguard -e "WIREGUARD_VERSION=${WIREGUARD_VERSION}" \
     -e "WIREGUARD_KERNEL_VERSION=${WIREGUARD_KERNEL_VERSION}" --rm --privileged \
     wireguard:${WIREGUARD_VERSION} modprobe ip6_udp_tunnel

sudo podman run --name wireguard -e "WIREGUARD_VERSION=${WIREGUARD_VERSION}" \
     -e "WIREGUARD_KERNEL_VERSION=${WIREGUARD_KERNEL_VERSION}" --rm --privileged \
     wireguard:${WIREGUARD_VERSION} \
     insmod /usr/lib/modules/${WIREGUARD_KERNEL_VERSION}/extra/wireguard.ko
```

and then we can verify that it is loaded:

```
$ lsmod |grep wireguard
wireguard             229376  0
ip6_udp_tunnel         16384  1 wireguard
udp_tunnel             16384  1 wireguard
```

From there you can use the built container to call the WireGuard `wg` binary to setup your WireGuard VPN on Fedora Atomic Host.

```
export WIREGUARD_VERSION=0.0.20180531
export WIREGUARD_KERNEL_VERSION=$(uname -r)

sudo podman run --name wireguard -e "WIREGUARD_VERSION=${WIREGUARD_VERSION}" \
-e "WIREGUARD_KERNEL_VERSION=${WIREGUARD_KERNEL_VERSION}" --rm --privileged \
wireguard:${WIREGUARD_VERSION} /usr/bin/wg --help
Usage: /usr/bin/wg <cmd> [<args>]

Available subcommands:
  show: Shows the current configuration and device information
  showconf: Shows the current configuration of a given WireGuard interface, for use with `setconf'
  set: Change the current configuration, add peers, remove peers, or change peers
  setconf: Applies a configuration file to a WireGuard interface
  addconf: Appends a configuration file to a WireGuard interface
  genkey: Generates a new private key and writes it to stdout
  genpsk: Generates a new preshared key and writes it to stdout
  pubkey: Reads a private key from stdin and writes a public key to stdout
You may pass `--help' to any of these subcommands to view usage.

```

All of the above is an example of a manual process for building a kernel module on Atomic. In order to provide an automated DKMS-like experience you can check out the [atomic-wireguard](https://github.com/jdoss/atomic-wireguard) project on GitHub and [Copr](https://https://copr.fedorainfracloud.org/coprs/jdoss/atomic-wireguard/).

The goal of the `atomic-wireguard` project is to automate the process of building the WireGuard kernel module with Podman on boot by using a build script called via systemd unit. It hopefully can be used as a stopgap to help support third party kernel modules on Atomic until official kernel module support is figured out. If you have any questions, please feel free to reach out to me (`jdoss`) on Freenode in either the `#atomic` or `#wireguard` channels or on Twitter [@jdoss](https://twitter.com/jdoss).

Special thanks to the Project Atomic and libpod teams. Especially Dan Walsh, Dusty Mabe, Tom Sweeney, Matthew Heon, and Colin Walters for their patient help and guidance on this endeavor.
