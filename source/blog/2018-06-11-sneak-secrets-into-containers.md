---
title: How to sneak secrets into your containers, without leaving a trace
author: dwalsh
date: 2018-06-11 00:00:00 UTC
layout: post
comments: false
categories:
- atomic
- buildah
- containers
---

# Default mounts for all of your containers.

I was presenting [OpenShift](https://www.openshift.com/) and really the underlying container technology we are building [CRI-O](https://github.com/kubernetes-incubator/cri-o), [Buildah](https://github.com/projectatomic/buildah) and [Podman](https://github.com/projectatomic/libpod) to some customers the other day.  After the presentation, one of the customers came over to me and said, the biggest problem they have with their users building containers, was they needed to use certificates in the container in order to access their software repositories.  But they did not want the certificates to end up embedded in the containers.  I pointed out that [Red Hat’s version of Docker](https://github.com/projectatomic/docker) allowed you to do volume mounts into containers during a `docker build`.  Also Buildah had the same functionality.  But he pointed out that they did not want everyone of their engineers to have to add the volumes, or if they were running a container and wanted to update software and they forgot the volume mount then they could not access the certificates.  

READMORE

## SECRETS PATCH

This reminded me of the first patch that we ever added the the upstream Docker package, the secrets patch.  We called it this because we needed to inject the RHEL subscription secrets into every container so that yum update would work inside of a container, using the host certificates.  If you grab Docker-ce or Docker-ee you don’t have this patch, so every RHEL container that you build needs to have its own subscription.

When we talked about this secrets patch with customers over the years they wanted us to extend it so that they could inject their own secrets or content into containers.

## BUILDAH, PODMAN, CRI-O support.

Anyways I realized that all of our new products had support for this.  We support a file called mounts.conf that has a simple SRC:DEST format for volume mounting the SRC directory into every container you use, no matter which of the tools above you use.

```
man buildah
…
       mounts.conf (/usr/share/containers/mounts.conf and optionally /etc/containers/mounts.conf)

              The mounts.conf files specify volume mount directories that are automatically mounted inside containers when executing the `buildah run` or `buildah build-using-dockerfile` commands.  Container process can then use this content.  The volume mount content does not get committed to the final image.

              Usually these directories are used for passing secrets or credentials required by the package software to access remote package repositories.

              For example, a mounts.conf with the line "`/usr/share/rhel/secrets:/run/secrets`", the content of `/usr/share/rhel/secrets` directory is mounted on `/run/secrets` inside the container.  This mountpoint allows Red Hat Enterprise Linux subscriptions from the host to be used within the container.

              Note this is not a volume mount. The content of the volumes is copied into container storage, not bind mounted directly from the host.
```

As explained above the content ends up in the container’s storage, and is private to the container.  If these directories or files are modified on the host system after the container is created, the changes will not show up inside the container.  The container has its own private copy.  The private copy does not get committed to the final image, if the container is committed.  

To demonstrate this functionality for the customer, and I created a directory:

```
mkdir /var/lib/walsh
```

I added a file to it.

```
touch /var/lib/walsh/dan
```

Now I added a line to /etc/containers/mounts.conf

```
echo “/var/lib/walsh:/run/walsh” >> /etc/containers/mounts.conf
```

When I run any container image the `/run/walsh` directory shows up and contains the `dan` file.

```
podman run -ti fedora ls /run/walsh
dan
```

I also created a Dockerfile

```
Cat > Dockerfile < _EOF
FROM rhel7
RUN ls -l /run/walsh
_EOF
```
Executed Buildah
```
# buildah bud -t secrets .
buildah bud -t secrets -f Dockerfile.RHEL ~
STEP 1: FROM rhel7
STEP 2: RUN ls -l /run/walsh
total 0
-rwx------. 1 root root 0 Jun  6 13:25 dan
STEP 3: COMMIT containers-storage:[overlay@/var/lib/containers/storage+/var/run/containers/storage:.override_kernel_check=true]localhost/secrets:latest
Getting image source signatures
Skipping fetch of repeat blob sha256:f4fa6c253d2ff944ef6975be17cd0bb59896b386f9e2b737539400a37a68a80b
Skipping fetch of repeat blob sha256:d6a4dd6ace1f76d1410e389c23e515a09eda880da05850b4343e2b39b6ced363
Copying blob sha256:bbcf34dcd633ea7ac67e53ab64a71b5cbf7c019c376b372c5bb9cba997bef67e
 119 B / 119 B [============================================================] 0s
Copying config sha256:380d63f99748e885dc31bcf6ff94a6a050d17dd1a6c3c61ca6180c6d32ffebb5
 3.09 KiB / 3.09 KiB [======================================================] 0s
Writing manifest to image destination
Storing signatures
380d63f99748e885dc31bcf6ff94a6a050d17dd1a6c3c61ca6180c6d32ffebb5
```

As you see in the above example the `/run/walsh/dan` content is in the build environment.  

Now I want to examine the actual containers image layer before committing, to make sure the `dan` file does not end up in the final image, if it was committed.

I will create a container `secretctr` based on the `secret` image using podman.

```
# ./bin/podman create --name secretctr -ti secrets ls -l /run/walsh
Fcec8526624adf9b2173cf9cd359d80a1e1dde92165ba6a1bc80ca5275075278
```

Now I will mount and examine the container images /run/walsh directory.

```
# mnt=$(podman mount secretctr)
# ls $mnt/run
# ls $mnt/run/walsh
#
```

Note the `walsh` directory gets created since this is the mount point necessary for the volume, but the content is not in the container image.  There is no `dan` file.

Now if I actually start the container, it will show the `dan` file.

```
# podman start --attach secret1
total 0
-rwx------. 1 root root 0 Jun  6 14:34 dan
```

When we create the running container, the containers storage copy of the mounts directory gets mounted and the `dan` file becomes available.

## BOTTOM LINE

We have added a long sought after feature to our tools, to allow the injecting of secrets or other content into containers, without this content ending up in the container image. This allows all of your containers to take advantage of content on the host inside of your containers.
