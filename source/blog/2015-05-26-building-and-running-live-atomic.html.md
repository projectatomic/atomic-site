---
title: Building and running live Atomic from PXE with iSCSI
author: rvykydal
date: 2015-05-26 04:00:00 UTC
tags: Atomic, iSCSI, PXE
comments: true
published: true
---

In this post I'll show how to build live Atomic Host image that can be run on diskless machine using PXE boot. Once we have the images, I'll show you how to run the live system and customize it with boot options and cloud-config for better use of resources, leading to the goal of storing Docker images on iSCSI devices.

READMORE

##Servers you'll need:

To run the live image you will need to set up the following:

- A PXE server to serve kernel and initramfs modified for booting into live Atomic image.
- A HTTP server to serve live Atomic image and `cloud-init` configuration.
- (optional) An iSCSI target serving device used for storing docker images.

I won't describe how to set these up here.

If you are not interested in building the images you can try [images I built during writing this blogpost](https://rvykydal.fedorapeople.org/atomic/pxetolive/) or Fedora images if there are already some at the time you are reading this post, and jump right to the section *Build output - images and PXE config*.

## Building the live Atomic image

### Using the livemedia-creator tool

* I will be using Fedora 22 Beta Server to build the live image. We need `lorax` package containing `livemedia-creator` - the tool for building the image, and kvm virtualization which livemedia-creator uses to create live image with Atomic installer iso. (Note, Fedora 22 Server will be released soon.)

```
sudo dnf install wget lorax libvirt virt-install qemu-kvm
```

* Download the Atomic **installer iso** which will be used to install live Atomic to raw disk image in a virtual machine. For now let's use Fedora 22 Test Candidate 3 (final ISO images for the current Fedora release should be available at https://getfedora.org/en/cloud/download/, or you can try [Fedora 22 Beta Atomic iso](http://download.fedoraproject.org/pub/fedora/linux/releases/test/22_Beta/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-x86_64-22_Beta.iso))

```
sudo wget http://alt.fedoraproject.org/pub/alt/stage/22_TC3/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-x86_64-22_TC3.iso -O /var/lib/libvirt/images/atomic-installer.iso
```


The ISO contains the repository Atomic Host will be installed from (it is also possible to use remote repository, see below).


* Download installer **kickstart file** for live Atomic image.

```
wget http://raw.githubusercontent.com/rvykydal/anaconda-kickstarts/master/atomic/fedora-atomic-pxe-live.ks
```

The comments in the [fedora-atomic-pxe-live.ks](https://github.com/rvykydal/anaconda-kickstarts/blob/master/atomic/fedora-atomic-pxe-live.ks) should explain the kickstart settings specific for live Atomic.


* Build the live image with `livemedia-creator`

`livemedia-creator` uses a kvm virtual machine:

```
sudo systemctl start libvirtd.service
```

First it creates raw Atomic disk image by Anaconda installation in kvm using installer iso and kickstart.

```
sudo livemedia-creator --make-disk --image-name=atomic.disk --iso=/var/lib/libvirt/images/atomic-installer.iso --ks=fedora-atomic-pxe-live.ks --ram=1500 --vnc=spice
```

Then ext4 rootfs image (merging separate `/boot` partition in) is created from the raw disk image and packed into squashfs image, and modules for fetching and using the live image are added into initrd in the process:


```
sudo livemedia-creator --make-ostree-live --disk-image=/var/tmp/atomic.disk  --live-rootfs-keep-size
```

The two steps can be run in one shot:

```
sudo livemedia-creator --make-ostree-live --iso=/var/lib/libvirt/images/atomic-installer.iso --ks=fedora-atomic-pxe-live.ks  --live-rootfs-keep-size --ram=1500 --vnc=spice
```

`--make-ostree-live` option is a special version of `--make-pxe-live` option for systems using ostree deployment and update model (as Atomic) where handling deployment root different from physical root is needed. `--live-rootfs-keep-size` option makes the rootfs image honor the size defined in kickstart (by default it has the size close to the size occupied by the installed system). If you are interested about the details of build process, there is quite a lot of info in the logs (`program.log`, `virt-install.log`, `livemedia.log`)

* Let's look at the results. Due to a bug in F22 `--resultsdir` option is not working currently so we have to look in `/var/tmp` where the results are stored by default. There is a hint in the tool terminal output:

```
2015-05-15 10:47:36,013: SUMMARY
2015-05-15 10:47:36,014: -------
2015-05-15 10:47:36,014: Logs are in /home/rvykydal
2015-05-15 10:47:36,014: Disk image is at /var/tmp/diskiJGJzG.img
2015-05-15 10:47:36,014: Results are in /var/tmp
```

We know where the intermediate Atomic disk image is, but we need to find **live images** in a temporary directory with results in /var/tmp

```
$ sudo find /var/tmp | grep PXE
/var/tmp/tmpPHiQsv/PXE_CONFIG
$ sudo ls -l /var/tmp/tmpPHiQsv
total 425076
-rw-r--r--. 1 root root  32584368 May 15 10:47 initramfs-4.0.1-300.fc22.x86_64.img
-rw-r--r--. 1 root root 396787712 May 15 10:46 live-rootfs.squashfs.img
-rw-r--r--. 1 root root       317 May 15 10:47 PXE_CONFIG
-rwxr-xr-x. 1 root root   5895192 Jan  1  1970 vmlinuz-4.0.1-300.fc22.x86_64

```
### Building the image from non-local Atomic repo

With the [fedora-atomic-pxe-live.ks](https://github.com/rvykydal/anaconda-kickstarts/blob/master/atomic/fedora-atomic-pxe-live.ks) we were using Atomic repository embedded in the installer iso by including kickstart snippet from the installation image:
```
%include /usr/share/anaconda/interactive-defaults.ks
```
The snippet contains `ostreesetup` command pointing to the repository. To override it add `ostreesetup` command pointing to repository of your choice some place after the `%include` clause:

```
%include /usr/share/anaconda/interactive-defaults.ks

ostreesetup --nogpg --osname=fedora-atomic --remote=fedora-atomic --url=http://10.34.102.55:8000/ --ref=fedora-atomic/f22/x86_64/docker-host
```

This way the Atomic installer ISO can be used to create live Atomic image with updated content. It is not possible to update live Atomic Host in the normal way with `atomic host upgrade` command, respin of the live image needs to be done. It is because (atomic) updates of system using ostree technology require rebooting into updated system (and allow for reboot or rollback to previous version of the system).


### Building image with rpm-ostree-toolbox

To build Atomic repository locally there is the [rpm-ostree-toolbox](https://github.com/projectatomic/rpm-ostree-toolbox) tool. The repository is built with `treecompose` command. With the tool also installer iso can be built using `installer` command, and there is even a `liveimage` command for building live Atomic image. It is running `livemadia-creator` in container so one big advangage is that the image can be built on other than target system without any issues. I may cover this in another blog post.

## Build output - images and PXE config

To run live Atomic three images and PXE configuration are required:

* `vmlinuz-4.0.1-300.fc22.x86_64` - kernel image to be supplied by PXE (tftp) server
* `initramfs-4.0.1-300.fc22.x86_64.img` - initrd image to be supplied by PXE (tftp) server. Compared to initrd image from Atomic repository it has two dracut modules added: `livenet` for fetching live images and `dmsquash-live` for running system from live root images.
* `PXE_CONFIG` - template **pxe configuration** file where location of images (kernel and initrd on PXE server, rootfs image on HTTP server) needs to be substituted according to your environment. The main reason for supplying this template is the `ostree` option which tells dracut ostree module where to find deployment root that should be used.

```
# PXE configuration template generated by livemedia-creator
kernel <PXE_DIR>/vmlinuz-4.0.1-300.fc22.x86_64
append initrd=<PXE_DIR>/initramfs-4.0.1-300.fc22.x86_64.img root=live:<URL>/live-rootfs.squashfs.img ostree=/ostree/boot.0/Fedora-Cloud_Atomic/b71c9aba7a86fb046928c05d5175e65234589a82a471e7d3030f126b24211018/0
```

* `live-rootfs.squashfs.img` - the live rootfs ext4 image packed in squashfs image. Here is **how the image is mounted** by dracut's `dmsquash-live` module with `root=live:` option. It is using devicemapper's read-write overlay (snapshot) on read-only loop-mounted rootfs image:

```
live-rootfs.squashfs.img
         |
        (ro)
         |
         V
     /dev/loop0
         |
     (squashfs ro)                    dd
         |                             |
         V                             V
  LiveOS/rootfs.img (sparse)       /overlay (sparse)
         |                             |
        (ro)                          (rw)
         |                             |
         V                             V
     /dev/loop1---------------     /dev/loop2
         |                    \      /
   (dm linear ro)         (dm snapshot rw)
         |                       |
         V                       V
/dev/mapper/live-base   /dev/mapper/live-rw
                                 |
                                 /
```

Yes, seems like quite a bit of layers. I'll talk about another option which should be available in Fedora rawhide in *Mounting live image with rd.writable.fsimg?* section.


## Running live Atomic Host from PXE:

So, let's move our kernel and initrd images to our PXE server, live image to our HTTP server, update PXE_CONFIG accordingly and set it up on the PXE server, e.g.:

```
# PXE configuration template generated by livemedia-creator
label pxetolive_f22_atomic
kernel test/rv/atomic_live_blog/vmlinuz-4.0.1-300.fc22.x86_64
append initrd=test/rv/atomic_live_blog/initramfs-4.0.1-300.fc22.x86_64.img root=live:http://10.34.39.2/trees/rv/atomic_live_blog/live-rootfs.squashfs.img ostree=/ostree/boot.0/Fedora-Cloud_Atomic/b71c9aba7a86fb046928c05d5175e65234589a82a471e7d3030f126b24211018/0
```

And run it live! Be it on bare-metal or virtual (diskless if you like) machine. Oh, wait, we should supply cloud-init configuration.

### Cloud-init to configure access to host

The live image is built with cloud-init service enabled, as configured in [fedora-atomic-pxe-live.ks](https://github.com/rvykydal/anaconda-kickstarts/blob/master/atomic/fedora-atomic-pxe-live.ks):

```
services --enabled=cloud-init,cloud-init-local,cloud-final,cloud-config
```

so if you don't want to wait for fail of cloud-init service trying to fetch configuration from default location during boot, you need either to disable the service (`services --disabled=`) in kickstart file for the live image build (but you'll hardly want to do it as you'll see it is useful) or to supply cloud-init configuration by this boot option added:

```
ds=nocloud-net;seedfrom=http://10.34.39.2/ks/rv/ci/
```

The option points to a directory containing `meta-data` and `user-data` files.

Here is an example of [meta-data](https://github.com/rvykydal/anaconda-kickstarts/blob/master/atomic/ci/pxe-to-live-with-iscsi/meta-data) file.

```
instance-id: Atomic0
local-hostname: atomic-00
```

The actual host configuration goes into `user-data` file. Let's use it to configure **ssh access**. The live image is built with root password set in kickstart file:

```
rootpw --plaintext atomic
```

To be able to access the system with ssh, add your public ssh key for default `fedora` user in `user-data`:

```
#cloud-config
password: atomic
chpasswd: {expire: False}
ssh_pwauth: True
ssh_authorized_keys:
  - ssh-rsa AAA...SDvZ user1@domain.com
```

The `#cloud-config` line is not a comment but actually a keyword.

The root password can be also changed by this `user-data` configuration:

```
chpasswd:
  list: |
    root:ciatomic
  expire: False
```

It is also possible to **lock the root password** during compose of live image by modifying the installation kickstart.

Replace

```
rootpw --plaintext atomic
```

with

```
rootpw --lock --iscrypted locked
user --name=none
```

and remove dummy user (probably required by installer because of locked root pw) in `%post` section of kickstart:

```
userdel -r none
```



### How much data can we write?

As we are running live system, it is basically limited by available RAM. But it is not so simple. First, let's see our root fs size:

```
[fedora@atomic-00 ~]$ df -h
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             2.0G     0  2.0G   0% /dev
tmpfs                2.0G     0  2.0G   0% /dev/shm
tmpfs                2.0G   17M  2.0G   1% /run
tmpfs                2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/mapper/live-rw  4.9G  1.1G  3.9G  23% /
tmpfs                399M     0  399M   0% /run/user/0
tmpfs                399M     0  399M   0% /run/user/1000
```

It is roughly the same as the size defined in kickstart file.

```
part / --fstype="ext4" --size=6000
```

Because we build the image with livemedia-creator using `--live-rootfs-keep-size` option (I think the size from kickstart is truncated to number of GiBs, hence the 6000 MiB vs 4.9 GB difference). It is also possible to set the desired size directly by `--live-rootfs-size` option. We don't have to be afraid of overcommiting here as the image is sparse. But what we see reported by `df` is not the real space available for writing our data. As said above, there is a read-write devicemapper layer using **overlay image** (devicemapper shapshot) to store live data:

```
[fedora@atomic-00 ~]$ lsblk
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sr0                           11:0    1   623M  0 rom  
loop0                          7:0    0 378.6M  1 loop 
loop1                          7:1    0     5G  1 loop 
├─live-rw                    253:0    0     5G  0 dm   /sysroot
└─live-base                  253:1    0     5G  1 dm   
loop2                          7:2    0   512M  0 loop 
└─live-rw                    253:0    0     5G  0 dm   /sysroot
loop3                          7:3    0   100G  0 loop 
└─docker-253:0-278707-pool   253:2    0   100G  0 dm   
  └─docker-253:0-278707-base 253:3    0    10G  0 dm   
loop4                          7:4    0     2G  0 loop 
└─docker-253:0-278707-pool   253:2    0   100G  0 dm   
  └─docker-253:0-278707-base 253:3    0    10G  0 dm   
```

The size of overlay image (mounted to `loop2`) which is used for storing data written over read-only loop-mounted rootfs image (`loop1`, which is the 5G reported above) is 512M by default. So athough the root's `live-rw` device reports 3.9G available in `df`, the actual available space can be obtained by `dmsetup` command:

```
[fedora@atomic-00 ~]$ sudo dmsetup status
live-base: 0 10485760 linear 
docker-253:0-278707-base: 0 20971520 thin 596992 20971519
live-rw: 0 10485760 snapshot 632648/1048576 2472
docker-253:0-278707-pool: 0 209715200 thin-pool 1 179/524288 4664/1638400 - rw discard_passdown queue_if_no_space 
```

Looking at values for `live-rw` we can see that there are 632648/1048576 of 512B sectors used, which is about a half of the total 512MB.

Let's try to pull some docker image and look at the values.
```
[fedora@atomic-00 ~]$ sudo docker pull centos
latest: Pulling from centos

6941bfcbbfca: Pulling fs layer 
6941bfcbbfca: Download complete 
41459f052977: Download complete 
fd44297e2ddb: Error pulling image (latest) from centos, endpoint: https://registry-1.docker.io/v1/, Driver devicemapper failed to create image rootfs fd44297e2ddb050ec4fa9752b7a4e3a8439061991886e2091e7c1f007c906d75: Error saving transaction metadata: Error syncing metadata file /fd44297e2ddb: Error pulling image (latest) from centos, Driver devicemapper failed to create image rootfs fd44297e2ddb050ec4fa9752b7a4e3a8439061991886e2091e7c1f007c906d75: Error saving transaction metadata: Error syncing metadata file /var/lib/docker/devicemapper/metadata/.tmp816100005: fsync: input/output error 
FATA[0074] Error pulling image (latest) from centos, Driver devicemapper failed to create image rootfs fd44297e2ddb050ec4fa9752b7a4e3a8439061991886e2091e7c1f007c906d75: Error saving transaction metadata: Error syncing metadata file /var/lib/docker/devicemapper/metadata/.tmp816100005: fsync: input/output error 
```

Oops, we'we already run out of space trying to pull about 80 MB image (you'll see also handful of Buffer I/O errors on device dm-0 and Ext4-fs errors in console). Indeed, the live-rw snapshot became invalid:

```
[fedora@atomic-00 ~]$ sudo dmsetup status
live-base: 0 10485760 linear 
docker-253:0-278707-base: 0 20971520 thin 596992 20971519
live-rw: 0 10485760 snapshot Invalid
docker-253:0-278707-pool: 0 209715200 thin-pool 3 224/524288 8633/1638400 - ro discard_passdown queue_if_no_space 
```

### rd.live.overlay.size

The default overlay size is not big enough for storing docker images. And maybe even not enough for other system stuff. We've added dracut `rd.live.overlay.size` boot option to set the size of overlay image, let's try to double it to 1 GB. Again, you don't have to be afraid of overcommiting the overlay size compared to available physical RAM as it is a sparse file. Now the pxe configuration looks like:

```
# PXE configuration template generated by livemedia-creator
label pxetolive_f22_atomic
kernel test/rv/atomic_live_blog/vmlinuz-4.0.1-300.fc22.x86_64
append initrd=test/rv/atomic_live_blog/initramfs-4.0.1-300.fc22.x86_64.img root=live:http://10.34.39.2/trees/rv/atomic_live_blog/live-rootfs.squashfs.img ostree=/ostree/boot.0/Fedora-Cloud_Atomic/b71c9aba7a86fb046928c05d5175e65234589a82a471e7d3030f126b24211018/0 ds=nocloud-net;seedfrom=http://10.34.39.2/ks/rv/ci/ rd.live.overlay.size=1024
```

Let's reboot into the live Atomic with the option and pull CentOS Docker image.

```
[fedora@atomic-00 ~]$ sudo docker pull centos
latest: Pulling from centos

6941bfcbbfca: Pulling fs layer 
6941bfcbbfca: Download complete 
41459f052977: Download complete 
fd44297e2ddb: Download complete 
Status: Downloaded newer image for centos:latest

[fedora@atomic-00 ~]$ sudo dmsetup status
live-base: 0 10485760 linear 
docker-253:0-278707-base: 0 20971520 thin 596992 20971519
live-rw: 0 10485760 snapshot 1144248/2097152 4464
docker-253:0-278707-pool: 0 209715200 thin-pool 4 231/524288 8639/1638400 - rw discard_passdown queue_if_no_space 
```

Looks better, we can see 1144248/2097152 sectors used, but anyway, pulling 80 MB image has eaten up about 0.25 GB of our overlay space. It is clear that for serious work we want to store docker images on network storage.

### Docker images on iSCSI

As we can see also from `lsblk` output and `docker info`, docker on live Atomic (unlike on regular Atomic) is using devicemapper storage backend with loopdevices, which is highly discouraged for reliablility and performace reasons.

```
[fedora@atomic-00 ~]$ lsblk
NAME                         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sr0                           11:0    1   623M  0 rom  
loop0                          7:0    0 378.6M  1 loop 
loop1                          7:1    0     5G  1 loop 
├─live-rw                    253:0    0     5G  0 dm   /sysroot
└─live-base                  253:1    0     5G  1 dm   
loop2                          7:2    0     1G  0 loop 
└─live-rw                    253:0    0     5G  0 dm   /sysroot
loop3                          7:3    0   100G  0 loop 
└─docker-253:0-278707-pool   253:2    0   100G  0 dm   
  └─docker-253:0-278707-base 253:3    0    10G  0 dm   
loop4                          7:4    0     2G  0 loop 
└─docker-253:0-278707-pool   253:2    0   100G  0 dm   
  └─docker-253:0-278707-base 253:3    0    10G  0 dm   
```

```
[fedora@atomic-00 ~]$ sudo docker info
Containers: 1
Images: 3
Storage Driver: devicemapper
 Pool Name: docker-253:0-278707-pool
 Pool Blocksize: 65.54 kB
 Backing Filesystem: extfs
 Data file: /dev/loop3
 Metadata file: /dev/loop4
 Data Space Used: 567.7 MB
 Data Space Total: 107.4 GB
 Data Space Available: 3.827 GB
 Metadata Space Used: 1.004 MB
 Metadata Space Total: 2.147 GB
 Metadata Space Available: 2.146 GB
 Udev Sync Supported: true
 Data loop file: /var/lib/docker/devicemapper/devicemapper/data
 Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata
 Library Version: 1.02.93 (2015-01-30)
Execution Driver: native-0.2
Kernel Version: 4.0.1-300.fc22.x86_64
Operating System: Fedora 22 (Twenty Two)
CPUs: 1
Total Memory: 3.892 GiB
ame: atomic-00.localdomain
ID: 5TP5:IGTL:CWW3:2L43:G26P:M7T7:IICW:Y5PE:C56W:FA77:OTI7:65NG
```

Recently we've added `iscsi-initiator-utils` to Atomic Host so now it is possible to use devicemapper backend with LVM thin pool on iSCSI device which is set up for docker by `docker-storage-setup` service (the service is disabled on live Atomic by kickstart command). We will use cloud-init to configure the storage, adding this configuration to `user-data`:

```
write_files:
  - path: /etc/sysconfig/docker-storage-setup
    permissions: 0644
    owner: root
    content: |
      DEVS=/dev/sda
      VG=docker-images
      SETUP_LVM_THIN_POOL="yes"

runcmd:
  - iscsiadm --mode discoverydb --type sendtargets --portal 10.34.102.54 --discover
  - iscsiadm --mode node --targetname iqn.2009-02.com.example:part --portal 10.34.102.54:3260 --login
  - docker-storage-setup
  - systemctl restart docker.service
```

First we write configuration file for `docker-storage-service` telling it what device (`DEVS=`) it should use. We are assuming diskless machine where iSCSI device will become `/dev/sda`, but in general any unpartitioned block device should work. By `VG=` we configure the name of volume group the service creates for the thin pool logical volume. The SETUP_LVM_THIN_POOL flag tells docker-storage-setup to set up lvm thin pool for docker (otherwise it only creates data an metadata logical volumes for docker handling the thin pool on its own). This is option is not required in Fedora rawhide as it is become the default.

Then we run commands to attach the iSCSI device (the device must be unpartitioned), run `docker-storage-setup` to prepare thin pool for docker and configure docker to use it, and restart docker service to use new storage configuration.

Running live Atomic with this cloud config we can see that docker's devicemapper backend is using the pool created by `docker-storage-setup` on iSCSI device.

```
[fedora@atomic-00 ~]$ lsblk
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                                     8:0    0     2G  0 disk 
└─sda1                                  8:1    0     2G  0 part 
  ├─docker--images-docker--pool_tmeta 253:4    0     4M  0 lvm  
  │ └─docker--images-docker--pool     253:6    0     2G  0 lvm  
  │   └─docker-253:0-278707-base      253:2    0    10G  0 dm   
  └─docker--images-docker--pool_tdata 253:5    0     2G  0 lvm  
    └─docker--images-docker--pool     253:6    0     2G  0 lvm  
      └─docker-253:0-278707-base      253:2    0    10G  0 dm   
sr0                                    11:0    1   623M  0 rom  
loop0                                   7:0    0 378.6M  1 loop 
loop1                                   7:1    0     5G  1 loop 
├─live-rw                             253:0    0     5G  0 dm   /sysroot
└─live-base                           253:1    0     5G  1 dm   
loop2                                   7:2    0     1G  0 loop 
└─live-rw                             253:0    0     5G  0 dm   /sysroot
```
```
[fedora@atomic-00 ~]$ sudo lvs
  LV          VG            Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-pool docker-images twi-aotz-- 1.95g             0.56   1.07                            
```
```
[fedora@atomic-00 ~]$ sudo docker info
Containers: 0
Images: 0
Storage Driver: devicemapper
 Pool Name: docker--images-docker--pool
 Pool Blocksize: 65.54 kB
 Backing Filesystem: extfs
 Data file: 
 Metadata file: 
 Data Space Used: 11.8 MB
 Data Space Total: 2.093 GB
 Data Space Available: 2.081 GB
 Metadata Space Used: 45.06 kB
 Metadata Space Total: 4.194 MB
 Metadata Space Available: 4.149 MB
 Udev Sync Supported: true
 Library Version: 1.02.93 (2015-01-30)
Execution Driver: native-0.2
Kernel Version: 4.0.1-300.fc22.x86_64
Operating System: Fedora 22 (Twenty Two)
CPUs: 1
Total Memory: 3.892 GiB
Name: atomic-00.localdomain
ID: RQHA:CJAF:B5WX:M3RN:W7UI:2LCZ:ULKB:7SZA:WJYH:HSJR:FRLE:VCPA
```

And how much overlay space will pulling docker image eat up now?

```
[fedora@atomic-00 ~]$ sudo dmsetup status live-rw
0 10485760 snapshot 633144/2097152 2472
```
```
[fedora@atomic-00 ~]$ sudo docker pull centos
latest: Pulling from centos
6941bfcbbfca: Pulling fs layer 
6941bfcbbfca: Download complete 
41459f052977: Download complete 
fd44297e2ddb: Download complete 
Status: Downloaded newer image for centos:latest
```
```
[fedora@atomic-00 ~]$ sudo dmsetup status live-rw
0 10485760 snapshot 633552/2097152 2480
```

Far better, some 200 KB were consumed during the pull. With this setup we seem to have fairly usable live Atomic system.

### Mounitng live image with rd.writable.fsimg?

There is a new patch in rawhide dracut alowing to mount rootfs image packed in squashfs image in a slightly different way, copying the rootrs image into RAM and loop mounting it read-write.

```
live-rootfs.squashfs.img
         |
        (ro)
         |
         V
     /dev/loop0
         |
     (squashfs ro)
         |
         V
  LiveOS/rootfs.img (sparse)
         |
        cp
         |
         V
/run/initramfs/fsimg/rootfs.img
         |
        (rw)
         |
         V
     /dev/loop1
         |
   (dm linear rw)
         |
         V
/dev/mapper/live-rw
         |
         /
```


With this option there is no read-write overlay layer so you don't need to care about its size and `rd.live.overlay.size` option.

You should be able to try this dracut boot option with Atomic Host images built from rawhide repository. See the *Builiding image from non-local Atomic repo* section for learning how to use another repository in place of the one embedded in installer ISO. The effectiveness of this approach compared to read-write overlay is something to be explored and will probably vary in aspects depending on use case.