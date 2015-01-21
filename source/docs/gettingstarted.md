# Project Atomic Getting Started Guide

## About the Project

You will be using Project Atomic to deploy Docker containers, either
locally on a development laptop, or in a physical or cloud servers.

## Prerequisites 

You will need a virtualization capable computer, a relatively high
bandwidth internet connection, and at least several gigabytes of free
disk space for the OS, containers, and data.

## Downloading Atomic

Want to try out Project Atomic? We've got what you need to get
started.

### Fedora Atomic Host

Fedora 21 shipped Atomic images for use with Virt-Manager, KVM, and
private cloud environments, as well as AMIs for Amazon Web Services.

For more info on Fedora 21 Atomic Host, see the [Download page for
Fedora 21 Cloud](https://getfedora.org/en/cloud/download/).

### CentOS Atomic Host

CentOS Atomic Host builds are now being provided by the CentOS
[Atomic SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic). 

All of the CentOS Atomic Host images are currently available via
[buildlogs.centos.org](http://buildlogs.centos.org/rolling/7/isos/x86_64/).

You can grab gzipped or uncompressed qcow2 images for use with KVM,
VirtManager, OpenStack, etc. 

Bare metal installers and Vagrant Boxes are coming soon.

## Installing Atomic

At the moment, only pregenerated disk images are available.  A future
release will have Anaconda support and thus support all installation
scenarios that Anaconda does, including bare metal.

Once you have a machine with an Atomic Host, there should be Docker
base images available from the upstream distribution and the upstream
Docker registry.  For more information, see:
[Image Author Guidance](/docs/docker-image-author-guidance/).

## Configuring and Managing Atomic Host

It's important to note that on an Atomic system, the `/etc` and `/var`
directories are writable as they are on a traditional yum or dpkg
managed system.  Any changes made to /etc are propagated forwards.
The OSTree upgrade system does not ever change /var in any way.

At present, the primary expected method to install software locally is
via Docker containers.  You can also use `/usr/local` or `/opt` (in
the OSTree model, these are really `/var/usrlocal` and `/var/opt`,
respectively).

See [kubernetes](https://github.com/googlecloudplatform/kubernetes) for
more information on managing container lifecycle.

## Use Cases

If you are a developer of an application which is in a Docker Container,
you can use Project Atomic as a deployment target.
