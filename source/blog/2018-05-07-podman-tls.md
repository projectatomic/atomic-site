---
title: Podman and insecure registries
author: baude
date: 2018-05-07
layout: post
comments: false
categories:
- Blog
tags:
- crio
- libpod
- podman
---

## Podman and insecure registries
The last few weeks, we have had a number of bugs and questions about how to pull from an insecure registry. The obvious advice here is that you should always be using a registry which implements _tls-verify_. But if you are a container or image developer or you are just plain breaking new ground, your registry may not use _tls-verify_. And [Podman](https://github.com/projectatomic/libpod/) can handle this; and I wanted to spend a minute or two explaining how it does and the logic behind it.

READMORE

### Podman pull

We first need to talk about the various components in play here. To start with, lets use an example of the `podman pull` command:

```
$ sudo podman pull --help
NAME:
   podman pull - pull an image from a registry

USAGE:
   podman pull [command options] [arguments...]

DESCRIPTION:
   Pulls an image from a registry and stores it locally.
An image can be pulled using its tag or digest. If a tag is not
specified, the image with the 'latest' tag (if it exists) is pulled.

OPTIONS:
   --authfile value             Path of the authentication file. Default is ${XDG_RUNTIME_DIR}/containers/auth.json
   --cert-dir pathname          pathname of a directory containing TLS certificates and keys
   --creds credentials          credentials (USERNAME:PASSWORD) to use for authenticating to a registry
   --quiet, -q                  Suppress output information when pulling images
   --signature-policy pathname  pathname of signature policy file (not usually used)
   --tls-verify                 require HTTPS and verify certificates when contacting registries (default: true)
```

Most noteworthy, the podman pull command has a _tls-verify_ command line switch. It can accept a booleon (true/false) argument and you will notice it is set to true by default.

### System-wide registries configuration file

The next component to look at is the system-wide registries configuration file. On my system, that file resides at _/etc/containers/registries.conf_. And I will show a somewhat redacted version of mine as an example:

```
# This is a system-wide configuration file used to
# keep track of registries for various container backends.
# It adheres to TOML format and does not support recursive
# lists of registries.

[registries.search]
registries = ['docker.io', 'registry.fedoraproject.org', 'registry.access.redhat.com']

# If you need to access insecure registries, add the registry's fully-qualified name.
# An insecure registry is one that does not have a valid SSL certificate or only does HTTP.
[registries.insecure]
registries = ['localhost:5000']
```

Here you can see I have three registries defined under the search header and a single registry defined as an insecure registry. The registries under the search header are registries that Podman will search when you try to find an image that is not fully-qualified.

I also have a development registry defined under the insecure header as _localhost:5000_. It was not pragmatic for me to setup certificates for a registry I might delete and rerun 10 times a day so I simply access it without _tls-verify_.

You can also quickly see what registries Podman is aware of by issuing the `podman info` command. Both searchable and insecure registries are listed there.

### Applying system-wide registries to Podman pull

When you run Podman, it reads and parses your system-wide registries configuration file. When it pulls an image, it will use the searchable registries to find the image in question. And when the image is actually pulled, it will see if the registry it is pulling from is listed as insecure. If the registry is listed as insecure and you did not specifically set the _tls-verify=true_ option, Podman will pull the image with _tls=verify=false_. This is a convenience function for users so they do not have to remember the security protocols of their registries.

```
$ sudo podman pull localhost:5000/bb:latest
Trying to pull localhost:5000/bb:latest...Getting image source signatures
Copying blob sha256:f70adabe43c0cccffbae8785406d490e26855b8748fc982d14bc2b20c778b929
 706.22 KB / 706.22 KB [====================================================] 0s
Copying config sha256:8ac48589692a53a9b8c2d1ceaa6b402665aa7fe667ba51ccc03002300856d8c7
 1.46 KB / 1.46 KB [========================================================] 0s
Writing manifest to image destination
Storing signatures
8ac48589692a53a9b8c2d1ceaa6b402665aa7fe667ba51ccc03002300856d8c7
```

To review, the rules are as follows.

* If you pull from a registry not in the configuration file, _tls-verify_ is assumed true unless you override it.
* If you pull from a registry defined as a searchable registry (only) in your configuration file, _tls-verify_ is assumed true unless you override it.
* If you pull from a registry that is defined as insecure, _tls-verify_ will be false unless you specifically call out _tls-verify=true_.

### Insecure registries can be searchable too

A follow up question I often get is if a searchable registry can be insecure as well? Yes, you can list a registry as both searchable and insecure. Notice how I pulled the previous bb:latest image by a fully-qualified name. If _localhost:5000_ is a searchable registry, I can pull it by short name — bb.

```
$ sudo podman pull bb
Trying to pull docker.io/bb:latest...Failed
Trying to pull registry.fedoraproject.org/bb:latest...Failed
Trying to pull registry.access.redhat.com/bb:latest...Failed
Trying to pull localhost:5000/bb:latest...Getting image source signatures
Copying blob sha256:f70adabe43c0cccffbae8785406d490e26855b8748fc982d14bc2b20c778b929
 706.22 KB / 706.22 KB [====================================================] 0s
Copying config sha256:8ac48589692a53a9b8c2d1ceaa6b402665aa7fe667ba51ccc03002300856d8c7
 1.46 KB / 1.46 KB [========================================================] 0s
Writing manifest to image destination
Storing signatures
8ac48589692a53a9b8c2d1ceaa6b402665aa7fe667ba51ccc03002300856d8c7
```
