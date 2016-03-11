---
author: jzb
comments: true
layout: post
title: "Is It Safe? A Look at Docker and Security from LinuxCon"
date: 2014-08-29 14:33 UTC
tags:
- Docker
- Security
- SELinux
categories:
- Blog
---
Running applications in Docker is *easy*. Developers and users are finding this out in droves, which is why Docker is a runaway success. But is it **safe**? The answer seems to be a resounding "it depends," but trending more closely to "yes" as work continues on Docker and we learn more about how to secure workloads.

Jérôme Petazzoni, "tinkerer extraordinaire" at Docker, gave an excellent presentation at LinuxCon in Chicago that addressed the safety of running applications in Linux containers. (The presentation from SlideShare is embedded below.) 

The short answer, in absolute terms, is "no" if you depend solely on Docker to ensure security. As Dan Walsh says (and Petazzoni pointed out) "containers do not contain." 

Currently, if you have root in a container, you potentially can have root on the entire box. Petazzoni suggests that there are a few solutions to that problem:

* Don't give root
* If the application "needs" root, give "looks-like-root"
* If that's not sufficient, "give root, but build another wall"

## Threat Models and Docker

Petazzoni then ran through different use cases / threat models that you might run into with Docker and fixes for the threats they may pose. For instance, if you're worried about normal apps escalating from non-root to root, "defang" SUID binaries by removing the SUID bit and/or mount filesystems with nosuid. Worried about applications "leaking" to another container? Use user namespaces to map UIDs to different UIDs outside the container (*e.g.* UID 1000 in the container is 14298 outside). 

Petazzoni continued with examples of potential fixes for scenarios where Docker might be attacked, up to situations where one might want to run kernel drivers or network stacks in Docker. His response? "Please stop trying to shoot yourself in the foot safely." (In other words, anything that requires control over hardware isn't going to be more secure in a container!)

You can, of course, get crazy and [run Docker-within-Docker](https://github.com/jpetazzo/docker2docker) by using KVM within a container. But then again, maybe *everything* doesn't need to be containerized. 

One area that Petazzoni didn't mention during the initial talk is image signing. Right now, a lot of people are sharing Docker images without signing to ensure that the code you're running in a container actually is what was originally supplied or is actually from the source it purports to be from. This is a major concern, and Petazzoni says signing will be addressed eventually.

With some caveats, though, the security picture for Docker is pretty good &ndash; but not yet perfect. So it goes. At the rate Docker is improving, we'll see many of the issues that Petazzoni discussed addressed by this time next year. And, in many cases, there are already workarounds.

The presentation (below) is well worth skimming through. Overall, Petazzoni delivered a great presentation &ndash; to a packed room, I might add. Interest in Docker at LinuxCon was quite high (not surprisingly). Last year, I recall Docker being discussed at LinuxCon but with little indication of how important it would be this year. Should be interesting to look back next year to see where we were in mid-2014 and how far it's come.

If you're interested in all things Docker, you probably want to follow Petazzoni on Twitter at [@jpetazzo](https://twitter.com/jpetazzo). 

<iframe src="//www.slideshare.net/slideshow/embed_code/38191500" width="512" height="421" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="https://www.slideshare.net/jpetazzo/docker-linux-containers-lxc-and-security" title="Docker, Linux Containers (LXC), and security" target="_blank">Docker, Linux Containers (LXC), and security</a> </strong> from <strong><a href="http://www.slideshare.net/jpetazzo" target="_blank">Jérôme Petazzoni</a></strong> </div>
