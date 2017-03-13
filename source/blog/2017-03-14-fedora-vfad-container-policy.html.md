---
title: Fedora VFAD about Container Guidelines
author: jberkus
date: 2017-03-13 12:00:00 UTC
tags: fedora, containers, FLIBS, docker
published: true
comments: true
---

The [Fedora Atomic Working Group](https://pagure.io/atomic-wg) had our second [Virtual Fedora Activity Day](https://pagure.io/atomic-wg/issue/238) (VFAD) last Friday in order to resolve a [number of issues and policy questions](https://pagure.io/atomic-wg/roadmap?status=Open&no_stones=&milestone=2017-03-10+VFAD) with the [Container Guidelines](https://fedoraproject.org/wiki/Container:Guidelines). Our decisions will be of interest to anyone submitting software to the [Fedora Layered Image Build Service](https://docs.pagure.org/releng/layered_image_build_service.html) (FLIBS), as well as anyone who runs their own public open source registry.  Among those we discussed were versioning, labeling requirements, help files, volumes and systemd in containers.

READMORE

VFADs are an innovation of the Atomic WG.  Regular [Fedora Activity Days](https://fedoraproject.org/wiki/Fedora_Activity_Day_-_FAD) (FADs), are held in person and thus can only happen once a year or so, due to the cost of flying folks in from all over the world.  Since the Atomic WG wants to "release early and often," we needed a different way, and Adam Miller and Dusty Mabe came up with one.  Instead of flying everyone around the world, once every month we get together on IRC and video chat for VFAD.  In addition to letting us meet more often, this also lets contributors who couldn't travel to a FAD participate.

Friday's VFAD demonstrated the success of this, including nine regular Fedora Atomic contributors, as well as several people who just showed up for specific issues.  For example, Dan Walsh dialed in for the conversation about systemd containers.

We'll discuss a few of the group's decisions below.  For the rest, check out [the VFAD notes](https://fedoraproject.org/wiki/Atomic/VFAD_20170310) on the Fedora wiki.

## Run and Usage

In order to support the container user, every FLIBS container will have either the `Run` or `Usage` labels defined. `Run` is consumed my the [Atomic CLI](https://github.com/projectatomic/atomic), which uses it to execute a container image. It's machine-readable, and is part of a set with the `Install` and `Uninstall` labels.  System Containers are required to have `Run`.  For example, the Cockpit Dockerfile has this:

```
LABEL RUN /usr/bin/docker run -d --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh
```

Since supporting the Atomic CLI is optional for FLIBS, the maintainer can choose to have a human-readable `Usage` label instead, such as one for OwnCloud:

```
LABEL Usage="docker run -d -P -v owncloud-data:/var/lib/owncloud -v owncloud-config:/etc/owncloud owncloud"
```

Importantly, such `Usage` examples must show how volumes and port mappings are expected to work for the container, as well as any special permissions required.  They can show any container runtime.

## Versions and Releases

Another issue discussed was the [ambiguity around what to put for `VERSION` and `RELEASE`](https://pagure.io/atomic-wg/issue/235). As it turns out, part of this came down to a missing feature in our build pipeline, which will be addressed as soon as reasonable.

The obvious answer for `VERSION` is to populate the ENV variable with the version number of the "primary" RPM installed in the image.  However, that assumes that a maintainer is manually building the image and each update to the image.  One of the critical features of FLIBS is auto-build so that all images get updated with critical security releases and dependency updates.  Since we have no way for the build system to pull the version number from the RPM right now, that would mean that `VERSION` does not get updated on auto-build, possibly making it inaccurate.  

As Jason Brooks pointed out, it's better to have no information than inaccurate information.  As such, all image definitions will have `VERSION=0` until such time as it can be automatically populated.  There will likely be exceptions for specific images where the version is not tied to any specific RPM.

`RELEASE` will start at 1, and get automatically incremented each time either the maintainer or auto-build makes a change.  This means that the maintainer needs to make sure to `git pull` the FLIBS repository before making any changes to the image.

## Help File

One of the other issues made obvious by the [OwnCloud image submission](https://bugzilla.redhat.com/show_bug.cgi?id=1420275) was the need for a "man page" for each container.  Complicating this is that some images need only a couple lines of information about how to run them, whereas others (such as OwnCloud or PostgreSQL) need a page or more.  Also, some users will want to be able to access this help information "inside" the container.  The lack of such help information has been one of the flaws in Docker Hub.

Given that, the group created a multi-step requirement.  Images that need very little documentation (like libraries) will have that in the `Help` label as text.  Images which need significant documentation will have a file, named one of the following: `help1.txt`, `README`, or `README.md`.  This file will be submitted with the image proposal, and will be included bout inside the container image and available online from fedoraproject.org.  The `Help` label will link to that URL.

There were several other decisions and details worked out at this VFAD.  In addition to making FLIBS successful, we are hoping that we can set some precedents for other independent, open source registries.  Our container guidelines are being updated now; take a look at them in a week when we're done.
