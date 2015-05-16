---
author: jperrin
layout: post
comments: true
title: CentOS Docker Images updated to 20140902
date: 2014-09-05 19:53 UTC
tags:
- CentOS
- Docker
categories:
- Blog
---
Some fresh Docker fun as we head into the weekend! The [CentOS images in the Docker index](https://registry.hub.docker.com/_/centos/) have been bumped to 20140902.

## Fixes

These updates bring the following fixes: 

1. Add CentOS-5 image, with SELinux patch (thanks to Dan Walsh and Miroslav Grepl!) 

2. CentOS-7 image includes a `fakesystemd` package instead of the distro provided systemd. This should resolve a number of the udev and/or pid-1 errors users were seeing. This package is only useful for docker, and **will** break other installs.

3. Images now contain a new file, `/etc/BUILDTIME`, to reference when the image was created/published.

4. Includes recent updates current to 20140902.

## More info

For detailed information or to see the code differences used in building the images, please see: [https://github.com/CentOS/sig-cloud-instance-build](https://github.com/CentOS/sig-cloud-instance-build).
