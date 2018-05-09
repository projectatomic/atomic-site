---
title: Project Atomic Docker Hub Namespace Changes
author: smilner
date: 2017-12-20 10:00:00 UTC
published: true
comments: false
tags: atomic, docker, registry, image
---

As many people are aware the Project Atomic team has provided container images via its [Docker Hub namespace](https://hub.docker.com/u/projectatomic/). As more and more image registries come online it has become apparent that it is time to refocus how our Docker Hub namespace is used. Read on for a rundown of upcoming changes!

READMORE

## Pruning
The first change to the namespace will be image pruning. Today there are 18 images that are available in the namespace. Images which are not being actively built and pulled will be removed from the Project Atomic namespace. By removing older and no longer used images from the registry it should be easier to follow what images are in development.

## Automated Building
New images, as well as images which are currently active, will start to be built upon source code changes. This means that images provided in the Project Atomic namespace will represent the master branch in source control. This change will allow users to pull the latest images to test and play with without the need to rebuild locally. It also means that the images available in the Project Atomic Docker Hub namespace will be **bleeding edge** and should be considered similar to rpm packages in Rawhide. If you are wanting to use a supported image you should use an official image.

## System Container Inclusion
Bleeding edge [System Containers](https://github.com/projectatomic/atomic-system-containers/) will be moved from their respective authors namespaces in to the Project Atomic namespace. As an example, Giuseppe Scrivano's [etcd System Container](https://hub.docker.com/r/gscrivano/etcd/) will be moved to [Project Atomic's Namespace](https://hub.docker.com/u/projectatomic/). Not only does this widen the ability for other members of Project Atomic to update the image in the namespace but it also firmly cements it as an image developed by the team.

## Official Images
Officially released images will be available in their respective registries. As an example, the ```etcd``` system container built on Fedora and supported by said community will be available through the Fedora Layered Image Builds System (FLIBS).

## Conclusion
Hopefully these changes will make using images which are in development and fast moving easier to test, play with, and develop. As always, if there are questions drop in to the #atomic on Freenode or send an email to our mailing list!
