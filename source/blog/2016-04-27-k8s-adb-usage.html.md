---
title: Using Kubernetes with ADB (Atomic Developer Bundle)
date: 2016-04-27 14:30 UTC
author: SurajD
tags: Kubernetes, Vagrant, CentOS
published: true
comments: true
---


The easiest way to get started with [Kubernetes](http://kubernetes.io/docs/whatisk8s/) is to start using the [Vagrant Box](https://www.vagrantup.com/docs/boxes.html) provided under [ADB (Atomic Developer Bundle)](https://github.com/projectatomic/adb-atomic-developer-bundle#what-is-the-atomic-developer-bundle-adb). All you need to do to get started is have Vagrant installed and [Vagrantfile](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/components/centos/centos-k8s-singlenode-setup/Vagrantfile), which configures the Kubernetes on the Vagrant box.

Make sure you have basic setup ready. For that follow these [installation instructions](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/docs/installing.rst).

READMORE

Now all you need to do is clone the repository that has Vagrantfile and start the Vagrantbox:

```bash
$ git clone https://github.com/projectatomic/adb-atomic-developer-bundle.git
$ cd adb-atomic-developer-bundle/components/centos/centos-k8s-singlenode-setup/
$ vagrant up --provider libvirt
```

You can also choose `provider` as `virtualbox` with the command `vagrant up --provider virtualbox`

This will start the box. But, if the box is not available, then Vagrant will download it for you. Once the box is up and running, ssh into the box and you will have a running Kubernetes all-in-one cluster. This cluster is set up as a Kubernetes Master and Kubernetes Node running on the same host.

```bash
vagrant ssh
```

When you are in the machine, try using Kubernetes with `kubectl` commands. If you are already familiar with Kubernetes, you can skip the following steps and test if the cluster has everything you need. For someone new to Kubernetes, keep following along here.

To test to see if Kubernetes is working, let's create a pod. For that create a file named `pod.json` with the following data:

```json
$ cat pod.json
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "labels": {
            "app": "apache-centos7"
        },
        "name": "apache-centos7"
    },
    "spec": {
        "containers": [
            {
                "image": "centos/httpd",
                "name": "apache-centos7",
                "ports": [
                    {
                        "containerPort": 80,
                        "hostPort": 80,
                        "protocol": "TCP"
                    }
                ]
            }
        ]
    }
}
```

To create a pod running on Kubernetes out of this file, use

```bash
kubectl create -f pod.json
```

See if the pod is running by entering

```bash
kubectl get pods
```

You may see a pod named `apache-centos7` there, but the `STATUS` might be `Pending` so wait for a while and keep checking the output. Once it's changed to `Running` we can test if its running, but first we will need the IP address of the pod. To get the IP:

```bash
kubectl describe pod apache-centos7 | grep 'IP:'
```

Note the IP and curl on it

```bash
curl IP_ADDRESS_OBTAINED
```

Unless you get any errors, the pod is running, which also signifies Kubernetes cluster is running. Now you can explore more options in Kubernetes on your own.
