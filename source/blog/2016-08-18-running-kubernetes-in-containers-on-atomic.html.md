---
title: Running Kubernetes in Containers on Atomic
author: jbrooks
date: 2016-08-18 16:57:25 UTC
tags: atomic, kubernetes, centos, docker
published: false
comments: true
---

The [atomic hosts](http://www.projectatomic.io/docs/introduction/) from CentOS and Fedora earn their "atomic" namesake by providing for atomic, image-based system updates via rpm-ostree, and atomic, image-based application updates via docker containers.

This "system" vs "application" division isn't set in stone, however. There's room for system components to move across from the [somewhat](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host/) rigid world of ostree commits to the freer-flowing container side.

In particular, the key atomic host components involved in orchestrating containers across multiple hosts, such as flannel, etcd and kubernetes, could run instead in containers, making life simpler for those looking to test out newer or different versions of these components, or to swap them out for alternatives.

READMORE

[Suraj Deshmukh](https://twitter.com/surajd_) wrote a post recently about [running kubernetes in containers](https://deshmukhsuraj.wordpress.com/2016/07/19/hybrid-setup-for-multi-node-kubernetes/). He wanted to test kubernetes 1.3, for which Fedora packages aren't yet available, so he turned to the upstream [kubernetes-on-docker](https://github.com/kubernetes/kubernetes.github.io/blob/master/docs/getting-started-guides/docker-multinode/master.md). 

Suraj ran into trouble with flannel and etcd, so he ran those from installed rpms. Flannel can be tricky to run as a docker container, because docker's own configs must be modified to use flannel, so there's a bit of a chicken-and-egg situation. 

One solution is [system containers for atomic](http://www.scrivano.org/2016/03/24/system-containers-for-atomic/), which can be run independently from the docker daemon. [Giuseppe Scrivano](https://twitter.com/gscrivano) has built example containers [for flannel](https://hub.docker.com/r/gscrivano/flannel/) and [for etcd](https://hub.docker.com/r/gscrivano/etcd/), and in this post, I'm describing how to use these system containers alongside a containerized kubernetes on an atomic host.

### setting up flannel and etcd

You need a very recent version of the `atomic` command. I used a pair of CentOS Atomic Hosts running the ["continuous"](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) stream.

The master host needs etcd and flannel:

```
# atomic pull gscrivano/etcd

# atomic pull gscrivano/flannel

# atomic install --system gscrivano/etcd
```

With etcd running, we can use it to configure flannel:

```
# export MASTER_IP=YOUR-MASTER-IP

# runc exec gscrivano-etcd etcdctl set /atomic.io/network/config '{"Network":"172.17.0.0/16"}'

# atomic install --name=flannel --set ETCD_ENDPOINTS=http://$MASTER_IP:2379 --system gscrivano/flannel
```

The worker node needs flannel as well:

```
# export MASTER_IP=YOUR-MASTER-IP

# atomic pull gscrivano/flannel

# atomic install --name=flannel --set ETCD_ENDPOINTS=http://$MASTER_IP:2379 --system gscrivano/flannel
```

On both the master and the worker, we need to make docker use flannel:

```
# echo "/usr/libexec/flannel/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker" | runc exec flannel bash
```

Also on both hosts, we need this docker tweak ([because of this](https://github.com/kubernetes/kubernetes/issues/4869)):

```
# cp /usr/lib/systemd/system/docker.service /etc/systemd/system/

# sed -i s/MountFlags=slave/MountFlags=/g /etc/systemd/system/docker.service

# systemctl daemon-reload

# systemctl restart docker
```

On both hosts, some context tweaks to make SELinux happy:

```
# mkdir -p /var/lib/kubelet/

# chcon -R -t svirt_sandbox_file_t /var/lib/kubelet/

# chcon -R -t svirt_sandbox_file_t /var/lib/docker/
```

### setting up kube

With flannel and etcd running in system containers, and with docker configured properly, we can start up kubernetes in containers. I've pulled the following docker run commands from the [docker-multinode](https://github.com/kubernetes/kube-deploy/tree/master/docker-multinode) scripts in the kubernetes project's kube-deploy repository.

On the master:

```
# docker run -d \
    --net=host \
    --pid=host \
    --privileged \
    --restart="unless-stopped" \
    --name kube_kubelet_$(date | md5sum | cut -c-5) \
    -v /sys:/sys:rw \
    -v /var/run:/var/run:rw \
    -v /run:/run:rw \
    -v /var/lib/docker:/var/lib/docker:rw \
    -v /var/lib/kubelet:/var/lib/kubelet:shared \
    -v /var/log/containers:/var/log/containers:rw \
    gcr.io/google_containers/hyperkube-amd64:$(curl -sSL "https://storage.googleapis.com/kubernetes-release/release/stable.txt") \
    /hyperkube kubelet \
      --allow-privileged \
      --api-servers=http://localhost:8080 \
      --config=/etc/kubernetes/manifests-multi \
      --cluster-dns=10.0.0.10 \
      --cluster-domain=cluster.local \
      --hostname-override=${MASTER_IP} \
      --v=2
```

On the worker:

```
# export WORKER_IP=YOUR-WORKER-IP

# docker run -d \
    --net=host \
    --pid=host \
    --privileged \
    --restart="unless-stopped" \
    --name kube_kubelet_$(date | md5sum | cut -c-5) \
    -v /sys:/sys:rw \
    -v /var/run:/var/run:rw \
    -v /run:/run:rw \
    -v /var/lib/docker:/var/lib/docker:rw \
    -v /var/lib/kubelet:/var/lib/kubelet:shared \
    -v /var/log/containers:/var/log/containers:rw \
    gcr.io/google_containers/hyperkube-amd64:$(curl -sSL "https://storage.googleapis.com/kubernetes-release/release/stable.txt") \
    /hyperkube kubelet \
      --allow-privileged \
      --api-servers=http://${MASTER_IP}:8080 \
      --cluster-dns=10.0.0.10 \
      --cluster-domain=cluster.local \
      --hostname-override=${WORKER_IP} \
      --v=2

# docker run -d \
    --net=host \
    --privileged \
    --name kube_proxy_$(date | md5sum | cut -c-5) \
    --restart="unless-stopped" \
    gcr.io/google_containers/hyperkube-amd64:$(curl -sSL "https://storage.googleapis.com/kubernetes-release/release/stable.txt") \
    /hyperkube proxy \
        --master=http://${MASTER_IP}:8080 \
        --v=2
```

### get current kubectl

I usually test things out from the master node, so I'll download the newest stable kubectl binary to there:

```
# curl -sSL https://storage.googleapis.com/kubernetes-release/release/$(curl -sSL "https://storage.googleapis.com/kubernetes-release/release/stable.txt")/bin/linux/amd64/kubectl > /usr/local/bin/kubectl

# chmod +x /usr/local/bin/kubectl
```

### test it

It takes a few minutes for all the containers to get up and running. Once they are, you can start running kubernetes apps. I typically test with the [guestbookgo atomicapp](https://github.com/projectatomic/nulecule-library/tree/master/guestbookgo-atomicapp):

```
# atomic run projectatomic/guestbookgo-atomicapp
```

Wait a few minutes, until `kubectl get pods` tells you that your guestbook and redis pods are running, and then:

```
# kubectl describe service guestbook | grep NodePort
```

Visiting the `NodePort` returned above at either my master or worker IP (these kube scripts configure both to serve as workers) gives me this:

![](images/guestbook-ftw.png)
