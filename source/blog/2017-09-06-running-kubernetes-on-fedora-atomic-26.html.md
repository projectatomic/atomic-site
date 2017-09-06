---
title: Running Kubernetes on Fedora Atomic Host
author: jbrooks
date: 2017-09-06 16:00:00 UTC
tags: kubernetes, ansible, kubeadm, fedora
comments: false
published: true
---

Fedora 26 Atomic Host relies on Kubernetes for automating deployment, scaling, and operations of application containers across clusters of hosts.

Getting up and running with Kubernetes on Fedora Atomic Host involves installing Kubernetes (or sticking with the version of the software that's currently baked into the images), and then configuring a cluster. This can be done manually, with the Kubeadm utility, or with Ansible scripts (among other methods).

Below is an overview of your options for installing and configuring Kubernetes clusters on Fedora Atomic Hosts. If you're looking to get up and running as quickly as possible with a Fedora Atomic-hosted Kubernetes cluster, skip ahead to the "Kubeadm Deployment" section below. For a more configurable installation, check out the Ansible Deployment section.

# Install Kubernetes

## Use Built-in Packages

Fedora Atomic Host ships with Kubernetes packages baked into the system image. The specific version of Kubernetes included matches the latest release marked stable for f26 in Fedora's [updates system](https://bodhi.fedoraproject.org/updates/?packages=kubernetes&release=F26). If this is the version you wish to run, you can move on to the Manual Deployment, Ansible Deployment or Kubeadm Deployment sections.

### Updates and Testing Packages

If there is a newer stable Kubernetes version available that hasn't yet appeared in a two-weekly Fedora Atomic release, you can access it by rebasing to the updates ref of Fedora Atomic, which is recomposed each night to track the latest stable packages:

```bash
# rpm-ostree rebase fedora-atomic:fedora/26/x86_64/updates/atomic-host -r
```

Similarly, if there is a newer Kubernetes version available in Fedora's updates-testing repository, you can access it by rebasing to the testing ref of Fedora Atomic, which is recomposed each night to track the latest testing packages:

```bash
# rpm-ostree rebase fedora-atomic:fedora/26/x86_64/testing/atomic-host -r
```

## Use System Containers

You can also install Kubernetes using [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/), a new approach that will eventually replace baked-in Kubernetes packages in the atomic host. You can begin trying it out now, however:

### Run on your kubernetes master

```bash
# atomic install --system --system-package=no --name kube-apiserver registry.fedoraproject.org/f26/kubernetes-apiserver

# atomic install --system --system-package=no --name kube-controller-manager registry.fedoraproject.org/f26/kubernetes-controller-manager

# atomic install --system --system-package=no --name kube-scheduler registry.fedoraproject.org/f26/kubernetes-scheduler
```

### Run on your kubernetes node(s)

```bash
# atomic install --system --system-package=no --name kubelet registry.fedoraproject.org/f26/kubernetes-kubelet

# atomic install --system --system-package=no --name kube-proxy registry.fedoraproject.org/f26/kubernetes-proxy
```

From here, you could proceed with the Manual Deployment or the Ansible Deployment sections.

System containers place systemd unit files in `/etc/systemd/system`, where they override the unit files from the packages baked into the image, so it's possible to install system containers built from other versions of Fedora. You could, for instance, build and run containers including the more recent (1.7.2) version of Kubernetes from rawhide from [these sources](https://github.com/projectatomic/atomic-system-containers).

Keep in mind that unlike standard containers, which are stored under `/var/lib/docker` and may reside on a separate partition, system containers are stored in the root partition, so you may need to provide that partition with more space.

# Deploy Kubernetes

## Kubeadm Deployment

Kubeadm is a tool for bootstrapping Kubernetes clusters that's still [under development](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#kubeadm-maturity) by the Kubernetes project, but offers a really simple method of getting up and running with a single or multi-node cluster. Starting with the Kubernetes version that ships with Fedora Atomic Host, the kubeadm command is available in a Fedora package. It's not currently baked into the image, but you can install it using rpm-ostree package layering:

```bash
# rpm-ostree install kubernetes-kubeadm ethtool ebtables
```

After installing, you either have to reboot (using `systemctl reboot` or by tacking an `-r` onto the end of the install command above) or you can skip the reboot and apply the changes using the experimental command `rpm-ostree ex livefs`.

In order for kubeadm to work with SELinux in enforcing mode, you'll need to [for now](https://github.com/kubernetes/kubeadm/issues/279) create the following directory and set its SELinux context as follows:

```bash
# mkdir /etc/kubernetes/pki

# chcon -Rt container_share_t /etc/kubernetes/pki
```

Also, kubeadm requires a different restart-on-fail behavior from the kubelet, so we'll need to add three lines to this drop-in file (this step won't be necessary once [this commit](http://pkgs.fedoraproject.org/cgit/rpms/kubernetes.git/commit/?id=e1f50eb5233848580ed354b1ec8b0c886ce8caaf) makes its way into the stable kubeadm rpm):

```bash
# vi /etc/systemd/system/kubelet.service.d/kubeadm.conf

Restart=always
StartLimitInterval=0
RestartSec=10

# systemctl daemon-reload
```

From here, you can follow the [upstream kubeadm documentation](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) to bring up a cluster. Note, though, that you'll have to append `--skip-preflight-checks` to the `kubeadm init` command because kubeadm currently does not know where to look for Fedora's kernel module configuration. See this [pull request](https://github.com/kubernetes/kubernetes/pull/49410) for more information.

Also, most of the network plugins I've tested with Kubeadm have an issue running with SELinux confinement, which is one of the reasons why the upstream docs suggest putting SELinux into permissive mode. There are a couple of ways to avoid disabling this security feature on your host, however. I typically edit the yaml file that configures the network plugin to tell Kubernetes to run the plugin as type [`spc_t`](http://danwalsh.livejournal.com/74754.html), which leaves its containers unconfined by SELinux.

For instance, here's a portion of the Flannel plugin yaml that I've edited:

```bash
spec:
  template:
    metadata:
      labels:
        tier: node
        app: flannel
    spec:
      securityContext:
        seLinuxOptions:
          type: "spc_t"
      hostNetwork: true
```

The three lines beginning with `securityContext:` go in right before the `hostNetwork: true` line. This same trick should work in any of the network plugin yaml files.

I've opened [an issue](https://pagure.io/atomic/kubernetes-sig/issue/3) here to track efforts to get SELinux-compatible changes into these upstream plugins. Head over there to track progress or help out.

Another item to keep in mind for Kubeadm on Fedora Atomic Host is that the 1.13.x version of the docker container runtime that's stable in Fedora 26 [isn't yet validated](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md#external-dependency-version-information) for Kubernetes. Due to [this issue](https://github.com/kubernetes/kubernetes/issues/40182), you may have to run `sudo iptables -P FORWARD ACCEPT` on each Kubeadm node in order to access your services over the network.

### Kubeadm system container

It's also possible to run Kubeadm in a system container, although there isn't yet an official Fedora container image for this system container. Check out [this git pull request](https://github.com/projectatomic/atomic-system-containers/pull/96) for more information.

## Ansible Deployment

For a more advanced installation option, the contrib repository of the upstream Kubernetes project contains [ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) for deploying a Kubernetes cluster that work with Fedora Atomic Host and its default Kubernetes packages, as well as with an Atomic Host with installed system containers.

Grab the scripts by git cloning them:

```bash
git clone https://github.com/kubernetes/contrib.git

cd contrib/ansible
```

Next, create and populate an inventory file with the hostnames or IP addresses of the systems you intend to use as your master and your nodes:

```bash
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

```bash
cd scripts

./deploy-cluster.sh
```

For more information, check out the [README file](https://github.com/kubernetes/contrib/blob/master/ansible/README.md).

## Manual Deployment

Finally, the Project Atomic [Getting Started Guide](http://www.projectatomic.io/docs/gettingstarted/) provides manual directions for configuring a cluster that should work with a stock Fedora Atomic Host or with a host with Kubernetes installed via system containers.

# Openshift Origin

Another set of routes to running Kubernetes on Fedora Atomic Host involve installing and configuring Openshift Origin, a container application platform built from Kubernetes. Openshift Origin's [`oc cluster up`](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md) command provides a similar experience to Kubeadm, and there are also [Anisble scripts available](http://www.projectatomic.io/blog/2016/12/part1-install-origin-on-f25-atomic-host/) for deploying a full-fledged cluster.
