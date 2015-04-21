---
title: Using Environment Substitution with the Atomic Command
author: dwalsh
date: 2015-04-22 11:00:00 UTC
tags: Atomic, CLI, Docker, Bash
published: false
comments: true
---

I recently published a [post on the Red Hat Developer Blog](http://developerblog.redhat.com/2015/04/21/introducing-the-atomic-command) about the Atomic command that we've been working on for the last few months. 

The [Atomic](http://www.projectatomic.io/docs/usr-bin-atomic/) command (/usr/bin/atomic) is a high-level, coherent entrypoint for Atomic Host systems, and aims to fill in the gaps in Linux container implementations. 

One of the first questions I received was about environment substitution. The user wanted to have standard Bash substitutions working with /usr/bin/atomic. Specifically, he wanted to allow substitutions like `$PWD/.foobar` and `--user=$(id -u)`.

I decided to try this out by creating a simple Dockerfile.

```
from rhel7
LABEL RUN echo $PWD/.foobar --user=$(id -u)
```
Then I build the container

```
docker build -t test .
```
Then, I'll execute atomic run test

```
atomic run test
echo 
```
Looking at the label using `docker inspect`, I see that building the container dropped the $() content.

So, I'll change the Dockerfile to quote it.

 ```
from rhel7
LABEL RUN echo '$PWD/.foobar' '--user=$(id -u)'
```
Build the container

```
docker build -t test .
```
Let's run it again:

```
atomic run test
echo $PWD/.foobar --user=$(id -u)
/root/test1/.foobar --user=0
```
## Success

Woohoo, it works! If you want to take advantage of environment variables in your `LABEL RUN` statements, make sure to quote them so they're passed through appropriately.

Have more questions about the `atomic` command? Leave a comment here, or ask on the [atomic@projectatomic.io](https://lists.projectatomic.io/mailman/listinfo/atomic).