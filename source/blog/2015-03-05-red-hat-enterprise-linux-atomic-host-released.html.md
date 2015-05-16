---
author: jzb
title: Red Hat Enterprise Linux Atomic Host released
date: 2015-03-05 14:15 UTC
tags:
- RHEL
- Red Hat
- Release
- GA
categories:
- Blog
---
Red Hat [announced](http://developerblog.redhat.com/2015/03/05/announcement-rhel-atomic-host-ga/) the general availability of Red Hat Linux Enterprise Atomic Host earlier today. This pulls together work from Project Atomic and makes it ready for organizations that are looking to package and run applications based on Red Hat Enterprise Linux (RHEL) 6 and 7 as containers. 

This release includes all the components (Docker, Kubernetes, Flannel, systemd, etc.) that you need to [deploy a container-based architecture](http://rhelblog.redhat.com/2014/12/04/top-7-reasons-to-use-red-hat-enterprise-linux-atomic-host/) in an environment based on RHEL. 

Not quite sure about the benefits of containers? The RHEL folks are hosting a [virtual event on March 12th](http://www.redhat.com/en/about/events/transform-application-delivery-containers-red-hat-virtual-event). This features Tim Yeaton and Lars Herrman from Red Hat, and principal analyst Dave Bartoletti from Forrester. Odds are if you're following Project Atomic you're *already* pretty hip to the benefits fo containers, but if not &ndash; this should answer many of your questions.

## Getting RHEL Atomic Host

Interested in trying RHEL Atomic Host? Head over to the Red Hat [Customer Portal](https://access.redhat.com/products/red-hat-enterprise-linux/atomic-host) and grab the installation media and [read up](https://www.redhat.com/en/resources/red-hat-enterprise-linux-atomic-host) on the offering. You can download installation media and test it out with out a RHEL subscription.

## More Fun Ahead

The fun doesn't stop with the RHEL Atomic Host release, of course. We are still working on getting Fedora Atomic Host ready for the Fedora 22 release, and the [CentOS SIG](http://wiki.centos.org/SpecialInterestGroup/Atomic) is continuing to work on CentOS Atomic Host as well. Naturally, the work in Fedora and CentOS will benefit future RHEL Atomic Host releases. 

The alpha for the Fedora 22 Cloud edition, including Atomic, should be released in the next week or two (the schedule currently calls for 10 March). A new CentOS image should be out in the next day or two, including some additional image types! 

Have questions, or want to get involved in Project Atomic? Here's where to find us:

 * The [Atomic](https://lists.projectatomic.io/mailman/listinfo/atomic) mailing list is for discussions around using Atomic Hosts or containers on Atomic.
 * The [Atomic-Devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) mailing list is for discussions around building Atomic Hosts and the Atomic Host Definition.
 * The [CentOS-Devel](http://lists.centos.org/mailman/listinfo/centos-devel) mailing list is where CentOS-specific discussions happen.
 * The [Fedora Cloud](https://admin.fedoraproject.org/mailman/listinfo/cloud) mailing list is where Fedora-specific discussions happen.
 * Chat with us real-time in #atomic on Freenode.

And, as always, ping me directly (jzb, at RedHat.com) if you can't find what you need elsewhere! 
