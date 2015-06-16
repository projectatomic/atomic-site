---
title: Why Red Hat is Shipping Docker 1.6
author: dwalsh
date: 2015-05-20 20:24:04 UTC
tags: Docker, CVE, Security
comments: true
published: true
---

We attempt to ship new versions of Red Hat Enteprise Linux Atomic Host (RHELAH) every six weeks. I am in charge of the Docker portion of each release. I also lead the team developing the [atomic](http://www.projectatomic.io/docs/usr-bin-atomic/) command. As a major component of the RHELAH release, we want to include the most recent Docker release possible to our users. 

However, just because Docker releases a new version does not mean this instantly gets into the RHEL release. We need to allow our QE team time for testing, and to make sure it is "Enterprise Ready."  Towards the end of the most recent six week period Docker released an updated Docker 1.6.1 package with a series of [CVEs](http://www.openwall.com/lists/oss-security/2015/05/07/10). 

Naturally, Red Hat's Security Response Team (SRT) analysed these CVEs to see if we needed to hold up the release to include Docker 1.6.1. After careful analysis, SRT decided that the potential threat posed by these CVEs was *not* a real risk to users who deploy containers responsibly.

Trevor Jay, from Red Hat Security, states:

 > Technically speaking, these don't cross any trust boundaries. Docker images are root-run software. They can drop or restrict permissions and capabilities so that you're protected should they become compromised just like any other software that starts with elevated privileges, but you are inherently trusting the image itself to be well-written (to take advantage of the safeties we provide) and non-malicious.

 > This is all about trusting the application you install on your system. Sometimes I worry people have the opinion that any piece of software I install, as long as it is in a container I am safe.  I believe Docker is playing whack a mole with these vulnerabilities and preventing this is going to be near impossible.

 > Container safety is about restricting what can happen when your application gets owned, not about randomly running potential malware.

## Verify, then Trust

I don't want to sound like a broken record, but [I've covered this before](http://www.projectatomic.io/blog/2014/11/docker-s-new-security-advisories-and-untrusted-images). The problem isn't the privilege escalation, it's that users are running untrusted images and expecting Docker to protect them against potentially malicious software.

Docker shouldn't be about running random crap from the Internet (as root, no less!) and expecting not to be hacked. 

Make no mistake, we will do everything we can to have a timely (but tested) asynchronous release when we identify real security vulnerabilities in the software we ship. These "vulnerabilities," however, are easily prevented by sane computing practices.