---
title: Client Binary Installation Now Included in the ADB
author: budhram
date: 2016-07-22 09:56 UTC
tags: atomic-developer-bundle, vagrant-service-manager
published: true
comments: true
---

As part of the effort to continually improve the developer experience and make getting started easier, the ADB now supports client binary downloads. These downloads are facilitated by a new feature in 'vagrant-service-manger', the `install-cli` command.

The [vagrant-service-manager](https://github.com/projectatomic/vagrant-service-manager) plugin enables easier access to the features and services provided by the [Atomic Developer Bundle (ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle). More information can be found in the README of 'vagrant-service-manager' repo.

The `install-cli` command was released as part of 'vagrant-service-manager' version 1.2.0. This command installs the client binary for services provided by the ADB. Today it can download client binaries for docker and OpenShift. This feature allows developers to know they have the best client for use with the ADB services they are using.

READMORE

To use the 'install-cli' command, you must have version 1.2.0 or later of 'vagrant-service-manager' installed. You can verify the version you have installed with the following command:

```
$ vagrant plugin list
```

You can install the plugin with the following command:

```
$ vagrant plugin install vagrant-service-manager
```

The usage of the 'install-cli' command is very straightforward:

```
vagrant service-manager install-cli [service]

Where 'service' can be 'docker' and 'openshift'.
```

Here is how you can use the command. In this example, we will use an ADB set up and running OpenShift Origin. To setup the ADB and start OpenShift, use the following commands:

```
$ mkdir adb-openshift
$ cd adb-openshift
$ curl -o Vagrantfile https://raw.githubusercontent.com/projectatomic/adb-atomic-developer-bundle/master/components/centos/centos-openshift-setup/Vagrantfile
$ vagrant up
```

`vagrant up` will take a few minutes (and longer in the case of a slow network connection) to finish as it has to download the OpenShift Origin images from the Docker Hub. Once everything is ready you will see the information about how to access OpenShift Origin.

Now, the OpenShift origin server is ready and you may need a client to access it and perform your desired operations. You can manually download the client binary from [OpenShift repository](https://github.com/openshift/origin/releases) but we recommend you to use 'install-cli' command provided.

To get started, let's review the help:

```
$ vagrant service-manager install-cli --help
```

Now, if you want to install the OpenShift client binary, 'oc', run the following command:

```
$ vagrant service-manager install-cli openshift
# Binary now available at /home/budhram/.vagrant.d/data/service-manager/bin/openshift/1.1.1/oc
# run binary as:
# oc <command>
export PATH=/home/budhram/.vagrant.d/data/service-manager/bin/openshift/1.1.1:$PATH

# run following command to configure your shell:
# eval "$(VAGRANT_NO_COLOR=1 vagrant service-manager install-cli openshift | tr -d '\r')"
```

Now, the binary has been downloaded and made available in the listed directory. You can configure your shell with the command mentioned in the output. This will make sure that the 'oc' binary is in your executable path.

You can verify everything worked by running the `oc version` command as is shown below:

```
$ oc version
oc v1.1.1
kubernetes v1.1.0-origin-1107-g4c8e6f4
```

Great!

Now the OpenShift binary client has been set up and you can play around with it. You may wish to watch [OpenShift Origin quickstart with Atomic Developer Bundle](https://www.youtube.com/watch?v=HiE7TgjLjAk) as a next step.

<iframe width="560" height="315" src="https://www.youtube.com/embed/HiE7TgjLjAk" frameborder="0" allowfullscreen></iframe>
