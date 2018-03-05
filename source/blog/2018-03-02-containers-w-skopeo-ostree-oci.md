---
title: How does Atomic run system containers without Docker Daemon?
author: alsadi
date: 2018-03-05 00:00:00 UTC
published: true
comments: false
tags:
- oci
- containers
- docker
- ostree
- skopeo
---

# How does Atomic run system containers without Docker Daemon?

## Introduction

In 2016, we started to [Containerize the Kubernetes stack](https://www.projectatomic.io/blog/2016/09/running-kubernetes-in-containers-on-atomic/),
that is to ship all the components as containers as you can see [here](https://registry.fedoraproject.org/).
But some of those containers like [etcd](https://coreos.com/etcd/) and [flanneld](https://coreos.com/flannel/docs/latest/)
must be started before Docker daemon because `etcd` is the cluster state store,
and `flanneld` is the cluster network overlay (SDN).

In this blog post we are going to demonstrate how to use the same components used by
[Project Atomic](http://www.projectatomic.io/)
in the so called [system containers](https://www.projectatomic.io/blog/2016/09/intro-to-system-containers/)
that is to run the containers without a Docker daemon, namely:
[skopeo](https://github.com/projectatomic/skopeo),
[ostree](https://github.com/ostreedev/ostree), and an OCI runtime like
[runc](https://github.com/opencontainers/runc)
or [bubble wraps](https://github.com/projectatomic/bubblewrap) and its [OCI wrapper](https://github.com/projectatomic/bwrap-oci).

READMORE

## Background

`Atomic Host` is an immutable stateless operating system,
that is designed to consume applications via containers.
You can do carefree updates or even switch from `CentOS` to `Fedora` and vice versa
because of the image-like nature of `ostree` and it's carefree because your workloads are in the containers.
It has many use cases like running `Kubernetes` clusters,
and there is an ongoing effort to extend it to desktop
(using [Flatpak](https://flatpak.org/) as the containers for the desktop, which also uses ostree). This desktop variant is called [Atomic Workstation](https://www.projectatomic.io/blog/2018/02/fedora-atomic-workstation/)

In the containerized Kubernetes stack, there seems to be "the chicken or the egg" dilemma,
We need a running `flanneld` or `etcd` to start Docker Daemon,
and you need a running docker daemon to start flanneld or etcd if they are shipped as containers.

In this blog post, we are going to demonstrate how to pull docker container images
and run them the same way as the [Atomic tool](https://github.com/projectatomic/atomic) does.

If you inspected the `flannel` container image (either using `docker inspect` or remotely with `skopeo inspect`)
you would see that it has a label called `atomic.type` indicating it is a system container.

```
$ skopeo inspect docker://registry.fedoraproject.org/f27/flannel
{
    "Name": "registry.fedoraproject.org/f27/flannel",
    "Labels": {
        "atomic.type": "system",
// ...
```

Either that or by passing `--system` after `atomic install`,
those are special containers that are executed without Docker daemon,
those containers have [a special directory structure](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/)
like their `systemd` service template as you can see in the source of [Fedora's flannel container source](https://src.fedoraproject.org/container/flannel/blob/master/f/Dockerfile#_23).

The steps in this article are inspired by [how atomic tool work under the hood](https://github.com/projectatomic/atomic/blob/v1.22/Atomic/syscontainers.py).

You can follow those steps on atomic host or in your regular OS (I've tested them on regular Fedora Workstation),
and you don't need to be root.

## OSTree - a space-efficient way to store images locally

OSTree is the same technology used by Atomic host to store its own host OS images.
It's a content-addressable object storage to store files,
which means a file is stored once even if it's in multiple images,
this is even more efficient than layer-based Docker's storage backends, because it's not on layer level, but on file level.

Let's start by creating a directory and initializing it to contain bare OSTree repo,
but because we are running as non-root we need to pass `--mode=bare-user` instead of `--mode=bare`

```
$ mkdir ostree
$ cd ostree
$ ostree init --mode=bare-user --repo=$PWD
```

## Skopeo - for dealing with container Images and Image registries

Skopeo can inspect remote container images from various registries and formats,
pull them, and store them in many kinds of ways. 
We are going to demonstrate how to pull small images and run them,
so for this purpose let's choose some small few megabytes images like `docker://redis:alpine`.

```
$ skopeo copy docker://redis:alpine ostree:redis@$PWD
$ skopeo copy docker://nginx:alpine ostree:nginx@$PWD
$ skopeo copy docker://busybox:alpine ostree:busybox@$PWD
```

You can list images in OSTree using:

```
$ ostree refs
```

The interesting part of the output looks like:

```
ociimage/redis_3Alatest
ociimage/nginx_3Alatest
ociimage/busybox_3Alatest
```

The Atomic command like tool is written in python, and it uses `libostree` via `gobject-introspection`, it looks like [this](https://github.com/projectatomic/atomic/blob/v1.22/Atomic/syscontainers.py#L26).

```
import gi
gi.require_version('OSTree', '1.0')
from gi.repository import OSTree
```

For our article we are going to use `ostree` command line interface:

```
$ ostree ls ociimage/redis_3Alatest 
d00755 1000 1000      0 /
-00644 1000 1000   1568 /manifest.json
$ ostree cat ociimage/redis_3Alatest /manifest.json
{
// ...
   "config": {
      "mediaType": "application/vnd.docker.container.image.v1+json",
      "size": 4791,
      "digest": "sha256:d3117424aaee14ab2b0edb68d3e3dcc1785b2e243b06bd6322f299284c640465"
   },
// ...
   "layers": [
      {
         "mediaType": "application/vnd.docker.image.rootfs.diff.tar.gzip",
         "size": 2065537,
         "digest": "sha256:ff3a5c916c92643ff77519ffa742d3ec61b7f591b6b7504599d95a4a41134e28"
      },
      //  ..
    ]
}
```

We are going to use `jq` tool to get the specific parts from this JSON like getting the config digest:

```
$ config_hash=`ostree cat ociimage/redis_3Alatest /manifest.json | jq -r .config.digest | cut -d ':' -f 2`
$ ostree cat ociimage/$config_hash /content | jq 
{
// ...
}
$ ostree cat ociimage/$config_hash /content | jq .config.Entrypoint
["docker-entrypoint.sh"]
$ ostree cat ociimage/$config_hash /content | jq .config.Cmd
["redis-server"]
$ ostree cat ociimage/$config_hash /content | jq .config.ExposedPorts
{"6379/tcp": {}}
$ ostree cat ociimage/$config_hash /content | jq .config.Volumes
{"/data": {}}
$ ostree cat ociimage/$config_hash /content | jq .config.WorkingDir
"/data"
```

Let's create a directory for our container and apply layers one by one inside that directory,
using `ostree checkout`.

```
$ mkdir -p cont1/rootfs
$ ostree checkout --union ociimage/redis_3Alatest cont1
$ cat cont1/manifest.json | jq -r '.layers[]|.digest' | cut -d ':' -f 2 |
  while read a
  do
    ostree checkout --union ociimage/$a cont1/rootfs;
  done
```

We can reverse the order of layers (using `tac`) and use `--union-add` instead of `--union`.

## Running the container using OCI runtimes

### Runc

Now we have checked out the redis root filesystem in `cont1/rootfs`,
and that does not take space because they are merely [hard links](https://en.wikipedia.org/wiki/Hard_link)
to those in our ostree repo. Before we run it, let's generate [OCI `config.json`](https://github.com/opencontainers/runtime-spec/blob/master/config.md) using `runc spec`:

```
$ cd cont1
$ mkdir data
$ runc spec --rootless
```

We have added `--rootless` because we are not running as root, by default it's configured to run `/bin/sh`.

```
{
"process": {
  "terminal": true,
  "args": [
    "sh"
  ],
  // ...
}
```

You can edit the file `config.json`, for example you can:

- adjust `args`: to be the command to be executed, for example `"args": [ "redis-server" ]`
- adjust `env`: to pass custom environment variables
- adjust `cwd`: to set current working directory (in our example,  it could be `/data`)
- adjust `mounts`: to add tmpfs on "/tmp" and "/var/run" or even "/var", or even bind mount data volumes
- adjust `namespaces`: to add `{"type": "network"}` to make a separated network stack otherwise it would use host networking
- you can adjust mapping between users `"linux": { "uidMappings": [ ... ] }` typically containers root is the current user

Atomic system containers can ship a template for config.json as in [flannel's config.json.template](https://src.fedoraproject.org/container/flannel/blob/master/f/config.json.template).

Here is how you can attach a writable directory for `/data` (which is `cont1/data` we have created before):

```
{
// ...
	"mounts": [
		{
			"destination": "/data",
			"type": "bind",
			"source": "data",
			"options": ["rbind","rw"]
		},
    // ...
    ]
// ...
}
```

To run the container type `runc run` followed by any name like `redis`.

```
$ runc run redis 
1:C 03 Mar 16:13:06.463 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 03 Mar 16:13:06.474 # Redis version=4.0.8, bits=64, commit=00000000, modified=0, pid=1, just started
...                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 4.0.8 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

```

In another terminal you can have a shell inside the container using `runc exec redis /bin/sh`:

```
$ runc exec redis /bin/sh
/data # ps -a
PID   USER     TIME   COMMAND
    1 root       0:00 redis-server
   18 root       0:00 /bin/sh
   24 root       0:00 ps -a
/data # 
```

### Bubble Wraps OCI

`bwrap-oci` is another OCI runtime that is designed for userspace containers (non-root)
You can use the same `config.json` we made in previous section.
There was [a bug](https://github.com/projectatomic/bwrap-oci/pull/17) in `bwrap-oci`,
that's why you need to build it from source.

```
$ bwrap-oci run redis
```

You can list running Bubble wrapped containers using `bwrap-oci list`

```
$ bwrap-oci list
NAME                          PID       STATUS    BUNDLE
redis                         23369     running   /home/alsadi/ostree/cont1
```

Unfortunately there is no `bwrap-oci exec`.

## Atomic Options

Atomic Install has corresponding options to the choices we have demonstrated in this article like:

- `--storage=ostree|docker` whether to use `docker` or `ostree` to store the image
- `--runtime=/bin/bwrap-oci` for user containers or when `--user` is passed
- `--runtime=/bin/runc` for system containers or when `--system` is passed

For more details type `man atomic install`.
