---
title: An Introduction to Fedora Atomic Workstation
author: jlebon
date: 2018-02-06 00:00:00 UTC
published: true
comments: false
tags: atomic, fedora, workstation, desktop
---

For the last few Fedora releases, the Workstation WG has been working on
combining the best of the Project Atomic pattern with the Fedora Workstation
Edition into a deliverable dubbed &quot;Fedora Atomic Workstation&quot;. In
Fedora 27, we have reached a point where we feel comfortable inviting other
developers and enthusiasts to try it out and even make it their daily driver.

Read on to discover what Fedora Atomic Workstation is, what its benefits are,
and how you can get started today!

Note: this blog post is based on a talk I gave at
[DevConf.cz 2018](https://devconf.cz/cz/2018). Head over to
[YouTube](https://www.youtube.com/watch?v=7c3GdfhWzcc) if you'd prefer listening
to it.

READMORE

# What is Atomic Workstation?

Just like Atomic Host, Atomic Workstation uses RPM-OSTree as its update manager.
However, Atomic Workstation is geared towards all the same use cases that the
regular Workstation Edition is meant to fulfill. Though there are some
differences between the two beyond the update model.

In an Atomic Workstation, desktop applications are shipped and run as
[flatpaks](https://flatpak.org/), and development mostly happens inside
containers. For example, you may have a pet container with your development
environment set up as well as an `oc cluster up` OpenShift cluster to develop
server applications.

# Why should I use Atomic Workstation?

So what are the advantages of this strategy? Many of the reasons below are
shared with Atomic Host. Though I will try to give a more Workstation-centric
point-of-view.

## 1. Transactional Updates

The main reason to use Atomic Workstation of course is transactional updates.
This is as relevant in the server case as it is for desktops. Most people would
consider their workstations to be the stereotypical pet system: set up and
customized just the way they want them, and a huge hindrance to productivity if
anything should happen to them. Using an update model which greatly reduces
[risks](https://www.happyassassin.net/2016/10/04/x-crash-during-fedora-update-when-system-has-hybrid-graphics-and-systemd-udev-is-in-update/)
of
[failures](https://bugzilla.redhat.com/show_bug.cgi?id=1398698) is thus well
justified.

I will not stay on this subject any longer since I assume readers of this blog
are familiar with the benefits there and what pitfalls the Atomic model helps us
avoid. If you are not familiar with these ideas, definitely check out the
[OSTree docs](http://ostree.readthedocs.io/en/latest/manual/introduction/)
and the
[Project Atomic update docs](http://www.projectatomic.io/docs/os-updates/) if
you'd like more information.

## 2. Immutability and Isolation

As discussed in
[a previous blog entry](../../../2016/07/hacking-and-extending-atomic-host/),
all the great features of an OSTree-based system require immutability of the
base OS. For example, `/usr` is *not* writable by default. This is equally true
in Atomic Workstation as it is in Atomic Host. This is a *good* thing, because
(1) it protects you from
[accidental damage](https://github.com/MrMEEE/bumblebee-Old-and-abbandoned/issues/123),
and (2) it encourages a healthier workflow.

For example, on `yum/dnf`-managed systems, RPM scriptlets run unconfined
*as root* during update transactions, which opens the door for accidental (or
intentional) corruption. On `rpm-ostree`-managed systems, all scriptlets are run
on the server when composing the update. (As mentioned lower down, we do also
support layering additional RPMs; their scriptlets are run in a locked down
container and cannot affect the running system).

By running your applications in flatpaks and doing your development in
containers, you not only help protect your base OS from harm but also minimize
the number of packages standing between you and a successful boot.

Basing your development workflow around pet containers could warrant a blog post
of its own. There have been some great talks around that area at DevConf.cz this
year (linked below).

## 3. Effortless Change Tracking

Now, part of customizing your workstation will undoubtedly require installing
packages that are not part of the base OSTree and aren't quite fit for
containerization (e.g. drivers, virtualization stacks, `$FAVOURITE_EDITOR`).
Because RPM-OSTree is a *hybrid* model, it understands both RPMs and OSTrees.
We can, for example, do `rpm-ostree install vim-enhanced libvirt-client` to
layer additional packages. `rpm-ostree status` will then show:

```
$ rpm-ostree status
State: idle
Deployments:
● faw27:fedora/27/x86_64/workstation
                   Version: 27.62 (2018-01-31 21:39:54)
                BaseCommit: a052d7482a186f1979f8bba90cfe1a1d0c13e75a43a416b580d2f2a83c18fe5a
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: libvirt-client vim-enhanced
```

In contrast to `dnf/yum`-managed systems, which provide a &quot;bag of
packages&quot; approach, `rpm-ostree status` allows to know *exactly* what we
changed from the base OSTree commit, and how to go back to the initial state (in
this case, `rpm-ostree uninstall libvirt-client vim-enhanced`).

For completeness, I will mention that RPM-OSTree not only supports pure
additions, but also *replacing* and *removing* base packages. All these changes
can equally be tracked in `rpm-ostree status` and easily reverted.

Additionally, because in the OSTree model configuration defaults are stored in
`/usr/etc`, one can also perform a simple diff to figure out which defaults were
changed (e.g. `diff /usr/etc /etc | less`).

## 4. Upstream Testing

Having updates delivered as concrete units allows the content provider to more
easily test them, which translates into a more stable operating system for end
users. In contrast, it's effectively impossible in the &quot;bag of
packages&quot; approach to sanely test all permutations. This mostly means that
testing is limited to the package-level.

In an OSTree model however, it's possible to gate updates on higher-level
integration tests such as what we've been doing in the two-week releases of
Fedora Atomic Host. Note though that Atomic Workstation updates are not
currently being gated on tests; we are still at the onset of these discussions.

## 5. Automatic Updates

In RPM-OSTree, we are currently working on adding an
[automatic update feature](https://github.com/projectatomic/rpm-ostree/issues/247).
Similar functionality on `dnf`-managed systems does
[exist](https://fedoraproject.org/wiki/AutoUpdates). The difference is that the
OSTree model allows us to eliminate or minimize
[many of the issues](https://fedoraproject.org/wiki/AutoUpdates#Reasons_AGAINST_using_automatic_updates)
involved in such a scheme. For example, the ability to roll back updates is
critical here, and this is something that RPM-OSTree does with ease.

In the future, we'd like to get to a point where (if enabled) the system
automatically prepares updates in the background and "upgrading" simply involves
rebooting your computer for minimal downtime.

# How can I get started with Atomic Workstation?

You can either
[download the ISO](https://dl.fedoraproject.org/pub/fedora/linux/releases/27/WorkstationOstree/x86_64/iso/)
and re-install from scratch, or you can convert your existing `dnf`-based system
using the steps from
[this](https://pagure.io/workstation-ostree-config/blob/master/f/README-install-inside.md)
document. The latter also allows you to switch back and forth between the two
models if you're not yet ready to dive in.

Once booted into Atomic Workstation, check out the &quot;Using the system&quot;
section [here](https://pagure.io/workstation-ostree-config). To learn more about
how to manage upgrades, check out the Project Atomic
[docs](http://www.projectatomic.io/docs/os-updates/) and the RPM-OSTree
[docs](http://rpm-ostree.readthedocs.io/en/latest/manual/administrator-handbook/).

If you need any help, you can pop into the `freenode/#atomic` channel, or send
an email to the
[atomic-devel](http://lists.projectatomic.io/mailman/listinfo/atomic-devel)
mailing list.

# More information

- [Fedora Change Proposal](https://fedoraproject.org/wiki/Changes/WorkstationOstree)
- [workstation-ostree-config](https://pagure.io/workstation-ostree-config)
- [Kalev Lember: Atomic Workstation](https://www.youtube.com/watch?v=Yc7lvkl5atE)
- [Sanja Bonic and Colin Walters: You want a Clean Desktop OS? Containerize it.](https://www.youtube.com/watch?v=a4IPWlf)
- [Jan Pazdziora: Minimizing workstation installation](https://www.youtube.com/watch?v=eWoFpOoA-tE)
