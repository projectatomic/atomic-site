---
title: Projectatomic.io running in Atomic App
author: jberkus
date: 2016-03-04 12:00:00 UTC
tags: Atomic App, Nulecule, testing, development
published: true
comments: true
---

Since Atomic App is released version 0.4.2, I decided it was past time
to make the atomic-site into an Atomic App instead of using a shell script that
wraps Docker to test it.  The new setup is a big improvement, and a useful
guide to "Nuleculeizing" your own apps.

As you know the purpose of Atomic App and Nulecule is to give you a provider-agnostic
way to specify multi-container applications and orchestration metatdata which stays
with the application image(s).  Eventually, this will allow for single-command
deploys of even large, scalable apps involving many containers.  For now, it
lets us get rid of some hackish shell scripting around Docker in our atomic-site
test setup.

In order to turn atomic-site into an Atomic App, I had to do five things:

1. Create and register an application image which expected the /source and /data
   directories to be mounted as volumes, and set permissions on those;
2. Create a template Dockerfile for the Atomic App;
3. Create a Nulecule configuration file;
4. Create a provider file for Docker.
5. Generate a an answers.conf file and edit it.

Since the atomic-site is just a single-container app, and here we're just running
it for testing purposes, we're only going to support Docker as a provider, and
not Kubernetes or Mesos.  However, either of those could be added with just a few
lines of configuration and a single provider file (or more than one if we wanted
a bunch of load-balanced webservers).

I won't go over the first step in detail since it's a standard Docker build; you
can [look at the dockerfile here](https://github.com/projectatomic/atomic-site/blob/master/Dockerfile).  The
important thing is that both the `source` and `data` mounts are commented out
because those are the parts of the Middleman application which change, and thus
need to be mounted as volumes.  I then pushed this image to
 [jberkus/atomic-site](https://hub.docker.com/r/jberkus/atomic-site/)
(eventually it will go to projectatomic/atomic-site).

Because we're sharing some volumes and I have SELinux turned on (don't you?), I also
need to tell SELinux that the container is allowed to share access to those directories.
So I added a little [selinux_share.sh](https://github.com/projectatomic/atomic-site/blob/master/selinux_share.sh)
 script in the repo's home directory which sets
those.

The second part is to create a placeholder Dockerfile, which is used to build the Atomic App
wrapper container.  These files pretty much all look the same:

```
FROM projectatomic/atomicapp:0.4.2

MAINTAINER Red Hat, Inc. <container-tools@redhat.com>

LABEL io.projectatomic.nulecule.providers="docker" \
      io.projectatomic.nulecule.specversion="0.0.2"

ADD /Nulecule /Dockerfile README.md /application-entity/
ADD /artifacts /application-entity/artifacts
```

The only thing which really changes is which providers you support and the spec
and app versions.

Now we get to the good stuff: the Nulecule file, which is most of the definition.
Let's do this one a little at a time.

First, we define the spec version and the application ID in the header.  Nothing
exciting here:

```
---
specversion: 0.0.2
id: atomic-site
```

Next we set some overall metadata, which is pretty much just for registry
and future searching use:

```
metadata:
  name: Atomic Site app
  appversion: 0.1.0
  description: Atomic app for testing the Atomic Website
```

The "graph" contains the definition of all of the app's objects.  While ordering-independant,
we're going to start it with the parameters which will need to be supplied by
the answers.conf file:

```
graph:
  - name: atomic-site
    params:
      - name: image
        description: The webserver image
        default: jberkus/atomic-site
      - name: hostport
        description: The host TCP port as the external endpoint
        default: 4567
      - name: sourcedir
        description: location of the middleman source directory
      - name: datadir
        description: the middleman data directory
```

Here you'll notice that we supplied some defaults for the image name and the
port to be used on the host, because we expect those to be the same for most
users.  We don't expect that most users will have the same path to their local
copy of the atomic-site repo, though, so those parameters have no defaults, meaning
that the user has to supply them.

Finally, the "artifacts" section defines where the provider files live:

```
artifacts:
  docker:
    - file://artifacts/docker/atomic-site-run
```

Since we're supporting only Docker right now, one line is all we need.  We also
don't currently define any persistentVolumes, even though we'll be using some
volumes; this is because of a limitation which will be resolved when we start requiring
Docker 1.9 or later.

As a fourth step, we need to create that atomic-site-run file.  Right now that's
a bit of a messy command line because of the lack of volume support, but not
too bad:

```
docker run --rm -p $hostport:4567 --volume $sourcedir:/tmp/source --volume $datadir:/tmp/data $image
```

One thing we are doing here is adding --rm because this Atomic App is strictly for testing;
for production you might not want it.  You'll notice that the params are supplied here
as $variables.

Finally, we generate the answers file from Nulecule:

```
cd Nulecule/
atomicapp genanswers .
sudo emacs answers.conf

[atomic-site]
image = jberkus/atomic-site
hostport = 4567
sourcedir = /home/josh/git/redhat/atomic-site-master/source
datadir = /home/josh/git/redhat/atomic-site-master/data
[general]
namespace = default
provider = docker
```
So the [general] section is something all Atomic Apps have.  Here you supply a
namespace and a provider, which in our case is docker.  The parameters are supplied
in the section named after the app.  For atomic-site, you'd want to change
the full path to the directories to one which matches your own workstation.

Now, with it all together, I can now run my atomic app:

```
[josh@redhat atomic-site-master]$ sudo atomicapp run Nulecule/
2016-03-02 18:55:37,514 - [INFO] - main.py - Action/Mode Selected is: run
2016-03-02 18:55:37,585 - [INFO] - docker.py - Deploying to provider: Docker

== The Middleman is loading
```

... and access the site on http://127.0.0.1:4567 so that I can test changes.

Now, it's your turn to Nuleculeize an app.

Check out the config here on the [atomic-site repo](https://github.com/projectatomic/atomic-site), and additional sample Atomic App
configurations in the
[Nulecule-library](https://github.com/projectatomic/nulecule-library).
