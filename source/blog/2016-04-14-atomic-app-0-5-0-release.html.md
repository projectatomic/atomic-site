---
title: Atomic App 0.5.0 Released!
author: cdrage
date: 2016-04-14 12:15:00 UTC
tags: atomicapp, Nulecule, releases
published: true
comments: true
---

This is a major release of Atomic App where we introduce a new CLI command as well as the renaming of multiple provider configuration parameters.

The main features of this release are:

  - Introduction of the `atomicapp init` CLI command
  - Renaming of provider configuration related parameters
  - --provider-auth added as a CLI command

README

Other:

  - Updated legal information
  - Bug fix on persistent storage initialization
  - Utility method to gather sudo user path and information
  - Improved detection if we're inside a Docker container
  - Improved readability on provider failed exceptions
  - docker inspect bugfix

## Atomic App Initialization

We've included support for initializing a basic Atomic App via the `atomicapp init` command. This creates a basic example that can be used on Docker and Kubernetes providers based on the [centos/httpd](https://hub.docker.com/r/centos/httpd/) docker image.

```bash
▶ atomicapp init helloworld
[INFO] - main.py - Action/Mode Selected is: init

Atomic App: helloworld initialized at ./helloworld

▶ vim ./helloworld/Nulecule # Make changes to the Nulecule file

▶ atomicapp run ./helloworld
[INFO] - main.py - Action/Mode Selected is: run
[INFO] - base.py - Provider not specified, using default provider - kubernetes
[WARNING] - plugin.py - Configuration option 'provider-config' not found
[WARNING] - plugin.py - Configuration option 'provider-config' not found
[INFO] - kubernetes.py - Using namespace default
[INFO] - kubernetes.py - trying kubectl at /usr/bin/kubectl
[INFO] - kubernetes.py - trying kubectl at /usr/local/bin/kubectl
[INFO] - kubernetes.py - found kubectl at /usr/local/bin/kubectl
[INFO] - kubernetes.py - Deploying to Kubernetes

Your application resides in ./helloworld
Please use this directory for managing your application
```

## New Provider Configuration Parameter Names

We've renamed the provider-specific parameters for better clarity by adding dashes in-between 'provider' and the specified function.

Major changes include the renaming of accesstoken to provider-auth.

```
providerapi --> provider-api
accesstoken --> provider-auth
providertlsverify --> provider-tlsverify
providercafile --> provider-cafile
```

```ini
[general]
provider = openshift
namespace = mynamespace
provider-api = https://127.0.0.1:8443
provider-auth = sadfasdfasfasfdasfasfasdfsafasfd
provider-tlsverify = True
provider-cafile = /etc/myca/ca.pem
```

```sh
atomicapp run projectatomic/etherpad-centos7-atomicapp --provider openshift --provider-tlsverify False --provider-auth foo --provider-api "https://localhost:8443"
```

Want to get started using Atomic App? Have a look at our extensive [start guide](https://github.com/projectatomic/atomicapp/blob/master/docs/start_guide.md), or use Atomic App as part of the Atomic CLI on an [Atomic Host](http://www.projectatomic.io/download/).

For a full list of changes between 0.4.5 and 0.4.5 please see [the commit log](https://github.com/projectatomic/atomicapp/commits/0.4.5).
