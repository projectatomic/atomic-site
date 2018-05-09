---
title: Latest rpm-ostree features
author: jlebon
date: 2018-03-20 17:00:00 UTC
tags: rpm-ostree, rpm, ostree, atomic, atomic host
comments: false
published: true
---

[rpm-ostree](https://rpm-ostree.readthedocs.org/) is the
hybrid image/package system that provides transactional
upgrades on Atomic Host.

This blog post is a high-level summary of the recent
features that were added in the last few releases.

READMORE

### New rojig delivery mechanism

By far the most fundamental shift that has occurred in the
latest releases is support for a different way of delivering
OSTrees to client machines. Dubbed "rojig", the idea is that
rather than clients downloading commits from OSTree remotes,
they instead re-assemble the exact same commit using RPMs
from yum repos. How? When OSTree commits are created on the
server, most of its files can be traced back to specific
RPMs. The work of figuring out which files come from which
RPM is done on the compose server. Files which do not come
from an RPM (e.g. the initramfs) are dumped in a special
"rojig RPM". Using this rojig RPM and all other constituent
RPMs, which are in essence fancy archives, the client is
capable of reproducing the bit-for-bit matching OSTree
commit.

This allows content providers to only worry about delivering
RPMs, rather than yet another format. It opens the doors to
the many established tools and services that exist for
organizing and distributing RPMs.

You can try this out today using the instructions in
[FAHC](https://pagure.io/fedora-atomic-host-continuous/):

```
$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.100 (2018-03-13 17:19:44)
                    Commit: 326f62b93a5cc836c97d31e73a71b6b6b6955c0f225f7651b52a693718e6aa91
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
$ cat >/etc/yum.repos.d/fahc.repo <<EOF
[fahc]
baseurl=https://ci.centos.org/artifacts/sig-atomic/fahc/jigdo
gpgcheck=0
EOF
$ rpm-ostree rebase --experimental rojig://fahc:fedora-atomic-host
...
Will download: 463 packages (349.5 MB)
  Downloading from updates: [=============] 100%
  Downloading from fedora: [=============] 100%
  Downloading from fahc: [=============] 100%
Importing (463/463) [=============] 100%
...
$ rpm-ostree status -v
State: idle; auto updates disabled
Deployments:
  fahc:fedora-atomic-host-27.406-1.fc27.x86_64
                   Version: 27.406 (2018-03-19 19:55:50)
                    Commit: 6495a62314ea2158240cba6a2cbb687bb6965a38d1c724ebdfaa63a13bf9ef73
                 StateRoot: fedora-atomic

● ostree://fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.100 (2018-03-13 17:19:44)
                    Commit: 326f62b93a5cc836c97d31e73a71b6b6b6955c0f225f7651b52a693718e6aa91
                 StateRoot: fedora-atomic
              GPGSignature: 1 signature
                            Signature made Tue 13 Mar 2018 05:19:53 PM UTC using RSA key ID F55E7430F5282EE4
                            Good signature from "Fedora 27 <fedora-27@fedoraproject.org>"
```

At no point in the above did we reach out to the
`fedora-atomic` remote for data. Yet, we match the exact
same checksum:

```
$ ostree remote summary fahc | grep -A2 fahc/27/x86_64/buildmaster
* fahc/27/x86_64/buildmaster
    Latest Commit (20.7 kB):
      6495a62314ea2158240cba6a2cbb687bb6965a38d1c724ebdfaa63a13bf9ef73
```

This is still a work in progress, though much of the
implementation has already been done. We're hoping to drive
this as an experimental option in a future release of
Fedora.

Upstream issue: https://github.com/projectatomic/rpm-ostree/issues/1081

### Automatic updates

Another major effort currently underway is a push for adding
support for automatic updates. As of the latest release,
rpm-ostree now supports a new `AutomaticUpdatePolicy`
configuration option with only two possible values: `off`
and `check`. In `check` mode, rpm-ostree will routinely
check the remote for updates and display any pending updates
in the output of `status`:

```
$ rpm-ostree status -v
State: idle; auto updates enabled (check; last run 56m ago)
Deployments:
● ostree://fedora:fedora/27/x86_64/workstation
                   Version: 27.94 (2018-03-16 16:33:28)
                    Commit: dc9d19682ca2414d5a76a9765a772d5f4d8f0d9768579ee434d742555168b40c
                 StateRoot: fedora
              GPGSignature: 1 signature
                            Signature made Fri 16 Mar 2018 12:33:36 PM EDT using RSA key ID F55E7430F5282EE4
                            Good signature from "Fedora 27 <fedora-27@fedoraproject.org>"

Available update:
        Version: 27.95 (2018-03-19 04:29:52)
         Commit: 6a99b39d701a243ec9668efe7511879df4697087869e913ec9f0a4d04fdffcb3
   GPGSignature: 1 signature
                 Signature made Mon 19 Mar 2018 12:30:00 AM EDT using RSA key ID F55E7430F5282EE4
                 Good signature from "Fedora 27 <fedora-27@fedoraproject.org>"
  SecAdvisories: FEDORA-2018-a068ade416  Critical   firefox-59.0.1-1.fc27.x86_64
       Upgraded: firefox 59.0-4.fc27 -> 59.0.1-1.fc27
                 osinfo-db 20170813-1.fc27 -> 20180311-1.fc27
```

As shown in the output above, it also includes open security
advisories and their severities.

This is only the start. The goal is to support fully
automated updates, including automatic reboots as well as a
"softer" pending mode where new deployments are created, but
reboots are initiated manually.

Upstream issue: https://github.com/projectatomic/rpm-ostree/issues/247

### Overrides no longer experimental

We have now straightened out the `override` commands enough
that we feel confident declaring it stable. For example, we
now support doing `override replace` to replace the kernel
itself. As a result it has been moved out of `ex`.

Upstream patch: https://github.com/projectatomic/rpm-ostree/pull/1089

### New kargs experimental feature

There is a new `kargs` command to make it easier to modify
kernel arguments. The feature is marked experimental for
now, and thus is found under the `ex` command. For more
information on `kargs`, check out Peter's blog post covering
it in details
[here](../../../2018/03/update-kernel-arguments-on-atomic-host/).

Upstream patch: https://github.com/projectatomic/rpm-ostree/pull/1013

### New cancel command

rpm-ostree now supports a new `cancel` command to cancel any
ongoing transaction. This is useful for cases where you lost
the controlling TTY from which you initiated the operation.

More fundamentally, this is a classic display of the power
of the background update mechanism in Atomic Host. You can
safely cancel an update at any time without affecting the
stability of your running system.

Upstream patch: https://github.com/projectatomic/rpm-ostree/pull/1019

### LiveFS support for full filesystem update

Previously, the experimental `livefs` command only worked
when the pending deployment had pure additions (e.g. a new
layered package). `livefs` now supports a `--replace` switch
to take this to the extreme and switch all of `/usr`. This
is essentially a big hammer, so use with care.

As usual, please remember that details of the `livefs`
command may change in a future release.

Upstream patch: https://github.com/projectatomic/rpm-ostree/pull/1028

### Other minor fixes and improvements

- The `upgrade`, `deploy`, and `rebase` commands learned new
  `--download-only` and `--cache-only` switches. This is
  analogous to `dnf`'s `--downloadonly` and `--cacheonly`
  switches, but extends to layered packages as well.
- Related to the previous item, a new `refresh-md` command
  was added to support refreshing the rpm-md. This is
  analogous to `dnf`'s `makecache` command.
- In the spirit of making rpm-ostree the only front-facing
  application, a new `usroverlay` command was added to take
  over the functionality of `ostree admin unlock`.
- The `compose tree` subcommand has now been split into
  three subcommands: `install`, `postprocess`, and `commit`.
  This can be used to more easily customize the rootfs
  before committing it to the OSTree repo.
- The `db diff` command now can use commit metadata to
  retrive package lists. This means that one no longer needs
  to have the full commit when performing diffs.
- The `status` command learned a new `--booted` switch to
  only display information about the booted deployment.
