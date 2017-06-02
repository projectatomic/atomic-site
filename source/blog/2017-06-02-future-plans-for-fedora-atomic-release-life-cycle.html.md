---
title: Future Plans for the Fedora Atomic Release Life Cycle
author: jbrooks
date: 2017-06-02 13:00:00 UTC
tags: fedora, atomic host
comments: true
published: true
---

The Fedora Project ships new Fedora Server and Fedora Workstation releases at roughly six-month intervals, and [maintains](https://fedoraproject.org/wiki/Fedora_Release_Life_Cycle) each release for around thirteen months. So Fedora N is supported by the community until one month after the release of Fedora N+2. Since the first Fedora Atomic host shipped, as part of Fedora 21, the project has maintained separate ostree repositories for both of the active Fedora releases. For instance, there are currently trees available for Fedora Atomic 25 and Fedora Atomic 24.

Fedora Atomic sets out to be a particularly fast-moving branch of Fedora, with releases every two weeks and updates to key “atomic” components such as Docker and Kubernetes that move more quickly than one might expect from the other releases of Fedora. Due in part to this faster pace, the Fedora Atomic Workgroup has always focused its testing and integration efforts most directly on the latest stable release, encouraging users of the older release to rebase to the newer tree as soon as possible. Releases older than the current tree are supported only on a "best effort" basis, meaning that the ostree is updated, but there is no organized testing of the older releases.

Starting with either the Fedora 26 to 27 or the 27 to 28 upgrade cycle (depending on readiness), the Fedora Atomic Workgroup intends to collapse Fedora Atomic into a single version which will track the latest stable Fedora branch. When a new stable version of Fedora is released, Fedora Atomic users will automatically shift to the new version when they install updates.

Traditional OS upgrades can be disruptive and error-prone, but due to the image-based technologies that Atomic Hosts use for system components (rpm-ostree) and for applications (Linux containers), upgrading an Atomic Host between major releases is little different than installing updates within a single release. In both scenarios, the system updates are applied by running an rpm-ostree command and rebooting, with rollback to the previous state available in case something goes wrong, and applications running in containers are unaffected by the host upgrade or update.

There’s work that must be done to prepare for this collapsed release structure, but for users that wish to opt for this new behavior starting with the upcoming Fedora 25 to Fedora 26 upgrade cycle, we’ll be preparing a “stable” ostree repo location that you can rebase to follow the latest major release. Look for more information on that shortly.

If you'd like to get involved in the Fedora Atomic Workgroup, come talk to us in IRC in #fedora-cloud or #atomic on Freenode, or join the [Atomic WG on Pagure](https://pagure.io/atomic-wg).
