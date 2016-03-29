---
title: How I Wrote exec Support for docker-compose
author: ttomecek
date: 2016-03-29 00:00:00 UTC
tags: docker, docker-compose, patches, orchestration
published: true
comments: true
---

If you are a `docker-compose` user, as I am, you may be missing one feature:
`exec`&mdash;spawning arbitrary commands in already running containers.

READMORE

Instead of doing this:

```
$ docker exec -ti $container bash
```

you should be able do the same with `docker-compose` itself:

```
$ docker-compose exec web bash
```

Usually when you wanted to do such thing, you had to:

1. Type `docker exec -ti`
2. Now, the container name
3. `^c`
4. `docker ps`, I forgot to name my container again!
5. `ba3f7099b709`, ugh
6. `docker exec -ti`, once again, copy-paste that ID, write `bash` and 30 seconds later:

```
[root@ba3f7099b709 /] # █
```

That workflow isn't very ideal. So I realized I wanted to implement the feature (especially when there already was [an
issue open](https://github.com/docker/compose/issues/593), with tons of `+1` and not even a single promise of someone working on it).

## Easy Start

In September, I cloned `compose` and started working on the code. I managed to have a working prototype very soon:

```
$ docker-compose exec web ls
bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

## Time to Go Interactive

That's when all the fun started.

Running simple, non-interactive commands is pretty trivial. Just [create an exec
object](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.22/#exec-create) via engine's API,
[start](https://docs.docker.com/engine/reference/api/docker_remote_api_v1.22/#exec-start) it, and collect results. Easy.

When you want an interactive session, it's getting a bit more complex than a simple request/response over HTTP. That's when
[dockerpty](https://github.com/d11wtq/dockerpty) comes into the play. It is able to *attach* to the process via engine's
API, send input, receive output and display it. Brief code-browsing revealed there's tons of work ahead:

* I had to [rewrite](https://github.com/d11wtq/dockerpty/pull/48/commits/df6ac1a49b99803c95233e51d0cd9b8f6aba9240) big part of existing codebase.
* I had to change existing API and add a new one.
* Cherry on top: the tests didn't work and I had to [fix](https://github.com/d11wtq/dockerpty/pull/53/commits/555b525f49026271c9a291f014c3b7025b183d4a) those.

Even `dockerpty` didn't have all the bits to write proper `exec` support for interactive commands. I had to go deeper:
improve python's API client&mdash;`docker-py`. Luckily that [patch](https://github.com/docker/docker-py/pull/858) was pretty
easy: just return socket directly, not a generator.

[The patch](https://github.com/d11wtq/dockerpty/pull/48) for `dockerpty` turned out to be super-complex. In the end, it took me more than 5 months to get the former `compose` patch merged.

Enjoy `docker-compose exec` once 1.7 is out! Happy `exec`ing!
