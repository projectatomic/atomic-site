---
title: Report on the Container Roundtable @ LinuxCon EU 2015
author: bexelbie
date: 2015-10-12 00:52:32 UTC
tags: Docker, Event
comments: true
published: true
---

At [LinuxCon Europe 2015](http://events.linuxfoundation.org/events/linuxcon-europe) from 5-7 October, 2015 in Dublin, Ireland. Joe Brockmeier (Red Hat) moderated a panel discussion between Tom Barlow (Docker), Sebastian Goasguen (Citrix) and Brandon Philips (CoreOS) about containers.  As you may know, the technology underlying containers is not new and that a big part of the innovation provided by Docker and others is essentially an easier way to package and access this technology.  However, there are key questions ahead as the technology continues to mature and transcend the "it's just packaging" idea.  I didn't transcribe the entire session, but I wanted to call out a few of the exchanges and how they affect various roles.

READMORE

First the difference between application containers and system containers was stressed by Brandon from CoreOS and agreed with by the panel.  System containers are characterized by the use of an init system and typically contain multiple pieces of an application and supporting services like ssh.  This is treating containers as lightweight virtual machines.  This was the original pattern that many users adopted, but it is now seen as sub-optimal.  Application containers, on the other hand, are based on the idea of one microservice (or service or application component) per container.  This model allows for more library independence, easier scaling and development.

Wearing my operations hat, I particularly liked an exchange that started with a question about whether we are actually moving backwards from packaging and forgetting the 20 years of lessons we have learned with technology like RPM and apt.

  * Brandon responded by saying that in his opinion RPM and apt failed because they are great for distributions, but not for custom apps.  Building software is complex and people resort to wget/rsync/git checkout instead of trying to package their applications.  Containers recognize this, although, as he acknowledged, you are giving up updates and auditability today.
  * Sebastian noted that there is a big trust issue that needs to be talked about.  DockerHub is an amazing resource and deploying apps has never been this easy, but we need to go further and ensure we have trust, signatures and upgradability.  He also acknowledged that the goal of trust is not necessarily fully realized today.  Every time we install a javascript library, for example, with npm, we are probably not really doing our full due diligence in verifying the package.  So we need to get the container model quickly to one where trusted images are running in production.
  * Tom extended these thoughts by saying that we need to develop and apply a "ton" of best practices.  We are still seeing multi-gig images that haven't been stripped of dev/test dependencies.  Signed images and trust from a vendor are required and need to be gotten.  Notary is a good idea, but we need to go beyond GPG signing because of the risk of key compromise.  Today, Notary is not going to introspection and will still rely on external tools.  This is on the roadmap and is important.

As a developer, a question about service discovery was very interesting to me.

  * Brandon noted that time has been spent on high-availability and fail-over and that they work fine on a small scale.  However, containers really should be using service discovery because we can do heterogeneous service composition (i.e. 80% stable build, 10% beta build, 10% experimental) in the same application.  This is a new enablement opportunity.
  * Tom offered that service discovery is more of a spectrum.  Some applications will use traditional methods, like DNS, and will be unaware they are in a container, others will use a platform or orchestration provided service discovery mechanisms, like SkyDNS, and be more "container native."  We need more documentation on this and we need to make things like SkyDNS easier to use.
  * Sebastian added that IBM had an Autonomic Computing Initiative that provided self-discovery, healing, etc.  Containers are getting there.  Today you can you use something like registrator to rewrite an haproxy/nginx configuration and you are on your way.  This needs scale, but it works.  Before containers all of this was much harder.

A common question in my mind, and put to the panel, is "What do existing deployments look like?"

  * Brandon has found that most folks originally think application containers are cool.  Then when you add distributed systems, people are want Google-like infrastructure.  Orechestrators like swarm and kubernetes are pumping people up and getting them excited about the future.  However, today, CoreOS is mostly seeing people containerizing a small part of their application and experimenting with the build system before taking too big of a step forward.  While this will be slow, the benefit we get with containers is that because the technology decomposes nicely.  Therefore, it is easy to use this kind of a "small-test and see" strategy.
  * Tom is seeing similar use cases at the start.  Typically they are seeing people containerize their jenkins and then their jenkins agents.  There is still a bit of fear and this seems like the least risky way to approach the technology.  Companies that can easily get to or already have microservices are currently the best use cases.
  * Sebastian opined that building an image from a Dockerfile and pushing it is very fast.  He is also seeing people update the small bits in the tests they are running.  For example, instead of migrating more of their application to containers, they will update from log paths to log drivers in the tiny part they have already moved and see how it goes.

Naturally, you have to ask technologists what they think is coming next, and give the audience a view into their crystal balls. 

  * Brandon says we need to develop clear paths from RPM/apt content to containers that allow continuous integration systems (jenkins, etc.) to build them.  This is what the [Open Container Initiative](https://www.opencontainers.org/) is doing by addressing build, ship and sign.  We also need to evolve how containers get into production.  There are lots of "tricky" bits that need to get sorted out and the road will be bumpy for a few years.
  * Tom believes that there is now an interesting contract between an application and the infrastructure.  Projects like prometheus make it easier to monitor containers because of this contract.  This can be leveraged by other tools.  We also need to see how things like logging can be made easier and abstracted out for developers as part of this contract.  Additional storage solutions should come online and the challenges around service discovery, networking, signing and security should start to resolve.  Docker expects to see content trust and other innovations supplement package management and signing.
  * Sebastian has seen thinking there is an ongoing shift from a machine management orientation to an application management orientation.  We are going to see much better monitoring and management systems which will move operations up the stack to really managing and operating applications.  Multi-container applications are going to be complex and specifications like nulecule will help resolve this.

I am very grateful to the panelists for this thoughtful and informed conversation.  Joe did a great job keeping the questions on the technology and not the companies and the panelists did a great job of answering in ways that can guide us as users, whether we are customers or not.  I also want to thank the organizers for making this a keynote session so I didn't have to choose between other sessions at the conference and this one.
