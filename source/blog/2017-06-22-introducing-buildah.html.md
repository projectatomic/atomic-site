---
title: Buildah - build your containers from the ground up!
author: tsweeney
date: 2017-06-22 15:00:00 UTC
tags: containers, images, docker, buildah, oci
comments: true
published: true
---

Since I'm relatively new to the world of containers and images, I was excited to learn about [the Buildah tool](https://github.com/projectatomic/buildah).  Especially since I'm a native New Englander and it's a clever play on how we say Builder in these parts.

Buildah is a newly released command line tool for efficiently and quickly building [Open Container Initiative](https://www.opencontainers.org/) (OCI) compliant images and containers.  Buildah simplifies the process of creating, building and updating images while decreasing the learning curve of the container environment.  It is easily scriptable and can be used in an environment where one needs to spin up containers automatically based on calls from your application.  What's really neat is there is no requirement for a container runtime daemon to be running on your system chewing up resources and complicating the build process.

READMORE

## Testing Environment

Just to let you know my testing environment,  I'm running Red Hat Enterprise Linux (RHEL) version 7 on a Lenovo T460p laptop (Dual Core Intel Core i7-6820HQ processor, 16GB of memory and a solid state drive) over a VPN on 50/50 Verizon FIOS.  I then used Virtual Machine Manager to create a [Fedora 26 Beta](https://fedoramagazine.org/announcing-the-release-of-fedora-26-beta/) virtual machine (VM) with 2GB of memory and 20GB of disk space.  I installed and ran Buildah on this Fedora VM.

## Setting Up Buildah

Before you can run Buildah, you need to install it.  One way is using the package which is now available on Fedora:

```
# dnf -y install buildah
```

If the Buildah package is not available on your Linux distribution, or you would like to contribute to the project, you can [clone it from GitHub](https://github.com/projectatomic/buildah).  The configuration and installation process there is straightforward and is documented in the README.md file.  To configure and install Buildah using this method, I spun up my Fedora 26 Beta virtual machine (VM) and then installed the following packages using dnf on it.

```
# dnf -y install make golang bats btrfs-progs-devel \
  device-mapper-devel gpgme-devel libassuan-devel \
  git bzip2 go-md2man runc skopeo-containers
```

After that completed I then did the following, as documented in the README.md, to build Buildah itself:

```
# mkdir ~/buildah
# cd ~/buildah
# export GOPATH=`pwd`
# git clone https://github.com/projectatomic/buildah \
 ./src/github.com/projectatomic/buildah
# cd ./src/github.com/projectatomic/buildah
# make
# make install
```

To verify the install:

```
# buildah --help
```

After installing Buildah via either method  you should be able to run `man buildah` and see all of the man pages associated with the tool.  From here you can get detailed examples of each of the commands.

## Let's Play!

Now for the fun stuff.  I wanted to set up a little container running Fedora from the docker registry.  I simply issue the following command in BASH which sets my variable named `container` to the container's name for use later on :

```
# container=$(buildah from fedora)
Getting image source signatures
Copying blob  sha256:691bc14ee27487db536172a1fcdbbf956f460d1e1e1b201828e3a2bab81c5ec8
 72.22 MiB / 72.22 MiB   [=======================================================]
Copying config sha256:15895ef0b3b2b4e61bf03d38f82b42011ff7f226c681705a4022ae3d1d643888
 0 B / 2.29 KiB [--------------------------------------------------------------]
Writing manifest to image destination
Storing signatures
```

This command completed relatively quickly for me (26 seconds), and most of that time was used for the initial download of the Fedora base image.

Now I can verify that the image has been pulled and the container has been setup by using the buildah images and buildah containers commands respectively:

```
# buildah images
IMAGE ID     IMAGE NAME
dc3a60619440 docker.io/library/fedora:latest
# buildah containers
CONTAINER ID IMAGE ID     IMAGE NAME CONTAINER NAME
ae93de45778a dc3a60619440 fedora     fedora-working-container
```
## Look Ma!  No container runtime is running!

We've now downloaded an image we can manipulate, without using the Docker daemon or even having it installed on the system:

```
# systemctl status docker
Unit docker.service could not be found.
# rpm -qa docker
#
```

We don't need any other container runtime, either.  This is very useful because it makes Buildah easily embeddable in automation scripts and inside other container-building tools, since neither a server process nor root access are required.

## Manipulating the Image

In the initial buildah `from` command, I saved the container name in the `$container` variable, and I can now use that variable to manipulate the container.   First, let's mount the container on a local mount point, saving the location of the mount point in the `$mountpoint` variable and then we'll add a file from our local system into our container.  To do this, we use:

```
# mountpoint=$(buildah mount $container)
```

Now that we've the mountpoint in hand, let's play around a bit with it:

```
# ls $mountpoint
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
# cat /tmp/moveit.txt
Move this file to the Buildah container's /tmp directory.
# ls $mountpoint/tmp
anaconda-post.log  ks-script-64xpp1a9  ks-script-sw0bp7j4
# cp /tmp/moveit.txt $mountpoint/tmp
# ls $mountpoint/tmp
anaconda-post.log  ks-script-64xpp1a9  ks-script-sw0bp7j4  moveit.txt
# cat $mountpoint/tmp/moveit.txt
Move this file to the Buildah container's /tmp directory.
```

So in under 30 seconds we were able to pull down an image from a registry, create a corresponding container and then manipulate that container.  We now have a container that's unique to our needs, so let's save an image of it.  The `buildah commit` command creates a new image which will let us replicate the container later as we need to.  After we create and save the image we'll remove the first container that we created and then create a second container from our newly created image.  With luck our `moveit.txt` file will be in the new container's /tmp directory!

Let's create an image based upon our container.

```
# buildah commit $container containers-storage:first-new-image
# buildah images
IMAGE ID        IMAGE NAME
dc3a60619440 docker.io/library/fedora:latest
54e012885dcf docker.io/library/first-new-image:latest
```

Now let's clean up our containers leaving only our images behind.

```
# buildah umount "$container"
# buildah rm "$container"
ae93de45778a5f3905c52de9378f14d54c2617e4336766efde6311596541e98c
# buildah containers  # No more containers
```

If we want to create a new container using the saved image, we just execute the following:

```
# container2=$(buildah from first-new-image)
# buildah containers
CONTAINER ID IMAGE ID     IMAGE NAME      CONTAINER NAME
757b5b595f0a 54e012885dcf first-new-image first-new-image-working-container
```

Let's mount the container on a local mount point:

```
# mountpoint2=$(buildah mount $container2)
```

Now check to see if our `moveit.txt` file is in the new container that we created from the image.

```
# ls $mountpoint2/tmp  # Let's see if our file is there
anaconda-post.log  ks-script-64xpp1a9  ks-script-sw0bp7j4  moveit.txt
# cat $mountpoint2/tmp/moveit.txt
Move this file to the Buildah container's /tmp directory.
```

With just a few very scriptable steps we were able to create an image from the container that we had built and modified to fit our needs.  With this image in hand, we can then generate as many new containers as we need in the future based on that image.

## Using Dockerfiles

I'm sure folks with a lot more container time under their belts than I will have many Dockerfile specification files lying around.  These too can be used by Buildah to create a new image.  For instance let's look at this simple Dockerfile that runs a little “Hello World” python script.

```
FROM python
ADD HelloFromContainer.py /
CMD ["python","./HelloFromContainer.py"]
```

The HelloFromContainer.py file simply contains:

```
#!/usr/bin/env python3
#

import sys

def main(argv):
    for i in range(0,10):
        print ("Hello World from Container Land! Message # [%d]" % i)

if __name__ == "__main__":
    main(sys.argv[1:])
```

Let's put it all together and run the container.  First we'll create an image based on our DockerFile.

```
# ls HelloFromContainer.py
HelloFromContainer.py
# ls Dockerfile
Dockerfile
# buildah bud -t hellofromcontainer .
STEP 1: FROM python
Getting image source signatures
Copying blob sha256:ef0380f84d05d3cdc5a5f66023 ...
 49.55 MiB / 50.13 MiB [==========================]
...
Copying config sha256:74145628c3310c1a8634aa04 ...
 0 B / 6.91 KiB [---------------------------------]
Writing manifest to image destination
Storing signatures
STEP 2: ADD HelloFromContainer.py /
STEP 3: CMD ["python","./HelloFromContainer.py"]
STEP 4: COMMIT containers-storage:[overlay@/var/lib/containers/storage]docker.io/library/hellofromcontainer:latest
 6.91 KiB / 6.91 KiB [============================]
```

For those wondering at home, this `buildah bud` command completed in 2 minutes and 3 seconds.  The first two minutes of that time was spent in `STEP 1` which pulls down the bits to run Python.  Now let's check that the image got created.

```
# buildah images
IMAGE ID        IMAGE NAME
dc3a60619440 docker.io/library/fedora:latest
54e012885dcf docker.io/library/first-new-image:latest
35de96ee8fb5 docker.io/library/python:latest
f19ac91f7e60 docker.io/library/hellofromcontainer:latest
```

And let's build the container from that image:

```
# buildah from hellofromcontainer
hellofromcontainer-working-container
# buildah containers
CONTAINER ID IMAGE ID        IMAGE NAME      CONTAINER NAME
757b5b595f0a 54e012885dcf first-new-image first-new-image-working-container
8cf6034f22e3 f19ac91f7e60 hellofromcontainer hellofromcontainer-working-container
```

This `buildah from` command finished in a second.  Now let's run our new container!

```
# buildah run hellofromcontainer-working-container
Hello World from Container Land! Message # [0]
Hello World from Container Land! Message # [1]
Hello World from Container Land! Message # [2]
Hello World from Container Land! Message # [3]
Hello World from Container Land! Message # [4]
Hello World from Container Land! Message # [5]
Hello World from Container Land! Message # [6]
Hello World from Container Land! Message # [7]
Hello World from Container Land! Message # [8]
Hello World from Container Land! Message # [9]
```

## Give Buildah a Try

The Buildah command line tool simplifies the administration needed for containers and allows them to be run without the overhead of a container daemon on your system.  Buildah also allows you to create smaller containers with less overhead within them.  I've just started to dive into containers and Buildah both, it's easy to see how this would be a great tool for a DevOps environment or any other environment that needs to easily spin up containers efficiently and cheaply.  I hope you find Buildah to be useful in your environments too and I'd love to hear what you think!
