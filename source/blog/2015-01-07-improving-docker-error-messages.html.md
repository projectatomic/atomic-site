---
author: dwalsh
layout: post
title: Improving Docker Error Messages
date: 2015-01-07 15:13 UTC
tags:
---

It is always amazing how small things can aggravate you. One of the biggest irritants I have with `docker` is how it has handled the `--help` option.

It was sending `docker --help` and `docker COMMAND --help` to `stderr`. This caused Red Hat's Quality Engineering (QE) teams headaches since they wanted to automate testing for things like new options, or making sure the options in the man page matched those in the usage page.

QE would end up doing things like:

`docker --help 2&>1 | cat ...`

And it would never quite work correctly.  Besides, a user running a `command --help` should not be considered an error.

But a **far** bigger irritant was when running a docker run command and mis-typing an option, like so:

```
docker run --itq rhel7 /bin/sh
flag provided but not defined: -itq

Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container

  -a, --attach=[]            Attach to STDIN, STDOUT or STDERR.
  --add-host=[]              Add a custom host-to-IP mapping (host:ip)
  -c, --cpu-shares=0         CPU shares (relative weight)
  --cap-add=[]               Add Linux capabilities
...
```

The error message would scroll off the terminal window, and now I need to use the scroll bar to see what I screwed up.

Why did it show me the usage? 

I know the usage, and if I want the usage I will type `docker run --help`.

Well, [a patch I submitted a while ago](https://github.com/docker/docker/pull/8980) just got merged to fix both issues. Now `docker` error messages will go to `stderr`, and usage messages will go to `stdout`.

Committing an error in the command line will now put out a message like the following:

```
docker run --itq rhel7 /bin/sh
flag provided but not defined: -itq

Try 'docker run --help' for more information.
```

This new behavior should be in docker-1.4.1. Enjoy!

As Eric S. Raymond said, [every good work of software starts by scratching a developer's personal itch](http://en.wikipedia.org/wiki/The_Cathedral_and_the_Bazaar).
