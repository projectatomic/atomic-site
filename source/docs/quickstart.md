# Project Atomic Quick Start Guide

We recommend reading the Getting Started Guide and Concepts Guide if you're entirely new to the concept of Atomic and Docker. But, we also wanted to provide a **Quick Start Guide** (or "guide for the impatient") for folks who just want to plow through and see what all the fuss is about. 

## What You Need

* **A virtualization client.** [Virtual Machine Manager](http://virt-manager.org/) (virt-manager) is a very good KVM-based client for Linux systems. Windows and OS X users can give [VirtualBox](https://www.virtualbox.org/) a try. Be sure your virtualization client is properly configured to access the Internet.

* **A virtual machine image.** Images for Atomic based on Fedora 20 can be found at the [rpm-ostree project](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/) for [VirtualBox](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/f20/vbox) and [KVM/QEMU](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/f20/qemu) images for virt-manager.

## Step by Step on virt-manager

Here's how to get started with Atomic on your machine using virt-manager on Linux. The instructions below are for running virt-manager on Fedora 20. The steps may vary slightly when running older distributions of virt-manager.

1. Download the KVM/QEMU image.

2. Run `xz -d [filename]` to uncompress the downloaded image.

3. Start virt-manager.

4. Run the File, New Virtual Machine menu command. The New VM dialog box will open.

5. Select the Import existing disk image option and click Forward. The next page in the New VM dialog will appear.

6. Click Browse. The Locate or create storage volume dialog will open.

7. Click Browse Local. The Locate existing storage dialog will open.

8. Navigate to the downloaded virtual machine file, select it, and click Open. The Locate existing storage dialog will close.

9. In the New VM dialog, select Linux for the OS type, Fedora 20 (or later) for the Version, and click Forward. The next page in the New VM dialog will appear.

10. Adjust the VM's RAM and CPU settings (if needed) and click Forward. The next page in the New VM dialog will appear.

11. Assign a new name to the VM and click Finish. The Atomic instance will boot.

Note: When running virt-manager on Red Hat Enterprise Linux 6 or CentOS 6, the VM will not boot until the disk storage format is changed from raw to qcow2.

## Step by Step on VirtualBox

Here's how to get started with Atomic on your machine using VirtualBox on Windows, OS X or Linux.

1. Download the VirtualBox image.

2. Run `bzip2 -i [filename]` to uncompress the downloaded image.

3. Start VirtualBox.

4. Click the New icon on the VirtualBox toolbar. The Create Virtual Machine dialog box will open.

5. Enter a name for the new machine, select Linux for the Type, Fedora (64 bit) for the Version, and click Next. The Memory Size page in the Create Virtual Machine dialog will appear.

6. Adjust the VM's RAM if needed and click Next. The Hard Drive page in the Create Virtual Machine dialog will appear.

7. Select the Use an existing virtual hard drive option, browse to the file location, and click Create. The virtual machine will be created and the virtual machine will be ready.

## Logging In To Your Atomic Machine

You will need to create a metadata ISO to supply data through [**cloud-init**](http://cloudinit.readthedocs.org/en/latest/) when your host boots. 

1. Create a ```meta-data``` file with your desired hostname and any instance-id.

  ```
  $ cat meta-data
  instance-id: id-local01
  local-hostname: samplehost.example.org
  ```
2. Create a ```user-data``` file. The #cloud-config directive at the beginning of the file is mandatory.
  ```
  $ cat user-data
  #cloud-config
  password: mypassword 
  ssh_pwauth: True
  chpasswd: { expire: False }
  
  ssh_authorized_keys: 
    - ssh-rsa ... foo@bar.baz (insert ~/.ssh/id_rsa.pub here)
  ```
3. After creating the `user-data` and `meta-data` files, generate an ISO. Make sure the user running libvirt has the proper permissions to read the generated image.

  ```$ genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data```

#### virt-manager

1. In the virt-manager GUI, click to open your Atomic machine. Then on the top bar click *View > Details*
2. Click on *Add Hardware* on the bottom left corner.
3. Choose *Storage*, and *Select managed or other existing storage*. Browse and select the `init.iso` image you created. Click on *Finish* to create and attach this storage.
4. Go to *Boot Options* and check the box next to the name of the recently created device, under the *Boot device order* menu. This will make your system boots using the cloud-init ISO.
5. You should be able to boot your machine and use the password or SSH keys specified in your `user-data` file.

#### VirtualBox

1. In the VirtualBox GUI, click *Settings* for you Atomic virtual machine.
2. On the *Storage* tab, for the IDE Controller, *Add CD/DVD Device*.
3. Select *Choose Disk*, and select the `init.iso` you created.
4. Boot your machine with the disk attached and cloud-init will populate your user information with the password you provided. **For a Fedora image, the user is `fedora`, for CentOS the user is `centos`.**

Now that you've booted and logged in to your machine, you can update the system software with `$ sudo rpm-ostree upgrade` to pull in any updates.

## Readying More Space For Containers

Docker is ready to go at this point, but there's another fairly important bit of config to do, if you're going to be testing out more than a couple containers--you need to add a bigger drive for `/var/lib/docker`.

### Add A New Drive in virt-manager

1. Select the View, Details menu command on your VM window.

2. Click the Add Hardware. The Add New Virtual Hardware dialog box will open. 

3. Select Storage, change disk size to what you want, change bus type to VirtIO, and click Finish. The Add New Virtual Hardware dialog box will close. 

### Add A New Drive in VirtualBox

1. With the Atomic VM closed, select the Machine, Settings menu command. The Settings dialog box will open.

2. Select the Storage option. The Storage settings will appear.

3. Select the Controller for the VM and click the Add Hard Disk icon. A Question dialog will open.

4. Choose Create New Disk. The Create Virtual Hard Drive dialog box will open.

5. Follow the steps 7-10 above used in creating a new VirtualBox VM to make a new hard drive for the VirtualBox VM.

### Configuring the New Drive

1. Run `fdisk -l` to find name of your new disk (e.g., /dev/vdb)

2. Run `fdisk /dev/vdb`. 

3. In fdisk, type `n`, `p`, [Enter] three times, and `w` to make new partition on a new
disk.

4. Run `mkfs.xfs /dev/vdb1`. This doesn't have to be xfs, it can be any filesystem type.

5. If you already have data in `/var/lib/docker` you want to keep, copy this data off to some backup directory.

6. Run `systemctl stop docker`.

7. Run `rm -rf /var/lib/docker/*`

8. Run `blkid /dev/vdb1`. Take note of the blkid.

9. Open /etc/fstab and add this line:

`UUID=<UUID-from-blkid> /var/lib/docker <file system type> defaults 1 1`

10. Run `mount -a`.

11. Run `systemctl start docker`. Docker is ready to go.

## Finding Help

For more help, check out the Project Atomic mailing lists for [general discussions](http://lists.projectatomic.io/mailman/listinfo/atomic) or [technical issues](http://lists.projectatomic.io/mailman/listinfo/atomic-devel) or ask a question in our [forum](http://ask.projectatomic.io).

## Reporting Bugs

If you have a well identified issue, report it in the Bugzilla hosted by Red Hat. Remember: first [check existing issues](https://bugzilla.redhat.com/buglist.cgi?product=Atomic), then [enter a new bug](https://bugzilla.redhat.com/enter_bug.cgi?product=Atomic). We appreciate your bugs!
