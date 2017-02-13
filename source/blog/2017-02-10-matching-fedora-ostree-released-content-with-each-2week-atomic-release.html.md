---
title: 'Matching Fedora OSTree Released Content With Each 2 Week Atomic Release'
author: dustymabe
date: 2017-02-13 12:00:00 UTC
tags: fedora, atomic, ostree
published: true
comments: true
---

***TL;DR***: The default Fedora cadence for updates in the RPM streams is once a
             day. Until now, the OSTree-based updates cadence has matched this, but
             we're changing the default OSTree update stream to match the
             Fedora Atomic Host image release cadence (once every two weeks).

READMORE

---

In Fedora we release a new Atomic Host approximately every two weeks. In the
past this has meant that we bless and ship new ISO, QCOW, and Vagrant images that
can then be used to install and or start a new Atomic Host server. But
what if you already have an Atomic Host server up and running?

Servers that are already running are configured to get their updates
directly from the OSTree repo that is sitting on Fedora Infrastructure
servers. The client will ask ***What is the newest commit for my
branch/ref?*** and the server will kindly reply with the most recent commit.
If the client is at an older version then it will start to pull the
newer commit and will apply the update.

This is exactly how the client is supposed to behave, but one problem
with the way we have been doing things in the past is that we have
been updating everyone's branch/ref every night when we do
our updates runs in Fedora.

This has the side effect of meaning that users can get content as soon
as it has been created, but it also means that the two week release
process where we perform testing and validation really means nothing
for these users, as they will get something before we ever did testing
on it.

We have decided to slow down the cadence of the
`fedora-atomic/25/x86_64/docker-host` ref within the OSTree
repo to match the exact releases that we do for the two week release
process. Users will be able to track this ref like they always have,
but it will only update when we do a release, approximately every
two weeks.

We have also decided to create a new ref that will get updated every
night, so that we can still do our testing. This ***ref*** will be called
`fedora-atomic/25/x86_64/updates/docker-host`. If you want to keep
following the content as soon as it is created you can rebase to this
branch/ref at any time using:

```
# rpm-ostree rebase fedora-atomic/25/x86_64/updates/docker-host
```

As an example, let's say that we have a Fedora Atomic host which is on
the default ref. That ostree will now be updated every two weeks, and only
every two weeks:

```
-bash-4.3# date
Fri Feb 10 21:05:27 UTC 2017

-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.51 (2017-01-30 20:09:59)
        Commit: f294635a1dc62d9ae52151a5fa897085cac8eaa601c52e9a4bc376e9ecee11dd
        OSName: fedora-atomic

-bash-4.3# rpm-ostree upgrade
Updating from: fedora-atomic:fedora-atomic/25/x86_64/docker-host
1 metadata, 0 content objects fetched; 569 B transferred in 1 seconds
No upgrade available.
```

If you want the daily ostree update instead, as you previously had, you need
to switch to the _updates_ ref:

```
-bash-4.3# rpm-ostree rebase --reboot fedora-atomic/25/x86_64/updates/docker-host

812 metadata, 3580 content objects fetched; 205114 KiB transferred in 151 seconds                                                                                                                                                           
Copying /etc changes: 24 modified, 0 removed, 54 added
Connection to 192.168.121.128 closed by remote host.
Connection to 192.168.121.128 closed.

[laptop]$ ssh fedora@192.168.121.128
[fedora@cloudhost ~]$ sudo su -
-bash-4.3# rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/25/x86_64/updates/docker-host
       Version: 25.55 (2017-02-10 13:59:37)
        Commit: 38934958d9654721238947458adf3e44ea1ac1384a5f208b26e37e18b28ec7cf
        OSName: fedora-atomic

  fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.51 (2017-01-30 20:09:59)
        Commit: f294635a1dc62d9ae52151a5fa897085cac8eaa601c52e9a4bc376e9ecee11dd
        OSName: fedora-atomic

```

We hope you are enjoying using Fedora Atomic Host. Please share your
success or horror stories with us on the
[mailing](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
[lists](https://lists.fedoraproject.org/admin/lists/cloud.lists.fedoraproject.org/)
or in IRC: `#atomic` or `#fedora-cloud` on
[Freenode](https://freenode.net/).

Cheers!

The Fedora Atomic Team
