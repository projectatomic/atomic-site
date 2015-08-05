---
title: Testing Nulecule on Debian
author: bexelbie
date: 2015-07-17 04:00:00 UTC
tags: Docker, Nulecule
comments: true
published: true
---

# Testing Nulecule on Debian

Unless you've recently returned from a sabbatical year in a remote monastery with no internet, you know that Containers have arrived, and it's a whole new world.

<img src="https://images.duckduckgo.com/iu/?u=http%3A%2F%2Fglobal3.memecdn.com%2Fa-whole-new-world_o_941765.jpg&f=1">

READMORE

I'll save you five minutes of reading, and 90 minutes of watching Disney's Alladin and assume you know about containers.  If not, take a look at [Docker](https://github.com/docker), [rkt](https://github.com/coreos/rkt) and the [Open Container Project](http://www.opencontainers.org/).  For bonus points, watch [How Docker Didn't Invent Containers](http://www.motivp.com/shop/video/How_Docker_did_not_invent_the_containers) from the [First Docker Meetup](http://www.projectatomic.io/blog/2015/05/docker-meetup-brno/) in my adopted hometown of Brno, Czech Republic.  When you're done singing the fantastic Disney songs, come back.  I'll wait.

While there is a lot of "shaking out" still going on around containers, one thing is for sure.  Applications are definitely starting to be delivered this way.  Currently, honestly, most folks are not using containers in production, and most deliverables are for internal use only.  Even in these few cases though, the applications being delivered are typically simple.  Maybe 2-3 containers. i.e. a web server container, a database container, and a caching server container. But something like [OpenStack on Docker](https://www.youtube.com/watch?v=NGOnG8czBk0)  is 12 containers.  12 containers that need to be linked, networked, and  orchestrated with various configuration changes for your environment. 

Complex applications are ... complex, in the sense that they require multiple processes to interact. No significant ISVs or OpenSource projects have delivered complex applications using containers.  The [Nulecule Specification](http://www.projectatomic.io/blog/2015/05/announcing-the-nulecule-specification-for-composite-applications/) was created to solve the problem of complex application delivery.

But does it work?  Well yes, it does.  There are a bunch of great [examples](https://github.com/projectatomic/nulecule/tree/master/examples) in the specification and a reference implementation that uses [atomicapp](https://github.com/projectatomic/atomicapp) for driving the packaging and parameterization, and the fancy [atomic](https://github.com/projectatomic/atomic) command to make launching those 12 containers in a fully orchestrated environment a one-command operation.

Recently a friend asked me, "This is all nice and stuff, but what if I don't use Fedora/CentOS/RHEL.  Can I still use Nulecule?"  I decided to find out.

To test this, I installed Debian 8.1 "Jessie" in a VM.  I followed the directions for installating docker.  Since the atomic command is not yet packaged for Debian, I downloaded the source and ran the customary `sudo make install`.  Next I discovered that Kubernetes is also not packaged for Debian, so I installed it using a set of prebuilt docker containers.  At this point I tried not to slip into an Inception induced coma at the thought of orchestrating docker containers using an orchestrator running inside of those same docker containers.

Lastly, for the big moment, I ran one command:

    atomic run projectatomic/helloapache

I am happy to say, Apache immediately told me "hello" in response to a `curl` command.

I was really expecting a slog to get all the parts working and to have to expend some effort to cajole the reference implementation of the specification into functioning, but it was really quite simple.  For those of you interested in the gory details, my specific steps are below.

If you are interested in packaging some of these tools for Debian, let me know if I can be of help.  If you want to help us make Nulecule better, give us a shout out in #nulecule@irc.freenode.net or on our mailng list.

# Nulecule Testing on Debian

## Installed Debian 8.1 Jessie in a VM
  - Text based install
  - single partition
  - Only loaded SSH Server and Standard tools
  - apt-get install sudo
  - usermod -a -G sudo bexelbie
  - apt-get update
  - reboot

## Install Docker
  - From: http://docs.docker.com/installation/debian/
    - Add 'deb http://http.debian.net/debian jessie-backports main' to /etc/apt/sources.list
    - sudo apt-get update
    - sudo apt-get -t jessie-backports install docker.io
    - sudo usermod -a -G docker bexelbie

## Install atomic
  - sudo apt-get install make pylint python-docker python-selinux go-md2man
  - git clone https://github.com/projectatomic/atomic.git
  - sudo make install

## Install Kubernetes using the via Docker instructions (it is not packaged for Debian)
  - From: https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/docker.md
    - Run the three docker commands to get things running - get kubectl below
    - docker run --net=host -d gcr.io/google_containers/etcd:2.0.9 /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
    - docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  gcr.io/google_containers/hyperkube:v0.18.2 /hyperkube kubelet --api_servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests
    - docker run -d --net=host --privileged gcr.io/google_containers/hyperkube:v0.18.2 /hyperkube proxy --master=http://127.0.0.1:8080 --v=2
  - Get kubectl from the same release (0.18.2): https://github.com/GoogleCloudPlatform/kubernetes/releases
    - wget https://github.com/GoogleCloudPlatform/kubernetes/releases/download/v0.18.2/kubernetes.tar.gz
    - tar -xvf kubernetes.tar.gz
    - sudo cp kubernetes/platforms/linux/amd64/kubectl /usr/bin

## Run helloapache
  - atomic run projectatomic/helloapache
  - kubectl get pods
  - once running
  - sudo apt-get install curl
  - curl localhost and see the default CentOS apache page
  - kubectl delete pod helloapache
  - curl localhost and get nothing

## Build our own using a stock example
  - First install atomicapp - latest version
    - git clone https://github.com/projectatomic/atomicapp.git
    - cd atomicapp
    - git checkout 0.1.1
    - sudo apt-get install python-pip
    - sudo pip install .
  - Try building our own helloapache
    - git clone https://github.com/projectatomic/nulecule.git
    - cd nulecule/examples/helloapache
    - docker build -t <tag> .
    - atomic run <tag>
    - curl localhost and see the default CentOS apache page
    - kubectl delete pod helloapache
    - curl localhost and get nothing