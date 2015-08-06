---
title: El-Deko - Why Containers Are Worth the Hype
author: johnmark
date: 2015-08-05 17:23:28 UTC
tags: containers, docker, cloud native, kubernetes, openshift, atomic, open container
  initiative
comments: true
published: true
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/vqtnG1TBdxM" frameborder="0" allowfullscreen></iframe>

Video above from Kubernetes 1.0 Launch event at [OSCON](http://www.oscon.com/open-source-2015)

In the above video, I attempted to put Red Hat's container efforts into a bit of context, especially with respect to our history of Linux platform development. Having now watched the above video (they forced me to watch!) I thought it would be good to expound on what I discussed in the video.

Admit it, you’ve read one of the umpteen millions of articles breathlessly talking about the new Docker/Kubernetes/Flannel/CoreOS/whatever hotness and thought to yourself, "Wow, is this stuff overhyped." There is some truth to that knee-jerk reaction, and the buzzworthiness of all things container-related should give one pause - "It's turt^H^H^H^Hcontainers all the way down!"

READMORE

I myself have often thought how much fun it would be to write the Silicon Valley buzzword-compliant slide deck, with all of the insane things that have passed for “technical content” over the years, from Java to Docker and lots of other nonsense in between. But this blog post is not about how overhyped the container oeuvre is, but rather why it's getting all the hype and why - and this is going to hurt writing this - it's actually deserved.

IT, from the beginning, has been about doing more, faster. This edict has run the gamut from mainframes and microcomputers to PCs, tablets, and phones. From timeshare computing to client-server to virtualization and cloud computing, the quest for this most nebulous of holy grails, efficiency, has taken many forms over the years, in some cases fruitful and in others, meh.

More recently, efficiency has taken the form of automation at scale, specifically in the realm of cloud computing and big data technologies. But there has been some difficulty with this transition:

* The preferred base of currency for cloud computing, the venerable virtual machine, has proved to be a tad overweight for this transformation.
* Not all clouds are public clouds. The cloudies want to pretend that everyone wants to move to public cloud infrastructure NowNowNow. They are wrong.
* Existing management frameworks were not built for cloud workloads. It’s extremely difficult to get a holistic view of your infrastructure, from on-premises workloads to cloud-based SaaS applications and deployments on IaaS infrastructure.

While cloud computing has had great momentum for a few years now and shows no signs of stopping, its transformative power over IT remains incomplete. To complete the cloudification of IT, the above problems need to be solved, which involves rewriting the playbook for enterprise workloads to account for on-premises, hybrid and, yes, public cloud workloads. The entire pathway from dev to ops is currently undergoing the most disruption since the transition from mainframe to client-server. We’re a long ways from the days when LAMP was a thing, and software running on bare metal was the only means of deploying applications. Aside from the “L”, the rest of the LAMP stack has been upended with its replacements in the formative stages.

While we may not know precisely what the new stack will be, we can now make some pretty educated guesses:

* Linux (duh): It’s proved remarkably flexible, regardless of what new workload is introduced. Remember when [Andy Tanenbaum tried to argue in 1992](http://www.oreilly.com/openbook/opensources/book/appa.html) that "monolithic kernels" couldn’t possibly provide the modularity required for modern operating systems?
* Docker: The preferred container format for packaging applications. I realize this is now called the [Open Container Format](https://github.com/opencontainers/specs), but most people will know it as Docker.
* [Kubernetes](http://kubernetes.io/): The preferred orchestration framework. There are others in the mix, but Kubernetes seems to have the inside track, although its use certainly doesn’t preclude Mesos, et al. One can see a need for multiple, although Kube seems to be “core”.
* [OpenShift](http://www.openshift.org/): There’s exactly one open source application management platform for the Docker and Kubernetes universe, and that’s OpenShift. No other full-featured open source PaaS is built on these core building blocks.

In the interest of marketers everywhere, I give you the “LDKO” or “El-deko” stack. You’re welcome.

**Why This is a Thing**

The drive to efficiency has meant extending the life of existing architecture, while spinning up new components that can work with, rather than against, current infrastructure. After it became apparent to the vast majority of IT pros that applications would need to straddle the on-premises and public cloud worlds, the search was on for the best way to do this.

Everyone has AWS instances; everyone has groups of virtual machines; and everyone has bare metal systems in multiple locations. How do we create applications that can run on the maximum number of platforms, thus giving devops folks the most choices in where and how to deploy infrastructure at scale? And how do we make it easy for developers to package and ship applications to run on said infrastructure?

At Red Hat, we embraced both Docker and Kubernetes early on, because we recognized their ability to deliver value in a number of contexts, regardless of platform. By collaborating with their respective upstream communities, and then [rewriting OpenShift](http://www.openshift.org/#v3) to take advantage of them, we were able to create a streamlined process that allowed both dev and ops to focus on their core strengths and deliver value at a higher level than ever before. The ability to build, package, distribute, deploy, and manage applications at scale has been the goal from the beginning, and with these budding technologies, we can now do it more efficiently than ever before.

**Atomic: Container Infrastructure for the DevOps Pro**

In the interests of utilizing the building blocks above, it was clear that we needed to retool our core platform to be “container-ready,” hence [Project Atomic](http://projectatomic.io/) and its associated technologies:

* Atomic Host: The core platform or “host” for containers and container orchestration. We needed a stripped-down version of our Linux distributions to support lightweight container management. You can now use RHEL, CentOS, and Fedora versions of Atomic Host images to provide your container environment. The immutability of Atomic Host and its "atomic update" feature provides a secure environment to run container-based workloads.
* Atomic CLI: This enables users to quickly perform administrative functions on Atomic Host, including installing and running containers as well as performing an Atomic Host update.
* [Atomic App](http://github.com/projectatomic/atomicapp/): Our implementation of the [Nulecule](http://github.com/projectatomic/nulecule/) application specification, allowing developers to define and package an application and operations to then deploy and manage that application. This gives enterprises the advantage of a seamless, iterative methodology to complete their application development pipeline. Atomic App supports OpenShift, Kubernetes, and Just Plain Docker as orchestration targets "out of the box" with the ability to easily add more.

**Putting It All Together**

As demonstrated in the graphic below, the emerging stack is very different from your parents' Linux. It takes best of breed open source technologies and pieces them together into a cloud native fabric worthy of the "DevOps" moniker.

*El-Deko in All Its Glory*

![el-decko stack](/images/container-stack.png)

With our collaboration in the Docker and Kubernetes communities, as well as our rebuild of OpenShift and the introduction of Project Atomic, we are creating a highly efficient dev to ops pipeline that enterprises can use to deliver more value to their respective businesses. It also gives enterprises more choice:

* Want to use your orchestration framework? You can add that parameter to your Nulecule app definition and dependency graph.
* Want to use another container format? Add it to your Nulecule file.
* Want to package an application so that it can run on Atomic Host, Just Plain Docker, or OpenShift? Package it with Atomic App.
* Want an application management platform that utilizes all this cool stuff and doesn’t force you to manage every detail? OpenShift is perfect for that.
* Need to manage and automate your container infrastructure side-by-side with the rest of your infrastructure? [ManageIQ](http://manageiq.org/) is emerging as an ideal open source management platform for containers - in addition to your cloud and virtualization technologies.

As our container story evolves, we’re creating a set of technologies useful to every enterprise in the world, whether developer or operations-centric (or both). The IT world is changing quickly, but we’re pulling it together in a way that works for you.

**Where to Learn More**

There are myriad ways to learn more about the tools mentioned above:

* [projectatomic.io](http://projectatomic.io/) - All the Atomic stuff, in one place
* [openshift.org](http://openshift.org/) - Learn about the technology that powers the next version of OpenShift.com and download OpenShift Origin
* [manageiq.org](http://manageiq.org/) - ManageIQ now includes container management, especially for Kubernetes as well as OpenShift users

We will also present talks at many upcoming events that you will want to take advantage of:

* [ContainerCon](http://events.linuxfoundation.org/events/containercon) - new conference from the Linux Foundation, co-located with [LinuxCon North America](http://events.linuxfoundation.org/events/linuxcon-north-america). It will feature talks on Atomic as well as OpenShift.
* [USENIX Container Management Summit](https://www.usenix.org/conference/ucms15) - co-located with [USENIX LISA](https://www.usenix.org/conference/lisa15)
