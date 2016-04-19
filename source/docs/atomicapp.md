---
title: "Atomic App"
---
# What is Atomic App?

[Atomic App](https://github.com/projectatomic/atomicapp) is a reference implementation of the [Nulecule Specification](https://github.com/projectatomic/nulecule). It can be used to bootstrap container applications and to install and run them. Atomic App is designed to be run in a container context. 

Examples using this tool may be found in the [Nulecule examples library](https://github.com/projectatomic/nulecule-library).

## Getting Started

Atomic App itself is packaged as a container. End-users typically do not install the software from source. Instead using the `atomicapp` container as the `FROM` line in a Dockerfile and packaging your application on top. For example:

```
FROM projectatomic/atomicapp

MAINTAINER Your Name <you@example.com>

ADD /nulecule /Dockerfile README.md /application-entity/
ADD /artifacts /application-entity /artifacts
```
For more information see the [extensive Atomic App getting started guide](https://github.com/projectatomic/atomicapp/blob/master/docs/start_guide.md) which goes over in detail on how to build your first Atomic App container.

## Running your first Nulecule


### Install Atomic App

Clone the github repository

```
git clone https://github.com/projectatomic/atomicapp
cd atomicapp
```

Install it

```
sudo make install
```

### Running Atomic App

This will run a helloworld example using the `centos/apache` container image on Kubernetes.
```
sudo atomicapp run projectatomic/helloapache 
```

Same with Docker.
```
sudo atomicapp run projectatomic/helloapache --provider=docker
```

### Fetching, modifying and running an Atomic App

Fetch a Nuleculized container, modify the answers file and launch it.
```
atomicapp fetch projectatomic/helloapache --destination helloapache
cd helloapache
cp answers.conf.sample answers.conf # Modify then copy answers.conf.sample
atomicapp run .
```

### Commands
```
atomicapp {run,fetch,stop,genanswers,init} APP|PATH [--dry-run] [-a answers.conf] [-v] [--namespace foo] [--destination foo]
```

Pulls the application and it's dependencies. If the last argument is an existing path, it looks for `Nulecule` file there instead of pulling the container.

* `--destination DST_PATH` Unpack the application into given directory instead of current directory
* `APP` Name of the image containing the application (f.e. `vpavlin/wp-app`)
* `PATH` Path to a directory with installed (i.e. result of `atomicapp install ...`) app
* `--dry-run` Performs a faux command of Atomic App to simulate a deployment scenario
* `-a answers.conf` Provide an answers.conf file when deploying a container
* `--namespace foo` Use a particular namespace for a specific provider (specifically, k8s and openshift)

## Providers

Atomic App currently supports the following providers:

* Kubernetes
* OpenShift
* Marathon
* Docker

## Contribution

Interested in contributing? We have an awesome [development guide to get you started](https://github.com/projectatomic/atomicapp/blob/master/CONTRIBUTING.md)!

## Communication channels

Interested in **Atomic App**? We'd love to hear from you about your use of Atomic App and work together on improving it.

* IRC: __#nulecule__ on irc.freenode.net
* Mailing List: [container-tools@redhat.com](https://www.redhat.com/mailman/listinfo/container-tools)
* Weekly IRC Nulecule meeting: Monday's @ 0930 EST / 0130 UTC
* Weekly SCRUM Container-Tools meeting: Wednesday's @ 0830 EST / 1230 UTC on [Bluejeans](https://bluejeans.com/381583203/)
