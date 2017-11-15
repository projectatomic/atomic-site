---
title: Migrating Kubernetes on Fedora Atomic Host 27
author: jbrooks
date: 2017-11-15 00:00:00 UTC
tags: atomic, kubernetes, fedora, system containers, rpm-ostree
comments: true
published: true
---

Starting with Fedora 27 Atomic Host, the rpms for Kubernetes, Flannel and Etcd are no longer baked into the host's image, but are installable instead either as [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/) or via [package layering](https://rpm-ostree.readthedocs.io/en/latest/manual/administrator-handbook/#hybrid-imagepackaging-via-package-layering).

System containers can serve as drop-in replacements for components that had been included in the Fedora Atomic image. Once installed, these components will be manageable using the same systemctl commands that apply to regular rpm-installed components. System containers are very flexible -- you can easily run system container images based on CentOS or on older (or newer) versions of Fedora on a Fedora Atomic 27 host.

Package layering makes it possible to install regular rpm packages from configured repositories. These additional "layered" packages are persistent across upgrades, rebases, and deploys. You must typically reboot after layering on packages, and not all packages may be installed in this way. For instance, rpms that install content to `/opt` [aren't currently installable](https://github.com/projectatomic/rpm-ostree/issues/233) via package layering. Unlike with system containers, the packages you layer onto your host must be compatible with the version of Fedora the host is running.

If you're running a Kubernetes cluster on Fedora Atomic Host that depends on the baked in versions of these components, such as a cluster installed via the Ansible scripts in the [kubernetes/contrib repo](https://github.com/kubernetes/contrib/tree/master/ansible), you'll need to choose one of these methods to migrate your cluster when [upgrading to Fedora Atomic 27](http://www.projectatomic.io/blog/2017/11/fedora-atomic-26-to-27-upgrade/).

## Migrating Kubernetes and related components using System Containers

To replace Kubernetes, Flannel and Etcd with system containers, you would run the following commands. You could run these commands on a Fedora 26 Atomic Host, and then [upgrade to 27](http://www.projectatomic.io/blog/2017/11/fedora-atomic-26-to-27-upgrade/). Upon rebooting, your components and any cluster based on them should be up and running. 

### System containers for master nodes

```bash
# atomic install --system --system-package=no --name kube-apiserver registry.fedoraproject.org/f27/kubernetes-apiserver

# atomic install --system --system-package=no --name kube-controller-manager registry.fedoraproject.org/f27/kubernetes-controller-manager

# atomic install --system --system-package=no --name kube-scheduler registry.fedoraproject.org/f27/kubernetes-scheduler
```

Note: the kube-apiserver system container provides the `kubectl` client.


### System containers for worker nodes

```bash
# atomic install --system --system-package=no --name kubelet registry.fedoraproject.org/f27/kubernetes-kubelet

# atomic install --system --system-package=no --name kube-proxy registry.fedoraproject.org/f27/kubernetes-proxy
```

### System container for etcd

```bash
# atomic install --system --system-package=no --storage=ostree --name etcd registry.fedoraproject.org/f27/etcd
```

When installed with the name **etcd**, the etcd system container expects to find stores etcd data in `/var/lib/etcd/etcd.etcd`. The etcd rpm is configured by default to store data in `/var/lib/etcd/default.etcd`, and the ansible scripts in [kubernetes/contrib](https://github.com/kubernetes/contrib/tree/master/ansible) use `/var/lib/etcd`. On a system running etcd as configured by the kubernetes/contrib ansible scripts, you'd move your data as follows:

```bash
# systemctl stop etcd

# cp -r /var/lib/etcd/member /var/lib/etcd/etcd.etcd/
```

Note: the etcd container provides the `etcdctl` client.

### System container for flannel

```bash
# atomic install --system --system-package=no --name flanneld registry.fedoraproject.org/f27/flannel
```

### Updating system containers

System container updates are independent of host updates. You can update a system container by pulling an updated version of the image, and then running the `atomic containers update` command.

```
# atomic pull registry.fedoraproject.org/f27/etcd
# atomic containers update etcd
```

 You can then roll back to the previous system container version by running `atomic containers rollback`.
 
 ```
 # atomic containers rollback etcd
 ```

## Migrating Kubernetes and related components using Package Layering

During the [upgrade to 27](http://www.projectatomic.io/blog/2017/11/fedora-atomic-26-to-27-upgrade/), you can opt to layer on particular packages by appending `--install PACKAGE` to the `rpm-ostree rebase` commands. Upon rebooting into 27, your components and any cluster based on them should be up and running. 

### Package layering on master + etcd nodes

```bash
# rpm-ostree rebase fedora-atomic-27:fedora/27/x86_64/atomic-host --install kubernetes-master --install flannel --install etcd -r
```

### Package layering on worker nodes

```bash
# rpm-ostree rebase fedora-atomic-27:fedora/27/x86_64/atomic-host --install kubernetes-node --install flannel -r
```

## Updating package layers

During regular rpm-ostree upgrades (with `rpm-ostree upgrade` or `atomic host upgrade`), your host will fetch updated package versions from your configured repositories.
