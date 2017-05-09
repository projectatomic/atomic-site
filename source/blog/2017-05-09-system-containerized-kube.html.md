---
title: Testing System-Containerized Kubernetes
author: jbrooks
date: 2017-05-09 12:00:00 UTC
published: true
comments: true
tags: atomic, kubernetes, system containers
---

I've blogged here in the past about different ways of [running Kubernetes and its dependencies in containers](http://www.projectatomic.io/blog/2016/09/running-kubernetes-in-containers-on-atomic/). In that post, I discussed how you could side-step the chicken-and-egg complexities of trying to use Docker to run components on which Docker itself relies by running Flannel and etcd in [system containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/), which don't rely on Docker to run.

Recently, I’ve been working on running Kubernetes in system containers, too.  Since I was already running etcd and Flannel in system containers, I could save on a bit of storage by having Flannel, etcd, and Kubernetes all share the same image in the ostree-based storage that system containers use.

READMORE

More compelling than the storage-savings, though, is the way that system containers integrate with systemd, which is how I wanted to manage my containerized Kubernetes components, anyway. When I run the Kubernetes master components on CentOS Atomic Host using Docker, I create [systemd unit files](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster) for each component. With system containers, the systemd unit files are rolled in and deployed automatically when you run `atomic install --system foo`, as opposed to storing them somewhere separate from the containers, and copying them into place.

The [system containers](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-containers) I'm testing with are based on the Fedora 25 Kubernetes Docker containers I maintain, and come with Kubernetes v1.5.3. I made a second set of containers [based on rawhide](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-rawhide), and those come with Kubernetes v1.6.2.

I've modified a [fork of the Ansible scripts](https://github.com/jasonbrooks/contrib/tree/system-containers/ansible) in the Kubernetes contrib repository to deploy a cluster using these etcd, Flannel and Kubernetes system containers. The `inventory/group_vars/all.yml` file in my fork is set to pull containers from my namespace in the Docker Hub, using the fc25 tag, but you can change fc25 to rawhide to get that version of the images.

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

Substitute those hostnames above with ones that match your own test machines. Alternatively, you should be able to use the Vagrantfile in the vagrant directory of that repo, though I haven’t tested that yet.

Depending on your setup, you may have to edit several variables in `group_vars/all.yml`, such as the `ansible_root_user`, the `flannel_subnet`, and `ansible_python_interpreter`.  See the [docs](https://github.com/kubernetes/contrib/blob/master/ansible/README.md) for more details.

If you run the script as laid out above, you'll get etcd, Flannel, and kubernetes containers from my namespace in the Docker Hub, because the current upstream Fedora containers (in the case of etcd and Flannel) need a couple of changes. Further, in the case of Kubernetes, the upstream Fedora containers aren't yet modified to run as system containers.  

Once it's set up, you can see that you have a bunch of system containers:

```
# kubectl get nodes
NAME                             STATUS    AGE
kube-minion-test-1.example.com   Ready     6m
kube-minion-test-2.example.com   Ready     6m

# atomic containers list
   CONTAINER ID IMAGE                COMMAND              CREATED          STATE     RUNTIME   
   etcd         docker.io/jasonbrook /usr/bin/etcd-env.sh 2017-05-08 23:26 running   ostree    
   flanneld     docker.io/jasonbrook /usr/bin/flanneld-ru 2017-05-08 23:28 running   ostree    
   kube-apiserv docker.io/jasonbrook /usr/bin/kube-apiser 2017-05-08 23:31 running   ostree    
   kube-control docker.io/jasonbrook /usr/bin/kube-contro 2017-05-08 23:31 running   ostree    
   kube-schedul docker.io/jasonbrook /usr/bin/kube-schedu 2017-05-08 23:31 running   ostree
```

But these are not Docker containers:

```
# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
#
```

To make this work, I've changed the etcd and Flannel containers to bind mount config dirs in /etc, so that the Ansible can config them using the same operations it'd use for non-system containers. I'm using tmpfiles.d to put a link to the etcdctl from the container into /usr/local/bin/etcd because
Ansible expects and needs etcdctl to be on the host to set up the Flannel network, and linking to the etcdctl from the container again lets us reuse the same Ansible operations as for non system container case.

The Kubernetes containers are based on the ones I'm maintaining in the fedora and centos container registries, and they also get configs from bind mounted /etc/kubernetes. Like with the etcd container, I'm creating a link from the kube-apiserver container's kubectl to /usr/local/bin/kubectl on the host, because the kube-addons service expects kubectl to be on the host.

One of the cool things about system containers is that they can also be run as regular Docker containers. My next step will be to get my changes merged into the existing etcd, Flannel and Kubernetes containers that live in the Fedora and CentOS container registries, which will give users the option of running these components either as system containers or via Docker.

In my next blog post, we'll launch Kubeadm in system containers for an even easier way to install Kubernetes clusters.
