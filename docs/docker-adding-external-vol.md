Attaching External Storage for Docker
=====================================

This section descibes how to attach an external volume to your Docker host for Docker usage.

# Motivation
In most cases an administrator will not be able to predict precisely how large the local repository will become on the Docker host. At the same time it is prudent to keep RHEl Atomic images as small as possible. If you have a small RHEL Atomic Controller image, e.g.8Gb, this is hardly enough space to do lots of Docker work. Docker will fill up the /var/lib/docker, where all the Docker images and metadata is stored, very quickly. It is recommended to  make an external volume available and bind mount it to the /var/lib/docker dir.
 
On Debian and Ubuntu it's possible to make a change to the `/etc/default/docker` file (add `DOCKER_OPTS="-g <path-to-larger-dir>"`). But Fedora and RHEL, which use systemd, don't follow that approach. Furthermore with SELinux labels it is important to be using `/var/lib/docker`.
 
# Solution

First we need to create a substantial sized volume:
 
    # lvcreate --size 30GB --name extra-disk-for-rhel-atomic
 
then attach it to the RHEL Atomic virtual machine using virt-manager. 
 
Now, on the rhel atomic controller, ensure the device is there:
 
    # fdisk -l
 
Create a partition with the newly discovered device from the output above:
 
    # fdisk /dev/sdb   
 
Create a filesystem on the new partition, or start using lvm here.
 
    # mkfs.ext4 /dev/sdb1
 
Get the UUID from the device:
 
    # blkid /dev/sdb1
 
Add that UUID to the `/etc/fstab`:
 
    UUID=be840c0d-91f8-41fa-bb40-82e1c4e2e985 /var/lib/docker ext4 defaults 1 1

Then we need to stop the Docker deamon:
 
    # systemctl stop docker
 
Mount the volume:

    # mount -a
 
And restart Docker deamon:

    # systemctl start docker

And that is it. When Docker restarts it will create several files and directories in '/var/lib/docker' and you should be able to check the success by viewing that direcories contents. 