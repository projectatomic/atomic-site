---
title: Practical SELinux and Containers
author: dwalsh
date: 2016-03-04 02:20:31 UTC
tags: selinux, security, containers, docker
comments: true
published: true
---

I believe SELinux is the best security measure we currently have for controlling access between standard Docker containers. Of course, I might be biased.  

All of the security separation measures are nice, and should be enabled for security in depth, but SELinux policy prevents a lot of break out situations where the other security mechanisms fail. With SELinux on Docker, we write policy that says that the container process running as `svirt_lxc_net_t` can only read/write `svirt_sandbox_file_t` by default (there are some booleans to allow it to write to network shared storage, if required, like for NFS). This means that if a process from a Docker container broke out of the container, it would only be able to write to files/directories labeled `svirt_sandbox_file_t`. We take advantage of Multi-Category Security (MCS) separation to ensure that the processes running in the container can only write to `svirt_sandbox_file_t` files with the same MCS Label: `s0`.

READMORE

The problem with SELinux and Docker comes up when you are volume mounting content into a container.  

## It Depends on the Use Case  

There are multiple ways to run containers with an SELinux-enforced system when sharing content inside of the container.

The SELinux policy for `svirt_lxc_net_t` also enables the processes to read/execute most of the labels under /usr. This means if you wanted to volume mount an executable from /usr into a container, SELinux would probably allow the processes to execute the commands. If you want to share the same directory with multiple containers such that the containers can read/execute the content you could label the content as `usr_t`.

```
docker run -v /opt:/opt rhel7 ...
```

If you are sharing parts of the Host OS that can not be relabeled, you can always disable SELinux separation in the container.

```
docker run --security-opt label:disable rhel7 ...
```

This means that you can continue to run your system with SELinux enforcing and even run most of your containers locked down, but for this one particular container, it will run an unconfined type. (We use the spc_t type for this.)  As I [wrote in a blog on Super Privileged Containers (SPC)](http://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/) a while back, these are containers that you don't want to isolate from the system.

Docker has the ability to automatically relabel content on the disk when doing volume mounts, by appending a `:z` or `:Z` on to the mount point.

If you want to take a random directory from say /var/foobar and share it with multiple containers such that the containers can write to these volumes, you just need to add the `:z` to the end of the volume mount.

```
docker run -v /var/foobar:/var/foobar:z rhel7 ...
```

If you want to take a random directory from say /var/foobar and have it private to the container such that only that container can write to the volume, you just need to add the `:Z` to the end of the volume mount.

```
docker run -v /var/foobar:/var/foobar:Z rhel7 ...
```

You should be careful when doing this, since the tool will basically the following:

```
chcon -R -t svirt_sandbox_file_t /SOURCEDIR
```

This could cause breakage on your system. Make sure the directory is only to be used with containers. The following is probably a *bad* idea.

```
docker run -v /var:/var:Z rhel7
```

Using these few easy commands makes SELinux and containers work well together and give you the best security separation possible for default containers.
