---
title: Cockpit 125 Now Available
author: stef
date: 2016-11-28 16:00:00 UTC
published: true
comments: true
tags: cockpit, ostree, encryption, localization
---

Cockpit's [build 125 has been released](http://cockpit-project.org/blog/cockpit-125.html).

Cockpit is the modern Linux admin interface. We release regularly. Here
are the release notes from version 123, 124 and 125.


## Cockpit is now properly translatable

Cockpit is now properly translatable. It was a big task to extract
all the translatable strings and make translations work consistently
between the browser and installed tools like the bridge.

We now start also run the login user session with a proper locale and
LANG environment variables.

You can help [translate cockpit in Zanata](https://fedora.zanata.org/iteration/view/cockpit/master), or if you find text in the
front end that isn't translatable, then please do report it.

Changes:

*  [pull 5362](https://github.com/cockpit-project/cockpit/pull/5362)
*  [pull 5418](https://github.com/cockpit-project/cockpit/pull/5418)
*  [pull 5418](https://github.com/cockpit-project/cockpit/pull/5418)
*  [pull 5420](https://github.com/cockpit-project/cockpit/pull/5420)
*  [pull 1728](https://github.com/cockpit-project/cockpit/pull/1728)
*  [pull 5442](https://github.com/cockpit-project/cockpit/pull/5442)
*  [pull 5444](https://github.com/cockpit-project/cockpit/pull/5444)
*  [pull 5443](https://github.com/cockpit-project/cockpit/pull/5443)
*  [pull 5461](https://github.com/cockpit-project/cockpit/pull/5461)


Display OSTree signatures
-------------------------

Peter implement displaying OSTree tree signatures. You can tell where
a certain update tree came from and who signed it.

*  [Screenshot](http://cockpit-project.org/blog/images/ostree-signatures.png)
*  [Changes](https://github.com/cockpit-project/cockpit/pull/5433)

New expandable views for storage partitions
-------------------------------------------

Marius implemented expandable views in the *Storage* pages. These let
you dive into the details of a particular partition without having
to navigate away from the page describing where it lives.

*  [Screenshot](http://cockpit-project.org/blog/images/storage-listing.png)
*  [Changes](https://github.com/cockpit-project/cockpit/pull/5097)


Other storage fixes
-------------------

Marius did work to fix many other storage related bugs. In particular
Cockpit now deals properly with passphrases stored for LUKS encrypted
devices, and also no longer offers to format read-only block devices.

* [Changes](https://github.com/cockpit-project/cockpit/pull/5343)
* [more](https://github.com/cockpit-project/cockpit/pull/5097)


Full testing on RHEL 7.3, Ubuntu 16.04 and Debian 8 Jessie
----------------------------------------------------------

The Cockpit project started testing on Cockpit on RHEL 7.3, Ubuntu 16.04
and Debian 8 Jessie along the operating systems we tested earlier. These
will be part of our usual continuous integration, where we boot
thousands or tens of thousands of instances per day to test changes and
contributions.

Marius fixed many bugs we found, and filed operating system bugs in
the issue trackers for those operating systems.

You can see the which operating systems we test Cockpit on:

*  [pull 5445](http://cockpit-project.org/running.html)

There's no Debian Jessie repository yet, but hopefully we can have that
ready as time permits.

* [Changes](https://github.com/cockpit-project/cockpit/pull/5445)
* [more](https://github.com/cockpit-project/cockpit/pull/5285)

System shutdown can be scheduled by date
----------------------------------------

Fridolin did work a long time ago, so that users could select a specific
date and time to schedule a shutdown or reboot of the system. Stef
finished that work added tests and it's now in Cockpit.

* [Screenshot](http://cockpit-project.org/blog/images/shutdown-date.png)
* [Changes](https://github.com/cockpit-project/cockpit/pull/2419)

Properly terminate user sessions on the Accounts page
-----------------------------------------------------

The Accounts page now properly terminates user sessions when the
Terminate Session button is clicked. We use the correct systemd
loginctl commands.

* [Changes](https://github.com/cockpit-project/cockpit/pull/5359)


Get it
------

You can [get Cockpit here](http://cockpit-project.org/running.html).

Cockpit 125 is [available in Fedora 25](https://bodhi.fedoraproject.org/updates/cockpit-125-1.fc25).

Or [download the tarball](https://github.com/cockpit-project/cockpit/releases/tag/125).
