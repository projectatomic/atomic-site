---
title: Building a Buildah container image for Kubernetes
author: ipbabble
date: 2018-03-01 00:00:00 UTC
published: true
comments: false
tags:
- buildah
- oci
- containers
- kubernetes
---

![buildah logo](https://cdn.rawgit.com/projectatomic/buildah/master/logos/buildah-logo_large.png)

# Building a Buildah Container Image for Kubernetes
## Background

Dan Walsh ([@rhatdan](https://github.com/rhatdan)) asked me to look into building a working [Buildah](https://github.com/projectatomic/buildah) container image. This was not just a cool experiment. It has a real purpose. As many readers know, Dan is not a fan of "[big fat daemons](https://www.youtube.com/watch?v=BeRr3aZbzqo&list=PLaR6Rq6Z4IqfhzC5ds3sMju7KKNzdd0xy&t=1055s)." This has become less of an issue when running containers in Kubernetes as there is an alternative with [CRI-O](http://cri-o.io/). CRI-O provides kubernetes a standard interface to [OCI compliant runtimes](https://github.com/opencontainers/runtime-spec). [runC](https://github.com/opencontainers/runc) is the reference implementation of the OCI runtime specification. Kubernetes calls the runtC runtime through CRI-O and runC then talks to the Linux kernel to run a container. This bypasses the need for the Docker daemon, and containerd. With CRI-O, there is no requirement for the Docker daemon for a kubernetes cluster to run containers.

However this does not solve the problem of building container images. Until recently, Docker was considered the gold standard for building OCI compliant container images - and with Docker, a running daemon is required to build them. There are two ways to solve this: have dedicated build nodes or run the Docker daemon across the cluster, which puts us back at square zero. 

The daemon runs as root, and adds complexity and attack surface. To mitigate this risk, having dedicated machines for doing builds seems the better choice. But when you have a cluster of resources with something like Kubernetes you really don’t want to waste resources with dedicated nodes which might sit idle when not doing builds. It’s much better to schedule builds in the cluster, just like any other process. There are several reasons for this.

* In a continuous integration, multi-tenant environment there can be multiple builds going on at any time. So if your cluster is a PaaS for developers you want to be able to schedule builds whenever the developer needs them as quickly as possible. Having the ability to schedule across the cluster is very efficient.
* When new base images become available in a continuous deployment environment, you will want to take advantage of them as soon as possible. This may cause a spike of build activity that you want to spread across the cluster rather than overloading a single machine.
* Related to the second point, when security events like a CVE occurs, many images will need to be rebuilt to ensure the vulnerability is addressed. Again this is going to cause spikes and will require many simultaneous build resources. 

Therefore it is important to be able to be able to schedule container image builds within the kubernetes cluster. But it's hardly worth having solved the "big fat daemon" issue for runtime if you still need the daemon for build time across the cluster. i.e. you still need to have Docker running on all the nodes in the cluster if you intend to do builds on them.

Enter Buildah. Buildah doesn’t require a daemon to run on a host in order to build a container image. At the same time it would be great if we didn’t have to install Buildah on every node in the cluster, as we did with Docker, and also maintain consistent updates on each node. Instead it would be preferable to run Buildah as a container. If we can.

So I embarked on this effort and hit several small roadblocks, but essentially got it working relatively quickly.

## Building a Buildah OCI [image](https://developers.redhat.com/blog/2018/02/22/container-terminology-practical-introduction/#h.dqlu6589ootw)

First let’s summarize the goal and purpose of this exercise. We want to build a Buildah container that can be run by Kubernetes to perform image builds across the cluster on demand. This allows kubernetes to orchestrate build farms. If we can do this then we can remove the need for running a Docker daemon everywhere on the Kubernetes cluster. CRI-O and runC solve the runtime problem and CRI-O, runC and Buildah solve the build problem.

Time to install Buildah. Run as root because you will need to be root for running Buildah commands for this exercise. My Linux of choice is Fedora and so I use DNF.

```
# dnf -y install buildah
```

Here are the steps I performed to build my Buildah OCI image:

First I wanted to build it from scratch. I wanted nothing in the container except what I need to run Buildah. But what about DNF or Yum, you might ask? Don't need them. If I'm using this Buildah container from the command line then I'll be using the host’s package manager, whatever that might be. If I'm using Buildah `bud`, aka build-using-dockerfile, then I'm using the FROM images package manager. To start the process, I created a scratch container and stored the container's name, which happens to be working-container, in a environment variable for convenience.

```  
# containerid=$(buildah from scratch)
```

Now I need to mount the container's file system so that I can install the buildah package and dependencies.

```
# scratchmnt=$(buildah mount $containerid)
```

Next I install the buildah package and dependencies into the containers filesystem. Notice that as I'm doing this from a Fedora laptop I'm defaulting to the Fedora repositories and I'm specifying the version, 27. Also, I clean up afterward so that we can reduce the image size. If you skip the `dnf clean` step you'll have extra bloat.

```
# dnf install --installroot $scratchmnt --release 27 buildah --setopt install_weak_deps=false -y
# dnf clean all --installroot $scratchmnt --release 27
```

Now we need to set the container ENTRYPOINT and CMD. It's good practice to use ENTRYPOINT for the command that you want to run. When containerizing a command line tool, I usually set CMD to `--help` so that it gets appended to the ENTRYPOINT if you don't specify any parameters. I got into the practice after reading Michael Crosby’s [Best Practices](http://crosbymichael.com/dockerfile-best-practices.html) post. See section 5. 

 (Currently Buildah needs ‘\’ for parameters with ‘--’. That will get fixed.)

```
# buildah config --cmd "\-\-help" $containerid
# buildah config --entrypoint /usr/bin/buildah $containerid
```

It’s also good practice, and pretty important, to set some other metadata like the image name and who created it etc.

```
# buildah config --author "wgh @ redhat.com" --created-by "ipbabble" --label name=buildah $containerid
```

Finally I need to commit the container to an image. It should be called `buildah` because it is good practice to name a command line tool container the name of the command. That way, if its ENTRYPOINT is set correctly, you can run it similar to the command it is containerizing. The following command ran a little over a minute and currently has no status output. So be patient.

```
# buildah commit $containerid buildah
```

A bonus step is to push it to a registry so that other people can use it. I used the Podman client to do that. Below I push to the [Quay.io](https://quay.io) public registry. In order to do that you need to create an account. Click on the “Create Account” link on the [sign in page](https://quay.io/signin/). Push to Quay just like Docker. (Quay supports OCI version 1.0 or above). You can install Podman (a daemon-less alternative to Docker) using DNF and then use it to authenticate with and then push the image to quay.io.

```
# dnf -y install podman
# podman login quay.io
Username: ipbabble
Password:
Login Succeeded!
# podman push buildah quay.io/ipbabble/buildah
```

## Running the Buildah container using Podman

To test it you can also use the Podman client. That way you don't have to install Docker and the "big fat daemon". In order to do this there are a number of parameters required. Of course the purpose of this exercise to build a Buildah container for use with Kubernetes. So this will be run by runC through CRI-O and not Podman.

* For the main use case you need to run Podman as a privileged container. This will change in the future, but for right now building a container image requires access to the underlying `/var/lib/containers` directory so the the image is persisted and can be shared with others on the host. But for this case we'll make use of the `--privileged` parameter in `podman run`. It doesn’t require `/var/lib/containers` for building, just for sharing. You could bind mount another directory that doesn’t need privileges. See more about that below in “The case for no privilege”. There are some considerations.
* You probably need network access if you are going to run something like `buildah bud`. You don't need this if you are just running `buildah images/containers` etc. But many use cases will be using `bud` and so I've just used the hosts network and now the bridge because it's a short running build process. So for the example I'll use the `--network host` parameter for `podman run`.
* You'll need to bind mount an area of the file system, so that `buildah bud` can build up and then commit the image to the host file system. This can be `/var/lib/containers` if you like, so as it’s immediately shared shared on the host, or it can be some build sandbox area etc. You also need to bind mount the Dockerfile path so that Buildah can see the Dockerfile. So for the example I’ll use the bind mount parameter `-v` or `--volume` parameter for `podman run`.

Use your favorite Nginx Dockerfile or the one below. 

```
# Base on the Fedora
FROM fedora:latest
MAINTAINER http://fedoraproject.org/wiki/Cloud

RUN dnf -y update && dnf clean all
RUN dnf -y install nginx && dnf clean all
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN echo "nginx on Fedora" > /usr/share/nginx/html/index.html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/nginx" ]
```

The following command builds an Nginx container image called ‘nginx’. Obviously using Podman (or Docker) is overkill because they both have build capabilities. Ideally this container would be run in a pod on kubernetes through CRI-O. My Dockerfile is in my `/home/whenry/dfs` directory (shorter for dockerfiles). So I bind mount that directory to `/tmp` inside the container. Inside it’s `/tmp/Dockerfile`.

```
# podman run --privileged --network host -v /var/lib/containers:/var/lib/containers:rw  -v /home/whenry/dfs:/tmp:Z buildah bud -f /tmp/Dockerfile -t nginx 
```

Currently, due to OverlayFS requiring root privileges, this container must run in privileged mode. This requirement should be deprecated when Fedora’s OverlayFS does not require a privileged user.

## Current issues with non privileged mode

There is a requirement in large clusters for buildah not to run in privileged mode. There are ways to mitigate this but there will be cases where people demand it.

I had prepared an example of how to do this but I will keep it for a later blog.  Here are some of the current constraints I encountered trying to solve the non-privileged problem.

* If you want to share the builds immediately through the hosts `/var/lib/containers` then you need to run Buildah as privileged. You could build somewhere else and then move the images to `/var/lib/containers` - see below. 
* If you don't care to share on the host immediately then you can use unprivileged (don’t use --privileged) but you need to use a different directory than /var/lib/containers. However currently OverlayFS requires privileged mode on Fedora/RHEL. This should be fixed soon. You could use `--storage-driver=vfs`.
* If you decide to build inside the container you can do that with unprivileged, but you hit the overlay on overlay issue and will then need to run with `--storage-driver vfs`. This worked at one point but I’ve seen a regression. I am investigating.

Watch for a progress upstream and for a new blog post on using Buildah unprivileged in a later blog. 

## Final thanks and some helpful links

Feel free to pull the Buildah image  ipbabble/buildah from Quay.io. Have fun. Thanks to [@nalind](https://github.com/nalind), [@tsweeney](https://github.com/nalind) (so many great edits) , [@fatherlinux](https://github.com/fatherlinux),  [@bbaude](https://twitter.com/bbaude), [@rhatdan](https://github.com/rhatdan), [@rossturk](https://twitter.com/rossturk), and [@bparees](https://github.com/bparees) (confirming the kubernetes use case) for all the input along the way. 

If you have any suggestions or issues please post them at the [Project Atomic Buildah Issues](https://github.com/projectatomic/buildah/issues) page. For more information on Buildah and how you might contribute please visit the [Buildah home page](https://github.com/projectatomic/buildah) on Github including [tutorials](https://github.com/projectatomic/buildah/blob/master/docs/tutorials/README.md).  For more information on the buildah system container see [here](https://github.com/projectatomic/atomic-system-containers/buildah-fedora/config.json.template). My previous blogs on Buildah: [Intro to Buildah](http://www.projectatomic.io/blog/2017/11/getting-started-with-buildah/), [Using Buildah with registries](http://www.projectatomic.io/blog/2018/01/using-image-registries-with-buildah/). Information on Podman can be found [here](https://github.com/projectatomic/libpod).  Podman man pages [here](https://github.com/projectatomic/libpod/tree/master/docs). 
