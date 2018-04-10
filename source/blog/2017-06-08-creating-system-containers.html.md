---
title: Creating and Building System Images
author: smilner
date: 2017-06-08 16:00:00 UTC
published: true
comments: true
tags: atomic, containers, runc, system containers
---

As we continue to push the boundaries of Linux containers, we increasingly see value in containerizing operating system-level components. It’s common for developers and administrators to turn towards containers to improve application isolation, portability, deployment scenarios, and so on. These, and plenty of other advantages, [are well proven across the industry today](https://www.theregister.co.uk/2014/05/23/google_containerization_two_billion/), and the value extends to components that aren’t traditionally delivered as container images, like the Docker engine. Breaking out components like the container engine, cloud/guest agents, and storage clients, into containers isolates these stacks and allows them to move independently from the container host’s operating system.

READMORE

Running components like the Docker engine in a container carries a few requirements that don’t apply to more traditional containerized workloads. [System Containers]( http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/) exist as an implementation to solve this use case. [Giuseppe Scrivano](https://www.scrivano.org/) introduced this idea last year as a means to originally solve the early boot problem. System Containers are regular OCI images with additional metadata and configs for runc and systemd units.

Giuseppe notes:

> “System images are Docker images with a few extra files that are exported as part of the image itself, under the directory ’/exports’. In other words, an existing Dockerfile can be converted adding the configuration files needed to run it as a system container (which translate to an additional ADD [files] /exports directive in the Dockerfile.”

Since then there has been quite a bit of refinements and development! But how does one know how to create a config.json.template file? What does a manifest.json file look like? What labels are expected for an image to be a true System Image?

This post will explore how easy it can be to build/modify your images so they can run as system containers.

## Background

Enter [system-buildah](https://github.com/ashcrow/system-buildah). `system-buildah` provides a few different commands which simplify the process of creating and building System Images.

`system-buildah` is a wrapper around other tools and aims to provide a single workflow for creating and building System Images. `system-buildah` currently boasts the following features:

* System Image flavoured Dockerfile generation
* System Image file generation
* Image build wrapper
* Image to tar wrapper

## Creating a new System Image

### Generating Files

System Images require at least two files to be present: `config.json.template` and `service.template`. There are also two other optional files that add extra functionality: `manifest.json` and `tmpfiles.template`. For more information on both required and optional files see [FILES.md](https://github.com/projectatomic/atomic-system-containers/blob/master/FILES.md)

With the knowledge that System Images require at least two files we must first create and populate these requirements before we can start building. `system-buildah` makes this easier by providing a `generate-files` subcommand. This subcommand fronts the `ocitools generate` command as well as filling in templates to provide the base System Image files needed.

```
usage: system-buildah generate-files [-h] [-d DESCRIPTION] [-c CONFIG]
                                         [-D DEFAULT]
                                         output

positional arguments:
  output                Path to write the new files

optional arguments:
  -h, --help            show this help message and exit
  -d DESCRIPTION, --description DESCRIPTION
                        Description of container
  -c CONFIG, --config CONFIG
                        Options to pass to ocitools generate. Example: -c "--
                        cwd=/tmp --os=linux"
  -D DEFAULT, --default DEFAULT
                        Default manifest values in the form of key=value
```

```
$ system-buildah generate-files \
    --description='My System Image \
    --config='--hostname=test --cwd=/' \
    --default=variable=value mysystemimage
```

If we move into the mysystemimage directory we can see that three files have been created: `config.json.template`,` manifest.json`, `service.template`.

A quick look at each file will show that the options passed in were used. For example, `manifest.json` looks like this:

```
{
    "version": "1.0",
    "defaultValues": {
        "variable": "value"
    }
}
```

We can also see that `config.json.template` has our cwd and hostname values set.

### Generate a Dockerfile

The next step is to generate a Dockerfile. As noted before, System Images require a set of files and labels to truly be complete. The [labels](https://github.com/projectatomic/atomic-system-containers/blob/master/LABELS.md) are used for both informational and execution purposes.  We can use the generate-dockerfile command to create a Dockerfile that includes labels and files that a System Image requires.

For example, let’s say we want to be based off the latest fedora image, copy one file to the host at /etc/someapp/cfg.txt upon install, and fill in all available labels.

```
system-buildah generate-dockerfile \
    --from-base fedora:latest
    --license gplv2
    --summary "My System Image"
    --version 1.0
    --help-text "Not much to help with right now"
    --maintainer me@example.org
    --scope public \
    --add-file cfg.txt=/etc/someapp/cfg.txt  # Have the install copy ./cfg.txt to /etc/someapp/cfg.txt \
    --output .  # We want to output the Dockerfile to the directory we are currently in \
    MySystemImage
```

The result is a Dockerfile with System Image specific labels and file configuration ready to be edited.

```
FROM fedora:latest

# Fill out the labels
LABEL name="MySystemImage" \
      maintainer="me@example.org" \
      license="gplv2" \
      summary="My System Image" \
      version="1.0" \
      help="Not much to help with right now" \
      architecture="x86_64" \
      atomic.type="system" \
      distribution-scope="public"

RUN mkdir -p /export/hostfs/etc/someapp/
COPY cfg.txt /export/hostfs/etc/someapp/cfg.txt
COPY manifest.json service.template config.json.template /exports/

# RUN YOUR COMMAND HERE
```

Your Dockerfile is ready for editing! After modifying the Dockerfile to your liking, it’s time to build the container.

Building System Images
`system-buildah` essentially calls `docker build` to create the image, though more functionality will likely be added in the future. Note: building the System Image requires docker to be running.

```
system-buildah build mysystemcontainer:latest
```

## Installing

Now that the System Image is built it can be pulled and installed as a System Container via the [atomic](https://github.com/projectatomic/atomic) command. Here is a simple example of pulling and installing:

First we pull the image into ostree:

```
atomic pull \
    --storage ostree \
    docker:mysystemcontainer:latest
```

Then install!

```
atomic install \
    --system \
    --system-package=no \
    --name=mysystemcontainer \
    mysystemimage
```

It’s also possible to export the image as a tar and import it directly:

First we export the image to a tarfile:

```
system-buildah tar mysystemimage
```

Pull the image from the tarfile into ostree:

```
atomic pull \
    --storage ostree \
   dockertar:/mysystemimage.tar
```

Lastly, we install the image as a System Container:

```
atomic install \
    --system \
    --system-package=no \
    --name=mysystemcontainer \
    mysystemimage
```

Please note that there are many other options provided by the `atomic` command that can be used when installing a System Image as a System Container.
Running The System Container

At this point the System Image has been installed as a System Container and can be started via systemd like any other service:

```
systemctl start mysystemcontainer
```

## Conclusion

Interested in trying this out? Sample System Images can be found in our GitHub repo [here](https://github.com/projectatomic/atomic-system-containers/). We hope these serve as useful examples for creating your own System Images. Feel free to contribute back any images that you create.  Creating and building System Images will only continue to get simpler as tools such as `atomic`, [buildah](https://github.com/projectatomic/buildah), and `system-buildah` evolve.
