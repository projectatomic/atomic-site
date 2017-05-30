---
title: Testing System-Containerized Kubeadm
author: jbrooks
date: 2017-05-26 07:00:00 UTC
tags: kubernetes, kubeadm, atomic, centos, fedora
comments: true
published: true
---

Recently, I’ve been experimenting with running [Kubernetes in system containers](http://www.projectatomic.io/blog/2017/05/system-containerized-kube/), and those tests led me to wonder whether I could use system containers as a means of working around the [issues I’ve experienced](https://jebpages.com/2016/11/01/installing-kubernetes-on-centos-atomic-host-with-kubeadm/) installing [kubeadm](https://kubernetes.io/docs/getting-started-guides/kubeadm/), the simple-to-use tool for bootstrapping kubernetes clusters, on an atomic host.

On a regular CentOS or Fedora host, using kubeadm is a matter of installing rpms for the kubelet, kubectl, kubeadm itself, and for a set of Kubernetes networking tools, kubernetes-cni. On an atomic host, rpm-ostree package layering allows for installing rpms, but if existing kube rpms are already part the atomic host image, as they are for Fedora Atomic Host, you won’t be able to install the prescribed upstream kube versions. And even on a host without built-in kubernetes, like [CentOS Atomic Continuous](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel), rpm-ostree won’t abide rpm content stored in `/opt`.

I managed to make a [kubadm system container](https://github.com/jasonbrooks/atomic-system-containers/tree/kube-containers/kubeadm) that uses the same tmpfiles.d trick I used to link kubectl and etcdctl from the container into the the host’s `/usr/local/bin` to make the kubeadm tool available from the host. 

For now, this works best on CentOS Atomic Host, with either the [downstream](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) or [continuous](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) branches. 

With Fedora-based Atomic Hosts, there are two issues. First, Fedora 25 currently ships with an older version of runc. Soon after the [updated version](https://bodhi.fedoraproject.org/updates/FEDORA-2017-f4ccc7cb91) gets enough karma, this kubeadm system container will work with Fedora 25... with SELinux in permissive mode. I’m trying to track down why this is necessary with Fedora but not with CentOS.

To try it for yourself, start out by installing this kubeadm system container, starting the kubelet service, and kicking off `kubeadm init`:

```
# atomic install --system --name kubelet docker.io/jasonbrooks/kubeadm
# systemctl start kubelet
# kubeadm init --skip-preflight-checks --pod-network-cidr=10.254.0.0/16
```

Once the `kubeadm init` completes, you’ll need to follow the directions on screen to configure kubectl:

```
$ sudo cp /etc/kubernetes/admin.conf $HOME/
$ sudo chown $(id -u):$(id -g) $HOME/admin.conf
$ export KUBECONFIG=$HOME/admin.conf
```

Next we need to configure a networking plugin, along with RBAC rules. I've modified the the `kube-flannel.yml` file below to work with SELinux:

```
$ kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
$ kubectl apply -f https://raw.githubusercontent.com/jasonbrooks/flannel/support-selinux-kube/Documentation/kube-flannel.yml
```
Assuming you want your master to do double-duty as a node for an all in one setup, run the following command:
 
```
$ kubectl taint nodes --all node-role.kubernetes.io/master-
```

Once all the pods in the `kube-system` namespace are up and running, which you can check with `kubectl get pods -n kube-system`, you can test out your cluster. I like to use this guestbook-go app:

```
$ kubectl apply -f https://gist.githubusercontent.com/jasonbrooks/c2cab426c315ec26266ddd2c78aa4b60/raw/f9199348a04d5d65b60ce974992f5fd589b3e1de/guestbookgo.yaml

$ kubectl get svc guestbook
NAME        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
guestbook   10.106.170.7   <nodes>       3000:32534/TCP   6m
```

Once all the pods for the guestbook app are are up and running, which you can check with `kubectl get pods`, you can test out the app by visiting the IP address of your host at the NodePort listed above (in this case 32534).

Running `atomic containers list` will show that most of the containers running are run via docker, with the exception of the kubelet container, run via runc:

```
$ atomic containers list
   CONTAINER ID IMAGE                COMMAND              CREATED          STATE     BACKEND    RUNTIME   
   81ab52fe1a6a docker.io/redis@sha2 docker-entrypoint.sh 2017-05-10 14:21 running   docker     docker    
   cf2561dbd708 docker.io/kubernetes /bin/sh -c /run.sh   2017-05-10 14:21 running   docker     docker    
   9cbbea14fc20 gcr.io/google_contai ./guestbook          2017-05-10 14:21 running   docker     docker    
   b8b91e19260e gcr.io/google_contai /pause               2017-05-10 14:21 running   docker     docker    
   e68cf8f192ab gcr.io/google_contai /pause               2017-05-10 14:21 running   docker     docker    
   f619b1092cfc gcr.io/google_contai /pause               2017-05-10 14:21 running   docker     docker    
   5d9b7966a292 gcr.io/google_contai /sidecar --v=2 --log 2017-05-10 12:27 running   docker     docker    
   f74a7d3da1bd gcr.io/google_contai /dnsmasq-nanny -v=2  2017-05-10 12:27 running   docker     docker    
   b6afd95588a9 gcr.io/google_contai /kube-dns --domain=c 2017-05-10 12:27 running   docker     docker    
   96a68d5a53d3 gcr.io/google_contai /pause               2017-05-10 12:27 running   docker     docker    
   75f981a02222 quay.io/coreos/flann /opt/bin/flanneld -- 2017-05-10 12:27 running   docker     docker    
   2c7d8e7af5c2 gcr.io/google_contai /usr/local/bin/kube- 2017-05-10 12:27 running   docker     docker    
   180eeb2e9a26 quay.io/coreos/flann /bin/sh -c 'set -e - 2017-05-10 12:26 running   docker     docker    
   1c35ebad2642 gcr.io/google_contai /pause               2017-05-10 12:26 running   docker     docker    
   f09b2e9f60ad gcr.io/google_contai /pause               2017-05-10 12:24 running   docker     docker    
   b980f99adec8 gcr.io/google_contai etcd --listen-client 2017-05-10 12:24 running   docker     docker    
   8d58bd57c632 gcr.io/google_contai kube-apiserver --kub 2017-05-10 12:24 running   docker     docker    
   2ffdb4612a64 gcr.io/google_contai kube-scheduler --add 2017-05-10 12:24 running   docker     docker    
   2cabf3d7a924 gcr.io/google_contai kube-controller-mana 2017-05-10 12:23 running   docker     docker    
   a5a8d203f7e7 gcr.io/google_contai /pause               2017-05-10 12:23 running   docker     docker    
   d25bc2c3808a gcr.io/google_contai /pause               2017-05-10 12:23 running   docker     docker    
   d3191cdaef80 gcr.io/google_contai /pause               2017-05-10 12:23 running   docker     docker    
   ef0d198666bc gcr.io/google_contai /pause               2017-05-10 12:23 running   docker     docker    
   kubelet      docker.io/jasonbrook /usr/bin/launch.sh   2017-05-10 12:22 running   ostree     runc
```

kubeadm is still considered beta for now, and there aren't official Fedora or CentOS packages , so the system container I made pulls that packages directly from the upstream. Once kubeadm is considered GA, I expect to see it available in Fedora-packaged form.