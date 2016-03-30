---
title: Increasing the Base Device Size on Docker Daemon Restart
author: shishir
date: 2016-03-30 15:45:00 UTC
tags: Docker, docker-storage
published: true
comments: true
---
Sometime back I wrote [a feature for docker to allow expanding Base device size on daemon restart](https://github.com/docker/docker/pull/19123).  This feature has been included in Docker 1.10, so you can try it out now.

Before we jump further into this article, I would like to point out that this feature is only available for devicemapper storage and does not apply to other storage drivers like overlay, btrfs, aufs, etc.

READMORE

## Base Device Size

If you do `docker info`, you will see base device size in the output.

![docker_info_1](./docker_info_1.png)

So what is this base device size? The first time docker is started, it sets up a base device with a default size of 10 GB. All future images and containers would be a snapshot of this base device.

Base size is the *maximum* size that a container/image can grow to. By default we limit containers to 10G. In Devicemapper, new container/images take zero size and grow up to the maximum size. Changing the base size will not actually change the physical usage of containers unless they grow larger than 10 GB.

Many users add Volumes instead of growing the base device, which is why they haven't used this feature yet. However, there are times when Volumes might not be suitable for your needs.

I will give you an example of growing it. For the purpose of this article, let’s use Fedora as an example image.

![docker_images_2](./docker_images_2.png)

Let’s start a container on this Fedora image:

![docker_container_3](./docker_container_3.png)

As we can see in the above container, the device size of this container is 10 GB. We can also check this using the `docker inspect` command with some filters:

![docker_inspect_4](./docker_inspect_4.png)

As we can see the container device size in docker inspect output is also 10 GB (10737418240 / 1024^3 ).

## Increasing the Base Device Size on daemon Restart

What if I want my container rootfs (device) size to be 20 GB? I cannot do that since the base device size is set to 10 GB. With this feature we can expand the Base device size on daemon restart to 20 GB. Note I used the word “expand” and not “change”, which means we cannot set the base device size to 5 GB (less than the existing base device size: 10GB) on daemon restart.

![daemon_restart_5](./daemon_restart_5.png)

We have changed the base device size to 20 GB on daemon restart. Let's double check it using the `docker info` command:

![docker_info_after_restart_6](./docker_info_after_restart_6.png)

As we can see, the base device has been expanded. Now let’s start a Fedora container and see if we get the new container rootfs size:

![new_fedora_container_7](./new_fedora_container_7.png)

Checking it using `docker inspect`:

![docker_inspect_4](./docker_inspect_4.png)

Why is the container still showing 10GB of container rootfs size? Shouldn’t we be getting 20 GB? This is expected behavior. Since our new container is based on our old Fedora image, which is based on the old base device size, the new container would not get a 20-GB device size unless we update the image.

So let’s remove the existing Fedora image and update it from the registry.

```
$ docker rmi fedora

$ docker pull fedora
```

And start a container on this new Fedora image:

![fedora_container_new_base_size_8](./fedora_container_new_base_size_8.png)

As we can see, the container rootfs size is now 20GB. This feature would allow us to expand the base device size on daemon restart, which means all future images and containers (based on those new images) will be of new size.However, there are certain limitations to this solution.
## Limitations
 *	All new containers would not have the increased rootfs size. As we saw above even after restarting the daemon with the new base device size (--storage-opt dm.basesize=20G), we would still need to update all the existing images in order for new containers to reap benefits of this new size.

 * With this approach the heaviest application (container) would dictate the size for the rest of the containers, e.g., if I want to have 100 containers on my infrastructure and one of them is a data intensive application requiring 100 GB of space, I would have to set the base device size (dm.basesize=100G) to 100 GB. Even though there are 99 other containers that only needed 200 MB of space each.Since these limitations are fairly serious, I have developed a better solution where we can grow the container rootfs at docker create/run time. I am trying to get that feature merged upstream and make it available in docker 1.12.Please comment on the [pull request]( https://github.com/docker/docker/pull/19367) if you are interested. Once the PR is merged upstream, I will write a blog post about it.