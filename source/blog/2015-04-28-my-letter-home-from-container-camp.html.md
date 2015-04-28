---
title: My Letter Home from Container Camp
author: jbrooks
date: 2015-04-28 17:47:17 UTC
tags: docker, atomic, containercamp
comments: true
published: true
---

![Container Camp](containercamp.png) Just over a week ago, I headed to the outskirts of San Francisco's Financial District to attend [Container Camp](http://container.camp), a one-day, single-track conference focused primarily on the Docker ecosystem. 

The Container Camp lineup included a nice mix of project talks and real user stories that left me looking forward to attending the next time the crew comes to town, and thinking back on the key issues raised during the event.

First, as anyone who’s ventured beyond running Docker containers on a personal laptop or in some other single host scenario has experienced, maintaining the sort of automagical delight that’s powered Docker’s popularity while expanding to a cluster of hosts can be quite a challenge. 

As several of the Container Camp speakers pointed out, the networking, storage, and scheduling tasks that “just work” in a single host context require more planning and choices. Fortunately, the project and product communities clustered around Docker have come up with many different, compelling options for filling these gaps.

Possibly the most dramatic example of this diversity in Docker solutions came in [the talk](https://youtu.be/Ll50EFquwSo) that kicked off the day, from Joyent CTO [Bryan Cantrill](https://twitter.com/bcantrill), which sped through a brief history of hardware and OS virtualization en route to an introduction to his company’s new elastic container service, [Triton](https://www.joyent.com/blog/triton-docker-and-the-best-of-all-worlds). 

Cantrill mentioned that Joyent, which builds on the OS, storage and network virtualization work that appeared in Solaris before Oracle eclipsed Sun Microsystems, had been doing containers before containers were cool. Rather than rest on this lineage, Joyent has worked to make regular, Linux-based Docker containers run on its Solaris-derived platform, using a revamped version of the Linux-emulating [BrandZ](http://www.slideshare.net/bcantrill/illumos-lx) technology.

As Cantrill detailed, Docker’s remote API was one of the keys to delivering a native-seeming Docker experience on the Joyent platform -- a theme that reappeared in a talk centered on [Powerstrip](https://clusterhq.com/blog/powerstrip-prototype-docker-extensions-today/), an HTTP proxy for the Docker API that allows developers to plug multiple Docker extension prototypes into the same Docker daemon. 

[In that talk](https://youtu.be/bAw2djOLGA0), [Luke Marsden](https://twitter.com/lmarsden), CTO of ClusterHQ, demonstrated how to use Powerstrip to extend the multi-node networking and storage capabilities of a Docker Swarm cluster with [Weave](https://github.com/weaveworks/weave) and [Flocker](https://github.com/ClusterHQ/flocker), respectively. (Since the conference, ClusterHQ has added [another version](https://clusterhq.com/blog/data-migration-kubernetes-flocker/) of this demo to its blog, swapping out Swarm for Kubernetes.)

Flocker’s main offering “wraps” the docker command, as does Weave and several other tools in this space, including our own [Atomic command](http://developerblog.redhat.com/2015/04/21/introducing-the-atomic-command/). With Powerstrip, it’s possible to stack together multiple docker-extending components, for prototyping purposes, at least.

Marsden demonstrated a simple application with web and database containers, along with a data-only container for the database state. Using Flocker and ZFS on Linux, Marsden migrated database container and its data container from one host to another. The operation isn’t quite as seamless as a VM-style live migration, but can be reasonably close, depending on the size of the data volume in motion.

Eventually, Marsden explained, adapters prototyped in Powerstrip will become proper extensions based on a [still-in-progress](http://weaveblog.com/2015/04/23/weave-as-a-docker-extension/) docker framework. As this framework begins to solidify, I’m keen to see to what extent the Atomic command might be implemented as an extension.

Continuing with the theme of extensibility at the conference, I was reminded  how, in the Docker ecosystem, applications and system services alike partake in the same containerized hosting model. Flocker, Weave and Powerstrip run in containers, and the same is true for many other projects in this field. 

As a result, these various Docker+Friends projects are relatively easy to mix and match, which makes it easier to experiment with different components -- a serious benefit, given the relatively early state of container clustering. These projects, along with others, such as [Kolla](https://github.com/stackforge/kolla), an effort focused on deploying OpenStack services using Docker containers, have me excited about pushing the bounds of what we’ll containerize.

Pushing the bounds of what we run in containers was the sort of ground that [Jessie Frazelle](https://twitter.com/frazelledazzell) covered in her conference-concluding talk entitled, [“Willy Wonka of Containers.”](https://youtu.be/GsLZz8cZCzc) Frazelle threw a range of unlikely graphical applications at her Debian notebook’s docker daemon, from LibreOffice to Chrome, and ended up running a Steam game from a container.

Her presentation’s mad scientist vibe called to mind [Jim Perrin’s](https://twitter.com/bitintegrity) [bone-chilling presentation](https://youtu.be/m9H4vGzYoeo?t=6h11m) from [SCALE](http://www.socallinuxexpo.org/scale/13x) this year, in which he outlined the assorted evil-doing he’s committed with Docker in the service of legacy app support. It may be a good idea to keep these two apart...