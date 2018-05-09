---
title: Open Source, What a Concept!
author: tsweeney
date: 2018-04-02 00:00:00 UTC
tags: community, open source, buildah
comments: false
published: true
---

I recently joined Red Hat after many years working for another tech company whose three character symbol most would recognize, but I won’t name. While there, I developed a number of different software products that were all very successful in their spaces, but all very proprietary.  Not only were we legally compelled to not share the software outside of the company, we often times didn't share it within the company. To me at the time, that made complete sense. The company spent the time, energy and budget on developing the software, so they should then protect and then claim the rewards that were garnered for it.  

Fast forward to a year ago when I joined Red Hat, and developed a completely different mindset. One of the first things I jumped into was the Buildah project. It facilitates building Open Container Initiative (OCI) images and it is especially good at allowing you to tailor the size of the image that is created.  At that time Buildah was in its very early stages and there were some warts here and there that weren't quite production ready.

READMORE

Being new on the project, I made a few minor changes then asked where the company's internal git repository was that I could push my changes to.  The answer was nothing internal, just push your changes to GitHub.  I was baffled, sending my changes out to GitHub would mean anyone could look at that code and use it for their own projects!  Plus the code still had a few warts, so that just seemed so counter-intuitive.  But being the new guy, I shook my head in wonder and pushed the changes out.

Now a year later, I’m very convinced of the power and value of Open Source software. I’m still working on Buildah and we recently had an issue that really illustrates that power and value.  The issue titled ["Buildah images not so small"](https://github.com/projectatomic/buildah/issues/532), was raised by Tim Dudgeion (@tdudgeon). To summarize, he noted that images created by Buildah were bigger than those created by Docker even though the Buildah images didn’t contain the extra “fluff” he saw in the Docker images.

For comparison he first did:

```
$ docker pull centos:7
$ docker images
REPOSITORY            TAG              IMAGE ID                 CREATED             SIZE
docker.io/centos          7                   2d194b392dd1        2 weeks ago         195 MB
```

He noted that the size of the Docker image was `195 MB`.  Tim then went and created a minimal (scratch) image using Buildah, with only the `coreutils` and `bash` packages added to the image, using the following script.

```
$ cat  ./buildah-base.sh
#!/bin/bash

set -x

# build a minimal image
newcontainer=$(buildah from scratch)
scratchmnt=$(buildah mount $newcontainer)

# install the packages
yum install --installroot $scratchmnt bash coreutils --releasever 7 --setopt install_weak_deps=false -y
yum clean all -y --installroot $scratchmnt --releasever 7

sudo buildah config --cmd /bin/bash $newcontainer

# set some config info
buildah config --label name=centos-base $newcontainer

# commit the image
buildah unmount $newcontainer
buildah commit $newcontainer centos-base

$ sudo ./buildah-base.sh

$ sudo buildah images
IMAGE ID               IMAGE NAME                                             CREATED AT            SIZE
8379315d3e3e     docker.io/library/centos-base:latest           Mar 25, 2018 17:08   212.1 MB
```

Tim wondered why the image was `17 MB larger`, because `python` and `yum` were not installed in the Buildah image. Whereas they were installed in the Docker image.  Needless to say, this set off quite the discussion in the GitHub issue, as it was not at all an expected result.

What was great to see about the discussion was not only were Red Hat folks involved, but several others from outside of Red Hat were also involved.  In particular, a lot of great discussion and investigation was led by GitHub user @pixdrift.  Pixdrift noted that the documentation and locale-archive was chewing up a little over `100 MB` of space in the Buildah image.  Pixdrift  suggested forcing locale in the yum installer and provided this updated `buildah-bash.sh` script with those changes:

```
#!/bin/bash

set -x

# build a minimal image
newcontainer=$(buildah from scratch)
scratchmnt=$(buildah mount $newcontainer)

# install the packages
yum install --installroot $scratchmnt bash coreutils --releasever 7 --setopt=install_weak_deps=false --setopt=tsflags=nodocs --setopt=override_install_langs=en_US.utf8 -y
yum clean all -y --installroot $scratchmnt --releasever 7

sudo buildah config --cmd /bin/bash $newcontainer

# set some config info
buildah config --label name=centos-base $newcontainer

# commit the image
buildah unmount $newcontainer
buildah commit $newcontainer centos-base
```

When Tim ran this new script, the image size was shrunk down to `92 MB`, shedding `120 MB` from the original Buildah image size and getting more to the expected size.  However engineers being engineers, a savings in size of `56%` just wasn’t enough.   The discussion went further talking about how to remove individual locale packages to save even further space.  If you’d like to see more details of the discussion about the ["Buildah images not so small"](https://github.com/projectatomic/buildah/issues/532) issue, click on the link.  Who knows maybe you’ll have a helpful tip too or better yet, you’ll become a contributor for Buildah.

On a side note, this solution really illustrates how the Buildah software can be used to create a minimally sized container quickly and easily that fit your needs.  You can create a container loaded up only with the software that you need to get your job done efficiently.  As a bonus, it doesn’t require a daemon to be running….

This image sizing issue really drove home the power of Open Source software for me.  A number of people from different companies all collaborated to solve a problem through open discussion in a little over a day.  Although no code changes were created to address this particular issue, there have been many code contributions to Buildah from contributors outside of Red Hat and this has helped to make the project even better than if only a few of us had hands on it.  These contributions have served to get a lot more eyes onto the code from a wider variety of talented people than it ever would have if it was a proprietary piece of software stuck on a very private git repository.  It’s taken only a year to convert me to the [@opensourceway](https://twitter.com/opensourceway), I don’t think I could ever go back.  Come join us!


**Buildah == Simplicity**
