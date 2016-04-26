---
title: Using Kubernetes with ADB (Atomic Developer Bundle)
date: 2016-04-26 00:01 UTC
author: SurajD
tags: Kubernetes, Vagrant, CentOS
published: true
comments: true
---


The easiest way to get started with [Kubernetes](http://kubernetes.io/docs/whatisk8s/) is start using the [Vagrant Box](https://www.vagrantup.com/docs/boxes.html) provided under [ADB (Atomic Developer Bundle)](https://github.com/projectatomic/adb-atomic-developer-bundle#what-is-the-atomic-developer-bundle-adb), all you need to do to get started is have Vagrant installed and [Vagrantfile](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/components/centos/centos-k8s-singlenode-setup/Vagrantfile) which configures the Kubernetes on the Vagrant box. Follow the steps to get started:

Make sure you have basic setup ready, for that follow [install instructions](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/docs/installing.rst).

Now all you need to do is clone the repository that has Vagrantfile and start the Vagrantbox:

```bash
$ git clone https://github.com/projectatomic/adb-atomic-developer-bundle.git
$ cd adb-atomic-developer-bundle/components/centos/centos-k8s-singlenode-setup/
$ vagrant up --provider libvirt
```

You can also choose `provider` as `virtualbox` with command as `vagrant up --provider virtualbox`


This will start the box, but if the box is not available then Vagrant will download it for you. Once the box is up and running, ssh into the box and you have running Kubernetes all-in-one cluster. This cluster is setup as Kubernetes Master and Kubernetes Node running on the same host.

```bash
vagrant ssh
```

Now you are in the machine try using Kubernetes with `kubectl` commands. If you are already familiar with Kubernetes you can skip steps following and test if the cluster has everything you need. For someone new to Kubernetes can keep following, to test Kubernetes working let's create a pod, for that create file named `pod.json` with following data

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

To create pod running on Kubernetes out of this file follow

```bash
kubectl create -f pod.json
```

See if the pod is running by

```bash
kubectl get pods
```

You may see a pod named `apache-centos7` there but the `STATUS` might be `Pending` so wait for a while and keep checking the output and once its changed to `Running` we can test if its running, but first we will need the IP of the pod, to get IP

```bash
kubectl describe pod apache-centos7 | grep 'IP:'
```

Note the IP and curl on it

```bash
curl IP_ADDRESS_OBTAINED
```

Unless you get any error the pod is running, which also signifies Kubernetes cluster is running. Now you can explore more options in Kubernetes on your own.
