---
title: vagrant-service-manager 1.3.0 Released - Focus on Kubernetes Support
author: budhram
date: 2016-08-16 12:54:00 UTC
tags: vagrant, devtools, releases, kubernetes
published: true
comments: true
---

This release of [vagrant-service-manager](https://github.com/projectatomic/vagrant-service-manager) introduces support for displaying Kubernetes configuration information. This enable users to access the Kubernetes server running inside ADB virtual machine from their host.

Client binary installation support for 'Kubernetes' is included in this release. Support for client binary installation has also been extended to users of the [Red Hat Container Development Kit](http://developers.redhat.com/products/cdk/overview). Information about client binary installation can be found in the previous release announcement ["Client Binary Installation Now Included in the ADB"](../../../../blog/2016/07/vagrant-service-manager-install-cli).

The main new features of this release are:

* Configuration information for Kubernetes provided as part of the `env` command
* Client binary installation support for OpenShift, Kubernetes and docker in the Red Hat Container Development Kit
* Client binary installation support for Kubernetes added to the ADB
* Auto-detection of a previously downloaded `oc` executable binary on Windows
* Unit and acceptance tests for the Kubernetes service
* Option to enable kubernetes from a Vagrantfile as follows:

```
  config.servicemanager.services = 'kubernetes'
```

## Install Kubernetes Client Binary

The command below will install the kubernetes binary, `kubectl`:

```
$ vagrant service-manager install-cli kubernetes
# Binary now available at /home/budhram/.vagrant.d/data/service-manager/bin/kubernetes/1.2.0/kubectl
# run binary as:
# kubectl <command>
export PATH=/home/budhram/.vagrant.d/data/service-manager/bin/kubernetes/1.2.0:$PATH

# run following command to configure your shell:
# eval "$(VAGRANT_NO_COLOR=1 vagrant service-manager install-cli kubernetes | tr -d '\r')"

```

**Configure your shell as:**

```
$ eval "$(VAGRANT_NO_COLOR=1 vagrant service-manager install-cli kubernetes | tr -d '\r')"
```

## Enable Access to the Kubernetes Server Running Inside of the ADB

```
$ vagrant service-manager env kubernetes
# Set the following environment variables to enable access to the
# kubernetes server running inside of the vagrant virtual machine:
export KUBECONFIG=/home/budhram/.vagrant.d/data/service-manager/kubeconfig

# run following command to configure your shell:
# eval "$(vagrant service-manager env kubernetes)"
```

**Configure shell as:**

```
eval "$(vagrant service-manager env kubernetes)"
```

For a full list of changes in version 1.3.0 please see [the release log](https://github.com/projectatomic/vagrant-service-manager/releases/tag/v1.3.0).
