---
title: Using a Super Privileged Container to Troubleshoot Container Problems
author: mmicene
date: 2015-09-01 04:00:00 UTC
tags: fedora, atomic, docker
comments: true
published: true
---

One of the issues with containers built "The Right Way" (TM) (e.g., minimal containers that only provide the application code) is figuring out what's going on inside the container.  If you ship just application code, you run the risk of turning your container into a proverbial black box.  Atomic hosts can provide a one way view of all of the operations inside a container, if you can find the right tool.  Rather than adding more tools to your application container, folks like [Dan Walsh](https://twitter.com/rhatdan) have been working on [super privileged containers](https://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/) to manage the host, such as [the Cockpit container](http://www.projectatomic.io/blog/2015/06/running-cockpit-as-a-service/).

I was recently introduced to [Sysdig](www.sysdig.org/) for inspecting running process and activity on a Linux system.  It's a fairly nifty tool that understands Docker containers, and the authors have made sure that sysdig can be run in a container.  This made it very simple to install on my laptop and start investigating.

READMORE

The existing sysdig container works without an issue on my Fedora 22 Workstation install as is.  You can follow the general container install instructions on the website and start poking around on your system.  I was able to see I/O and network data, running process information, file access, and all sorts of other interesting data.

Looking to move this to an Atomic host, I found a few things that need some work.

First, the `docker run` command line:

```
docker run -i -t --name sysdig --privileged -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro sysdig/sysdig
```

Lots of volumes to mount read-only that present an opportunity for typos for this super privileged container.  This is exactly where [`atomic` LABEL support](http://www.projectatomic.io/blog/2015/04/using-environment-substitution-with-the-atomic-command/) is useful.

Secondly, sysdig needs kernel headers in order to build the probe module it uses.  Fedora 22 Atomic host doesn't ship with `kernel-headers` installed in the base tree, so my container will have to provide that package.

So I set out to build a new Dockerfile aimed at providing a Fedora Atomic host friendly environment.  I started with [the upstream sysdig Dockerfile](https://github.com/draios/sysdig/tree/dev/docker/stable).  I changed the source to match the Fedora version we build Atomic hosts from, in this case 22.  I added the kernel-headers package, trimmed down the other packages being installed, and set up the `docker run` command in the `RUN` label.

```
FROM fedora:22

MAINTAINER nzwulfin

LABEL RUN="docker run -i -t -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro --name NAME IMAGE"

ENV SYSDIG_HOST_ROOT /host

ENV HOME /root

RUN dnf -y update --setopt=deltarpm=0 \
 && dnf install -y kernel-headers gcc --setopt=deltarpm=0

RUN rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public \
 && curl -s -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo \
 && dnf install -y sysdig --setopt=deltarpm=0

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["bash"]
```

Since updates to the kernel would come as a new Atomic tree, I decided to use a tag to the container that tracked the Atomic version number.  This allows me to rebuild the container when the kernel version updates and know what the first version of Atomic hosts that use that kernel.  So sysdig-spc:22.99 will support any Atomic host of that version or later.  The next time a kernel update comes to an Atomic version, I can simply rebuild the container and add a new tag.

I'm not specifying a kernel version in this Dockerfile, but I did test that as well if you'd like tighter coupling between the Atomic versions and the Docker Hub tag.

Once the container is pushed to the Docker Hub, `atomic run` will be able to launch the sysdig-spc container and give you the ability to inspect your running containers.  The container will open a shell as root, you can run `csysdig` to get the TUI version, or `sysdig -l` to see what modules you can run from the command line.  You can also check out the sysdig website for examples.

If you'd like to try out the container I built try:

`atomic run --spc nzwulfin/sysdig-spc`

Or if you want to run a specific tagged container:

`atomic run --spc nzwulfin/sysdig-spc:22.99`

Once you have sysdig running on your host, check out the project's [examples page](http://www.sysdig.org/wiki/sysdig-examples/) to see what you can do with the utility. 

Building your own tools SPC can make inspecting and troubleshooting Docker and Kubernetes environments simpler.