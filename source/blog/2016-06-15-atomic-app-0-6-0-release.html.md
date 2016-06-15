---
title: Atomic App 0.6.0 Released&mdash;Native Kubernetes API Integration
author: cdrage
date: 2016-06-15 16:55:00 UTC
tags: atomicapp, Nulecule, releases
published: true
comments: true
---
This release of Atomic App introduces a large code-base change related to our Kubernetes provider.

We incorporate major changes to the Kubernetes provider. With this release, we replace the usage of `kubectl` with the *requests* Python library and the Kubernetes HTTP API end-point. This change results in faster deployment, smaller image sizes, and increased detail in logging messages.

The main features of this release are:

* Kubectl to API conversion
* Removal of ASCII art

READMORE

## Kubernetes `kubectl` to API Conversion

Changes to the Kubernetes provider introduces cleaner and more detailed logging messages for application deployment.

```
▶ sudo atomicapp run projectatomic/helloapache --destination helloapache
INFO   :: Atomic App: 0.6.0 - Mode: Run
INFO   :: Unpacking image projectatomic/helloapache to helloapache
INFO   :: Skipping pulling docker image: projectatomic/helloapache
INFO   :: Extracting Nulecule data from image projectatomic/helloapache to helloapache
INFO   :: App exists locally and no update requested
INFO   :: Using namespace default
INFO   :: Deploying to Kubernetes
INFO   :: Pods 'helloapache' successfully created

Your application resides in helloapache
Please use this directory for managing your application
```

Want to get started using Atomic App? Have a look at our extensive [start guide](https://github.com/projectatomic/atomicapp/blob/master/docs/start_guide.md), or use Atomic App as part of the Atomic CLI on an [Atomic Host](http://www.projectatomic.io/download/).

For a full list of changes between 0.5.2 and the 0.6.0 please see [the commit log](https://github.com/projectatomic/atomicapp/commits/0.6.0).
