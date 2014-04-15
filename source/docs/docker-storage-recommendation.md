# Setting Up Storage

## Introduction
 
The Atomic Controler is a minimal Linux distribution specifically purposed for hosting lxc/Docker containers. Atomic Controller is distributed on a 8.5Gb image to keep it's footprint small. That amount of storage doesn't support building and storing lots of Docker images.  It is expected practice that external storage of sufficient size will be attached to the Atomic Controler host  in order to provide enough space to build and storage Docker images . Docker depends on `/usr/lib/docker` as the default directory where all docker related files, including the images, are stored. If you use the default `/var/lib/docker` provided in the Atomic Controler image then it will fill up fast and soon Docker and the host will become unusable.
 
This document/section provides instructions on the recommended steps on how to use an attached volume with your Atomic Controller host so that you can build and store lots of Docker images.
 
## Preliminary Steps

Before setting up the `/var/lib/docker` directory to use the external volume it is assumed you have attached that volume to your host. Here is an example of setting up a 30Gb external volume to a Atomic Controler virtual machine.
 
    # lvcreate --size 30GB --name extra-disk-for-atomic-controler
 
Attach the volume to the Atomic Controler host virtual machine in virt-manager. Reboot the virtual machine. On the Atomic Controler host, ensure the device is available.
 
    # fdisk -l
 
Create a partition using the new device discovered using the above command. E.g. if `/dev/sdb1` is the device name:
 
    # fdisk /dev/sdb1
 
Now create a file system on the new partition, or start using lvm here. The preferred file systems types for Atomic Controler are ext4 and xfs.
 
    # mkfs.xfs /dev/sdb1
 
## Setting Up /var/lib/docker

Before setting up the external volume consider if there are already important images or containers already in use on this host.  It is unlikely due to the size of the image and it is preferred to do these recommended steps before building or pulling down images. i.e. it is not recommended to use Atomic Controler before attaching an external volume. But if there is important information in `/usr/lib/docker` then it is best to copy this to a backup directory now.

    # cp -r  /var/lib/docker  /my-backupd-dir

Stop the docker service and remove the `/var/lib/docker` directory and it's contents:

    # systemctl stop docker
    # rm -rf /var/lib/docker

Now, getting back to the new device, get the UUID from the device.
 
    # blkid /dev/sdb1
 
Then add that to the `/etc/fstab` in the format:

    UUID=<UUID-from-blkid> /var/lib/docker <file system type> defaults 1 1
 
For our xfs example it looks something like like:
 
    UUID=be840c0d-91f8-41fa-bb40-82e1c4e2e985 /var/lib/docker xfs defaults 1 1
 

## Start Using The New Volume With Docker

The volume is ready to be mounted and used by Docker. Mount the device:

    # mount -a
 
If you did backup any information from `/var/lib/docker` then now is a good time to restore it. Copy the backup to the new volume. Then restart the docker service:
 
    # systemctl start docker

If the provided `/var/lib/docker` was not backed up and restored then it is easy to check if everything worked.  After the docker service has started you should see the following files in the `/var/lib/docker` with ls :

    containers  devicemapper  execdriver  graph  init  linkgraph.db  
    lxc-start-unconfined  repositories-devicemapper  vfs  volumes

Another test is to build an image. Here is a simple example `Dockerfile`:

    FROM fedora
    RUN  yum -y update

 
## Looking Forward

In the future it is likely that the recommended mounting for /var/lib/docker will be more granular depending on the performance needs of various sub-directories of `/var/lib/docker`.  Watch this space.

## Filesystem Considerations

Docker supports several different filesystem formats. How these work and which one you choose for all or part of your deployment will greatly effect your performance and efficiency.

For information and recommendations on supported filesystems please see [Supported Filesystems](http://www.projectatomic.io/docs/filesystems/).
