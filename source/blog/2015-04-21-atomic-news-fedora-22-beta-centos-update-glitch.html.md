---
title: 'Atomic News: Fedora 22 Beta, CentOS Update Glitch (and Fix!)'
author: jzb
date: 2015-04-21 20:27:06 UTC
tags: Fedora, CentOS
comments: true
published: true
---

In case you missed it, Fedora 22 Beta was [released today](http://fedoramagazine.org/fedora-22-beta-released/) with [images for using Fedora Atomic Host](https://getfedora.org/en/cloud/prerelease/). If you're looking for qcow2 images for KVM, Vagrant Boxes, or EC2 AMIs, you'll find them all there. But wait, there's more! 

Not listed on the product page, but worth checking out, is an ISO you can use to install Atomic on bare metal (or in another virtualization platform of your choice). You can find that image [here](https://dl.fedoraproject.org/pub/alt/stage/22_Beta_RC3/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-x86_64-22_Beta.iso), along with its [CHECKSUM file](https://dl.fedoraproject.org/pub/alt/stage/22_Beta_RC3/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-22_Beta-x86_64-CHECKSUM). 

If you've installed Fedora before, that will look very familiar. You don't get to select packages, but the rest of the experience is fairly similar to doing a Server or Workstation installation. Give it a spin and let us know how it works for you! Note that you can use this image to install Atomic on a system and then [build your own](https://github.com/jasonbrooks/byo-atomic) Build Your Own Atomic to pull updates from. 

## CentOS Update Problem

If you've been using the test builds of CentOS Atomic Host based on CentOS 7, you may have run into a problem trying to update to the most recent tree:

````
# atomic upgrade
Updating from: centos-atomic-host:centos/7/atomic/x86_64/cloud-docker-host
 
Receiving objects: 24% (1436/5931) 308.3 kB/s 34.2 MB          
error: fsetxattr: Invalid argument
````

[According to Colin Walters](https://lists.projectatomic.io/projectatomic-archives/atomic/2015-April/msg00000.html) "what's happening here is that this is a full atomic switch from a CentOS 7.0 to CentOS 7.1 base - but we're using the old selinux policy to do it.  The 7.0 SELinux policy had a bug with respect to rpm-ostree that caused a domain transition to not occur."

The workaround is to use the `runcon` command to  run `atomic upgrade` with a context that won't fail:

````
# runcon -r system_r -t install_t atomic upgrade
````

This is a one-time issue, it shouldn't be a problem with future updates.