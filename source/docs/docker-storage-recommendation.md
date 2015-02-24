# Setting Up Storage

## Introduction
 
The Atomic host is a minimal distribution and as such is distributed on a 6Gb image to keep the footprint small. However, that amount of storage doesn't support building and storing lots of Docker images.  It is an expected practice that external storage of sufficient size will be attached to the Atomic Host host in order to provide enough space to build and store Docker images. 

Docker uses `/var/lib/docker` as the default directory where all docker related files, including the images, are stored.  Atomic hosts however use direct LVM volumes via the devicemapper backend to store Docker images and metadata `/dev/atomicos/docker-data` and `/dev/atomicos/docker-meta`.  Adding storage to an Atomic hosts therefore requires a different procedure to grow the LVM volume than adding more storage to a device mounted at `/var/lib/docker`.   
 
This document provides instructions for using an attached device with your Atomic host so that you can build and store lots of Docker images.  The basic procedure is the same as extending any other LVM volume.  Add the new device to the host, create a physical volume using the new device, add the physical volume to the volume group, and then extend the LVM volumes.  Since we are directly accessing the thin pool within docker, we won't need to create or extend a filesystem or mount the LVM volumes.
 
## Using the `docker-storage-setup` LVM helper
_In this example, we'll be using a virt-manager installed Atomic host_.  
Create a new VirtIO drive for use by the virtual machine and attach the volume to the Atomic host virtual machine in virt-manager.  On the Atomic host, ensure the device is available.  You may need to reboot the virtual machine.  Make sure no partitions are listed on the device, as we'll be adding this as a physical volume in LVM and get the appropriate device name.  

In the example, you can see a new 5GiB volume available at `/dev/vdb`.  This is the disk we'll add to the available pool.
 
    [fedora@atomic-host-001 ~]$ sudo fdisk -l

    Disk /dev/vda: 6 GiB, 6442450944 bytes, 12582912 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x0e409ce2

    Device     Boot  Start      End  Sectors  Size Id Type
    /dev/vda1  *      2048   411647   409600  200M 83 Linux
    /dev/vda2       411648 12582911 12171264  5.8G 8e Linux LVM

    Disk /dev/vdb: 5 GiB, 5368709120 bytes, 10485760 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x00000000

## Setting Up /etc/sysconfig/docker-storage-setup

Atomic hosts are delivered with a helper script to configure the direct LVM storage, `docker-storage-setup`.  The script reads from configuration options in `/etc/sysconfig/docker-storage-setup`.

We'll set up a very basic configuration file to add the new device to the docker data storage pool.  The two options we'll deal with is `DEVS` and `VG`.  
The `DEVS` option is a space separated list of the devices you want to add to the pool.  The `docker-storage-setup` script will automatically calculate the required amount of meta-data space from the overall size of the volume group, grow that volume, and then grow the data volume with the remaining space.

The `VG` option allows you to control the volume group used for docker storage.  By default, Atomic uses the same volume group as the root device.  This means that you can set or change the root volume size with this utility as well.  You can also change the group if you so choose.
    
    [fedora@atomic-host-001 ~]$ sudo vi /etc/sysconfig/docker-storage-setup 
    DEVS="/dev/vdb"

Once you've added the new storage device or devices in the configuration file, you can run the helper script.  If you are adding more than one device at a time, you'll see some of these steps more than once.

    [fedora@atomic-host-001 ~]$ sudo docker-storage-setup 
    0
    sfdisk: Checking that no-one is using this disk right now ...
    sfdisk: OK
    
    Disk /dev/vdb: 6241 cylinders, 16 heads, 63 sectors/track
    sfdisk:  /dev/vdb: unrecognized partition table type
    Old situation:
    sfdisk: No partitions found
    New situation:
    Units: sectors of 512 bytes, counting from 0

    Device Boot    Start       End   #sectors  Id  System
    /dev/vdb1          2048   6291455    6289408  8e  Linux LVM
    /dev/vdb2             0         -          0   0  Empty
    /dev/vdb3             0         -          0   0  Empty
    /dev/vdb4             0         -          0   0  Empty
    sfdisk: Warning: partition 1 does not start at a cylinder boundary
    sfdisk: Warning: partition 1 does not end at a cylinder boundary
    sfdisk: Warning: no primary partition is marked bootable (active)
    This does not matter for LILO, but the DOS MBR will not boot this disk.
    Successfully wrote the new partition table

    Re-reading the partition table ...
    
    sfdisk: If you created or changed a DOS partition, /dev/foo7, say, then use     dd(1)
    to zero the first 512 bytes:  dd if=/dev/zero of=/dev/foo7 bs=512 count=1
    (See fdisk(8).)
    Physical volume "/dev/vdb1" successfully created
    Volume group "atomicos" successfully extended
    NOCHANGE: partition 2 could only be grown by -48 [fudge=20480]
    Physical volume "/dev/vda2" changed
    1 physical volume(s) resized / 0 physical volume(s) not resized
    NOCHANGE: partition 1 could only be grown by -16 [fudge=20480]
    Physical volume "/dev/vdc1" changed
      1 physical volume(s) resized / 0 physical volume(s) not resized
    Rounding size to boundary between physical extents: 12.00 MiB
    Size of logical volume atomicos/docker-meta changed from 8.00 MiB (2 extents) to 12.00 MiB (3 extents).
    Logical volume docker-meta successfully resized
    Size of logical volume atomicos/docker-data changed from 3.84 GiB (1494   extents) to 8.83 GiB (2260 extents).
      Logical volume docker-data successfully resized

You can verify that docker can see the new storage with `docker info`:

    [fedora@atomic-host-001 ~]$ sudo docker info
    Containers: 0
    Images: 0
    Storage Driver: devicemapper
     Pool Name: docker-253:0-4655104-pool
     Pool Blocksize: 65.54 kB
     Backing Filesystem: <unknown>
     Data file: /dev/atomicos/docker-data
     Metadata file: /dev/atomicos/docker-meta
     Data Space Used: 11.8 MB
     Data Space Total: 4.123 GB
     Metadata Space Used: 53.25 kB
     Metadata Space Total: 8.389 MB
     Udev Sync Supported: true
     Library Version: 1.02.93 (2015-01-30)
    Execution Driver: native-0.2
    Kernel Version: 3.18.7-200.fc21.x86_64
    Operating System: Fedora 21 (Twenty One)
    CPUs: 1
    Total Memory: 1.955 GiB
    Name: atomic-host-001.localdomain
    ID: QN7L:2FJ5:CZXS:265G:JVIF:2CB3:35EE:T5KJ:7HXN:OXGG:MEW2:XLC2

## Looking Forward

In order to add a new device using the `docker-storage-setup` script, you will need to make sure that the configuration file only contains references to devices and sizes for this particular run of the tool.  

For example, if you add a new device to host and to the `DEVS` line, the `docker-storage-setup` script will exit as the exisiting device has a partition and physical volume already created.

    [fedora@atomic-host-002 ~]$ sudo vi /etc/sysconfig/docker-storage-setup
    DEVS="/dev/vdb /dev/vdc"

    [fedora@atomic-host-002 ~]$ sudo docker-storage-setup
    0
    /dev/vdb has partitions: vdb1

Since Atomic is using the devicemapper backend and direct LVM pools, you can also add new devices manually, as you would with any other LVM configuration.  When adding data storage, you should also calculate the needed space for meta-data, the `docker-storage-setup` helper reserves 0.1% of the size of the volume group as meta-data space.  
