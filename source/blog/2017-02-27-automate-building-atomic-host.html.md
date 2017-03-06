---
title: Automate Building Atomic Host
author: trishnag
date: 2017-02-27 18:00:00 UTC
published: true
comments: true
tags: atomic, fedora, ansible, automation, ostree
---

[Project Atomic](http://www.projectatomic.io/) hosts are built from standard RPM packages that have been composed into filesystem trees using rpm-ostree. This guide provides an example of automating building and testing new Atomic Host ostrees.

One of the primary benefits to Atomic Host and OSTree has been the ability to "configure once, deploy many times" using custom OSTree images. But the process for doing so wasn't streamlined or well-documented. I'm helping change that. I'm going to describe how to build atomic host in automated way. At the end of the article you'll be able to create VM from QCOW2 image which is going to boot your own OSTree.  The VM can also be used for testing Atomic Host releases (please feel free to [open an issue if you find anything](https://pagure.io/atomic-wg/issues)).

READMORE

The procedure and Ansible playbook below will enable you to create your own Atomic Host OSTree image. This is the first step in creating your own "distributions" of Atomic Host to install on your cloud servers. Note that it will install a bunch of requirements on your local server, as well as using system resources heavily. As such, you may want to run it on a development machine instead of your personal laptop.

If you just want to compose an ostree, and don't need the playbook automation or testing, see [the documentation for composing ostrees](http://www.projectatomic.io/docs/compose-your-own-tree/).


# Requirements
* Fedora Atomic QCOW2 Image. The image can be downloaded from here: [Fedora-Atomic](https://getfedora.org/en/atomic/download/)
* Make sure that Ansible is installed on your system. Note that I am installing it on my [Fedora-Workstation](https://getfedora.org/en/workstation/download).

```
$ sudo dnf install ansible python2-dnf
```

## Process
Clone the [Build-Atomic-Host](https://github.com/trishnaguha/build-atomic-host/) git repo on your working machine/

```
$ git clone https://github.com/trishnaguha/build-atomic-host.git
$ cd build-atomic-host
```


## Create VM from the QCOW2 Image
The following creates a VM from QCOW2 Image where the username is `atomic-user` and password is `atomic`.
Here `atomic-node` is the instance name.

```
$ sudo sh create-vm.sh atomic-node /path/to/fedora-atomic25.qcow2
# For example: /var/lib/libvirt/images/Fedora-Atomic-25-20170131.0.x86_64.qcow2
```


## Install Requirements and Start the HTTP Server

The custom ostree is made available via a simple web server. The following playbook installs requirements, creates directory structure, initializes the OSTree repository and starts the HTTP server on TCP Port 35000.

```
$ ansible-playbook setup.yml --ask-sudo-pass
```

Use `ip addr` to check for the IP Address of the HTTP server.  This needs to be the interface by which your workstations communicates with virtual machines running on it, such as "virbr0" for LibVirt on Linux:

```
$ ip addr
7: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:54:00:37:7f:e9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
```

In our example, the IP Address of the running HTTP server is `192.168.122.1`.


## Give the ostree a name and add HTTP Server IP Address

Replace the variables given in [vars/atomic.yml](https://github.com/trishnaguha/build-atomic-host/tree/master/vars/atomic.yml) with your choice of ostree name and the HTTP server IP address.
For Instance:

```
# Variables for Atomic host
atomicname: my-atomic
httpserver: 192.168.122.1
```

Here `my-atomic` is the ostree name and `192.168.122.1` is HTTP Server IP Address.


## Run All-in-one Playbook

The following playbook composes the ostree, performs SSH-setup and rebases on the created tree:

```
$ ansible-playbook main.yml --ask-sudo-pass
```


## Check IP Address of the Atomic instance

The following command returns the IP Address of the running Atomic instance:

```
$ sudo virsh domifaddr atomic-node
```


## Reboot

Now SSH to the Atomic Host and reboot it so that it can reboot into the created ostree:

```
$ ssh atomic-user@<atomic-hostIP>
$ sudo systemctl reboot
```

Wait for few minutes after the reboot so that you do not get connection refused by the host while SSH-ing.


## Verify: SSH to the Atomic Host

```
$ ssh atomic-user@192.168.122.221
[atomic-user@atomic-node ~]$ sudo rpm-ostree status
State: idle
Deployments:
● my-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.1 (2017-02-07 05:34:46)
        Commit: 15b70198b8ec7fd54271f9672578544ff03d1f61df8d7f0fa262ff7519438eb6
        OSName: fedora-atomic

  fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.51 (2017-01-30 20:09:59)
        Commit: f294635a1dc62d9ae52151a5fa897085cac8eaa601c52e9a4bc376e9ecee11dd
        OSName: fedora-atomic
```

Now you have the updated tree and can test it in the VM.

If you are interested in composing your own tree that includes addition or deletion of packages of your choice, please follow [Compose-your-own-tree](http://www.projectatomic.io/docs/compose-your-own-tree/) by [Jason Brooks](https://twitter.com/jasonbrooks).


Shout-Out for the following folks:

* [Gerard Braad](http://gbraad.nl) who mentored me for the project.
* [Jonathan Lebon](https://github.com/jlebon) who demonstrated Building Atomic host workshop in [DevConf.CZ](https://devconf.cz/), 2017 at Brno. His slides are here: [jlebon-devconf-slides](http://jlebon.com/devconf/slides.pdf).
