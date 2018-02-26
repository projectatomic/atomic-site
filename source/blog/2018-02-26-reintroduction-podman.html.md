---
title: Reintroduction of Podman
author: dwalsh
date: 2018-02-26 00:00:00 UTC
published: true
comments: false
tags: atomic, buildah, containers, podman, kubernetes
---

Podman (formerly kpod) has been kicking around since last summer.  It was originally part of the [CRI-O](https://github.com/kubernetes-incubator/cri-o&sa=D&ust=1519653090854000&usg=AFQjCNGVeTeYAfYk3RH27hK5ykSNrATy1w) project.  We moved podman into a separate project, [libpod](https://github.com/projectatomic/libpod).  We wanted Podman and CRI-O to develop at their own pace.  Both CRI-O and Podman work fine as independent tools and also work well together.

The goal of Podman (Pod Manager) is to offer an experience similar to the docker command line - to allow users to run standalone (non-orchestrated) containers.  Podman also allows users to run groups of containers called pods. For those that don’t know, a Pod is a term developed for the Kubernetes Project which describes an object that has one or more containerized processes sharing multiple namespaces (Network, IPC and optionally PID).

Podman brings innovation to container tools in the spirit of Unix commands which do “one thing” well. Podman doesn’t require a daemon to run containers and pods. This makes it a great asset for your container tools arsenal.

READMORE

## Debug, Diagnose, and Manage content for CRI-O

One of our goals with Podman is to allow users of CRI-O to examine what is going on behind the scenes in the OpenShift/Kubernetes environment when running CRI-O as the container runtime.  Users of Kubernetes with a Docker Engine backend could use the Docker CLI to examine the containers/images that were created and running in the environment.  If you swap out the Docker Engine with CRI-O then you could examine the containers/images in your environment with Podman.

**Note:** We have not fully integrated podman and CRI-O at this point but continue to work on the integration.

## Familiar with the Docker CLI? Don’t Worry!

When we started working on the Podman CLI, we wanted to make sure it was easy for people to use, especially for those transitioning from the Docker CLI.  For running containers and managing container images, we followed the same pattern on most of commands and options from the Docker CLI.

```
docker run -ti -v /var/lib/myapp:/var/lib/myapp:Z --security-opt seccomp:/tmp/secomp.json fedora sh

podman run -ti -v /var/lib/myapp:/var/lib/myapp:Z --security-opt seccomp:/tmp/secomp.json fedora sh

docker ps -a -q

podman ps -a -q

docker images --format "table {{.ID}} {{.Repository}} {{.Tag}}"

podman images --format "table {{.ID}} {{.Repository}} {{.Tag}}"
```

You get the idea.  The goal is, if you find a Docker example via your favorite search engine, you will only need to change the docker command to podman.

Podman implements 38 of the 40 Docker CLI commands defined in Docker 1.13, but there are a few that we don’t implement. For example those dealing with Docker Swarm - instead for orchestrated Pods/Containers we suggest the use of Kubernetes.  Also, some of the commands that deal with Docker Plugins like volume plugins and network plugins are not implemented.   A full breakdown of the Podman commands and their Docker equivalents can be found on the ["Podman Usage Transfer"](https://github.com/projectatomic/libpod/blob/master/transfer.md) page.

Podman is implemented as a standalone command. Unlike the Docker CLI which talks to the Docker daemon when examining the content, Podman requires no such daemon to get work done. Podman can examine registry server content directly without any daemon involved.

This gives Podman a big advantage in many operations scenarios. For example, imagine that the docker daemon hangs in a Kubernetes environment - you can’t inspect images nor inspect which containers are running.  No Docker daemon, no diagnosis.  With podman, you can because it doesn’t rely on daemon.

# libpod

You might have noticed that Podman is not in a github repo called podman, but is actually stored under [libpod](https://github.com/projectatomic/libpod). Libpod is a library that we are excited about that actually allows other tools to manage pods/containers.  Podman is the default CLI tool for using this library.  We plan on now porting CRI-O to use the libpod library.  Potentially other tools like [Buildah](https://github.com/projectatomic/buildah) will also be ported to use libpod as well.  We hope that others projects find some of its features useful, and could potentially use it when trying to implement the Kubernetes Pod concept, but do not need Kubernetes orchestration.

## No Big Fat Daemons

Podman does not implement a daemon like the Docker Engine.

The Docker CLI is a client/server operation and the Docker CLI communicates with the Docker engine when it wants to create a container.  Most users do not run into this, but it can lead to some issues when using Docker in practice.  You need to start the Docker Daemon before you can use the Docker CLI. When you create a container using Docker, the Docker CLI sends an API call to the Docker Engine to launch the OCI Container runtime, usually runc, to launch the container.  This means the container processes are not [descendants](https://www.thegeekstuff.com/2013/07/linux-process-life-cycle/) of the Docker CLI, they are descendants of the Docker Engine.

Podman on the other hand does not use a daemon.  It also uses OCI runtimes, usually runc, to launch the container, but the container processes are direct [descendants](https://www.thegeekstuff.com/2013/07/linux-process-life-cycle/) of the podman process.  Podman is more of a traditional fork/exec model of Unix and Linux.


The advantage of the Podman model is that cgroups or security constraints still control the container processes.  If I constrain the podman command with cgroups the container processes will receive those same constraints.  Another feature of this model is that I can take advantage of some of the advanced features of systemd by putting podman into a systemd unit file.


For example, systemd has a concept of a notify unit file.  When booting a system you might want to run a service in a container that has to be started before other services that require that service get started.  A notify unit waits until the primary service sends a notify signal to systemd, saying it is up and running.  With the Docker CLI there is no way to implement this, since it is a client/server operation.  Podman just forwards the systemd information down to its children, so that the container process can notify systemd when it is ready to receive connections.  Podman can also support systemd socket activation.

## But wait there's more ...

While we started with the Docker CLI, we by no means want to stop there.  We have added additional features to traditional commands that our engineering team finds convenient and always aggravated us when using the Docker CLI, and [were never able to get merged into upstream Docker/CLI](https://github.com/moby/moby/issues/1682).  For example we have added a `--all` flag to several commands.

```
podman rm --all

podman rmi --all
```

These two commands remove all containers and all images from your system.

We plan to introduce [pod commands](https://github.com/projectatomic/libpod/issues/341) to make it easier for users to create and manage "pods".


# containers/storage and containers/image

In the spirit of reuse, I wanted to point out the other two libraries that are critical to making Podman possible. [containers/storage](https://github.com/containers/storage) is the library that allows us to use copy-on-write (COW) file systems, required to run containers.  We share this storage between all of our tools: [CRI-O](https://github.com/kubernetes-incubator/cri-o), [Buildah](https://github.com/projectatomic/buildah), [Skopeo](https://github.com/projectatomic/skopeo), as well as Podman.


[containers/image](https://github.com/containers/image) is the library that allows us to download and install OCI Based Container Images from containers registries like Docker.io, [Quay](https://coreos.com/quay-enterprise/), and Artifactory, as well as many others.  Container/image even allows us to easily move container images in and out of Docker image storage and Podman container/storage as well as container registries.


But, unlike the Docker storage and image management, containers/storage and containers/image were built from the ground up to support multiple independent processes to interact with the libraries at the same time.  This means you can be running a full Kubernetes environment with CRI-O while at the same time you are building container images using Buildah and managing your containers and pods with Podman.


# Try it out

Podman is now available in Fedora 28 and 27.  It is also available in Ubuntu (via [Project Atomic PPA](https://launchpad.net/~projectatomic/+archive/ubuntu/ppa) and CentOS (via [Virtualization SIG yum repository](https://cbs.centos.org/repos/virt7-container-common-candidate/x86_64/os/) and should be available in Red Hat Enterprise Linux 7.5 release.  It should be easy to build and install in your favorite distribution.  This is an Alpha release, and we are anxious to hear your feedback.  We see Podman as a viable alternative to Docker for a lot of your container work loads, without requiring a large learning curve.

One last note, I pointed out above that podman manages the containers, images and storage directly, this is similar to the Docker CLI, but sometimes (ex. debugging) you still want to communicate with the CRI-O daemon directly, using the same interface that Kubernetes uses, but outside of Kubernetes.  We are also providing a new tool called [crictl](https://github.com/kubernetes-incubator/cri-tools) that can perform all of the CRI calls that Kubernetes defines. In a future blog, I will explain this further.
