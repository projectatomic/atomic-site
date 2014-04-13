# Project Atomic Getting Started Guide

## About the Project

You will be using Project Atomic to deploy Docker containers, either
locally on a development laptop, or in a physical or cloud servers.

## Prerequisites 

You will need a virtualization capable computer, a relatively high
bandwidth internet connection, and at least several gigabytes of free
disk space for the OS, containers, and data.

## Downloading Atomic

There are builds of Atomic available using Fedora and CentOS bases.

#### Fedora

At the moment, only pregenerated disk images suitable for use in a
virtualization platform such as `virt-manager` or `VirtualBox` are
provided.

In the near future, Anaconda support will allow installation to
bare metal.

You can download disk images from here:
http://rpm-ostree.cloud.fedoraproject.org/project-atomic/images/

#### Source

There is only one package shipped that is not in Fedora, which is a
patched `shadow-utils`.  For more information, see
https://lists.fedoraproject.org/pipermail/devel/2014-April/197783.html

Other important components are `docker`, `geard`, `rpm-ostree`,
`ostree`.  The source packages are available in the Fedora package
tree.

## Installing Atomic

At the moment, only pregenerated disk images are available.  A future
release will have Anaconda support and thus support all installation
scenarios that Anaconda does, including bare metal.

## Configuring and Managing Atomic

It's important to note that on an Atomic system, the `/etc` and `/var`
directories are writable as they are on a traditional yum or dpkg
managed system.  Any changes made to /etc are propagated forwards.
The OSTree upgrade system does not ever change /var in any way.

At present, the primary expected method to install software locally is
via Docker containers.  You can also use `/usr/local` or `/opt` (in
the OSTree model, these are really `/var/usrlocal` and `/var/opt`,
respectively).

## Use Cases

If you are developer of an application which is in a Docker Container,
you can use Project Atomic to as a deployment target.
