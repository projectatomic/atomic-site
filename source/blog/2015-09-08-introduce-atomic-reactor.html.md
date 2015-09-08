---
title: Introducing Atomic Reactor
author: ttomecek
date: 2015-09-08 12:00:00 UTC
tags: fedora, atomic, docker, build
comments: true
published: true
---

It's been a while when we [announced](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2015-July/msg00010.html) move of [atomic-reactor](https://github.com/projectatomic/atomic-reactor) under Project Atomic.

Since the name is so cryptic, one could wonder about the purpose of the tool. Let's go through a simple example...


## What problem is atomic-reactor trying to solve?

Imagine Bob, a software engineer who would like to ship company's products as containers. Bob's company has already pretty complex infrastructure with build system, source code management, product deployment and delivery.

So Bob starts the work on integrating docker into company's infrastructure.

Bob knows it's so easy to build a docker image:

```shell
$ docker build --tag=product-X .
```

READMORE

Bob thinks he needs a Dockerfile...

```shell
$ git clone https://example.com/git/dockerfile-product-x.git && cd dockerfile-product-x && docker build --tag=product-X .
```

That's not enough, artifacts are stored elsewhere.

```shell
$ git clone https://example.com/git/dockerfile-product-x.git && \
    cd dockerfile-product-x && \
    wget https://example.com/data/product-x.tar.gz && \
    docker build --tag=product-X .
```

We need to apply multiple tags, not just one.

```shell
$ git clone https://example.com/git/dockerfile-product-x.git && \
    cd dockerfile-product-x && \
    wget https://example.com/data/product-x.tar.gz && \
    docker build --tag=product-X . && \
    docker tag product-X product-X:v1 && \
    docker tag product-X product-X:v1.1
```

And push it of course...

```shell
$ git clone https://example.com/git/dockerfile-product-x.git && \
    cd dockerfile-product-x && \
    wget https://example.com/data/product-x.tar.gz && \
    docker build --tag=registry.example.com/product-X . && \
    docker tag product-X registry.example.com/product-X:v1 && \
    docker tag product-X registry.example.com/product-X:v1.1
    docker push registry.example.com/product-X && \
    docker push registry.example.com/product-X:v1 && \
    docker push registry.example.com/product-X:v1.1
```

...and apply custom labels before build, have persistent build logs, garbage-collect build artifacts, squash layers, manage yum repositories during build...

We were in Bob's position and this is where we realized that simple script won't be enough and we need to develop a tool.

So we developed atomic-reactor. A tool, which takes care of whole build process of creating a docker image. We knew we need plugins in it.

## Plugins

The major feature of atomic-reactor is its plugin system. At the moment we have 4 types of plugins:

 1. Plugins which are run before build (these are good for changing dockerfiles and managing base images).
 2. Essential part of build process is to push the image to registry. Another place where reactor runs plugins (e.g. testing whether the image passed tests). These are called pre-publish plugins.
 3. Since we have pre-build plugins, we also need to have post-build plugins.
 4. And finally, exit plugins. These are run no matter what. Good for storing logs and cleaning environment.

### What can it do with those plugins then?

 * Pull base image from custom registry.
 * Use [koji](https://fedoraproject.org/wiki/Koji) tag as a source yum repository.
 * Add custom labels to dockerfile prior to build.
 * Add new yum repositories which will be available during build.
 * Squash layers of the image.
 * Tag image according to `Name`, `Version` and `Release` labels as specified in [this document](https://github.com/projectatomic/ContainerApplicationGenericLabels).
 * Push image to [pulp](http://www.pulpproject.org/) registry.
 * Do additional tagging and pushing of the image to custom registries.
 * List all installed packages in the image.
 * Remove images after build — clean environment.
 * It is able to get input from [OpenShift v3](https://github.com/openshift/origin) using [custom build](https://docs.openshift.org/latest/creating_images/custom.html) and after build, stores metadata as [annotations](http://kubernetes.io/v1.0/docs/user-guide/annotations.html) of build object.

Do you miss some? [Just let us know!](https://github.com/projectatomic/atomic-reactor/issues/new)


## Isolated Builds

There are 3 ways you can build your images:

1. Have atomic-reactor installed in a docker image, start new instance of docker (docker in docker) and build your image inside such container.
2. Similar, except you mount docker socket inside container and thus use docker engine from host.
3. Build image in current environment.


## Hands On

Enough theory, time to give it a go! Let's install atomic-reactor first. It is packaged in Fedora, therefore installation is very simple.

```shell
$ dnf install atomic-reactor
```

Let's say we have a remote git repository with a dockerfile on branch `atomic-reactor-demo` and we want to build it and squash all layers from the dockerfile to a single one. Fair request.

We'll write a [build.json](https://github.com/projectatomic/atomic-reactor/blob/master/docs/build_json.md), a recipe for the build:

```
$ cat build.json
{
    "image": "ttomecek/hello-world",
    "source": {
        "provider": "git",
        "uri": "https://github.com/TomasTomecek/docker-hello-world.git",
        "provider_params": {
            "git_commit": "atomic-reactor-demo"
        }
    },
    "prepublish_plugins": [
        {
            "name": "squash"
        }
    ]
}
```

We are building image `ttomecek/hello-world` from git and are using just one plugin: [squash](https://github.com/projectatomic/atomic-reactor/blob/master/atomic_reactor/plugins/prepub_squash.py) (the plugin uses [python-docker-scripts](https://github.com/goldmann/docker-scripts) written by Marek Goldmann). This is the dockerfile:

```dockerfile
FROM fedora:latest
LABEL purpose="atomic reactor demo"
ENV x=y
RUN uname -a && env
```

So let's run it:

```shell
$ atomic-reactor build json --method here build.json
```

Method `here` builds image in current environment, not in container.

As you might see, the output is really verbose so you know precisely what's going on. After the build is done, let's check our image:

```shell
$ docker history ttomecek/hello-world
IMAGE               CREATED             CREATED BY          SIZE                COMMENT
da1a64eb6660        23 seconds ago                          241.3 MB
511136ea3c5a        2 years ago                             0 B                 Imported from -

$ docker inspect ttomecek/hello-world
...
    "Config": {
        "Env": [
            "x=y"
        ],
        "Labels": {
            "purpose": "atomic reactor demo"
...
```

Our dockerfile has 4 instructions and the image has only 2 layers. It worked!


Since atomic-reactor is written in python, you can call [python api](https://github.com/projectatomic/atomic-reactor/blob/master/docs/api.md) directly:

```python
In [1]: from atomic_reactor import api

In [2]: params=json.load(open("build.json"))

In [3]: api.build_image_here(**params)
```


This is the basic introduction of atomic-reactor. We'll be happy for any feedback. You can reach us at [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) or via [GitHub](https://github.com/projectatomic/atomic-reactor).
