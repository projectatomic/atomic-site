---
title: Making Docker images read-only in production
author: dwalsh
date: 2015-12-16 22:06:42 UTC
tags: docker, production, operations, images, tmpfs
comments: true
published: true
---

With Docker 1.10 approaching soon, I wanted to talk about one of the useful new features coming that makes it easier to run containers in read-only mode. Using the new `--tmpfs` you can run a container as read only, but still use writeable directories for things like `/etc`, `/tmp` or `/run` but discard changes when a container is stopped.

READMORE

## Developer Mode vs Production Mode

One of the reasons Docker has taken off is because it made it easier for developers to ship and update their software. Docker has streamlined the development process and allowed developers to choose the runtime environments that their applications are going to run.  The runtime/userspace that the developer (or developers) chooses can be tested by the QE Team and the exact same runtime can be deployed in production.

Part of the development process is usually built around updating the application and the userspace. The developer team does things like `yum install` or `dnf install`, and then copies in code that is particular to the application. But, once developers hand off to the quality engineers (QE) or operations, they expect content to be treated as read-only. 

I believe that the image of a container should be put into production in a read only mode, which would prevent the application or processes within the container from writing to the container, it would only allow these processes to write to volumes mounted into the container.  

### Security

From a security point of view, this would be great.  Imagine you are running an application that gets hacked.  The first thing the hacker wants to do is to write the exploit into the application, so that the next time the application starts up, it starts up with the exploit in place.  If the image was read-only the hacker would be prevented from leaving a back door in place and be forced to start the cycle from the beginning. 

Docker added a feature to handle this via `docker run -d --read-only image ...`  a while ago. But it is difficult to use, since a lot of applications need to write to temporary directories like `/run` or `/tmp` When these are read-only the apps fail. You could set up temporary locations on your host to volume mount into the container, but this ends up exposing temporary data to the host.  

What I wanted to be able to do is mount a tmpfs into the container. I have been working on a fix for this since last May, and it was finally merged in on December 2, from [this pull request](https://github.com/docker/docker/pull/13587). It will show up in docker-1.10.

With this patch you can set up tmpfs as `/run` and `/tmp`.

````
docker run -d --read-only --tmpfs /run --tmpfs /tmp IMAGE
````

I would actually recommend all applications in production run with this mode.  You might want to continue to mount in volumes from the host for permanent data.

## Other cool stuff.

One cool thing about this patch is that it `tar`s up the contents of the underlying directory in the image on top of the tmpfs. So if you have `/run/httpd` directory in the container image, you will have `/run/httpd` in the container's tmpfs.

You can also do some other stuff with this patch like setting up a temporary `/var` or `/etc` inside of your container.

If you execute `docker run -ti --tmpfs /etc fedora /bin/sh` then docker will mount a tmpfs on `/etc`, and tar up the content of the underlying `/etc` onto the new `/etc` tmpfs.  This means you could make changes to the `/etc` but it will not survive a container stop.  The container will be fresh every time you start and stop the container.
  
You can also pass tmpfs mount options on the command line, like so:

````
docker run -ti --tmpfs /etc:rw,noexec,nosuid,size=2g container
````

Docker will pass down these mount options.

## Call to action

It would be nice in the future if developers told QE and operations to run in production with the `--read-only` docker run/create flags. Or better yet set up [atomic labels](http://developerblog.redhat.com/2015/04/21/introducing-the-atomic-command/) to do this by default. Then we can separate the way a container application runs in development from the way it runs in production.
