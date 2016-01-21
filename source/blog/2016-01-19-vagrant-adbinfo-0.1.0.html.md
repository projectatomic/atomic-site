---
title: vagrant-adbinfo Plugin Version 0.1.0 Released
author: bexelbie
date: 2016-01-21 11:50:00 UTC
tags: Docker, ADB, Vagrant
published: true
comments: true
---
Version 0.1.0 of the [vagrant-adbinfo plugin](https://github.com/projectatomic/vagrant-adbinfo) has been released by Project Atomic.

The vagrant-adbinfo plugin works in conjunction with the [Atomic Developer Bundle (ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle/) to provide a Linux container development environment. The plugin is used to display the configuration information of services present in ADB.

At the moment, the plugin displays the configuration details for the Docker daemon running inside of the ADB. This information can be used by a docker-cli client or by an IDE, such as [Eclipse](http://www.eclipse.org/community/eclipse_newsletter/2015/june/article3.php), to interact with the ADB.

READMORE

Notable changes in this release include:

- Added gemspec in Gemfile to enable bundler packaging @lalatendumohanty
- Fix#67: OS is not a module (TypeError) on Windows @budhrg
- Updated ADB box Atlas namespace to projectatomic/adb @lalatendumohanty
- Updated README to reflect latest code and project goals @bexelbie
- Updated Vagrantfile for QuickStart guide @navidshaikh
- Fix#66: Added CHANGELOG.md to repository @navidshaikh

## Example Execution

```
$ curl https://raw.githubusercontent.com/projectatomic/vagrant-adbinfo/master/Vagrantfile > Vagrantfile
$ vagrant up
$ vagrant adbinfo
# Set the following environment variables to enable access to the
# docker daemon running inside of the vagrant virtual machine:
export DOCKER_HOST=tcp://192.168.33.10:2376
export DOCKER_CERT_PATH=/home/nshaikh/vagrant/cdk_19jan/.vagrant/machines/default/virtualbox/.docker
export DOCKER_TLS_VERIFY=1
export DOCKER_MACHINE_NAME=f984cee
# run following command to configure your shell:
# eval "$(vagrant adbinfo)"
```

vagrant-adbinfo is available via the standard method of plugin installation, `vagrant plugin install vagrant-adbinfo`. It is also is packaged for Fedora and available from [COPR] (https://copr.fedoraproject.org/coprs/nshaikh/vagrant-adbinfo/).

The future goals of the project include adding configuration information for providers (Kubernetes, OpenShift, etc.) running in the ADB. The plugin is also being redesigned to use subcommands and is subject to a name-change debate.

Please join us by using, testing, and contributing to the vagrant-adbinfo plugin.

*(With thanks to Navid Shaikh for co-writing this blog.)*
