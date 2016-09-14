---
title: Running Kubernetes and Friends in Containers on CentOS Atomic Host
author: jbrooks
date: 2016-08-18 16:57:25 UTC
tags: atomic, kubernetes, centos, docker
published: false
comments: true
---

The [atomic hosts](http://www.projectatomic.io/docs/introduction/) from CentOS and Fedora earn their "atomic" namesake by providing for atomic, image-based system updates via rpm-ostree, and atomic, image-based application updates via docker containers.

This "system" vs "application" division isn't set in stone, however. There's room for system components to move across from the [somewhat](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host/) rigid world of ostree commits to the freer-flowing container side.

In particular, the key atomic host components involved in orchestrating containers across multiple hosts, such as flannel, etcd and kubernetes, could run instead in containers, making life simpler for those looking to test out newer or different versions of these components, or to swap them out for alternatives.

The [devel tree](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) of CentOS Atomic Host, which features a trimmed-down system image that leaves out kubernetes and related system components, is a great place to experiment with alternative methods of running these components, and swapping between them.

READMORE


## System Containers

Running system components in docker containers can be tricky, because these containers aren't automatically integrated with systemd, like other system services, and because some components, such as flannel, need to modify docker configs, resulting in a bit of a chicken-and-egg situation. 

One solution is [system containers for atomic](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/), which can be run independently from the docker daemon. [Giuseppe Scrivano](https://twitter.com/gscrivano) has built example containers [for flannel](https://hub.docker.com/r/gscrivano/flannel/) and [for etcd](https://hub.docker.com/r/gscrivano/etcd/), and in this post, I'll be using system containers to run flannel and etcd on my atomic hosts.

You need a very recent version of the `atomic` command. I used a pair of CentOS Atomic Hosts running the ["continuous"](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) stream.

The master host needs etcd and flannel:

```
# atomic install --system gscrivano/etcd

# systemctl start etcd
```

With etcd running, we can use it to configure flannel:

```
# runc exec etcd etcdctl set /atomic.io/network/config '{"Network":"172.17.0.0/16"}'

# atomic install --system gscrivano/flannel

# systemctl start flannel
```

The worker node needs flannel as well:

```
# export MASTER_IP=YOUR-MASTER-IP

# atomic install --system --set FLANNELD_ETCD_ENDPOINTS=http://$MASTER_IP:2379 gscrivano/flannel

# systemctl start flannel
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

## Kube in Containers

With etcd and flannel in place, we can proceed with running kubernetes. We can run each of the kubernetes master and worker components in containers, using the rpms available in the CentOS repositories. Here I'm using containers built from [these dockerfiles](https://github.com/jasonbrooks/CentOS-Dockerfiles/tree/pr-kubernetes/kubernetes).

### On the master

```
# export MASTER_IP=YOUR-MASTER-IP

# docker run -d --net=host jasonbrooks/kubernetes-apiserver:centos --admission-control=NamespaceLifecycle,NamespaceExists,LimitRanger,SecurityContextDeny,ResourceQuota --address=0.0.0.0 --insecure-bind-address=0.0.0.0

# docker run -d --net=host --privileged jasonbrooks/kubernetes-controller-manager:centos

# docker run -d --net=host jasonbrooks/kubernetes-scheduler:centos
```

### On the worker

```
# export WORKER_IP=YOUR-WORKER-IP

# atomic run --opt3="--master=http://$MASTER_IP:8080" jasonbrooks/kubernetes-proxy:centos

# atomic run --opt1="-v /etc/kubernetes/manifests:/etc/kubernetes/manifests:ro" --opt3="--address=$WORKER_IP --config=/etc/kubernetes/manifests --hostname_override=$WORKER_IP --api_servers=http://$MASTER_IP:8080 --cluster-dns=10.254.0.10 --cluster-domain=cluster.local" jasonbrooks/kubernetes-kubelet:centos
```

### Get matching kubectl

I like to test things out from my master node. We can grab the version of the kubernetes command line client, kubectl, that matches our rpms by extracting it from the CentOS rpm.

```
# rpm2cpio http://mirror.centos.org/centos/7/extras/x86_64/Packages/kubernetes-client-1.2.0-0.13.gitec7364b.el7.x86_64.rpm | cpio -iv --to-stdout "./usr/bin/kubectl" > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
```

We can then use kubectl to check on the status of our node(s):

```
# kubectl get nodes

NAME            STATUS    AGE
10.10.171.216   Ready     3h
```

### DNS Addon

The guestbookgo sample app that I like to use for testing requires the dns addon, so I always ensure that it's installed. Here I'm following the directions from the docker-multinode page in the kube-deploy repository:

```
# curl -O https://raw.githubusercontent.com/kubernetes/kube-deploy/master/docker-multinode/skydns.yaml
```

I skipped over setting up certificates for this cluster, so in order for the dns addon to work, the kube2sky container in the dns pod needs the argument `--kube-master-url=http://$MASTER_IP:8080`. Also, I'm changing the `clusterIP` to `10.254.0.10` to match the default from the rpms.

```
# vi skydns.yaml

...

- name: kube2sky
        image: gcr.io/google_containers/kube2sky-ARCH:1.15
        resources:
          limits:
            cpu: 100m
            memory: 50Mi
        args:
        # command = "/kube2sky"
        - --domain=cluster.local
		- --kube-master-url=http://$MASTER_IP:8080
...

spec:
  selector:
    k8s-app: kube-dns
  clusterIP: 10.254.0.10

```

Now to start up the dns addon:

```
# kubectl create namespace kube-system

# export ARCH=amd64

# sed -e "s/ARCH/${ARCH}/g;" skydns.yaml | kubectl create -f -
```

## Test it

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

## A Newer Kube

The kubernetes rpms in the CentOS repositories are currently at version 1.2. To try out the current, 1.3 version of kubernetes, you can swap in some newer rpms, running in Fedora or Rawhide-based containers, or you can use the latest kubernetes containers provided by the upstream project.

### Cleaning up

If you've already configured kubernetes using the above instructions, and want to start over with a different kubernetes version, you can blow your existing cluster away (while leaving the flannel and etcd pieces in place).

First, remove all the docker containers running on your master and node(s). On each machine, run:

```
# docker rm -f $(docker ps -a -q)
```

Run `docker ps` to see if any containers are left over, if there are, run the command above again until they're all gone. Since we're running flannel and etcd using runc, killing all our docker containers won't affect our system containers.

Next, you can clear out the etcd keys associated with the cluster by running this on your master:

```
# runc exec -t etcd etcdctl rm --recursive /registry
```

Then, on your worker node, clean up the `/var/lib/kubelet` directory:

```
# rm -rf /var/lib/kubelet/*
```
## Containers from Rawhide

I mentioned that the CentOS repositories contain a v1.2 kubernetes. However, Fedora's [Rawhide](https://fedoraproject.org/wiki/Releases/Rawhide) includes v1.3-based kubernetes packages. howI wanted to try out the most recent rpm-packaged kubernetes, so I rebuilt the containers I used above swapping in `fedora:rawhide` for `centos:centos7` in the `FROM:` lines of the dockerfiles.

You can run the same series of commands listed above, with the container tag changed from `:centos` to `:rawhide`. 

For instance:

```
# docker run -d --net=host jasonbrooks/kubernetes-scheduler:centos --master=http://$MASTER_IP:8080
```

becomes:

```
# docker run -d --net=host jasonbrooks/kubernetes-scheduler:rawhide --master=http://$MASTER_IP:8080
```

## Containers from Upstream

With flannel and etcd running in system containers, and with docker configured properly, we can start up kubernetes using [the containers](https://github.com/kubernetes/kubernetes/tree/master/cluster/images/hyperkube) built by the upstream kubernetes project. I've pulled the following docker run commands from the [docker-multinode](https://github.com/kubernetes/kube-deploy/tree/master/docker-multinode) scripts in the kubernetes project's kube-deploy repository.

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

### Get current kubectl

I usually test things out from the master node, so I'll download the newest stable kubectl binary to there:

```
# curl -sSL https://storage.googleapis.com/kubernetes-release/release/$(curl -sSL "https://storage.googleapis.com/kubernetes-release/release/stable.txt")/bin/linux/amd64/kubectl > /usr/local/bin/kubectl

# chmod +x /usr/local/bin/kubectl

# kubectl get nodes
```

From here, you an scroll up to the subhead "Test it" to run the guestbookgo  app. It's not necessary to start up the dns addon manually with these upstream containers, because this configuration starts that addon automatically.