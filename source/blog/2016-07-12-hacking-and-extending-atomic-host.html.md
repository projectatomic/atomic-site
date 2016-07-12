---
title: Hacking and extending Atomic Host
author: jlebon
date: 2016-07-12 17:00:00 UTC
comments: true
published: true
tags: atomic, atomic host, hacking, ostree, rpm-ostree
---
Many of the features that make Atomic Host great are due to the immutability of
`/usr`. Things like atomic upgrades and rollbacks and efficient storage of files
in an object store all require immutability. However, this immutability is also
what can irritate people the most when they first start using Atomic Host.
There is no `yum` or `dnf` to install programs.  We are at the mercy of the
content provider.

The answer of course is to use containers. Keep a "pet" SPC container around
that will allow you to do all the configuration and hacking you need, all in the
comfort of your favourite editor.

But if you're hacking on the Atomic Host **itself**, containers can only take
you so far. What if you want to change the version of docker on the host? Or
install a new package? Or modify an installed Python script for debugging?

READMORE

The latest releases of [OSTree](http://ostree.readthedocs.org/) and
[rpm-ostree](http://rpm-ostree.readthedocs.org/) have acquired some new features
that makes hacking and extending Atomic Host much easier. These features are
OSTree system unlocking and rpm-ostree package layering. They both answer this
need for easier Atomic Host mutation, but in a completely different way.

### OSTree system unlocking

This feature was actually introduced in
[v2016.4](https://github.com/ostreedev/ostree/releases/tag/v2016.4) on March 23,
2016. It is already in both Fedora and CentOS Atomic Host. In a nutshell, system
unlocking allows you to make temporary changes to the `/usr` mount. To do this,
you simply use the `ostree admin unlock` command:

```
-bash-4.2# ostree admin unlock
Development mode enabled.  A writable overlayfs is now mounted on /usr.
All changes there will be discarded on reboot.
```

We can now do things like:

```
-bash-4.2# touch /usr/woohoo && echo "success"
success
-bash-4.2# rpm --install strace-4.8-11.el7.x86_64.rpm
-bash-4.2# strace -V
strace -- version 4.8
```

The `ostree admin status` will also have an updated status output:

```
-bash-4.2# ostree admin status
* centos-atomic-host 675583e7db81b59a08e0bbfb3735bddde9d768f9f4500b845799c7e97ab71091.1
    Version: 2016.0.169
    Unlocked: development
    origin refspec: centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
```

As mentioned in the command output, changes are actually written to an
overlayfs:

```
-bash-4.2# ls /var/tmp/ostree-unlock-ovl.45GXKY/upper/
bin  share  woohoo
```

These changes are all erased at reboot, though they can be made permanent by
using the `--hotfix` flag. This will make OSTree push back the current
deployment as the rollback (so that you can go back to the immutable deployment
from which you started) and unlock the current deployment:

```
-bash-4.2# ostree admin unlock --hotfix
Copying /etc changes: 34 modified, 8 removed, 44650 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Hotfix mode enabled.  A writable overlayfs is now mounted on /usr
for this booted deployment.  A non-hotfixed clone has been created
as the non-default rollback target.
-bash-4.2# ostree admin status
* centos-atomic-host 675583e7db81b59a08e0bbfb3735bddde9d768f9f4500b845799c7e97ab71091.0
    Version: 2016.0.169
    Unlocked: hotfix
    origin refspec: centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
  centos-atomic-host 675583e7db81b59a08e0bbfb3735bddde9d768f9f4500b845799c7e97ab71091.1
    Version: 2016.0.169
    origin refspec: centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
```

Note however, that there can be issues from unlocking due to its use of
overlayfs. Most notably, Docker does not currently work with SELinux and
OverlayFS (see the related Trello card
[here](https://trello.com/c/wLlFD9HN/134-8-add-selinux-labeling-support-to-overlayfs)).

The other caveat is that a hotfix is only as permanent as its associated
deployment. Thus, as soon as you create a new deployment (e.g. through
`rpm-ostree upgrade/rebase/deploy`), the overlayed hotfixed **are not** carried
over, but simply lost.

### Package layering in rpm-ostree

This is a relatively much newer feature than system unlocking. It's part of
[v2016.4](https://github.com/projectatomic/rpm-ostree/releases/tag/v2016.4),
released 4 days ago. There are [updates
pending](https://bodhi.fedoraproject.org/updates/FEDORA-2016-bfecf6abed) in
Fedora's Bodhi system awaiting your karma. The feature itself has been in the
works for a while now, with development starting more than a year ago.

Package layering does exactly what it says; it allows you to extend the base
distribution of RPM packages you receive from your content provider with your
own packages of choice. In contrast to system unlocking, these additional
"layered" packages **are** carried over during upgrades, making it great for
when your particular system requires an additional package to work correctly.

To use package layering, you can invoke the new `pkg-add` command of
`rpm-ostree`:

```
-bash-4.2# rpm-ostree pkg-add strace
notice: pkg-add is a preview command and subject to change.
Need to overlay 1 package onto tree 675583e:
  strace

Downloading metadata: [===================================================] 100%
Resolving dependencies... done
Transaction: 1 packages
  strace-4.8-11.el7.x86_64 (base)
Will download: 1 package (271.5 kB)

  Downloading from base: [================================================] 100%

Importing: [==============================================================] 100%
Checking out tree 675583e... done
Overlaying... done
Writing rpmdb... done
Writing OSTree commit... done
Copying /etc changes: 34 modified, 8 removed, 44651 added
Transaction complete; bootconfig swap: no deployment count change: 0
Freed objects: 26.0 MB
Added:
  strace-4.8-11.el7.x86_64
Run "systemctl reboot" to start a reboot
-bash-4.2# reboot
```

Once we're rebooted, we can make use of the new package:

```
-bash-4.2# strace -V
strace -- version 4.8
```

The status output of `rpm-ostree` will now also reflect this layering (which by
the way received a face lift in this release):

```
-bash-4.2# rpm-ostree status
State: idle
Deployments:
* centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
       Version: 2016.0.169 (2016-07-12 16:26:00)
    BaseCommit: 675583e7db81b59a08e0bbfb3735bddde9d768f9f4500b845799c7e97ab71091
        Commit: e0291b49619645d4df95c0924a48932f217b0ed4680656ebd47c1b17640a62ee
        OSName: centos-atomic-host
  GPGSignature: (unsigned)
      Packages: strace

  centos-atomic-continuous:centos-atomic-host/7/x86_64/devel/continuous
       Version: 2016.0.169 (2016-07-11 21:51:17)
        Commit: 675583e7db81b59a08e0bbfb3735bddde9d768f9f4500b845799c7e97ab71091
        OSName: centos-atomic-host
  GPGSignature: (unsigned)
```

Not surprisingly, packages that were layered using `pkg-add` can also be later
removed by invoking the `pkg-remove` command, left here as an exercise to the
reader.

Under the hood, `rpm-ostree` takes care of many subtleties, including safely
running RPM `%post` scripts using
[bubblewrap](https://github.com/projectatomic/bubblewrap) to ensure that the
OSTree system repo remains uncorrupted, and obeying expected RPM rules (e.g.
layering a package that conflicts with an existing package will error out).

To summarize, the power that package layering gives you is the ability to
customize the package set on particular hosts *without having to ship it to all
hosts*.

Finally, note that package layering is currently in preview mode, which means
that it is subject to change, though we will do our best to retain backwards
compatibility with layered deployments created with the v2016.4 release.

### Bonus section: CentOS Atomic Host Continuous (CAHC)

You might have been wondering what this `centos-atomic-continuous` remote was
about in the command outputs above. The [CentOS Atomic
SIG](https://wiki.centos.org/SpecialInterestGroup/Atomic) has set up an
automated job that continuously composes ostree repos using the latest code from
the git master of various Project Atomic components, such as `atomic`, `ostree`,
and `rpm-ostree`.

This means that within the hour, you can experience the latest and greatest
Atomic Host has to offer. For example, if you'd like to try out package layering
right away, you can simply rebase onto CAHC and reboot. For more information and
instructions, see the [devel wiki
page](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel).
