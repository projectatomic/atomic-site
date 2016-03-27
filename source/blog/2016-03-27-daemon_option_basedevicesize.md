 
# <span style="color:cornflowerblue">Increase the base device size on docker daemon restart</span>
## <span style="color:cornflowerblue">Author: Shishir Mahajan</span>
---
Sometime back I wrote a feature for docker to allow expanding Base device size on daemon restart. Before we jump further into this article, I would like to point out that this feature is only available for devicemapper storage and does not apply to other storage drivers like overlay, btrfs, aufs etc.

## <span style="color:cornflowerblue">Base device size</span>
<br/>
If you do docker info, you will see base device size in the output. 

$ docker info

![docker_info_1](./docker_info_1.png)

So what is this base device size? First time docker is started, it sets up a base device with a default size of 10GB. All future images and containers would be a snapshot of this base device. 

Base size is the MAXIMUM size that a container/image can grow to. By default we limit containers to 10G. In Devicemapper, new container/images take 0 size and grow up to the 
Maximum size. Changing the Base Size will not actually change the physical usage of containers unless they grow larger than 10 G. 

I will give you an example. For the purpose of this article let’s use fedora as an example image.

$ docker images

![docker_images_2](./docker_images_2.png)

Let’s start a container on this fedora image.

![docker_container_3](./docker_container_3.png)

As we can see in the above container, the device size of this container is 10GB. We can also check this using docker inspect command.

$ docker inspect --format {{.GraphDriver.Data.DeviceSize}} $(docker ps -lq)

![docker_inspect_4](./docker_inspect_4.png)

As we can see the container device size in docker inspect output is also 10GB (10737418240 / 1024 * 1024 * 1024). 


## <span style="color:cornflowerblue">Increasing the base device size on daemon restart</span>
<br/>
What if I want my container rootfs (device) size to be 20GB ? I cannot do that since the base device size is set to 10GB. With this feature we can expand the Base device size on daemon restart to 20GB. Note I used the word “expand” and not “change”, which means we cannot set the base device size to 5GB (less than the existing base device size: 10GB) on daemon restart.

$ docker daemon –storage-opt dm.basesize=20G

![daemon_restart_5](./daemon_restart_5.png)

We have changed the base device size to 20GB on daemon restart. Lets double check it using docker info command.

$ docker info

![docker_info_after_restart_6](./docker_info_after_restart_6.png)

As we can see the base device has been expanded. Now let’s start a fedora container and see if we get the new container rootfs size.

![new_fedora_container_7](./new_fedora_container_7.png)

$ docker inspect --format {{.GraphDriver.Data.DeviceSize}} $(docker ps -lq)

![docker_inspect_4](./docker_inspect_4.png)

Why is the container still showing 10GB of container rootfs size? Shouldn’t we be getting 20GB? This is expected behavior. Since our new container is based on our old fedora image, which is based on the old base device size, the new container would not get a 20GB device size unless we update the image.

So let’s remove the existing fedora image and update it from the registry.

$ docker rmi fedora
<br/>
$ docker pull fedora

And start a container on this new fedora image.

$ docker run –it fedora /bin/bash

![fedora_container_new_base_size_8](./fedora_container_new_base_size_8.png)

As we can see the container rootfs size is now 20GB. This feature would allow us to expand the base device size on daemon restart, which means all future images and containers (based on those new images) will be of new size.However there are certain limitations to this solution.
## <span style="color:cornflowerblue">Limitations</span>
1.	All new containers would not have the increased rootfs size. As we saw above even after restarting the daemon with the new base device size (--storage-opt dm.basesize=20G), we would still need to update all the existing images in order for new containers to reap benefits of this new size.

2.	With this approach the heaviest application (container) would dictate the size for the rest of the containers. e.g. If I want to have 100 containers on my infrastructure and one of them is a data intensive application requiring 100G of space. I would have to set the base device size (dm.basesize=100G) to 100G. Even though there are 99 other containers, which only needed 200 MB of space. 


