---
author: jzb
comments: true
layout: post
title: Fedora 21 goes gold with Atomic images
date: 2014-12-10 00:10 UTC
tags:
- Fedora
categories:
- Blog
---
Good news, everybody! Fedora 21 [was officially released yesterday](http://fedoramagazine.org/announcing-fedora-21/) with not just one, not just two, but three "flavors" &hdash; a Cloud, Server, and Workstation release. You should definitely check out the workstation and server releases, but I want to focus particularly on the Cloud release with its Atomic Host image. 

If you head over to the [Get Fedora Cloud Page](https://getfedora.org/en/cloud/), you'll [find the download page with the Fedora 21 Atomic Host](https://getfedora.org/en/cloud/download/), with a RAW-format image and a qcow2 image suitable for OpenStack or KVM (e.g., Virt-Manager). 

You'll also find a list of AMIs for running Fedora 21 Atomic Host on Amazon Web Services in US East, US West, EU West, Asia Pacific SE, Asia Pacific NE, and South America East. 

The Fedora 21 Atomic Host release is a streamlined Fedora 21 base with just the packages you need to run a host optimized for running Linux containers. 

## Updates

Note that if you were running one of the recent Fedora 21 Atomic Host pre-release images, you can update to Fedora 21 final with `sudo atomic upgrade` and then reboot. 

## Fedora 21 Docker Images

Naturally, you're going to want something *in* the containers to run on Fedora Atomic Host. Why not take the new Fedora 21 Docker images for a test drive? 

You can find the Fedora images on the Docker Hub (using `docker pull fedora:21`) or get them direct from the [Fedora Spins](http://spins.fedoraproject.org/docker/) site. The nice thing about grabbing directly from Fedora's Spins page is you can also [verify the download](http://spins.fedoraproject.org/verify). 

If you haven't directly downloaded an image before, here's how to load and run the image:

```
docker load -i Fedora-Docker-Base-20141203-21.x86_64.tar.gz
docker run -it --rm Fedora-Docker-Base-20141203-21.x86_64 bash
```

If the image name changes due to updates later, just replace the filename with the new download's filename.

## Get Involved!

Now that Fedora 21 is out the door, we all get a breather for about five minutes &ndash; and then start working on Fedora 22. 

You can join us in the [Fedora Cloud Working Group](http://fedoraproject.org/wiki/Cloud), sync up on the [mailing list](http://fedoraproject.org/wiki/Cloud#Mailing_List), or talk to us on Freenode in #fedora-cloud.
