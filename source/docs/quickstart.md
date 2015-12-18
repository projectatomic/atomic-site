# Project Atomic Quick Start Guide

We recommend reading the [Getting Started Guide](http://www.projectatomic.io/docs/gettingstarted) and Concepts Guide if you're entirely new to the concept of Atomic and Docker. But, we also wanted to provide a **Quick Start Guide** (or "guide for the impatient") for folks who just want to set up a single Atomic host and see what all the fuss around Docker and Atomic is about.

## What You Need

* **A virtualization client.** [Virtual Machine Manager](http://virt-manager.org/) (virt-manager) is a very good KVM-based client for Linux systems. Windows and OS X users can give [VirtualBox](https://www.virtualbox.org/) a try. Be sure your virtualization client is properly configured to access the Internet.

* **A virtual machine image.** Images for Atomic hosts are produced by both the Fedora Project and the CentOS Project.  Downloads for these images can be found via the [Downloads page] (http://www.projectatomic.io/download/) in QCOW2, RAW, and Vagrant BOX formats.

    **Note for VirtualBox users** We are not producing native VirtualBox images, but you can generate your own VirtualBox image from the qcow2 images with `qemu-img`:

    `$ qemu-img convert -f qcow2 [filename].qcow2 -O vdi [filename].vdi`

## Step by Step
There are three basic steps we'll do for each virtualization provider before booting the virtual machine:

1. Prep the cloud-init source ISO

2. Create the Atomic host virtual machine

3. Add and configure storage for Docker

## Prep the cloud-init source ISO

In order to pass run time customizations to an Atomic host, we use [**cloud-init**](http://cloudinit.readthedocs.org/en/latest/) .  

You will need to create a metadata ISO to supply critical data when your Atomic host boots.  System data is presented via the `meta-data` file and configuration data via the `user-data` file.  We will be setting up the password and ssh key for the default user.  The metatdata ISO is created on the machine running your virtualization provider.

1. Create a `meta-data` file with your desired hostname and instance-id.  If you need to change any of this information on a running host, you will need to increment the `instance-id`.  This is how `cloud-init` identifies a particular instance.

        $ vi meta-data
        instance-id: atomic-host001
        local-hostname: atomic01.example.org

2. Create a `user-data` file.

    **Note:** The #cloud-config directive at the beginning of the file is mandatory, not a comment.

    If you have multiple admins and ssh keys you'd like to access the default user, you can add a new `ssh-rsa` line.

        $ vi user-data
        #cloud-config
        password: atomic
        ssh_pwauth: True
        chpasswd: { expire: False }

        ssh_authorized_keys:
          - ssh-rsa ... foo@bar.baz (insert ~/.ssh/id_rsa.pub here)

3. After creating the `user-data` and `meta-data` files, generate an ISO file. Make sure the user running libvirt has the proper permissions to read the generated image.

        $ genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data

You'll add this ISO as a CD-ROM device in the virtual machine.

## Create the Atomic host virtual machine

We'll start with the QCOW2 format image for both virt-manager and VirtualBox.  For virt-manager, you will use this image directly. For VirtualBox, convert the QCOW2 to VDI in order to create an image suitable for VirtualBox.


````
$ qemu-img convert -f qcow2 [filename].qcow2 -O vdi [filename].vdi

````

### Creating with virt-manager

Here's how to get started with Atomic on your machine using virt-manager on Linux. The instructions below are for running virt-manager on Fedora 21. The steps may vary slightly when running older distributions of virt-manager.

1. Select `File` -> `New Virtual Machine` from the menu bar\. The New VM dialog box will open.

2. Select the Import existing disk image option and click Forward. The next page in the New VM dialog will appear.

3. Click `Browse`. The Locate or create storage volume dialog will open.

4. Click `Browse Local`. The Locate existing storage dialog will open.

5. Navigate to the downloaded virtual machine file, select it, and click `Open`.

6. In the New VM dialog, select `Linux` for the OS type, `Fedora 21` (or later) for the Version, and click `Forward`.

7. Adjust the VM's RAM and CPU settings (if needed) and click `Forward`.

8. Select the checkbox next to `Customize configuration before install` and click `Forward`.  This will allow you to add the metatdata ISO device before booting the VM.

**Note**: When running virt-manager on Red Hat Enterprise Linux 6 or CentOS 6, the VM **will not boot** until the disk storage format is changed from raw to qcow2.


#### Adding the CD-ROM device for the metadata source

1. In the virt-manager GUI, click to open your Atomic machine. Then on the top bar click *View > Details*
2. Click on *Add Hardware* on the bottom left corner.
3. Choose *Storage*, and *Select managed or other existing storage*. Browse and select the `init.iso` image you created. Change the *Device type* to CD-ROM device.  Click on *Finish* to create and attach this storage.

### Creating with VirtualBox

Here's how to get started with Atomic on your machine using VirtualBox on Windows, OS X, or Linux.

1. Click the New icon on the VirtualBox toolbar. The Create Virtual Machine dialog box will open.

2. Enter a name for the new machine, select `Linux` for the Type, `Fedora (64 bit)` for the Version, and click `Next`.

3. Adjust the VM's RAM if needed and click `Next`.

4. Select the `Use an existing virtual hard drive` option, browse to the file location, and click `Create`. The virtual machine will be created and the virtual machine will be ready.

#### Adding the CD-ROM device for the metadata source

1. In the VirtualBox GUI, click *Settings* for you Atomic virtual machine.
2. On the *Storage* tab, for the IDE Controller, *Add CD/DVD Device*.
3. Select *Choose Disk*, and select the `init.iso` you created.

## Exploring the Atomic host

Boot the virtual machine with the CD-ROM attached and cloud-init will populate the default user information with the password or SSH keys you provided in the `user-data` file. **For a Fedora image, the default user is `fedora`, for CentOS the default user is `centos`.**

Once you've booted and logged in to your Atomic host, you can update the system software with `$ sudo rpm-ostree upgrade` to pull in any updates.

### Add and configure storage for Docker

Docker is ready to go at this point, but there's another fairly important bit of config to do, if you're going to be testing out more than a couple containers--you need to add a bigger drive for the docker LVM thin pool.

#### Add A New Drive in virt-manager

1. Select the View, Details menu command on your VM window.

2. Click the Add Hardware. The Add New Virtual Hardware dialog box will open.

3. Select Storage, change disk size to what you want, change bus type to VirtIO, and click Finish. The Add New Virtual Hardware dialog box will close.

#### Add A New Drive in VirtualBox

1. With the Atomic VM closed, select the Machine, Settings menu command. The Settings dialog box will open.

2. Select the Storage option. The Storage settings will appear.

3. Select the Controller for the VM and click the Add Hard Disk icon. A Question dialog will open.

4. Choose Create New Disk. The Create Virtual Hard Drive dialog box will open.

### Configuring the New Drive

1. Run `$ sudo fdisk -l` to find name of your new disk (e.g., /dev/vdb)

2. Open `/etc/sysconfig/docker-storage-setup` in an editor

3. Add the new disk by creating a `DEVS` entry.  If you added more than one, you can add more to the list separated by a space.

        DEVS="/dev/vdb"

4. If you'd like to use some of the space on the new disk to grow the root volume, you can create a `ROOT_SIZE` with the new total size.

        ROOT_SIZE=4G

5. Run `$ sudo docker-storage-setup` to run the helper script and configure the thin pool.  This tool calculates the amount of available space, what's needed for the metadata pool, and executes the LVM commands.

6. Run `$ sudo docker info` to make sure that the Docker daemon sees the added space.

7. If you added space to the root volume, run `$ sudo xfs_growfs /` to make sure the filesystem gets expanded to match the volume size.

8. If you added space to the root volume, run `df -Th` to make sure that the root volume has been grown to the new total size.

## Finding Help

For more help, check out the Project Atomic mailing lists for [general discussions](http://lists.projectatomic.io/mailman/listinfo/atomic) or [technical issues](http://lists.projectatomic.io/mailman/listinfo/atomic-devel) or ask a question in our [forum](http://ask.projectatomic.io).

## Reporting Bugs

If you have a well identified issue, report it in the Bugzilla hosted by Red Hat. Remember: first [check existing issues](https://bugzilla.redhat.com/buglist.cgi?product=Atomic), then [enter a new bug](https://bugzilla.redhat.com/enter_bug.cgi?product=Atomic). We appreciate your bugs!
