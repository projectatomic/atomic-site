---
title: Introducing Atomic Developer Mode
author: jlebon
date: 2016-03-09 08:30:00 UTC
comments: true
published: true
categories: blog
tags:
- developers
- devmode
- fedora
- atomic
- cockpit
- docker
- cloud-init

---

In this week's latest release of Fedora Atomic Host, you might notice something
different when you boot the new image. There is now a "Developer Mode" entry in
the GRUB boot menu. This blog post will describe why this new feature was added
and what it does.

One of the confusing things that newcomers encounter when they want to try out
Atomic Host is setting up
[cloud-init](http://cloudinit.readthedocs.org/en/latest/). Currently, it is
impossible to use an Atomic Host image without providing cloud-init with a
datasource. In the absence of a source, cloud-init will try connecting to
various known metadata URLs for about 4 minutes and then give up.

READMORE

For most first-timers, the easiest way to get started has been to follow
[the Quick Start Guide](http://www.projectatomic.io/docs/quickstart/), which
takes them through the process of creating the meta-data and user-data files,
generating the cloud-init ISO, and attaching it to a virtual machine.

This represents pure "overhead" for folks who just want to try out Atomic Host
so they can play around with the
[atomic tool](https://github.com/projectatomic/atomic),
[rpm-ostree](https://github.com/projectatomic/rpm-ostree),
[Docker](https://www.docker.com/), or even
[Cockpit](http://cockpit-project.org/).

The new Atomic Developer Mode addresses this by adding a new entry in the GRUB
boot menu. Because a picture is worth a thousand words, here's a screenshot of
what the menu will now look like on the first boot:

<a href="../../../../images/atomic-devmode-boot.png">
  <img src="../../../../images/atomic-devmode-boot.png" width="60%">
</a>

**A word of caution:** the GRUB menu timeout has a timeout of 1 second. Though
increasing it would make it easier for people to select a different boot entry,
it would also increase the boot up time for every other regular use case. If you
miss it the first time, simply restart and try again!  If you're using
virt-mamanger, selecting "Enable boot menu" in the machine's boot options will give you a couple seconds extra
time.

When booted in Developer Mode, cloud-init will be provided with a local
datasource that will automatically:

1. generate a random root password,
2. autologin as root into a [tmux](https://tmux.github.io/) session,
3. pull and start a cockpit/ws container, and
4. print out all the useful info on the terminal

The benefit of using tmux is its scriptability. A custom tmux configuration file
is used to provide some easier navigation hotkeys. Here is a screenshot of the
tmux environment once it is fully booted up:

<a href="../../../../images/atomic-devmode-env.png">
  <img src="../../../../images/atomic-devmode-env.png" width="60%">
</a>

One of the great strengths of Atomic Developer Mode is that its functionality is
baked into the image. Thus, it does not assume any special setup of the host
environment/OS, as long as it is capable of booting the image.

You can find more information on Atomic Developer Mode on the
[atomic-devel mailing list](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2015-December/msg00034.html),
the
[cloud mailing list](https://lists.fedoraproject.org/archives/list/cloud@lists.fedoraproject.org/thread/M75UQFVNUPNC6ES3RZMT5PXRHIH3FMP5/),
the [Fedora wiki](https://fedoraproject.org/wiki/Changes/Atomic_Developer_Mode),
and the [upstream project](https://github.com/jlebon/atomic-devmode).
