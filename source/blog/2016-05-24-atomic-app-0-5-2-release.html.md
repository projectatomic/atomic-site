---
title: Atomic App 0.5.2 released - Cleaner logging and binary generation!
author: cdrage
date: 2016-05-24 12:15:00 UTC
tags: atomicapp, Nulecule, releases
published: true
comments: true
---

In this weeks release of Atomic App we not only have cleaner logging output when using the tool, but we've also added binary generation!

The main features of this release are:

* Cleaning logging
* Binary generation
* README.MD generation removed from `atomicapp init`

READMORE

Other:

  - Code cleanup / minor code modifications (dictionary searches, loops)
  - Provider module / class loading refactoring

## Cleaner logging

We've completed a clean-up on how we log Atomic App. With this release we've added ASCII art as well as cleaned up a lot of the redundant information outputted when deploying an Atomic App.

```
▶ atomicapp run projectatomic/helloapache --destination helloapache --provider=docker
INFO   ::    _  _             _      _
INFO   ::   /_\| |_ ___ _ __ (_)__  /_\  _ __ _ __   Version:  0.5.1
INFO   ::  / _ \  _/ _ \ '  \| / _|/ _ \| '_ \ '_ \  Nulecule: 0.0.2
INFO   :: /_/ \_\__\___/_|_|_|_\__/_/ \_\ .__/ .__/  Mode:     Run
INFO   ::                                |_|  |_|
INFO   :: Unpacking image: projectatomic/helloapache to helloapache
INFO   :: Skipping pulling Docker image: projectatomic/helloapache
INFO   :: Extracting nulecule data from image: projectatomic/helloapache to helloapache
INFO   :: Deploying to provider: Docker

Your application resides in helloapache
Please use this directory for managing your application
```

## Binary generation

You'll now be able to generate a stand-alone binary for Atomic App without the need of having Python installed.  This removes some issues around Python versions and module installation.

Simply use `make binary` in the root folder of the Atomic App source code and your binary will be generated!

```
▶ make binary
...
Binary created at bin/atomicapp
```


Want to get started using Atomic App? Have a look at our extensive [start guide](https://github.com/projectatomic/atomicapp/blob/master/docs/start_guide.md), or use Atomic App as part of the Atomic CLI on an [Atomic Host](http://www.projectatomic.io/download/).

For a full list of changes between 0.5.1 and 0.5.2 please see [the commit log](https://github.com/projectatomic/atomicapp/commits/0.5.2).
