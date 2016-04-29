 
# <span style="color:cornflowerblue">docker lvm plugin</span>
## <span style="color:cornflowerblue">Author: Shishir Mahajan</span>
---
Recently docker introduced a volume command (docker volume –help for more information) to allow users to create a logical volume and then bind mount it inside the container at container creation/run time.  You can achieve this by:

![local_volume_foobar](./local_volume_foobar_1.png)

This will create a logical volume `foobar` mounted at filesystem location `/var/lib/docker/volumes`.

Now, you can bind mount the `foobar` volume into the `/run` directory inside the container.

![bind_mount_foobar_local](./bind_mount_foobar_local_2.png)

While this is all good, docker does not allow us to put a restriction on the size of the volume created. For use cases like OpenShift , where the P-a-a-s (Platform-as-a-service) system wants to create a size adjustable container, docker volume command might not be good enough. 

So we decided to write a docker volume plugin which would allow us to create a size adjustable volume and then bind mount it inside the container.

## <span style="color:cornflowerblue">docker lvm plugin</span>
<br/>
docker-lvm-plugin is a volume plugin, which creates logical volumes using LVM2. LVM2 is a userspace toolset, which provide logical volume management in linux.To support LVM2 commands used by our plugin, you would basically need devicemapper in your kernel, userspace devicemapper support library (libdevmapper) and the userspace LVM2 tools. Most of these things should be present by default on your RHEL or fedora linux distributions.I would encourage you to check it out<br/>[https://github.com/projectatomic/docker-lvm-plugin](https://github.com/projectatomic/docker-lvm-plugin)
The README.md has all the instructions on how to set it up and get it running. However I would still list out the important things:
1. Even though the instruction says you need to start the docker-lvm-plugin daemon using    `systemctl start docker-lvm-plugin`. This is optional as the daemon is on-demand socket activated.  What it means is, once the plugin in installed on your system, doing a `docker volume ls` would automatically start the daemon.
2.	Since logical volumes (lv's) are based on a volume group, it is the responsibility of the user (administrator) to provide a volume group name. You can choose an existing volume group name by listing volume groups on your system using `vgs` command OR create a new volume group using `vgcreate command`. e.g. 
	```	vgcreate volume_group_one /dev/hda
	```
where `/dev/hda` is your partition or whole disk on which physical volumes were created.<br/>
Update your volume group name in `/etc/docker/docker-lvm-plugin`.

That’s it! You are all set to use the plugin now.

## <span style="color:cornflowerblue">Examples</span>
### <span style="color:cornflowerblue">Volume Creation</span>

![lvm_volume_foobar_create](./lvm_volume_foobar_create_3.png)

This will create a lvm volume named foobar of size 208 MB (0.2 GB).

### <span style="color:cornflowerblue">Volume List</span>

![lvm_volume_list](./lvm_volume_list_4.png)

This will list volumes created by all docker drivers including the default driver (local).

### <span style="color:cornflowerblue">Volume Inspect</span>
![lvm_volume_inspect](./lvm_volume_inspect_5.png)

This will inspect foobar and return a JSON.

### <span style="color:cornflowerblue">Volume Removal</span>

![lvm_volume_rm](./lvm_volume_rm_6.png)

This will remove lvm volume foobar.

### <span style="color:cornflowerblue">Bind Mount lvm volume inside the container</span>

![bind_mount_foobar_lvm](./bind_mount_foobar_lvm_7.png)

This will bind mount the logical volume foobar into the home directory of the container.

Hope you enjoy playing around with this plugin.





