---
author: jzb-lars
comments: true
layout: post
title: The Difference Between Project Atomic and Atomic Hosts
date: 2014-05-15 20:18 UTC
tags:
- Atomic
- RHEL
- Enterprise
- Docker
- Fedora
- CentOS
categories:
- Blog
---
Project Atomic has been getting a great deal of attention since it was announced at Red Hat Summit this April. We saw a lot of enthusiasm at Summit for the concept of Atomic Hosts that are focused on running Docker containers, but still built from a well-known, well-tested distribution. 

One thing we've seen, though, is a little confusion about the separation between Project Atomic and **Atomic Hosts**. Project Atomic, itself, does not produce Linux OS releases. Instead, those will come from CentOS, Fedora, Red Hat, and potentially others.

## The Value of Upstream First

Red Hat's philosophy on driving technology innovation in upstream communities that then gets into the hand of customers in the form of robust products can be summarized as "upstream first." 

Over the last decade this philosophy has spurred rapid technology innovation, fueled by user needs, that is ultimately delivered in supportable enterprise-grade products. This ensures that the best-suited technical solution is generated in the open source development community. 

Project Atomic is designed around this philosophy. Not only does it strive to be a community for the technology behind optimized container hosts, it is also designed to feed requirements back into the respective upstream communities. By leaving the downstream release of Atomic Hosts to the Fedora community, CentOS community and Red Hat, it can focus on driving technology innovation.

## The Atomic Family

This is important to understand, because each of the offerings will differ in important ways, though they'll also be very similar.

First, the release cycle will vary depending on where you're getting your host. Release cycles are defined as a balance between the desire to deliver new features and enhancements and the ability of the target users to consume new releases. The release cycle for Red Hat Enterprise Linux Atomic Host (RHEL Atomic Host) will not match up with the release cycle for the Atomic offering from the Fedora Project. The RHEL Atomic Host release cycle will be suited for enterprise deployments, while the Fedora cycle will be more attuned to those doing leading edge development and testing newer technologies.

It also goes without saying that the actual content of the releases will also differ. Fedora's offering will likely move faster, include newer and consequently less proven and robust technologies. These technologies may then work their way into future productized versions of RHEL Atomic Host, in the same way that Fedora feeds into future versions of Red Hat Enterprise Linux. 

How Fedora and CentOS Atomic offerings evolve is also up to the respective communities. The [Fedora Cloud Special Interest Group](https://fedoraproject.org/wiki/Cloud_SI) (SIG) is still discussing exactly what packages will be included, how frequently releases will be generated, what type of images should be produced, and more. There's plenty of room for the larger community to be involved in those projects, and we welcome participation. (See the [Fedora wiki](https://fedoraproject.org/wiki/Cloud_SIG) for more info, or join us on IRC (#fedora-cloud) on Freenode, or join the mailing list.)

Similar community discussion is happening in the [CentOS community](http://wiki.centos.org/GettingHelp/ListInfo) to land the optimal balance for their users. 

## The Role of Project Atomic

Project Atomic gives the larger community a place and tools to collaborate on related technologies that are vital to Atomic Hosts, such as SELinux (http://www.projectatomic.io/docs/docker-and-selinux/) to secure your containers, GearD (http://www.projectatomic.io/docs/geard/) for container wiring and systemd integration and Cockpit (http://www.projectatomic.io/docs/cockpit/) to help manage containers. It also gives users of the various releases a forum to solve problems on using the technologies, keep tabs on important developments, and to participate in developing the technologies. 

The project will also serve to disseminate news about Atomic Host distributions and important changes in the upstreams like Docker, rpm-ostree, SELinux, and others. So be sure to keep an eye on this site and [@projectatomic](http://twitter.com/projectatomic).
