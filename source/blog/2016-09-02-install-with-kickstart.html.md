---
title: "Subatomic cluster install with Kickstart"
author: jberkus
tags: atomic host, administration, microcluster
date: 2016-09-02 12:00:00 UTC
published: true
comments: true
---

In my previous install of the [Subatomic Cluster](/blog/2016/06/micro-cluster-part-1/), I simply did the manual Ananconda install.  However, since this cluster is for testing, I wanted a way to re-install it rapidly so that I can test out various builds of Atomic.

I also wanted to fix the disk allocation.  Due to various limitations, the initial root partition for a new Atomic Host is of fixed size (3GB) regardless of the amount of disk space available.  I wanted to increase that to 1/4 of the 64GB size of each SSD.  

Enter Kickstart, which is the standard installation automation system used by Fedora, CentOS, RHEL, and other Linux distributions.  I was more familiar with Kickstart as part of a PXEboot network install, and re-installing the cluster required something simpler.  In this case, a Kickstart file on the network, combined with editing the boot line for install.  Since [the Kickstart documentation](https://docs.fedoraproject.org/en-US/Fedora/24/html/Installation_Guide/chap-kickstart-installations.html) is extensive enough to be confusing, here's some simple examples.  

First, I created an [atomic-ks.cfg](https://gist.github.com/jberkus/cfcdea64361ca7b75dcf5517f2a6a748) file and dropped it on my laptop.  I've added comments in the example file so that you can understand what it's doing and modify it for your own use.  I then served this file on the local network just using `python -m SimpleHTTPServer`.  I've annotated [the atomic-ks.cfg file on Gist](https://gist.github.com/jberkus/cfcdea64361ca7b75dcf5517f2a6a748) so that you can use it as a base for your own.

I then booted each minnowboard off the USB.  There was one manual step: I had to edit the grub boot menu and tell it to use the kickstart file.  When the boot menu comes up, I selected "Install Fedora 24", pressed "e" and edited the linuxefi boot line:

```
linuxefi /images/pxeboot/vmlinuz inst.ks=http://192.168.1.105:8000/atomic-ks.cfg inst.stage2=hd:LABEL=Fedora-Atomic-24-x86_64 quiet
```

After that, it's all automatic.  Anaconda will partition, install, and boot the system.

*Thanks to Dusty Mabe and Matthew Micene for helping me create this Kickstart config and troubleshoot it*
