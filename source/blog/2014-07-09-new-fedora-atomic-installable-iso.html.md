---
author: walters
layout: post
comments: true
title: New Fedora Atomic Installable ISO
date: 2014-07-09 20:10 UTC
tags:
- Fedora
- Host
- ISO
- Install
categories:
- Blog
---
If you've been hoping for a bare-metal version of a Fedora Atomic host, there's good news! I've finally gotten time to work on Fedora/Atomic more, and have created a functional installer ISO based on Fedora Rawhide. 

You can grab the ISO from [http://rpm-ostree.cloud.fedoraproject.org/project-atomic/install/rawhide/20140708.0/](http://rpm-ostree.cloud.fedoraproject.org/project-atomic/install/rawhide/20140708.0/). 

Unlike the other images we've produced for Atomic proof-of-concepts, this is designed to be installed on bare metal. None of the trees contain cloud-init, but this will install directly using Anacona to bare metal. 

It contains a cache of the tree content inside it, similar to how the Fedora DVD includes many packages, and the Fedora LiveCD just copies itself. 

## To Receive Updates 

To get updates after installation, you'll need to run a few commands:

    # ostree remote add fedora-atomic http://rpm-ostree.cloud.fedoraproject.org/repo`
    # atomic rebase fedora-atomic:`

Let me explain those two commands a bit more.  The first adds a new "remote" with the location of the current (hopefully temporary) OSTree repository.  (For more information on the temporary part, see: [https://lists.fedoraproject.org/pipermail/infrastructure/2014-June/014447.html](https://lists.fedoraproject.org/pipermail/infrastructure/2014-June/014447.html).

Now the second command is effectively shorthand for:

    atomic rebase fedora-atomic:fedora-atomic/rawhide/x86_64/server/docker-host

Basically that way you don't have to retype the branch name.  It's shorthand, because you could also rebase to one of the other available trees (such as server/virt-host).

An important next step here is going to be integrating cloud init by default so that we can use the same tree on both baremetal and cloud.  (Unlike mainline where cloud-init is a package only installed on the cloud images by default; we can't do that without ~doubling the number of trees right now).

If you have feedback, questions, or ideas on improving the Atomic host, please join the [atomic-devel mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel), ask over on [ask.projectatomic.io](http://ask.projectatomic.io), or leave a comment here. This is still a work in progress, and we're looking forward to your feedback! 
