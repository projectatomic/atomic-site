---
title: "Atomic App"
---
# What is Atomic App?

Atomic App is a reference implementation of the [Nulecule Specification](https://github.com/projectatomic/nulecule). It can be used to bootstrap container applications and to install and run them. Atomic App is designed to be run in a container context. Examples using this tool may be found in the [Nulecule examples directory](https://github.com/projectatomic/nulecule/tree/master/examples).

## Getting Started

Atomic App itself is packaged as a container. End-users typically do not install the software from source. Instead use the atomicapp container as the `FROM` line in a Dockerfile and package your application on top. For example:

```
FROM projectatomic/atomicapp

MAINTAINER Your Name <you@example.com>

ADD /nulecule /Dockerfile README.md /application-entity/
ADD /artifacts /application-entity/artifacts
```

For more information see the [Nulecule getting started guide](https://github.com/projectatomic/nulecule/blob/master/docs/getting-started.md).

## Developers

Step 1 - clone the github repository: `git clone https://github.com/projectatomic/atomicapp`.

### Install this project
Simply run

```
pip install .
```

If you want to make some changes to the code, setting these environment variables will help:

```
cd atomicapp
export PYTHONPATH=`pwd`:$PYTHONPATH
alias atomicapp="`pwd`/atomicapp/cli/main.py"
```

### Build
```
atomicapp [--dry-run] build [TAG]
```

Calls 'docker build' to package up the application and tags the resulting image.

### Install and Run
```
atomicapp [--dry-run] [-a answers.conf] install|run [--recursive] [--update] [--destination DST_PATH] APP|PATH
```

Pulls the application and it's dependencies. If the last argument is
existing path, it looks for `Nulecule` file there instead of pulling anything.

* `--recursive yes|no` Pull whole dependency tree
* `--update` Overwrite any existing files
* `--destination DST_PATH` Unpack the application into given directory instead of current directory
* `APP` Name of the image containing the application (f.e. `vpavlin/wp-app`)
* `PATH` Path to a directory with installed (i.e. result of `atomicapp install ...`) app

Action `run` performs `install` prior it's own tasks are executed if `APP` is given. When `run` is selected, providers' code is invoked and containers are deployed.

## Providers

Providers represent various deployment targets. They can be added by placing a file called `provider_name.py` in `providers/`. This file needs to implement the interface explained in (providers/README.md). For a detailed description of all providers available see the [Provider description](Providers.asciidoc).

## Dependencies

As of Version 0.0.1 Atomic App uses [Python 2.7.5](https://docs.python.org/2/) and [Anymarkup](https://github.com/bkabrda/anymarkup).

##Communication channels

Interested in **Atomic App**? We'd love to hear from you about your use of Atomic App and work together on improving it. 

* IRC: #nulecule (On Freenode)
* Mailing List: [container-tools@redhat.com](https://www.redhat.com/mailman/listinfo/container-tools)
