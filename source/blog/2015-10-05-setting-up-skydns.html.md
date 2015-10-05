---
title: 'Setting up SkyDNS '
author: dmabe
date: 2015-10-05 08:17:14 UTC
tags: skydns, dns, fedora, centos, etcd, kubernetes
comments: true
published: true
---

Kubernetes is (currently) missing an integrated dns solution for service discovery. In the future it will be integrated into `kubernetes` (see [PR11599](https://github.com/kubernetes/kubernetes/pull/11599)) but for now we have to setup [SkyDNS](https://github.com/skynetservices/skydns) manually.

I have seen some tutorials on how to get `skydns` working, but almost all of them are rather involved. However, if you just want a simple setup on a single node for testing then it is actually rather easy to get `skydns` set up.

READMORE

Setting it up
=============

**NOTE:** This tutorial assumes that you already have a machine with `docker` and `kubernetes` set up and working. This has been tested on Fedora 22 and CentOS 7. It should work on other platforms but YMMV.

So the way `kubernetes`/`skydns` work together is by having two parts:

-   kube2sky - listens on the kubernetes api for new services and adds information into etcd.
-   skydns - listens for dns requests and responds based on information in etcd.

The easiest way to get `kube2sky` and `skydns` up and running is to just kick off a few `docker` containers. We'll start with `kube2sky` like so:

    [root@f22 ~]$ docker run -d --net=host --restart=always          \
                    gcr.io/google_containers/kube2sky:1.11           \
                    -v=10 -logtostderr=true -domain=kubernetes.local \
                    -etcd-server="http://127.0.0.1:2379"

**NOTE:** We are re-using the same `etcd` that `kubernetes` is using.

The next step is to start `skydns` to respond to dns queries:

    [root@f22 ~]$ docker run -d --net=host --restart=always         \
                    -e ETCD_MACHINES="http://127.0.0.1:2379"        \
                    -e SKYDNS_DOMAIN="kubernetes.local"             \
                    -e SKYDNS_ADDR="0.0.0.0:53"                     \
                    -e SKYDNS_NAMESERVERS="8.8.8.8:53,8.8.4.4:53"   \
                    gcr.io/google_containers/skydns:2015-03-11-001

The final step is to modify your `kubelet` configuration to let it know where the dns for the cluster is. You can do this by adding `--cluster_dns` and `--cluster_domain` to `KUBELET_ARGS` in `/etc/kubernetes/kubelet`:

    [root@f22 ~]$ grep KUBELET_ARGS /etc/kubernetes/kubelet
    KUBELET_ARGS="--cluster_dns=192.168.121.174 --cluster_domain=kubernetes.local"
    [root@f22 ~]$ systemctl restart kubelet.service

**NOTE:** I used the ip address of the machine that we are using for this single node cluster.

And finally we can see our two containers running:

    [root@f22 ~]$ docker ps --format "table {{.ID}}\t{{.Status}}\t{{.Image}}"
    CONTAINER ID        STATUS              IMAGE
    d229442f533c        Up About a minute   gcr.io/google_containers/skydns:2015-03-11-001
    76d51770b240        Up About a minute   gcr.io/google_containers/kube2sky:1.11

Testing it out
==============

Now lets see if it works! Taking a page out of the [kubernetes github](https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns#1-create-a-simple-pod-to-use-as-a-test-environment) we'll start a busybox container and then do an `nslookup` on the *"kubernetes service"*:

    [root@f22 ~]$ cat > /tmp/busybox.yaml <<EOF
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
      namespace: default
    spec:
      containers:
      - image: busybox
        command:
          - sleep
          - "3600"
        imagePullPolicy: IfNotPresent
        name: busybox
      restartPolicy: Always
    EOF
    [root@f22 ~]$ kubectl create -f /tmp/busybox.yaml
    pod "busybox" created
    [root@f22 ~]$ kubectl get pods
    NAME      READY     STATUS    RESTARTS   AGE
    busybox   1/1       Running   0          16s
    [root@f22 ~]$ kubectl exec busybox -- nslookup kubernetes
    Server:    192.168.121.174
    Address 1: 192.168.121.174

    Name:      kubernetes
    Address 1: 10.254.0.1

**NOTE:** The *"kubernetes service"* is the one that is shown from the `kubectl get services kubernetes` command.

Now you have a single node `k8s` setup with dns. In the future [PR11599](https://github.com/kubernetes/kubernetes/pull/11599) should satisfy this need but this works for now.
