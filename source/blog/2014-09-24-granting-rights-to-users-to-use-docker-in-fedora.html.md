---
author: dwalsh
comments: true
layout: post
title: Granting Rights to Users to Use Docker in Fedora
date: 2014-09-24 14:47 UTC
tags:
- Docker
- Fedora
categories:
- Blog
---
I saw on the docker-dev list someone was asking about Fedora documentation that described how you add a user to the `docker` group. The user wanted to allow his users to do `docker search` to try to find images that they could use.

From the [Docker installation documentation regarding Fedora](http://docs.docker.com/installation/fedora/): 

> Granting rights to users to use Docker

> Fedora 19 and 20 shipped with Docker 0.11. The package has already been updated to 1.0 in Fedora 20. If you are still using the 0.11 version you will need to grant rights to users of Docker.

> The `docker` command line tool contacts the `docker` daemon process via a socket file `/var/run/docker.sock` owned by group `docker`. One must be member of that group in order to contact the `docker -d` process.

Luckily this documentation is somewhat wrong, you still need to add users to the `docker` group in order for them to use `docker` from a non-root account.  I would hope that all Distributions have this policy.

READMORE

On Fedora and RHEL we have the following permissions on the `docker.sock`:

```
# ls -l /run/docker.sock 
srw-rw----. 1 root docker 0 Sep 19 12:54 /run/docker.sock
```

This means that only the root user or the users in the `docker` group can talk to this socket.  Also since `docker` runs as`docker_t` SELinux prevents all confined domains from connecting to this `docker.sock`.

## No Authorization controls from docker.

Docker currently does not have any Authorization controls. If you can talk to the `docker` socket or if `docker` is listening on a network port and you can talk to it, you are allowed to execute all `docker` commands.

For example, if I add dwalsh to the `docker` group on my machine, I can execute.

```
> docker run -ti --rm --privileged --net=host -v /:/host fedora /bin/sh
# chroot /host
# 
```

At which point you, or any user that has these permissions, have total control on your system. 

Adding a user to the docker group should be considered the same as adding:

```
USERNAME	ALL=(ALL)	NOPASSWD: ALL
```

to the /etc/sudoers file. Any application the user runs on his machine can become root, even without him knowing. I believe a better more secure solution would be to write scripts to allow the user the access you want to allow.

```
cat /usr/bin/dockersearch
#!/bin/sh
docker search $@
``` 

Then set up sudo with

```
USERNAME	ALL=(ALL)	NOPASSWD: /usr/bin/dockersearch
```

I hope to eventually add some kind of authorization database to `docker` to allow admins to configure which commands you would allow a user to execute, and which containers you might allow them to start/stop.

First eliminating the ability to execute `docker run --privileged` or `docker run --cap-remove` would be a step in the right direction. But, if you have read my other posts, you know that a lot more needs to be done to make [containers contain](http://www.projectatomic.io/blog/2014/09/keeping-up-with-docker-security/).
