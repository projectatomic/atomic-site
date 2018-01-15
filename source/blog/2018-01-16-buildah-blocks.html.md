---
title: Buildah Blocks - OCI Shell Game
author: tsweeney
date: 2018-01-16 00:00:00 UTC
published: true
comments: true
tags: atomic, buildah, containers
---

I’ve always been fascinated by the [three shells and a pea game](https://en.wikipedia.org/wiki/Shell_game) that street hustlers have used for years to make a bit of coin. I love watching a talented person running the game, but I know better than to bet on it! However, playing the game with [Buildah](https://github.com/projectatomic/buildah) leads to everyone being a winner.

I had a bit of time to play, so I tried out a variant of the shell game with Open Containers Initiative (OCI) containers. I made a quick example showing how you can create an OCI image with Buildah, saved the image to a repository on Docker Hub and then used both Docker and Buildah to run that  image from Docker Hub. Nothing terribly fancy, but the video does illustrate that Buildah is OCI-compliant and the images it creates can be used by other OCI-compliant technologies.

READMORE

The [demo](https://asciinema.org/a/biE5aEvLRJK6uMBwd106eB7S1) was recorded on a Fedora 27 virtual machine that was installed and then updated on December 23, 2017.  I decided to "leverage" William Henry’s [Buildah Tutorial #1](https://github.com/projectatomic/buildah/blob/master/docs/tutorials/tutorials.md) a bit to create a Dockerfile that runs his `runecho.sh` file. Prior to the video, I did the following on the virtual machine:

```
# dnf install -y docker buildah
# dnf update -y
# systemctl start docker
```

I also created a Dockerfile with these contents:

```
FROM alpine
ADD runecho.sh /usr/bin
CMD ["/bin/sh", "/usr/bin/runecho.sh"]
```

In the same directory I created `runecho.sh` with these contents:

```
#!/bin/bash
for i in `seq 0 9`;
do
    echo "This is a new container from ipbabble [" $i "]"
done
```

I then modified the privileges on `runecho.sh` with:

```
# chmod +x runecho.sh
```

The [demo](https://asciinema.org/a/biE5aEvLRJK6uMBwd106eB7S1) shows the results of these steps.  I’ve included the commands used in the video at the bottom of this blog.  I will note that Red Hat is currently developing [Podman](https://github.com/projectatomic/libpod). Once that is fully developed, the `podman run` command will be the suggested way to run your container; the Buildah variant of that command will be positioned for quick testing purposes.

I hope that you enjoyed the video and this article gives you a little more information on the Buildah project. Buildah is for simplicity - it is an Open Source project and contributors are always welcome. We’d love to see you there!

Commands used in the video for your perusal:

```
docker --version
buildah --version
docker login docker.io
cat Dockerfile
ls -alF runecho.sh
cat runecho.sh
buildah bud -t echo .
buildah push echo docker.io/tomsweeneyredhat/blog:echo
buildah images
docker images
docker run docker.io/tomsweeneyredhat/blog:echo
buildah from docker.io/tomsweeneyredhat/blog:echo --name echo
buildah run echo
```
