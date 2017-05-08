---
title: Testing System-Containerized Kubernetes
author: jbrooks
date: 2017-05-08 10:00:00 UTC
published: true
comments: true
tags: atomic, kubernetes
---

I've blogged here in the past about different ways of [running kubernetes and its dependencies in containers](http://www.projectatomic.io/blog/2016/09/running-kubernetes-in-containers-on-atomic/). In that post, I discussed how you could side-step the chicken-and-egg complexities of trying to use docker to run components on which docker itself relies by running flannel and etcd in [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/), which don’t rely on docker to run.

Recently, I’ve been working on running kubernetes in system containers, too.  Since I was already running etcd and flannel in system containers, I could save on a bit of storage by having flannel, etcd and kubernetes all share the same image in the ostree-based storage that system containers use.

READMORE

More compelling than the storage-savings, though, is the way that system containers integrate with systemd, which is how I wanted to manage my containerized kubernetes components, anyway. When I run the kubernetes master components on CentOS Atomic Host using docker, I create [systemd unit files](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster) for each component. With system containers, the systemd unit files are rolled in and deployed automatically when you run `atomic install --system foo`, as opposed to storing them somewhere separate from the containers, and copying them into place.

The [system containers](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-containers) I’m testing with are based on the Fedora 25 kubernetes docker containers I maintain, and come with kubernetes v1.5.3. I made a second set of containers [based on rawhide](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-rawhide), and those come with kubernetes v1.6.2.

I’ve modified a [fork of the ansible scripts](https://github.com/jasonbrooks/contrib/tree/system-containers/ansible) in the kubernetes contrib repository to deploy a cluster using these etcd, flannel and kubernetes system containers. The `inventory/group_vars/all.yml` file in my fork is set to pull containers from my namespace in the docker hub, using the fc25 tag, but you can change fc25 to rawhide to get that version of the images.

You can test it yourself like this:

```
$ git clone https://github.com/jasonbrooks/contrib.git
$ cd contrib
$ git checkout system-containers
$ cd ansible
$ vi inventory/inventory
 
[masters]
kube-master-test.example.com
 
[etcd:children]
masters
 
[nodes]
kube-minion-test-[1:2].example.com
 
$ cd scripts
$ ./deploy-cluster.sh
```

Substitute those hostnames above with ones that match your own test machines. For more information on using the ansible scripts, see the [README file](https://github.com/kubernetes/contrib/blob/master/ansible/README.md). Alternatively, you should be able to use the Vagrantfile in the vagrant directory of that repo, though I haven’t tested that yet.

If you run the script as laid out above, you’ll get etcd, flannel and kubernetes containers from my namespace in the docker hub, because the current upstream fedora containers, in the case of etcd and flannel, need a couple of changes , and in the case of kubernetes, the upstream fedora containers aren’t yet modified to run as system containers.  

Specifically, I've changed the etcd and flannel containers to bind mount config dirs in /etc, so that the ansible can config them using the same operations it'd use for non-system containers. I'm using tmpfiles.d to put a link to the etcdctl from the container into /usr/local/bin/etcd because
ansible expects and needs etcdctl to be on the host to set up the flannel network, and linking to the etcdctl from the container again lets us reuse the same ansible operations as for non system container case.

The kubernetes containers are based on the ones I'm maintaining in the fedora and centos container registries, and they also get configs from bind mounted /etc/kubernetes. Like with the etcd container, I'm creating a link from the kube-apiserver container's kubectl to /usr/local/bin/kubectl on the host, because the kube-addons service expects kubectl to be on the host.

One of the cool things about system containers is that they can also be run as regular docker containers. My next step will be to get my changes merged into the existing etcd, flannel and kubernetes containers that live in the Fedora and CentOS container registries, which will give users the option of running these components either as system containers or via docker.

### kubeadm in system containers

Finally, I wondered if I could use system containers as a means of working around the [issues I’ve experienced](https://jebpages.com/2016/11/01/installing-kubernetes-on-centos-atomic-host-with-kubeadm/) installing kubeadm, the simple-to-use tool for bootstrapping kubernetes clusters, on an atomic host.

On a regular CentOS or Fedora host, using kubeadm is a matter of installing rpms for the kubelet, kubectl, kubeadm itself, and for a set of kubernetes networking tools, kubernetes-cni. On an atomic host, rpm-ostree package layering allows for installing rpms, but if existing kube rpms are already part the atomic host image, as they are for Fedora Atomic Host, you won’t be able to install the prescribed upstream kube versions. And even on a host without built-in kubernetes, like [CentOS Atomic Continuous](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel), rpm-ostree won’t abide rpm content stored in `/opt`.

I managed to make a [kubadm system container](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-containers/kubeadm) that uses the same tmpfiles.d trick I used to link kubectl and etcdctl from the container into the the host’s `/usr/local/bin` to make the kubeadm tool available from the host. 

I’ve haven’t done much testing of it yet, but if you want to try it for yourself you can with:

```
# atomic install --system --name kubelet docker.io/jasonbrooks/kubeadm
# setenforce 0
# systemctl start kubelet
# kubeadm init --skip-preflight-checks
```
