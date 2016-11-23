---
title: Fedora Atomic 25 released
author: jberkus
date: 2016-11-22 20:00:00 UTC
published: true
comments: true
tags: atomic, fedora, docker
---

[Fedora 25](https://fedoramagazine.org/fedora-25-released/) has been released,
including [Fedora Atomic 25](https://getfedora.org/en/atomic/), the latest build of
Fedora's container platform.  Among the features added in this build are:

* [Package Layering](http://www.projectatomic.io/blog/2016/07/hacking-and-extending-atomic-host/)
* [Docker 12.1](https://blog.docker.com/2016/06/docker-1-12-built-in-orchestration/)

You can install Fedora Atomic 25 by any of the various methods listed
on [the GetFedora Atomic page](https://getfedora.org/en/atomic/).  You can also
upgrade an existing server to Atomic 25 from version 24:

```
-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/24/x86_64/docker-host
       Version: 24.78 (2016-11-10 02:57:50)
        Commit: 5ac1aee3c8810f4da27b0dee0c70899409602b3bf6ef47c60ee23600be795d47
        OSName: fedora-atomic

-bash-4.3# ostree remote add --set=gpg-verify=false fedora-atomic-25 \
   https://dl.fedoraproject.org/pub/fedora/linux/atomic/25/
-bash-4.3# rpm-ostree rebase fedora-atomic-25:fedora-atomic/25/x86_64/docker-host

2037 metadata, 10860 content objects fetched; 293397 KiB transferred in 301 seconds
Copying /etc changes: 24 modified, 0 removed, 49 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Freed objects: 18.7 kB
Changed:
  NetworkManager 1:1.2.4-3.fc24 -> 1:1.4.2-1.fc25
...
timedatex-0.4-2.fc24.x86_64
Run "systemctl reboot" to start a reboot

-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic-25:fedora-atomic/25/x86_64/docker-host
       Version: 25.42 (2016-11-16 10:26:30)
        Commit: c91f4c671a6a1f6770a0f186398f256abf40b2a91562bb2880285df4f574cde4
        OSName: fedora-atomic

  fedora-atomic:fedora-atomic/24/x86_64/docker-host
       Version: 24.78 (2016-11-10 02:57:50)
        Commit: 5ac1aee3c8810f4da27b0dee0c70899409602b3bf6ef47c60ee23600be795d47
        OSName: fedora-atomic

```

Package Layering is a feature which allows the installation of groups of packages
on a running Atomic system without breaking upstream updateability.  It requires
that the packages be available from a configured repo.  As a trivial example, since
I'm an emacs guy, I wanted to install emacs on my kuberntes master so that
I can edit my kubernetes configuration files with it:

```
-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.26 (2016-10-15 10:27:51)
        Commit: c972fb623bd7973aa26f2dc6703a398719d39410191a2aad1943733ac54a9c5d
        OSName: fedora-atomic
-bash-4.3# rpm-ostree pkg-add emacs-nox

Downloading metadata: [===========================] 100%
Resolving dependencies... done
Will download: 7 packages (42.7 MB)

  Downloading from fedora: [======================] 100%

Importing: [====================================] 100%
Checking out tree c972fb6... done
Overlaying... done
Running %post for emacs-common...... done
Running %posttrans for emacs-common...... done
Running %posttrans for emacs-nox...... done
Writing rpmdb... done
Writing OSTree commit... done
Copying /etc changes: 25 modified, 0 removed, 50 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Freed 1 pkgcache branch: 67.4 kB
Added:
  alsa-lib-1.1.1-2.fc25.x86_64
  emacs-common-1:25.1-2.fc25.x86_64
  emacs-nox-1:25.1-2.fc25.x86_64
  gpm-libs-1.20.7-9.fc24.x86_64
  libjpeg-turbo-1.5.1-0.fc25.x86_64
  liblockfile-1.09-4.fc24.x86_64
Run "systemctl reboot" to start a reboot
-bash-4.3# systemctl reboot

...

-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.26 (2016-11-23 00:39:02)
    BaseCommit: c972fb623bd7973aa26f2dc6703a398719d39410191a2aad1943733ac54a9c5d
        Commit: 82b69e3d34f4b1389126f0c57e03175a7c60f935da19f0285e0beef4476207b7
        OSName: fedora-atomic
      Packages: emacs-nox

  fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.26 (2016-10-15 10:27:51)
        Commit: c972fb623bd7973aa26f2dc6703a398719d39410191a2aad1943733ac54a9c5d
        OSName: fedora-atomic
-bash-4.3# emacs --version
GNU Emacs 25.1.1
```

In the next couple weeks, we'll post on how to use package layering to install
your chosen release of Kubernetes, how to deploy Docker Swarm on Atomic, and other
things you can do with the new release.  In  the meantime, download and
play with it yourself.
