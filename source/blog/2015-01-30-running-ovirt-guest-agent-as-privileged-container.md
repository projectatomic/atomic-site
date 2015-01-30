---
title: Running oVirt's Guest Agent on Atomic as a Privileged Container
author: jbrooks
date: 2015-01-30 18:00:00 UTC
tags:
- docker
- ovirt
- centos
categories:
- Blog
published: true
comments: true
---

Atomic hosts are meant to be as slim as possible, with a bare minimum of applications and services built-in, and everything else running in containers. However, what counts as your bare minimum is sure to differ from mine, particularly when we're running our Atomic hosts in different environments.

For instance, I'm frequently testing and using Atomic hosts on my [oVirt](http://www.ovirt.org) installation, where it's handy to have oVirt's [guest agent](http://www.ovirt.org/Ovirt_guest_agent) running, which provides handy information about what's going on inside of an oVirt-hosted VM. If you aren't using oVirt, though, there's no reason to carry this package around in what's supposed to be a svelte image.

I could [build my own](http://www.projectatomic.io/blog/2014/11/build-your-own-atomic-updates/) Atomic host, and include the `ovirt-guest-agent-common` package, but I'd rather stick with upstream. Containerization is the solution for running extra software on Atomic, but since the guest agent needs to see and interact with the host itself, we need an Containers Unbound sort of approach. Fortunately, Dan Walsh has blogged about this very issue, in a post about the [Super Privileged Container](http://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/) concept:

> "I define an SPC as a container that runs with security turned off (--privileged) and turns off one or more of the namespaces or 'volume mounts in' parts of the host OS into the container. This means it is exposed to more of the Host OS."

### Building the guest agent container

I started with a Dockerfile defining my ovirt-guest-agent container:

````
FROM centos:centos7
MAINTAINER Jason Brooks <jbrooks@redhat.com>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install ovirt-guest-agent-common; yum clean all

CMD /usr/bin/python /usr/share/ovirt-guest-agent/ovirt-guest-agent.py
````

For the `CMD` line, I took the command that you'll find running on a VM with guest agent active. I also tested with a longer `CMD`, in which I strung together all of the commands you find in the systemd service file for the guest agent, including the PreExec commands:

````
CMD /sbin/modprobe virtio_console; \
/bin/touch /run/ovirt-guest-agent.pid; \
/bin/chown ovirtagent:ovirtagent /run/ovirt-guest-agent.pid; \
/usr/bin/python /usr/share/ovirt-guest-agent/ovirt-guest-agent.py
````

Both `CMD` lines seemed to work in my tests, but this could stand some more testing.

### Running the guest agent container

Dan's post includes a variety of examples of host resources that a super privileged container may need to access, and the `docker run` arguments required to enable them. After experimenting with different run commands, the simplest set of arguments required appeared to be:

````
sudo docker run --privileged -dt --name ovirt-agent \
--net=host -v /dev:/dev $USER/ovirt-guest
````

### Setting the container to auto-start

I wanted the ovirt-agent container to start up following a reboot, so I followed the advice of the [docker docs]() and made myself a systemd service file to handle the job:

````
[Unit]
Description=ovirt guest agent container
Author=Me
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker start -a ovirt-agent
ExecStop=/usr/bin/docker stop -t 2 ovirt-agent

[Install]
WantedBy=multi-user.target
````

I saved this file at `/etc/systemd/system/ovirt-agent.service` and ran `sudo systemctl enable ovirt-agent` to direct systemd to start it up following a reboot.

### TODO

With the container built, running, and set to auto-start as I described above, the ovirt guest agent seems to work as expected. There's one more, *temporary*, item to consider: the dread `setenforce 0`.

I found that once my ovirt-guest container was running, I was unable to ssh to my VM. Login attempts triggered the error `PTY allocation request failed on channel 0`, and I haven't yet figured a way around this error, other than by putting SELinux into permissive mode in the config file `/etc/selinux/config`. When I get this bit figured out, I'll update my post.

### Till next time

If you have questions (or better yet, suggestions) regarding this post, I’d love to hear them. Ping me at jbrooks in #atomic on freenode irc or [@jasonbrooks](https://twitter.com/jasonbrooks) on Twitter, or send a message to the [Project Atomic mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel). Also, be sure to check out the [Project Atomic Q&A site](http://ask.projectatomic.io/en/questions/).
