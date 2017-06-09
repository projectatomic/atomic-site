---
title: Using kubeadm with CRI-O
author: runcom
date: 2017-06-09 16:00:00 UTC
comments: true
published: true
tags: kubernetes, centos, cri-o, kubeadm
---

**[CRI-O](https://github.com/kubernetes-incubator/cri-o)** is a Kubernetes incubator project which is meant to provide an integration path between Open Containers Initiative (OCI) conformant runtimes and the kubelet. Specifically, it implements the Container Runtime Interface (CRI) using OCI conformant runtimes. CRI-O uses [runc](https://github.com/opencontainers/runc) as its default runtime to run Kubernetes pods. For more information you can read a brief introduction [here](https://www.projectatomic.io/blog/2017/02/crio-runtimes/). If you're interested into why you should use CRI-O instead of other container runtimes you can read more [here](https://www.projectatomic.io/blog/2017/06/6-reasons-why-cri-o-is-the-best-runtime-for-kubernetes/).

READMORE

Introduction
=

First things first, I'm pleased to announce that [CRI-O](https://github.com/kubernetes-incubator/cri-o) can be seamlessy used with [kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) to install kubernetes. This allows containers to be run under Kubernetes without the docker-engine being present on your servers.


Getting  started with CRI-O and kubeadm
=

To begin, you first provision machines with CRI-O using a [handy ansible playbook](https://github.com/cri-o/cri-o-ansible). The playbook will compile CRI-O from source and is the only installation method currently available. Installation packages for all of the major distributions are under development and should be available in the near future. Stay tuned!

Once you have  successfully installed CRI-O, you can follow this blog post to install Kubernetes. We're also going to add a network  add-on to provide networking for the cluster.

Environment
=

You will be creating a three servers cluster using local virtual machines with `libvirt`. The master will be running on Fedora 25, the nodes will be a CentOS 7.3 machine and an Ubuntu 16.04 machine. Here is the identifying information for the two servers:

 ```
| Role       |      IP        | Hostname    |
|------------|----------------|-------------|
| master     | 192.168.122.34 | fedora.vm   |
| node       | 192.168.122.35 | centos.vm   |
| node       | 192.168.122.36 | ubuntu.vm   |
```

If you're going through this tutorial using machines in the cloud you can skip the following check. Machines in public clouds can usually  reach each other.

Setup SSH
=

Make sure machines are reachable using ssh using private keys to authenticate. We're going to need this for the ansible playbook:

```sh
laptop $ ssh-copy-id root@192.168.122.34 # fedora.vm
laptop $ ssh-copy-id root@192.168.122.35 # centos.vm
laptop $ ssh-copy-id root@192.168.122.36 # ubuntu.vm
```

Check connectivity
=

First  you're going to  make sure both servers can communicate via hostname by checking their `/etc/hosts` files:

On the fedora host:

```sh
fedora.vm $ cat /etc/hosts
[...]
192.168.122.34 fedora.vm
192.168.122.35 centos.vm
192.168.122.36 ubuntu.vm
```

On the ubuntu host:

```sh
ubuntu.vm $ cat /etc/hosts
[...]
192.168.122.34 fedora.vm
192.168.122.35 centos.vm
192.168.122.36 ubuntu.vm
```

On the centos hosts:

```sh
centos.vm $ cat /etc/hosts
[...]
192.168.122.34 fedora.vm
192.168.122.35 centos.vm
192.168.122.36 ubuntu.vm
```

Clone and run the ansible playbook
=

Now clone the ansible playbook needed to install CRI-O:

```sh
laptop $ git clone https://github.com/cri-o/cri-o-ansible
laptop $ cd cri-o-ansible
```

The last thing you need to do is now launch the ansible playbook on each server.

```sh
laptop $ pwd
/home/runcom/cri-o-ansible
laptop $ cat hosts
192.168.122.35
192.168.122.34 ansible_python_interpreter=’python3’
192.168.122.36 ansible_python_interpreter=’python3’
laptop $ ansible-playbook -i hosts cri-o.yml
[...]
laptop $
```

Currently the ansible playbook supports Ubuntu 16.04, CentOS 7.3 and Fedora 25+. We're planning to add support for other distributions. Feel free to open a PR for other distributions as well!

kubeadm
=

Now that you have correctly provisioned the two servers you need to follow the official `kubeadm` documentation to install kubernetes.  You don’t need  to install the `docker` package on any server!  It's not needed even though the kubeadm documentation says to install it.  CRI-O is replacing the functionality of the docker engine for  Kubernetes.

Setting up the Master
-

Start by logging into the `fedora.vm` machine which will be the master node:

```sh
fedora.vm # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
fedora.vm # dnf install -y kubelet kubeadm kubernetes-cni
fedora.vm # systemctl restart crio
fedora.vm # systemctl enable kubelet && systemctl start kubelet
```

Run `kubeadm` to install the master node:

```sh
fedora.vm # kubeadm init --pod-network-cidr=10.244.0.0/16 --skip-preflight-checks
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[init] Using Kubernetes version: v1.6.4
[init] Using Authorization mode: RBAC
[preflight] Skipping pre-flight checks
[certificates] Generated CA certificate and key.
[certificates] Generated API server certificate and key.
[certificates] API Server serving cert is signed for DNS names [kubeadm-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 10.138.0.4]
[certificates] Generated API server kubelet client certificate and key.
[certificates] Generated service account token signing key and public key.
[certificates] Generated front-proxy CA certificate and key.
[certificates] Generated front-proxy client certificate and key.
[certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"
[apiclient] Created API client, waiting for the control plane to become ready
[apiclient] All control plane components are healthy after 16.772251 seconds
[apiclient] Waiting for at least one node to register and become ready
[apiclient] First node is ready after 5.002536 seconds
[apiclient] Test deployment succeeded
[token] Using token: <token>
[apiconfig] Created RBAC rules
[addons] Created essential addon: kube-proxy
[addons] Created essential addon: kube-dns

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run (as a regular user):

  sudo cp /etc/kubernetes/admin.conf $HOME/
  sudo chown $(id -u):$(id -g) $HOME/admin.conf
  export KUBECONFIG=$HOME/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  http://kubernetes.io/docs/admin/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token 6b7a29.95a2995f65e1d3c9 192.168.122.34:6443
```

_Do not follow `kubeadm` commands in the output above as we're going to use some custom flags to make `kubeadm` works nicely with CRI-O_

Make a record of the `kubeadm join` token that `kubeadm init` outputs. You will need this in a moment when setting up the nodes.

Let's explain the flags you used:

- `--pod-network-cidr=10.244.0.0/16`: this is required as you're going to use Flannel to provide network for the cluster
- `--skip-preflight-checks`: `kubeadm` still assumes docker as the only container runtime which can be used with Kubernetes. You need this flag in order to silence `kubeadm init` when it warns us that docker is not installed.  We've  opened an issue upstream to take care of this at https://github.com/kubernetes/kubeadm/issues/285.

 The master is now up and running. Only thing remaining to do on the master is deploying a network add-on for the cluster. We're going to use a custom Flannel network add-on but we also tested the [official Weave network add-on](https://www.weave.works/docs/net/latest/kube-addon/) if you wish to use it instead.

```sh
fedora.vm # export KUBECONFIG=/etc/kubernetes/admin.conf
fedora.vm # kubectl apply -f https://gist.githubusercontent.com/sameo/cf92f65ae54a87807ed294f3de658bcf/raw/95d9a66a2268b779dbb25988541136d1ed2fbfe2/flannel.yaml
serviceaccount "flannel" created
clusterrolebinding "flannel" created
clusterrole "flannel" created
serviceaccount "calico-policy-controller" created
configmap "kube-flannel-cfg" created
daemonset "kube-flannel-ds" created
```

The master is now fully configured.

Setting up the Nodes
-

On the Ubuntu node:

```sh
ubuntu.vm # apt-get update && apt-get install -y apt-transport-https
ubuntu.vm # curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
ubuntu.vm # cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
ubuntu.vm # apt-get update
ubuntu.vm # systemctl restart crio
ubuntu.vm # apt-get install -y kubelet kubeadm kubectl kubernetes-cni
```
On the Centos node:

```sh
centos.vm # cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
centos.vm # yum install -y kubelet kubeadm kubernetes-cni
centos.vm # systemctl restart crio
centos.vm # systemctl enable kubelet && systemctl start kubelet
```

Installing Kubernetes on the nodes is just a matter of running the `kubeadm join` command. You now need to use the token taken from the first `kubeadm join` on the master. In case you missed it, run the following command on the master and grab it:

```sh
fedora.vm # kubeadm token list
```

On the Centos node:

```sh
centos.vm # kubeadm join --skip-preflight-checks --token 6b7a29.95a2995f65e1d3c9 192.168.122.34:6443
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[preflight] Skipping pre-flight checks
[discovery] Trying to connect to API Server "192.168.122.34:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.122.34.4:6443"
[discovery] Cluster info signature and contents are valid, will use API Server "https://192.168.122.34:6443"
[discovery] Successfully established connection with API Server "192.168.122.34:6443"
[bootstrap] Detected server version: v1.6.4
[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)
[csr] Created API client to obtain unique certificate for this node, generating keys and certificate signing request
[csr] Received signed certificate from the API server, generating KubeConfig...
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"

Node join complete:
* Certificate signing request sent to master and response
  received.
* Kubelet informed of new secure connection details.

Run 'kubectl get nodes' on the master to see this machine join.
```

On the Ubuntu node:

```sh
ubuntu.vm # kubeadm join --skip-preflight-checks --token 6b7a29.95a2995f65e1d3c9 192.168.122.34:6443
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[preflight] Skipping pre-flight checks
[discovery] Trying to connect to API Server "192.168.122.34:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://192.168.122.34.4:6443"
[discovery] Cluster info signature and contents are valid, will use API Server "https://192.168.122.34:6443"
[discovery] Successfully established connection with API Server "192.168.122.34:6443"
[bootstrap] Detected server version: v1.6.4
[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)
[csr] Created API client to obtain unique certificate for this node, generating keys and certificate signing request
[csr] Received signed certificate from the API server, generating KubeConfig...
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"

Node join complete:
* Certificate signing request sent to master and response
  received.
* Kubelet informed of new secure connection details.

Run 'kubectl get nodes' on the master to see this machine join.
```

Nodes setup is now completed.

Enjoy
=

Congratulations! You installed Kubernetes on the cluster and you're using CRI-O as the container runtime!

To start using your cluster, you need to run (as a regular user) on the master:

```sh
fedora.vm $  sudo cp /etc/kubernetes/admin.conf $HOME/
fedora.vm $  sudo chown $(id -u):$(id -g) $HOME/admin.conf
fedora.vm $  export KUBECONFIG=$HOME/admin.conf
fedora.vm $ kubectl get nodes
NAME        STATUS    AGE      VERSION
centos.vm   Ready     17s      v1.6.4
fedora.vm   Ready     15m      v1.6.4
ubuntu.vm   Ready     12m      v1.6.4
fedora.vm $
```

Play around with your cluster in any way you want. I suggest following the great examples at [kubernetesbyexample.com](http://kubernetesbyexample.com/).

Conclusions
=

Kubernetes runs well with alternative runtimes like CRI-O.  Since CRI-O is dedicated to the kubernetes runtime, it is an excellent alternative to the upstream docker engine.

We're currently working on making CRI-O available for every major distribution.  This will allow you to install it from your favorite package manager, as opposed to installing it from source. We'll make an official announcement when the packages are ready.  We’re always looking for help and would welcome anyone that would like to join the development effort for CRI-O!

If you run into issues following these installation instructions, please report them in one of the following places:

- [The CRI-O github repository](https://github.com/kubernetes-incubator/cri-o)
- The #cri-o channel on chat.freenode.net
- In the comments below

Grazie mille!
