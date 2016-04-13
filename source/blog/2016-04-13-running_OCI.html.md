---
title: Getting Started with OCI
author: mrunalp
date: 2016-04-13 13:20:00 UTC
tags: runc, OCI, Fedora
published: true
comments: true
---

This post will walk you through the steps to running a runc container using the [OCI](https://github.com/opencontainers/runtime-spec/) configuration.

We will walk through two examples. One for running a Fedora container and another for running a Redis container.

READMORE

There are three steps to running a runc container:

1. Construct a rootfs
2. Create a OCI configuration
3. Start the runtime

## Getting ocitools

[OCItools](https://github.com/opencontainers/ocitools) are a bunch of utilities to work with the OCI specification. We are going to make use of the generate utility. It helps generate a OCI configuration for runc with a command line that is similar to docker run.

```
$ export GOPATH=/some/dir
$ go get github.com/opencontainers/ocitools
$ cd $GOPATH/src/github.com/opencontainers/ocitools
$ make && make install
```

  **Note:** OCItools will soon be available as a package on Fedora, RHEL, and CentOS.

## Fedora Container

There are various ways to construct a rootfs. Ultimately, it is just a directory with a bunch of files that will be visible and used inside your container. In this example, we will use dnf to construct a rootfs.

First we create a directory for our container:

```
$ mkdir /runc/containers/Fedora/rootfs
$ cd /runc/containers/Fedora
$ dnf install --installroot /runc/containers/Fedora/rootfs bash coreutils procps-ng iptools
```

Next we generate a configuration using OCItools:

```
$ ocitools generate --args bash
```

This create a config.json in the current directory. By passing `--args` we change the command to be run to `bash` from the default.

And finally, we start the container:

```
$ runc start Fedora
bash-4.3# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 18:02 ?        00:00:00 bash
root         7     1  0 18:03 ?        00:00:00 ps -ef
bash-4.3# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
bash-4.3# ls -l
total 48
lrwxrwxrwx.   1 root root    7 Feb  3 22:10 bin -> usr/bin
dr-xr-xr-x.   2 root root 4096 Feb  3 22:10 boot
drwxr-xr-x.   5 root root  360 Apr  8 18:02 dev
drwxr-xr-x.  29 root root 4096 Apr  8 17:45 etc
drwxr-xr-x.   2 root root 4096 Feb  3 22:10 home
lrwxrwxrwx.   1 root root    7 Feb  3 22:10 lib -> usr/lib
lrwxrwxrwx.   1 root root    9 Feb  3 22:10 lib64 -> usr/lib64
drwxr-xr-x.   2 root root 4096 Feb  3 22:10 media
drwxr-xr-x.   2 root root 4096 Feb  3 22:10 mnt
drwxr-xr-x.   2 root root 4096 Feb  3 22:10 opt
dr-xr-xr-x. 287 root root    0 Apr  8 18:02 proc
dr-xr-x---.   2 root root 4096 Apr  8 17:43 root
drwxr-xr-x.   5 root root 4096 Apr  8 17:45 run
lrwxrwxrwx.   1 root root    8 Feb  3 22:10 sbin -> usr/sbin
drwxr-xr-x.   2 root root 4096 Feb  3 22:10 srv
dr-xr-xr-x.  13 root root    0 Apr  7 22:19 sys
drwxrwxrwt.   2 root root 4096 Apr  8 17:45 tmp
drwxr-xr-x.  12 root root 4096 Apr  8 17:42 usr
drwxr-xr-x.  19 root root 4096 Apr  8 17:45 var
bash-4.3#
```

We can list the running containers by using `runc list` in another terminal:

```
$ runc list
ID          PID         STATUS      BUNDLE      CREATED
Fedora      7770        running     /runc       2016-04-08T18:02:12.186900248Z
```

We can exec another process in the container using `runc exec`:

```
[root@dhcp-16-129 ~]# runc exec Fedora sh
sh-4.3# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 18:02 ?        00:00:00 bash
root        10     0  0 18:04 ?        00:00:00 sh
root        16    10  0 18:04 ?        00:00:00 ps -ef
sh-4.3# exit
exit
```

## Redis Container

We'll create a rootfs using dnf just like we did for Fedora:

```
$ mkdir /runc/containers/redis/rootfs
$ cd /runc/containers/redis
$ dnf install --installroot /runc/containers/redis/rootfs redis
```

Next, we generate a configuration using OCItools:

```
$ ocitools generate --args /usr/bin/redis-server --network host
```

We customize the args to start the redis-server and set network to host, meaning that we will use the host network stack instead of creating a new network namespace for the container.

Next, we start the Redis container:

```
$ runc start redis
1:C 08 Apr 18:08:22.665 # Warning: no config file specified, using the default config. In order to specify a config file use /usr/bin/redis-server /path/to/redis.conf
1:M 08 Apr 18:08:22.669 # Server started, Redis version 3.0.6
1:M 08 Apr 18:08:22.670 * DB loaded from disk: 0.001 seconds
1:M 08 Apr 18:08:22.670 * The server is now ready to accept connections on port 6379
```

We have our redis-server up and running!

We can try to connect to it from a redis-cli by exec'ing into the container:

```
$ runc exec redis redis-cli
127.0.0.1:6379>
127.0.0.1:6379> set name mrunal
OK
127.0.0.1:6379> get name
"mrunal"
127.0.0.1:6379> quit
```

These are some simple examples to get started with OCI. OCItools generate allows configuring the config with flags.
We use the host networking stack as a convenience. In a future post, we will delve into OCI hooks that allow
setting up container networking.
