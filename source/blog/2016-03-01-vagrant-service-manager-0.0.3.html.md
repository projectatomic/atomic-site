---
title: vagrant-service-manager Plugin Version 0.0.3 Released
author: bexelbie
date: 2016-03-01 17:35:00 UTC
tags: Docker, ADB, Vagrant
published: true
comments: true
---
Version 0.0.3 of the [vagrant-service-manager
plugin](https://github.com/projectatomic/vagrant-service-manager) has
been released by Project Atomic.

The vagrant-service-manager plugin works
in conjunction with the [Atomic Developer Bundle
(ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle/)
to provide a Linux container development environment. The plugin is used
to display the configuration information of services present in ADB.
This plugin replaces the previously released vagrant-adbinfo plugin.

The plugin displays the configuration details for the Docker and other
container-related services running inside of the ADB. This information can
be used by a CLI client, such as `docker` or `oc`, or by an IDE, such as
[Eclipse](http://www.eclipse.org/community/eclipse_newsletter/2015/june/article3.php),
to interact with the ADB.

READMORE

Notable changes in this release include:

- New sub-command for displaying OpenShift provider information

    `$ vagrant service-manager env openshift`

- New sub-command for displaying the version information of the ADB box
  and services

    `$ vagrant service-manager box version`

- New option to display the version information in `--script-readable` form

- Adds exit codes as per status of the executed command for better
  integration with tools consuming the plugin

## Example Execution

```
$ curl https://raw.githubusercontent.com/projectatomic/vagrant-service-manager/master/Vagrantfile > Vagrantfile
$ vagrant up

# Obtain docker configuration information:

$ vagrant service-manager env docker
# Copying TLS certificates to /home/bexelbie/Repositories/vagrant-service-manager/.vagrant/machines/default/virtualbox/docker
# Set the following environment variables to enable access to the
# docker daemon running inside of the vagrant virtual machine:
export DOCKER_HOST=tcp://172.28.128.3:2376
export DOCKER_CERT_PATH=/home/bexelbie/Repositories/vagrant-service-manager/.vagrant/machines/default/virtualbox/docker
export DOCKER_TLS_VERIFY=1
export DOCKER_MACHINE_NAME=3cd8ff6
# run following command to configure your shell:
# eval "$(vagrant service-manager env docker)"

# Printing the version of the vagrant box
$ vagrant service-manager box version
Atomic Developer Bundle (ADB) 1.7.0
```

Additionally, the information for contributors has been expanded to make
it even easier to become a contributor.

Users of the previous plugin, vagrant-adbinfo, should know of the
following significant changes:

- The docker certificate directory was renamed from `.docker` to `docker`

- There is now a sub-command structure in place.  The functionality of
  vagrant-adbinfo is now accessed as follows:

    `vagrant service-manager env docker`

vagrant-service-manager is available via the standard
method of plugin installation, `vagrant plugin install
vagrant-service-manager`.  You may upgrade from previous versions
with `vagrant plugin update vagrant-service-manager`. It
is also is packaged for Fedora and available from [COPR]
(https://copr.fedorainfracloud.org/coprs/nshaikh/vagrant-service-manager/).

Please join us by using, testing, and contributing to the
vagrant-service-manager plugin.
