---
title: Origin on Fedora, part 1
author: jberkus
date: 2016-06-09 12:41:00 UTC
tags: atomic host, openshift, fedora
published: true
comments: true
---

This week was the [Fedora Cloud Working Group's Activity "Day"](https://fedoraproject.org/wiki/FAD_Cloud_WG_2016) (FAD), where a dozen of us got together to work on the project's adoption and innovation in the public and private cloud sectors.  Discussions and decisions there covered a range of topics, including Fedora Atomic Host, public cloud images, Vagrant improvements, and automated testing of cloud base images, Atomic and container images. You'll be seeing a bunch of changes resulting from this over the coming months.

One topic came up which is going to pretty much eat my time for at least a week, though: we don't yet have a working, easy-to-deploy download of [OpenShift Origin](https://github.com/openshift/origin) on Fedora Atomic Host.  Clearly, we need to fix this; my goal is to have something working by this time next week, for [DockerCon](http://dockercon.com/).

During the Hackathon period of the FAD, Adam Miller, Jason Brooks and I set to work on making Fedora Atomic Origin happen.  We quickly found that there were four major areas of work to be to get things up and running:

1. Packaging and testing using containerized [Openshift-Ansible](https://github.com/fedora-cloud/openshift-ansible/) for configuring new clusters;
2. Replacing the container base images for the OpenShift container components with Fedora base images;
3. Recreating some components which currently pull from RHEL RPM and container repositories;
2. Polishing and testing deploying [fully containerized OpenShift](https://github.com/fedora-cloud/openshift-ansible/blob/master/README_CONTAINERIZED_INSTALLATION.md) on Fedora Atomic Host.

At the Hackathon, while Adam worked on 2, Jason and I worked on Openshift-Ansible. One of the first issues we ran across was that Openshift-Ansible requires an older version of Ansible which isn't available on current Fedora (an update is in progress).  Jason created [a new COPR](https://copr.fedorainfracloud.org/coprs/jasonbrooks/ansible1.9.4/) to allow installing a compatible version into a Fedora Container.

In the meantime, I looked at running Openshift-Ansible in a container.  This is not currently the primary deployment method; today, OpenShift administrators generally run Ansible from a non-Atomic Host, installed as packages and source.  A containerized version, though, allows an Atomic OpenShift cluster to be self-bootstrapping, something we clearly want.  Thankfully, the OpenShift team has already done the lion's share of the work required for containerizing it, and [example Dockerfiles are available on github](https://github.com/fedora-cloud/openshift-ansible/blob/master/Dockerfile).

Like I said, though, this approach isn't well-used, and hasn't been tested at all on Fedora, just CentOS.  So my first task is revising the container definition, then testing and troubleshooting.  There's a fair amount of work to do there; by the end of the hackathon, I didn't yet have it working.

Once I have containerized Ansible working, my next task will be to design a way to run it in a [super-privileged container](http://www.projectatomic.io/blog/2015/09/using-a-spc-to-troubleshoot-containers/) (SPC).  The reason we need to do that is that, among other things, Openshift-Ansible configures Docker and its networking overlay.  For self-bootstrapping, we need it to be able to configure Docker on the same host where Ansible is running, which means *not* running it under Docker.  Besides, given the broad permissions Ansible needs, an SPC is appropriate. We'll also want to convert some of the other standard OpenShift containers to SPCs, maybe all of them.

So, I guess I know what I'm doing for the next week.  Feel like helping out?  Our [fork of OpenShift-Ansible is here](https://github.com/fedora-cloud/openshift-ansible/).
