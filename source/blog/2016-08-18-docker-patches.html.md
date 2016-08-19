---
title: "Project Atomic Docker Patches"
author: dwalsh
date: 2016-08-18 12:00:00 UTC
tags: docker, patches, development
published: true
comments: true
---

Project Atomic's version of the Docker-based container runtime has been carrying a series of patches on the upstream Docker project for a while now.  Each time we carry a patch, it adds significant effort as we continue to track upstream, therefore we would prefer to never carry any patches.  We always strive to get our patches upstream and do it in the open.

This post, and the accompanying document, will attempt to describe the patches we are currently carrying:

* Explanation on types of patches.
* Description of patches.
* Links to GitHub discussions, and pull requests for upstreaming the patches to docker.

Some people have asserted that [our docker repo](https://github.com/projectatomic/docker) is a fork of the upstream docker project.

##  What Does It Mean To Be a Fork?

I have been in open source for a long time, and my definition of a "fork" might be dated. I think of a "fork" as a hostile action taken by one group to get others to use and contribute to their version of an upstream project and ignore the "original" version. For example, LibreOffice forking off of OpenOffice or going way back Xorg forking off of Xfree86.

Nowadays, GitHub has changed the meaning. When a software repository exists on GitHub or a similar platform, everyone who wants to contribute has to hit the "fork" button, and start building their patches. As of this writing, Docker on GitHub has 9,860 forks, including ours. By this definition, however, all packages that distributions ship that include patches are forks. Red Hat ships the Linux Kernel, and I have not heard this referred to as a fork. But it would be considered a "fork" if you're considering any upstream project shipped with patches a fork.

*The Docker upstream even relies on Ubuntu carrying patches for AUFS that were never merged into the upstream kernel.* Since Red Hat-based distributions don’t carry the AUFS patches, we contributed the support for Devicemapper, OverlayFS, and Btrfs backends, which are fully supported in the upstream kernel.  This is what enterprise distributions should do: attempt to ship packages configured in a way that they can be supported for a long time.

At the end of the day, we continue to track the changes made to the upstream Docker Project and re-apply our patches to that project. We believe this is an important distinction to allow freedom in software to thrive while continually building stronger communities.  It’s very different than a hostile fork that divides communities&mdash;we are still working very hard to maintain continuity around unified upstreams.

## How Can I Find Out About Patches for a Particular Version of Docker?

All of the patches we ship are described in the README.md file on the appropriate branch of [our docker  repository](https://github.com/projectatomic/docker). If you want to look at the patches for docker-1.12 you would look at [the docker-1.12 branch](https://github.com/projectatomic/docker/tree/docker-1.12).

You can then look on the [docker patches list page](/docs/docker_patches) for information about these patches.

## What Kind of Patches does Project Atomic Include?

Here is a quick overview of the kinds of patches we carry, and then guidance on finding information on specific patches.

### Upstream Fixes

The Docker Project upstream tends to fix issues in the **next** version of Docker. This means if a user finds an issue in docker-1.11 and we provide a fix for this to upstream, the patch gets merged in to the master branch, and it will probably not get back ported to docker-1.11.

Since Docker is releasing at such a rapid rate, they tell users to just install docker-1.12 when it is available. This is fine for people who want to be on the bleeding edge, but in a lot of cases the newer version of Docker comes with new issues along with the fixes.

For example, docker-1.11 split the docker daemon into three parts: docker daemon, containerd, and runc.  We did not feel this was stable enough to ship to enterprise customers right when it came out, yet it had multiple fixes for the docker-1.10 version. Many users want to only get new fixes to their existing software and not have to re-certify their apps every two months.

Another issue with supporting stable software with rapidly changing dependencies is that developers on the stable projects must spend time ensuring that their product remains stable every time one of their dependencies is updated. This is an expensive process, dependencies end up being updated only infrequently. This causes us to "cherry-pick" fixes from upstream Docker and to ship these fixes on older versions so that we can get the benefits from the bug fixes without the cost of updating the entire dependency. This is the same approach we take in order to add capabilities to the Linux kernel, a practice that has proven to be very valuable to our users.

### Proposed Patches for Upstream

We carry patches that we know our users require right now, but have not yet been merged into the upstream project.  Every patch that we add to the Project Atomic repository also gets proposed to the upstream docker repository.

These sorts of patches remain on the Project Atomic repository briefly while they’re being considered upstream, or forever if the upstream community rejects them. If we don't agree with upstream Docker and feel our users need these patches, we continue to carry them. In some cases we have worked out alternative solutions like building authorization plugins.

For example, users of RHEL images are not supposed to push these image onto public web sites. We wanted a way to prevent users from accidentally pushing RHEL based images to Docker Hub, so we originally created a patch to block the pushing.  When authorization plugins were added we then created a plugin to protect users from pushing RHEL content to a public registry like Docker Hub, and no longer had to carry the custom patch.

## Detailed List of Patches

Want to know more about specific patches? You can find the current table and list of patches on our new [docker patches list page](/docs/docker_patches).
