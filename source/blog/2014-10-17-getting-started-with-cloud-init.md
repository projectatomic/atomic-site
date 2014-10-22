---
title: Getting started with cloud-init
author: mmicene
date: 2014-10-17 
layout: post
comments: true
categories: 
- Blog
tags: 
---

Colin Walters [recently announced] (https://lists.projectatomic.io/projectatomic-archives/atomic/2014-October/msg00000.html) a new cloud image for Atomic that includes support for cloud-init and Kubernetes.  Supporting cloud-init is a great move but running this image locally with KVM needs a different set up than previous images.  Here's a walk through to get started with this latest image and the Fedora Atomic Cloud releases.  This was the first time I needed to work with cloud-init, and there was a bit of a learning curve.  There are a few different examples floating around the web and none of them seemed to work quite right.

READMORE

First things first, I'll grab the new image from the alt.fp.org link in Colin's message and expand it.

```
$ wget https://alt.fedoraproject.org/pub/alt/fedora-atomic/testing/rawhide/20141008.0/cloud/fedora-atomic-rawhide-20141008.0.qcow2.xz
$ xz -d fedora-atomic-rawhide-20141008.0.qcow2.xz
```

Since this image is using cloud-init, it will be looking for somewhere to pull two kinds of information: metadata and userdata.  Metadata is cloud specific host information like instance ID numbers, hostname, IP address, etc.  Userdata is pretty much everything else: adding and modifying users, adding packages, calling configuration management systems, etc.  This information is injected into the host the first time it boots.  The cloud-init package supports several different drivers to inject this information for different cloud APIs, including a 'No Cloud' driver.  Running this locally in KVM, I'll be using that driver.

You can see from [the docs](http://cloudinit.readthedocs.org/en/latest/topics/datasources.html#no-cloud) that the 'No Cloud' driver needs two YAML files provided at the root of an ISO to the booting instance.  The meta-data file I'm going to provide is just enough to get the system started and set a hostname.  Add these two lines to a file called `meta-data`

```
instance-id: Atomic01
local-hostname: atomic-host-001
```

One important note about making iterative changes during testing.  If you change the user-data or meta-data files and rebuild the ISO, you will need to update the instance-id.  This is how `cloud-init` knows if this is the first boot of a specific instantiated host.

For our user-data file, I'm going to set a password and inject a ssh key for the default user 'fedora'.  I don't want to use my normal key here, so I'll build one for this example.  I've also set ssh up to accept a password.  You can skip that if you want key only authentication.  

```
$ ssh-keygen -f atomic_rsa
Generating public/private rsa key pair.
<truncating output>
$ cat atomic_rsa.pub 
$ vim user-data

#cloud-config
password: redhat
chpasswd: { expire: False }
ssh_pwauth: True
ssh_authorized_keys:
   - ... ssh-rsa new public key here user@host ...
```

If you want to add more ssh keys, just add a new line starting with a - under the `ssh_authorized_keys:` stanza.  This is YAML, so you want to use white spaces not tabs to indent.  The `#cloud-init` line is not a comment in the user-data file.  This is acutally a keyword that needs to be there.  Anything else preceeded with a `#` is a comment.  

I've got the two files ready, so now I need to make a ISO to provide during the boot process.  If you've got a favorite method, you can use that, I'll use `genisoimage`.

```
$ genisoimage -output atomic01-cidata.iso -volid cidata -joliet -rock user-data meta-data
```
Now I've got everything I need to boot the qcow2 image, log in via the console and ssh as the default `fedora` user.  I'm using the downloaded image as the primary disk, the cloud-init ISO as the CD-ROM and attaching it to an existing bridge that virt-manager created previously.

```
$ qemu-kvm -name atomic-cloud-host -m 768 -hda fedora-atomic-rawhide-20141008.0.qcow2 -cdrom atomic01-cidata.iso -netdev bridge,br=virbr0,id=net0 -device virtio-net-pci,netdev=net0 -display sdl
```

As you watch the console you'll see cloud-init do it's work, including getting an IP from the bridge and setting up the authorized key for the `fedora` user.  I can log in using the key I created and injected, switch to root and set the host up for updates from the repo.

```
$ ssh -i atomic_rsa fedora@192.168.122.92
The authenticity of host '192.168.122.92 (192.168.122.92)' can't be established.
ECDSA key fingerprint is 9f:6a:4f:2c:b0:78:ca:7e:ba:0d:af:e5:0b:d3:15:a6.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.122.92' (ECDSA) to the list of known hosts.
[fedora@atomic-host-001 ~]$ 

[fedora@atomic-host-001 ~]$ sudo su -
-bash-4.3# ostree remote add alt.fp.org --set=gpg-verify=false https://alt.fedoraproject.org/pub/alt/fedora-atomic/repo/
-bash-4.3# atomic rebase alt.fp.org:

631 metadata, 2770 content objects fetched; 90536 KiB transferred in 34 seconds

Copying /etc changes: 11 modified, 0 removed, 15 added
Transaction complete; bootconfig swap: yes deployment count change: 1)
Deleting ref 'fedora-atomic:fedora-atomic/rawhide/x86_64/docker-host'
Changed:
```

I can see now that I have a new ostree with a different refspec that will be active on reboot.

```
-bash-4.3# atomic status
  TIMESTAMP (UTC)         ID             OSNAME            REFSPEC                                                    
  2014-10-17 17:29:43     8392c7b6cd     fedora-atomic     alt.fp.org:fedora-atomic/rawhide/x86_64/docker-host        
* 2014-10-08 20:12:21     9a56faf008     fedora-atomic     fedora-atomic:fedora-atomic/rawhide/x86_64/docker-host   
-bash-4.3# reboot
[fedora@atomic-host-001 ~]$ atomic status
  TIMESTAMP (UTC)         ID             OSNAME            REFSPEC                                                    
* 2014-10-17 17:29:43     8392c7b6cd     fedora-atomic     alt.fp.org:fedora-atomic/rawhide/x86_64/docker-host        
  2014-10-08 20:12:21     9a56faf008     fedora-atomic     fedora-atomic:fedora-atomic/rawhide/x86_64/docker-host 
```

You can use this as a starting point to add more users, add the new repo from the user-data file, add additional keys to the default fedora user, etc.  If you'd like to check out Kubernetes, the GuestBook example in the Kubernetes Github repo works with some minor changes.
