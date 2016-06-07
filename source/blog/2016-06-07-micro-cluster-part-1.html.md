---
title: Building a Sub-Atomic Cluster, Part 1
author: jberkus
date: 2016-06-07 12:00:00 UTC
tags: docker, atomic host, events
published: true
comments: true
---

While a lot of people use Atomic Host and OpenShift on public clouds, one of the ideas behind Project Atomic is to enable you to create your own container cloud. So for both testing and demos, we needed a container stack on "real hardware," letting us test things like bare-metal deployment, Foreman integration, power-loss failover, and high availability in general. And this cluster needed to be small enough to bring with us to events.  Given that, introducing the Sub-Atomic cluster:

![picture of minnowboard cluster](https://photos.smugmug.com/Computers/ContanersContainersContainers/i-Q7wJtsG/0/M/P1020636-M.jpg)

This micro-cluster contains four hosts (proton, electron, neutron, and photon), and is a fully functioning Atomic cluster.  If you want to see it in person, I will be demoing it at [DockerCon in Seattle](http://2016.dockercon.com/) at the Red Hat booth, where I will also be raffling off one of the minnowboards with Atomic Host pre-installed.  I will also be showing it off in the Community Central pavillion at [Red Hat Summit](https://www.redhat.com/en/summit).  For my fellow Portlanders, you can get a look at the Sub-Atomic Cluster early if you come to [PDXPUG](http://www.meetup.com/PDXPUG-Portland-PostgreSQL-Users-Group/events/231259650/), where I will use it to demo high-availability containerized Postgres.

On this blog, I'll show you how I built it, so that you can create your own.  More usefully, most of the steps and techniques used for creating the cluster are the same as what you'd need on real hardware, so consider this your introduction to bare-metal deployment of the Atomic platform.

First, let's talk about the hardware.  The four boards are [Minnowboard Turbots](http://wiki.minnowboard.org/MinnowBoard_Turbot), which are small "maker" boards, similar to the Raspberry Pi, but using an Intel x86 chipset (Atom E3826).  That means that we can run Atomic Host and other software without needing to recompile it for ARM, and makes it a much better testbed for real Atomic.  Order your soon; Intel is reducing Atom production and Turbots will become scarce in the future. Currently, one of the boards has a helper board ("lure") with an SSD; the remaining cards are running off SD cards.  I'll be adding more SSDs to the cluster later so that I can demonstrate Kubernetes HA configurations.

The boards are "stacked" using 3mm brass standoffs, and capped at either end with 1/4" craft plywood.  As you can see, those plywood boards are there to hold two things: a mini power strip for the Minnowboard power, and an 8-port router to connect the cluster.  We need the latter in order to assign fixed IP addresses to all four boards, since Kuberntes is a lot happier configured that way.  I'm using a TP-Link TL-R860. Amusingly, the power and networking are larger and heavier than the boards themselves. You could slim this down by using wireless networking, but since I'll be taking this cluster to conventions, that wasn't really an option.

Once everything was plugged in, it was time to install Atomic Host on all the nodes.  Ideally, I'd use [Foreman](https://theforeman.org/) for this, but I had constraints setting up a Foreman image server which would have required another board with SSD, so using Foreman will need to be a blog post for later.  I also thought about establishing a [kickstarter file](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-kickstart2-putkickstarthere.html) on the local network, but with only four boards it didn't seem worth it. Instead, I installed manually.  After some experimentation with installation methods, it turns out that installing from a USB key with an ISO image is really the best way; while you can write a raw host image directly to an SD card, it won't be sized right and you'll need to take a bunch of manual steps to make all of the space on the SD card available.

So, I downloaded the [Fedora Atomic Host ISO](https://getfedora.org/en/cloud/download/atomic.html) from Fedora downloads. I then wrote this to a bootable USB key, from my Fedora laptop:

```
wget https://download.fedoraproject.org/pub/alt/atomic/stable/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-x86_64-23-20160420.iso
dd if=Fedora-Cloud_Atomic-x86_64-23-20160420.iso of=/dev/sdc
```
I plugged in the key and a USB keyboard into the first host, proton.  Since this board is my initial kube-master, it's the one with the SSD. Since I'm doing a manual install, that also required me to plug an HDMI monitor into the board, which I'd be using just long enough to get the Anaconda remote VNC installer started.  Since we didn't plug in a mouse (which would have required a powered USB hub), we won't want to use the GUI installer.  Instead, at boot time, hit F2 to bring up the boot menu, and choose the USB key to boot from.  Then quickly hit TAB when the GRUB boot menu comes up, followed by "e" to edit the boot options for the the installer.  You'll want to add the following commands to the *end* of the boot line, which will be the first of two or three lines in the boot config:

```
  boot: linux ... inst.vnc inst.vncpassword=FedoraAH
```

Then save to boot it up.  In a few minutes, the screen will display the VNC server address, which you can then connect to using a VNC client (Remote Desktop or TigerVNC on Fedora), giving the password you set in the boot line.  Beyond this, installation is rather simple; just accept the defaults for everything. This will create an Atomic Host with 40% of the disk given over to the docker pool, which is what you want. If you're installing to an SD card on the board, you'll want to "make space" by reformatting the card through the installer.  Also, set a root password, and an administrator user named "atomic" for sudo access.

One thing you'll notice is that you don't choose packages to be installed.  That's because this is Atomic Host, and you don't install individual packages on it.  Instead, you are installing an image of a filesystem tree which comes from a central RPM-ostree server; in this instance, one run by the Fedora project.  Specific applications are installed as containers.

Once everything is installed, remove the USB key and reboot.  Note that you will need to choose the SD card or SSD from the BIOS boot menu on the first reboot, so that the Minnowboard will remember it thereafer.  

When you've rebooted, there's one more thing to do: run rpm-ostree upgrade to bring the host up to date with the latest filesystem image available.  You'll notice above that I installed the April 20th image, so this will bring me up to the latest image available (May 24th), updating all software.

```bash
-bash-4.3# rpm-ostree upgrade
Updating from: fedora-atomic:fedora-atomic/f23/x86_64/docker-host

820 metadata, 3820 content objects fetched; 192708 KiB transferred in 122 seconds
Copying /etc changes: 19 modified, 0 removed, 40 added
Bootloader updated; bootconfig swap: yes deployment count change: 1
Changed:
  avahi-autoipd 0.6.32-0.4.rc.fc23 -> 0.6.32-1.fc23
  avahi-libs 0.6.32-0.4.rc.fc23 -> 0.6.32-1.fc23

...

Run "systemctl reboot" to start a reboot
```

For this reason it doesn't really matter if you install an image which isn't the latest.

Now, we're up and running and ready to build a cluster. Next step: configuring the cluster with Ansible.
