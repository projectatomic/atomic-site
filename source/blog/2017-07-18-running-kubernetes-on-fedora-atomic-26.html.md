---
title: Running Kubernetes on Fedora Atomic 26
author: jbrooks
date: 2017-07-18 23:12:57 UTC
tags: kubernetes, ansible, kubeadm
comments: true
published: true
---

Fedora Atomic 26 relies primarily on Kubernetes for automating deployment, scaling, and operations of application containers across clusters of hosts. Below is an overview of your options for installing and configuring Kubernetes clusters on Fedora Atomic hosts.

# Install Kubernetes

## Use Built-in Packages

Fedora Atomic 26 ships with Kubernetes packages baked into the system image. The specific version of Kubernetes included matches the latest release marked stable for f26 in Fedora's [updates system](https://bodhi.fedoraproject.org/updates/?packages=kubernetes&release=F26). If this is the version you wish to run, you can move on to the Manual Deployment, Ansible Deployment or Kubeadm Deployment sections.

### Updates and Testing Packages
 
If there is a newer stable Kubernetes version available that hasn't yet appeared in a two-weekly Fedora Atomic release, you can access it by rebasing to the updates ref of Fedora Atomic, which is recomposed each night to track the latest stable packages:

```
rpm-ostree rebase fedora-atomic:fedora/26/x86_64/updates/atomic-host -r
```

Similarly, if there is a newer Kubernetes version available in Fedora's updates-testing repository, you can access it by rebasing to the testing ref of Fedora Atomic, which is recomposed each night to track the latest testing packages:

```
rpm-ostree rebase fedora-atomic:fedora/26/x86_64/testing/atomic-host -r
```

## Use System Containers

You can install and run versions of Kubernetes packaged for different Fedora releases using [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/). For instance, you could run the older Fedora 25 version (currently 1.5.3) or the newer rawhide version (currently 1.7.1) on your Fedora Atomic 26 host. System containers place systemd unit files in `/etc/systemd/system`, where they override the unit files from the packages baked into the image.

_note: this section below needs registry work. Are the f25 containers still being updated? Will the rawhide containers be updated? I'll probably point to my personal docker namespace, but it'd be better if all of these were available on Fedora's_

### Run on your kubernetes master:

```
# atomic install --system --name kube-apiserver docker.io/jasonbrooks/kubernetes-apiserver:rawhide

# atomic install --system --name kube-controller-manager docker.io/jasonbrooks/kubernetes-controller-manager:rawhide

# atomic install --system --name kube-scheduler docker.io/jasonbrooks/kubernetes-scheduler:rawhide

# systemctl daemon-reload
```

### Run on your kubernetes node(s):

```
# atomic install --system --name kubelet docker.io/jasonbrooks/kubernetes-kubelet:rawhide

# atomic install --system --name kube-proxy docker.io/jasonbrooks/kubernetes-proxy:rawhide

# systemctl daemon-reload
```

From here, you could proceed with the Manual Deployment or the Ansible Deployment sections. 

# Deploy Kubernetes

## Kubeadm Deployment

Kubeadm is a tool for bootstrapping Kubernetes clusters that's still [under development](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#kubeadm-maturity) by the Kubernetes project, but offers a really simple method of getting up and running with a single or multi-node cluster. Starting with the Kubernetes version that ships with Fedora Atomic 26, the kubeadm command is available in a Fedora package. It's not currently baked into the image, but you can install it using rpm-ostree package layering:

```
# rpm-ostree install kubernetes-kubeadm
```

After installing, you either have to reboot (using `systemctl reboot` or by tacking an `-r` onto the end of the install command above) or you can apply the changes using the experimental command `rpm-ostree ex livefs`.

In order for kubeadm to work with SELinux in enforcing mode, you'll need to create the following directory and set its SELinux context as follows:

```
# mkdir /etc/kubernetes/pki

# chcon -Rt container_share_t /etc/kubernetes/pki
```

From here, you can follow the [upstream kubeadm documentation](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) to bring up a cluster.


## Ansible Deployment

The contrib repository of the upstream Kubernetes project contains [ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) for deploying a Kubernetes cluster that work with Fedora Atomic 26 and its default Kubernetes packages, as well as with an Atomic Host with installed system containers.

Grab the scripts by git cloning them:

```
$ git clone https://github.com/kubernetes/contrib.git

$ cd contrib/ansible
```

Next, create and populate an inventory file with the hostnames or IP addresses of the systems you intend to use as your master and your nodes:

```
$ vi inventory/inventory

[masters]
kube-master-test.example.com

[etcd:children]
masters

[nodes]
kube-minion-test-[1:2].example.com
```

Review and modify `inventory/group_vars/all.yml` as needed, for instance, setting your user name or password to use with ansible as desired.

Finally, run the deploy cluster script:

```
$ cd scripts

$ ./deploy-cluster.sh
```

For more information, check out the [README file](https://github.com/kubernetes/contrib/blob/master/ansible/README.md).

## Manual Deployment

Finally, the Project Atomic [Getting Started Guide](http://www.projectatomic.io/docs/gettingstarted/) provides manual directions for configuring a cluster that should work with a stock Fedora Atomic 26 host or with a host with Kubernetes installed via system containers.

