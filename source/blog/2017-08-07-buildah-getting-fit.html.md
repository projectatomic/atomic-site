---
title: Buildah Blocks &mdash; Getting Fit
author: tsweeney
date: 2017-08-07 13:00:00 UTC
tags: buildah, fedora, containers
comments: false
published: true
---

Like many other Americans, I am fighting the battle to stay fit and I'm not always winning.  Staying fit can also be a problem in the container environment.  A common problem people have with building container images with tools like Dockerfile and the run-time-based [docker build command](https://docs.docker.com/engine/reference/commandline/build/) is the size of the image, as well as the number of build tools that end up inside of it.  Another concern about these unnecessary tools is they can weaken your container by opening potential venues for hackers to take advantage.

A really nice feature about [Buildah](https://github.com/projectatomic/buildah) is you can strengthen your container making it &quot;stronger and more fit&quot;.  By finely tuning the creation of the container, and then adding or removing pieces as you desire, you can control the size of your container and lessen its vulnerabilities.  It's all under your control.

READMORE

## Building a Buildah Fedora Container That Fits!

Nalin Dahyabhai, the creator of Buildah, gave me a few pointers on how to best illustrate tailoring a container.  I followed those suggestions to build a few containers based on different setups of the Fedora operating system with an installation of nginx.  For the last two containers that I worked with I also installed the minimal glibc language package to get an even smaller footprint there.  To slim the containers down further, he suggested also removing files related to the package installer and other system software.  Here's what I did.

I first started with a fresh install of Fedora 26 on a Virtual Machine (VM) and updated it paying special attention to update the 'runc' package.  At the time of this writing (August 2, 2017), Fedora 26 had just been released days prior and updates were still piling in.  I then installed Buildah by running `dnf install buildah -y` on the VM.

The next step was to make a container from Fedora.  I stored the name of the container in the bash environment variable 'ctrid_fedora' to make it easier for follow on commands.

```
# ctrid_fedora=$(buildah from fedora)
Getting image source signatures
Copying blob sha256:4db9daa7aafd1ea07f24d2ec893833adc17b5a9c5dde4150cf99a5789b3d322e
 72.06 MiB / 72.07 MiB [=======================================================]
Copying config sha256:49236bc2f0da4105c84cfb7238b48879efb489a62fe8536934434cf2072a2319
 0 B / 2.29 KiB [--------------------------------------------------------------]
Writing manifest to image destination
Storing signatures
```

I used the `buildah run` command to enter into the container, and I then removed the dnf directories, files, and the dnf binary.  This was done not only to save space, but to also show the control you can have over the container.  The dnf software self-protects itself and I could have used `rpm -e` to remove it and its long list of dependencies, but for the purpose of this demonstration I decided to just delete the binaries and key files.

```
# buildah run $ctrid_fedora /bin/bash
[root@611687aaa936 /]# rm -rf /var/lib/dnf /usr/bin/dnf /etc/dnf
[root@611687aaa936 /]# exit
```

After exiting from the container and getting back to the host, I then mounted the container on a local mountpoint saving the location in the bash variable named `mnt_fedora`.

```
# mnt_fedora=$(buildah mount $ctrid_fedora)
```

To verify the `mnt_fedora` variable points to the root directory (`/`) of the container, a quick `ls` was in order.

```
# ls $mnt_fedora
bin   dev  home  lib64       media  opt   root  sbin  sys  usr
boot  etc  lib   lost+found  mnt    proc  run   srv   tmp  var
```

Now to shrink the container a bit more and to show how unwanted packages can be removed,  I removed the `shadow-utils` and `libsemanage` packages from the container using `dnf`.  But wait &mdash; didn't we just delete the files that dnf relies on to run?  Yes we did, so I used `dnf` *from the host* to do the removal within the container like this.

```
# dnf remove --installroot $mnt_fedora --releasever 26 shadow-utils libsemanage -y
```

This is one difference between Docker and Buildah containers: you could not remove these dnf files from a Docker container and then easily remove or install additional software on that container.  We now need to install nginx package onto the container.  I again used `dnf` from the host to install on the container like this.

```
# dnf install --installroot $mnt_fedora --releasever 26 nginx --setopt install_weak_deps=false -y
```

Now one last bit of housekeeping to slim down this container.  I'll remove the dnf related logs and the cache files on the system, most of which dnf put in play to make future installs faster.

```
# rm -rf $mnt_fedora/var/cache $mnt_fedora/var/log/dnf*
```

Finally I saved an image of our container so it can be used later to see how much we were able to change it from its original form.

```
# buildah commit $ctrid_fedora my_fedora
```

## Making other Buildah Fedora Containers Fit

Now that I've created a Buildah container with Fedora and made it &quot;fit&quot;, I'm going to use the same process using Fedora-Minimal and &quot;scratch&quot;.  The special variable `scratch` causes the `buildah from` command to create a completely empty container save a few tiny bits of meta-data.

```
# ctrid_minimal=$(buildah from registry.fedoraproject.org/fedora-minimal)
# ctrid_scratch=$(buildah from scratch)
```

I then created the mountpoint variables `$mnt_minimal` and `$mnt_scratch` as handles for these two container images:

```
# mnt_minimal=$(buildah mount $ctrid_minimal)
# mnt_scratch=$(buildah mount $ctrid_scratch)
```

The next step was the `dnf install nginx` command and I also installed the glibc-minimal-langpack package for these two containers .  When `dnf install` is invoked on the scratch container, it installs all of the required packages for the nginx and glibc-minimal-langpack packages and makes the container runnable.

```
# dnf install --installroot $mnt_minimal  --releasever 26 nginx glibc-minimal-langpack --setopt install_weak_deps=false -y
# dnf install --installroot $mnt_scratch  --releasever 26 nginx glibc-minimal-langpack --setopt install_weak_deps=false -y
```

I did not remove the dnf files for either of these containers as it's not installed by default like it is on Fedora.  The `dnf remove` step also isn't necessary on these containers as the shadow-utils and libsemanage packages are also not installed.  To wrap up, I cleaned up the cache and dnf logs on each container and then saved each image with these commands.

```
# rm -rf $mnt_minimal/var/cache $mnt_minimal/var/log/dnf*
# rm -rf $mnt_scratch/var/cache $mnt_scratch/var/log/dnf*

# buildah commit $ctrid_minimal my_minimal
# buildah commit $ctrid_scratch my_scratch
```

Now for the pay off.  Let's `cd` into the mountpoints for our Buildah containers made to fit and check their sizes.  Doing a `cd` to each of these mountpoints is the equivalent of attaching to the container and going to the root directory.  Then I'll use `dnf list` from the host to show how many packages are installed on each container:

```
# cd $mnt_fedora
# du -hs
266M    .
# cd $mnt_minimal
# du -hs
147M    .
# cd $mnt_scratch
# du -hs
136M    .

# dnf list installed --installroot $mnt_fedora | wc -l
183
# dnf list installed --installroot $mnt_minimal | wc -l
145
# dnf list installed --installroot $mnt_scratch | wc -l
95
```

Using buildah images I took a look at the sizes of each image.  (Small confession.  I've reordered the output below to match the order that I created them above.  I also used a currently under development version of `buildah images` as the live version does not show the correct date or size at the time of this writing.)

```
# buildah images
IMAGE ID             IMAGE NAME                                               CREATED AT             SIZE
49236bc2f0da         docker.io/library/fedora:latest                          Jul 20, 2017 17:07     228.9 MB
15bc1f81701b         registry.fedoraproject.org/fedora-minimal:latest         Jul 5, 2017 21:47      111.5 MB
b941e4122799         docker.io/library/my_fedora:latest                       Jul 20, 2017 17:07     262.7 MB
3e19a5e0204f         docker.io/library/my_minimal:latest                      Jul 5, 2017 21:47      194.6 MB
1a30218cb3c0         docker.io/library/my_scratch:latest                      Aug 2, 2017 14:17      128.6 MB
```

As you may notice, the original Fedora image is 228.9 MB in size and our &quot;fit&quot; Fedora image is 263 MB in size.  Wait!  What??? If a diet company was in charge of this slim down, they'd be out of business very quickly.  What's happened in the &quot;fit&quot; image has multiple layers.  The first image at 228.9 MB is still there although now much of it's read-only and on top of it is the smaller image that we created with our `dnf` command that is now read-writable.  This is by design per the [Open Container Initiative](https://www.opencontainers.org/).

But here is where Buildah really helps your containers stay fit.  The image size for the 'scratch' container is 128.6 M, which is smaller than the other Fedora images, including the base Fedora image.  That's because when that container was created there was not an image to start the first layer on.  Our very first image layer was the one that we created with the `dnf` command that put down precisely what we needed for our container.  Nothing less, nothing more.

## Fit Containers via Buildah

As I showed in my [previous post](http://www.projectatomic.io/blog/2017/06/introducing-buildah/), Buildah is able to create and run containers without the Docker daemon even being installed.  Buildah also allows you to easily create smaller, stronger, purpose built containers that precisely fit your needs.  Buildah is an Open Source project that you are very much welcomed to contribute to.  If you're interested in contributing or just want to watch the progress being made, [check out the project in GitHub](https://github.com/projectatomic/buildah).

I hope you found this post to be useful and gets you thinking about how you might make the containers in your own environment even stronger and more fit.  If you come up with other ways to keep your containers fitting your needs, I'd love to hear what you did!
