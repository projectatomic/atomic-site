---
title: Vagrant Service Manager 1.3.0 Released
author: budhram
date: 2016-08-16 12:54:00 UTC
tags: vagrant, devtools, releases, kubernetes
published: true
comments: true
---

This version of [vagrant-service-manager](https://github.com/projectatomic/vagrant-service-manager) introduces support for displaying Kubernetes configuration information. This enable users to access the Kubernetes server that runs inside ADB virtual machine from their host machine.

This version also includes binary installation support for Kubernetes. This support is extended to users of the [Red Hat Container Development Kit](http://developers.redhat.com/products/cdk/overview). For information about client binary installation, see the previous release announcement ["Client Binary Installation Now Included in the ADB"](../../../../blog/2016/07/vagrant-service-manager-install-cli).

The full list of features from this version are:

* Configuration information for Kubernetes provided as part of the `env` command
* Client binary installation support for Kubernetes added to the ADB
* Client binary installation support for OpenShift, Kubernetes and Docker in the Red Hat Container Development Kit
* Auto-detection of a previously downloaded `oc` executable binary on Windows operating systems
* Unit and acceptance tests for the Kubernetes service
* Option to enable Kubernetes from a Vagrantfile  with the following command:

```
  config.servicemanager.services = 'kubernetes'
```

## 1. Install the kubernetes client binary

### Run the following command to install the kubernetes binary, `kubectl`

```
$ vagrant service-manager install-cli kubernetes
# Binary now available at /home/budhram/.vagrant.d/data/service-manager/bin/kubernetes/1.2.0/kubectl
# run binary as:
# kubectl <command>
export PATH=/home/budhram/.vagrant.d/data/service-manager/bin/kubernetes/1.2.0:$PATH

# run following command to configure your shell:
# eval "$(VAGRANT_NO_COLOR=1 vagrant service-manager install-cli kubernetes | tr -d '\r')"

```

### Run the following command to configure your shell

```
$ eval "$(VAGRANT_NO_COLOR=1 vagrant service-manager install-cli kubernetes | tr -d '\r')"
```

## 2. Enable access to the kubernetes server that runs inside of the ADB

### Run the following command to display environment variable for kubernetes

```
$ vagrant service-manager env kubernetes
# Set the following environment variables to enable access to the
# kubernetes server running inside of the vagrant virtual machine:
export KUBECONFIG=/home/budhram/.vagrant.d/data/service-manager/kubeconfig

# run following command to configure your shell:
# eval "$(vagrant service-manager env kubernetes)"
```

### Run the following command to configure your shell

```
eval "$(vagrant service-manager env kubernetes)"
```

For a full list of changes in version 1.3.0, see [the release log](https://github.com/projectatomic/vagrant-service-manager/releases/tag/v1.3.0).
