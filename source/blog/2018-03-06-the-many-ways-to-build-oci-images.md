---
title: The Many Ways to Build an OCI Image without Docker
author: miabbott
date: 2018-03-06 00:00:00 UTC
published: true
comments: false
tags:
- atomic
- buildah
- containers
- docker
- oci
- ostree
- runc
- skopeo
---

When containers initially made their big splash into the industry via Docker,
users were almost required to use the `docker` CLI and daemon to create and
manage their container images.  But a lot has happened since then and now it
is easier than ever to create a container image without using `docker` at all,
since the Docker image format has been standardized as the
[OCI Image format](https://github.com/opencontainers/image-spec).

In this post, we'll review some of the ways you can create and manage your
container images without ever having to start the `docker` daemon.

READMORE

We'll explore these alternative ways to build container images using a
privileged user, but most of the approaches also have a way to build images
using a non-privileged user.  We'll cover using a non-privileged user in a
future blog post.

# orca-build

The project that was probably first to build container images without `docker`
is the [orca-build](https://github.com/cyphar/orca-build) project from
[Aleksa Sarai](https://twitter.com/lordcyphar) of SUSE.  He's created a simple
Python3 script which leverages [runC](https://github.com/opencontainers/runc),
[skopeo](http://github.com/projectatomic/skopeo), and the
[umoci](https://github.com/openSUSE/umoci) library to build container images.

Let's see how it works with this simple Dockerfile that I've created to build
an `httpd` container.

```
$ cat fedora27-httpd/Dockerfile
FROM registry.fedoraproject.org/fedora:27
LABEL maintainer='Micah Abbott <miabbott@redhat.com>' \
      version='1.0'

ENV container=docker

COPY Dockerfile /root/

RUN dnf -y install httpd && \
    dnf clean all && \
    echo "SUCCESS fedora27_httpd" > /var/www/html/index.html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/httpd" ]
CMD [ "-D", "FOREGROUND" ]
```

Using a Fedora 27 system, I'll install the dependencies for using `orca-build`
and then build the container image from the Dockerfile.  (But obviously, I
won't be installing `docker`).

```
# rpm -q docker
package docker is not installed
# systemctl status docker
Unit docker.service could not be found.

# dnf -y install git golang runc skopeo
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOPATH/bin
# go get -d github.com/openSUSE/umoci
# cd $GOPATH/src/github.com/openSUSE/umoci/
# make
# cp $GOPATH/src/github.com/openSUSE/umoci/umoci $GOPATH/bin/
# cd $HOME
# git clone https://github.com/cyphar/orca-build.git
# cd orca-build
# python3 orca-build -t fedora27-httpd:orca $HOME/fedora27-httpd/
orca-build[INFO] Created new image for build: /tmp/orca-build.y3n_2i0m
orca-build[INFO] BUILD[1 of 8]: from ['registry.fedoraproject.org/fedora:27'] [json=False]
  ---> [skopeo]
Getting image source signatures
Copying blob sha256:d445b8c354cc48e75ed621cb6783a80c29ac24135cdd98fd02ae70e1f18345bc
 80.81 MB / 80.81 MB [=====================================================] 10s
Copying config sha256:400ec4f003634cb31d8b37d68ac56c41c6bbd8eb02eb7d7151b0ade59e513594
 424 B / 424 B [============================================================] 0s
Writing manifest to image destination
Storing signatures
  <--- [skopeo]
orca-build[INFO] BUILD[2 of 8]: label ['maintainer=Micah Abbott <miabbott@redhat.com>', 'version=1.0'] [json=False]
  ---> [umoci]
  <--- [umoci]
  ---> [umoci]
  <--- [umoci]
orca-build[INFO] BUILD[3 of 8]: env ['container=docker'] [json=False]
  ---> [umoci]
  <--- [umoci]
  ---> [umoci]
  <--- [umoci]
orca-build[INFO] BUILD[4 of 8]: copy ['Dockerfile', '/root/'] [json=False]
  ---> [umoci]
  <--- [umoci]
  ---> [umoci]
  <--- [umoci]
  ---> [umoci]
  <--- [umoci]
orca-build[INFO] BUILD[5 of 8]: run ['dnf', '-y', 'install', 'httpd', '&&', 'dnf', 'clean', 'all', '&&', 'echo', 'SUCCESS fedora27_httpd', '>', '/var/www/html/index.html'] [json=False]
  ---> [umoci]
  <--- [umoci]
  ---> [runc]
Error: Failed to synchronize cache for repo 'updates'
  <--- [runc]
orca-build[CRITICAL] Error executing subprocess: runc --root=/tmp/orca-runcroot.un2g__rz run --bundle=/tmp/orca-bundle.dw5x64x0 orca-build-6bE2dWZlNxyZELMtkmHjObCb9fAkvMbq failed with error code 1
```

Hmmm...I believe `runc` doesn't have network access to allow `dnf` to install
packages.  That is disappointing.  But I don't want to spend too much time on
any one way of building an image, so let's move on to another method.

# jessfraz/img

[Jessie Frazelle](https://twitter.com/jessfraz) recently announced her own
project called [img](https://github.com/jessfraz/img) that handles building
OCI images without `docker`. Her approach uses a Go binary that leverages
[buildkit](https://github.com/moby/buildkit) from the Moby project to build
images.

Using the same Dockerfile and Fedora 27 system, let's try to build the image.

```
# go get github.com/jessfraz/img
# img build -t fedora27-httpd:img $HOME/fedora27-httpd/
Building fedora27-httpd:img
Setting up the rootfs... this may take a bit.
INFO[0001] resolving docker.io/tonistiigi/copy@sha256:476e0a67a1e4650c6adaf213269a2913deb7c52cbc77f954026f769d51e1a14e
INFO[0001] resolving registry.fedoraproject.org/fedora:27@sha256:3a75aec3625da0c80dcedda6a0321f997f812e24336a1c06d8b402afffc55450
INFO[0010] unpacking registry.fedoraproject.org/fedora:27@sha256:3a75aec3625da0c80dcedda6a0321f997f812e24336a1c06d8b402afffc55450
RUN [copy /src-0/Dockerfile /dest/root/]
--->
<--- e70rtudliv77emdm70tc5m027 0 <nil>
RUN [/bin/sh -c dnf -y install httpd &&     dnf clean all &&     echo "SUCCESS fedora27_httpd" > /var/www/html/index.html]
--->
Fedora 27 - x86_64 - Updates                    8.8 MB/s |  20 MB     00:02
Fedora 27 - x86_64                              6.1 MB/s |  58 MB     00:09
Last metadata expiration check: 0:00:05 ago on Sat Mar  3 21:06:25 2018.
Dependencies resolved.
================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Installing:
 httpd                    x86_64       2.4.29-1.fc27        updates       1.3 M
Installing dependencies:
 apr                      x86_64       1.6.3-1.fc27         updates       121 k
 apr-util                 x86_64       1.6.1-2.fc27         updates       102 k
 fedora-logos-httpd       noarch       28.0.2-1.fc27        updates        33 k
 httpd-filesystem         noarch       2.4.29-1.fc27        updates        25 k
 httpd-tools              x86_64       2.4.29-1.fc27        updates        89 k
 mailcap                  noarch       2.1.48-2.fc27        fedora         37 k
 mod_http2                x86_64       1.10.13-1.fc27       updates       151 k

Transaction Summary
================================================================================
Install  8 Packages

Total download size: 1.9 M
Installed size: 5.0 M
Downloading Packages:
(1/8): httpd-filesystem-2.4.29-1.fc27.noarch.rp  66 kB/s |  25 kB     00:00
(2/8): mailcap-2.1.48-2.fc27.noarch.rpm         431 kB/s |  37 kB     00:00
(3/8): httpd-tools-2.4.29-1.fc27.x86_64.rpm     136 kB/s |  89 kB     00:00
(4/8): apr-1.6.3-1.fc27.x86_64.rpm              319 kB/s | 121 kB     00:00
(5/8): apr-util-1.6.1-2.fc27.x86_64.rpm         338 kB/s | 102 kB     00:00
(6/8): mod_http2-1.10.13-1.fc27.x86_64.rpm      728 kB/s | 151 kB     00:00
(7/8): fedora-logos-httpd-28.0.2-1.fc27.noarch. 332 kB/s |  33 kB     00:00
(8/8): httpd-2.4.29-1.fc27.x86_64.rpm           984 kB/s | 1.3 MB     00:01
--------------------------------------------------------------------------------
Total                                           857 kB/s | 1.9 MB     00:02
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1
  Installing       : apr-1.6.3-1.fc27.x86_64                                1/8
  Running scriptlet: apr-1.6.3-1.fc27.x86_64                                1/8
  Installing       : apr-util-1.6.1-2.fc27.x86_64                           2/8
  Running scriptlet: apr-util-1.6.1-2.fc27.x86_64                           2/8
  Installing       : httpd-tools-2.4.29-1.fc27.x86_64                       3/8
  Installing       : fedora-logos-httpd-28.0.2-1.fc27.noarch                4/8
  Installing       : mailcap-2.1.48-2.fc27.noarch                           5/8
  Running scriptlet: httpd-filesystem-2.4.29-1.fc27.noarch                  6/8
  Installing       : httpd-filesystem-2.4.29-1.fc27.noarch                  6/8
  Installing       : mod_http2-1.10.13-1.fc27.x86_64                        7/8
  Installing       : httpd-2.4.29-1.fc27.x86_64                             8/8
  Running scriptlet: httpd-2.4.29-1.fc27.x86_64                             8/8Failed to connect to bus: No such file or directory

  Verifying        : httpd-2.4.29-1.fc27.x86_64                             1/8
  Verifying        : httpd-filesystem-2.4.29-1.fc27.noarch                  2/8
  Verifying        : httpd-tools-2.4.29-1.fc27.x86_64                       3/8
  Verifying        : mailcap-2.1.48-2.fc27.noarch                           4/8
  Verifying        : apr-1.6.3-1.fc27.x86_64                                5/8
  Verifying        : apr-util-1.6.1-2.fc27.x86_64                           6/8
  Verifying        : mod_http2-1.10.13-1.fc27.x86_64                        7/8
  Verifying        : fedora-logos-httpd-28.0.2-1.fc27.noarch                8/8

Installed:
  httpd.x86_64 2.4.29-1.fc27            apr.x86_64 1.6.3-1.fc27
  apr-util.x86_64 1.6.1-2.fc27          fedora-logos-httpd.noarch 28.0.2-1.fc27
  httpd-filesystem.noarch 2.4.29-1.fc27 httpd-tools.x86_64 2.4.29-1.fc27
  mailcap.noarch 2.1.48-2.fc27          mod_http2.x86_64 1.10.13-1.fc27

Complete!
18 files removed
<--- rx3j12yy3t0ea0shbimrgxtdx 0 <nil>
INFO[0063] exporting layers
INFO[0066] exporting manifest sha256:1fd9c488a4f116e3d02c5ea0d9277994bc8145ea7bb5021442b348b257b7b6e6
INFO[0066] exporting config sha256:ae05d003b8ec6d046eb73ca8d3333a9d6e10bac332af7591a101f6f118f2bf7c
INFO[0066] naming to fedora27-httpd:img
Successfully built fedora27-httpd:img
```

We can also use `img` to list the container image that was just built.

```
# img ls
NAME										SIZE		CREATED AT	UPDATED AT	DIGEST
docker.io/tonistiigi/copy@sha256:476e0a67a1e4650c6adaf213269a2913deb7c52cbc77f954026f769d51e1a14e	1.333KiB	7 days ago	7 days ago	sha256:476e0a67a1e4650c6adaf213269a2913deb7c52cbc77f954026f769d51e1a14e
fedora27-httpd:img								754B		7 days ago	43 hours ago	sha256:1fd9c488a4f116e3d02c5ea0d9277994bc8145ea7bb5021442b348b257b7b6e6
```

That was pretty easy and successful!  There are more things that `img` can
do, but let's continue to expore other ways to build container images.

# DIY Docker using Skopeo+OStree+Runc

[Muayyad Alsadi](https://twitter.com/muayyadalsadi) recently shared his blog
post called [DIY Docker using Skopeo+OStree+Runc](https://bcksp.blogspot.com/2018/02/diy-docker-using-skopeoostreerunc.html)
to the [atomic-devel](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2018-February/msg00087.html)
mailing list.  In his post, he describes using `skopeo` and `ostree` to pull
down existing Docker images and building out a rootfs that can be used by
`runc`.  It is not exactly the same operation as building a container image
from a Dockerfile, but it is a useful exercise to show off some of the gory
details of working with OCI images.

But what if you don't want to have to run multiple `skopeo` and `ostree`
commands to pull down content and prep a container image?  Or maybe you don't
really care about the details of OCI images and you just want to pull a
container image without `docker`?

All of those operations are neatly wrapped up in the [atomic CLI](http://github.com/projectatomic/atomic)
and can be reduced to a single command!

```
 # atomic pull --storage=ostree docker.io/redis:alpine
Getting image source signatures
Copying blob sha256:ff3a5c916c92643ff77519ffa742d3ec61b7f591b6b7504599d95a4a41134e28
 1.97 MB / 1.97 MB [========================================================] 0s
Copying blob sha256:aae70a2e60279ffae89150a59b81fe10d1d81f341ef6f31b9714ea6cc3418577
 1.22 KB / 1.22 KB [========================================================] 0s
Copying blob sha256:87c655da471c9a7d8f946ec7b04a6a72a98ae8c1734bddf4b950861b5638fe20
 8.35 KB / 8.35 KB [========================================================] 0s
Copying blob sha256:a0bd51ac7350a7048a0bd85a83d87181a0b851952e94f70e18c1ddb6ff96e66e
 7.73 MB / 7.73 MB [========================================================] 0s
Copying blob sha256:755565c3ea2b1335705a21024b1bdb607f85492b284e8dec37eb759c0d601f57
 99 B / 99 B [==============================================================] 0s
Copying blob sha256:8bf100ea488d16d4401a9af72879db0c1ab56045b42670ebf64fe1f8d90568fc
 397 B / 397 B [============================================================] 0s
Copying config sha256:d3117424aaee14ab2b0edb68d3e3dcc1785b2e243b06bd6322f299284c640465
 4.68 KB / 4.68 KB [========================================================] 0s
Writing manifest to image destination
Storing signatures
```
And soon, you'll be able to use the very same `atomic` command to run the
container image via `runc`.  Keep your eyes open for new versions of `atomic`
that will include this [pull request](https://github.com/projectatomic/atomic/pull/1196)
from [Giuseppe Scrivano](https://twitter.com/gscrivano).

There's one more way to build container images that we'll cover before
wrapping up this post.

# Use This One Weird Command to Build OCI Images!

Maybe you are thinking, "Gee, it's great that we have all these ways to build
container images without Docker, but I'd really like a tool that highlights my
Boston accent."

Enter [buildah](https://github.com/projectatomic/buildah)!

You've probably already seen this tool mentioned on this blog a few times,
but it's worth showing off another time just how easy it is to install and use.
We'll continue to use the same Dockerfile and Fedora 27 system to build our
image.

```
# dnf install buildah
# buildah bud -t fedora27_httpd:buildah $HOME/fedora27-httpd/
STEP 1: FROM registry.fedoraproject.org/fedora:27
Getting image source signatures
Copying blob sha256:d445b8c354cc48e75ed621cb6783a80c29ac24135cdd98fd02ae70e1f18345bc
 80.81 MiB / 80.81 MiB [===================================================] 32s
Copying config sha256:99b71991af6eef73e85e3a657641cf2447929f37fff1f9570d525a6ef485a4a8
 1.27 KiB / 1.27 KiB [======================================================] 0s
Writing manifest to image destination
Storing signatures
STEP 2: LABEL maintainer='Micah Abbott <miabbott@redhat.com>'       version='1.0'
STEP 3: ENV container=docker
STEP 4: COPY Dockerfile /root/
STEP 5: RUN dnf -y install httpd &&     dnf clean all &&     echo "SUCCESS fedora27_httpd" > /var/www/html/index.html
Fedora 27 - x86_64 - Updates                    3.0 MB/s |  20 MB     00:06
Fedora 27 - x86_64                              1.6 MB/s |  58 MB     00:35
Last metadata expiration check: 0:00:08 ago on Mon Mar  5 16:02:41 2018.
Dependencies resolved.
================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Installing:
 httpd                    x86_64       2.4.29-1.fc27        updates       1.3 M
Installing dependencies:
 apr                      x86_64       1.6.3-1.fc27         updates       121 k
 apr-util                 x86_64       1.6.1-2.fc27         updates       102 k
 fedora-logos-httpd       noarch       28.0.2-1.fc27        updates        33 k
 httpd-filesystem         noarch       2.4.29-1.fc27        updates        25 k
 httpd-tools              x86_64       2.4.29-1.fc27        updates        89 k
 mailcap                  noarch       2.1.48-2.fc27        fedora         37 k
 mod_http2                x86_64       1.10.13-1.fc27       updates       151 k

Transaction Summary
================================================================================
Install  8 Packages

Total download size: 1.9 M
Installed size: 5.0 M
Downloading Packages:
(1/8): httpd-filesystem-2.4.29-1.fc27.noarch.rp 107 kB/s |  25 kB     00:00
(2/8): httpd-tools-2.4.29-1.fc27.x86_64.rpm     208 kB/s |  89 kB     00:00
(3/8): mailcap-2.1.48-2.fc27.noarch.rpm         127 kB/s |  37 kB     00:00
(4/8): apr-util-1.6.1-2.fc27.x86_64.rpm         452 kB/s | 102 kB     00:00
(5/8): apr-1.6.3-1.fc27.x86_64.rpm              305 kB/s | 121 kB     00:00
(6/8): fedora-logos-httpd-28.0.2-1.fc27.noarch. 355 kB/s |  33 kB     00:00
(7/8): mod_http2-1.10.13-1.fc27.x86_64.rpm      699 kB/s | 151 kB     00:00
(8/8): httpd-2.4.29-1.fc27.x86_64.rpm           1.1 MB/s | 1.3 MB     00:01
--------------------------------------------------------------------------------
Total                                           933 kB/s | 1.9 MB     00:02
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1
  Installing       : apr-1.6.3-1.fc27.x86_64                                1/8
  Running scriptlet: apr-1.6.3-1.fc27.x86_64                                1/8
  Installing       : apr-util-1.6.1-2.fc27.x86_64                           2/8
  Running scriptlet: apr-util-1.6.1-2.fc27.x86_64                           2/8
  Installing       : httpd-tools-2.4.29-1.fc27.x86_64                       3/8
  Installing       : fedora-logos-httpd-28.0.2-1.fc27.noarch                4/8
  Installing       : mailcap-2.1.48-2.fc27.noarch                           5/8
  Running scriptlet: httpd-filesystem-2.4.29-1.fc27.noarch                  6/8
  Installing       : httpd-filesystem-2.4.29-1.fc27.noarch                  6/8
  Installing       : mod_http2-1.10.13-1.fc27.x86_64                        7/8
  Installing       : httpd-2.4.29-1.fc27.x86_64                             8/8
  Running scriptlet: httpd-2.4.29-1.fc27.x86_64                             8/8
Failed to connect to bus: No such file or directory
  Verifying        : httpd-2.4.29-1.fc27.x86_64                             1/8
  Verifying        : httpd-filesystem-2.4.29-1.fc27.noarch                  2/8
  Verifying        : httpd-tools-2.4.29-1.fc27.x86_64                       3/8
  Verifying        : mailcap-2.1.48-2.fc27.noarch                           4/8
  Verifying        : apr-1.6.3-1.fc27.x86_64                                5/8
  Verifying        : apr-util-1.6.1-2.fc27.x86_64                           6/8
  Verifying        : mod_http2-1.10.13-1.fc27.x86_64                        7/8
  Verifying        : fedora-logos-httpd-28.0.2-1.fc27.noarch                8/8

Installed:
  httpd.x86_64 2.4.29-1.fc27            apr.x86_64 1.6.3-1.fc27
  apr-util.x86_64 1.6.1-2.fc27          fedora-logos-httpd.noarch 28.0.2-1.fc27
  httpd-filesystem.noarch 2.4.29-1.fc27 httpd-tools.x86_64 2.4.29-1.fc27
  mailcap.noarch 2.1.48-2.fc27          mod_http2.x86_64 1.10.13-1.fc27

Complete!
18 files removed
STEP 6: EXPOSE 80
STEP 7: ENTRYPOINT [ "/usr/sbin/httpd" ]
STEP 8: CMD [ "-D", "FOREGROUND" ]
STEP 9: COMMIT containers-storage:[overlay@/var/lib/containers/storage+/var/run/containers/storage:overlay.override_kernel_check=true]docker.io/library/fedora27_httpd:buildah
[root@fedora27cloud-dev ~]# buildah images
IMAGE ID             IMAGE NAME                                               CREATED AT             SIZE
99b71991af6e         registry.fedoraproject.org/fedora:27                     Mar 1, 2018 07:48      234.9 MB
c3fddc394f81         docker.io/library/fedora27_httpd:buildah                 Mar 5, 2018 16:03      252 MB

```

On my Fedora 27 host, I just needed two commands to install `buildah` and
build the container image!  When you pair `buildah` with `atomic`, you have
a powerful combination of tools that will allow you to build, manage, and run
your container images without ever having to run the Docker daemon.
