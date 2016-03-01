---
title: Project Atomic GSOC 2016
---

# Project Atomic in Google Summer of Code 2016

This year Project Atomic is participating in [Google Summer of Code 2016](https://developers.google.com/open-source/gsoc/) as part of the [Fedora Project](https://fedoraproject.org/wiki/GSOC_2016). If you are a student, or know a student, please consider submitting proposals once GSoC opens.

Specific projects we are accepting proposals in include:

* [Fedora Atomic Host](https://fedoraproject.org/wiki/Changes/AtomicHost)
* [RPM-OSTree](https://github.com/projectatomic/rpm-ostree) and [OSTree tools](https://github.com/projectatomic/rpm-ostree-toolbox)
* The [Atomic CLI](https://github.com/projectatomic/atomic)
* Docker and [OCI hooks](https://github.com/projectatomic/oci-systemd-hook)
* [Atomic.app](https://github.com/projectatomic/atomicapp)
* [Nulecule](https://github.com/projectatomic/nulecule)
* [Other Project Atomic projects](https://github.com/projectatomic)

## Contacts and Mentors

The administrator for Project Atomic GSOC projects is <a href="mailto:jberkus@redhat.com">Josh Berkus</a>.  Contact Josh if you have questions about making a GSOC proposal, or better ask
questions on the [Atomic-Devel mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) or on the #atomic or #fedora-cloud IRC channels on IRC.freenode.net.

Mentors are:

* Giuseppe Scriviano
* Colin Walters
* Matthew Barnes

## Project Ideas

What follows are a ideas for student projects around Atomic.  Please do not restrict yourself to these ideas;
if there is something you want to build with containers and Atomic, then propose it!  Additional details of these
ideas is available on the [Fedora GSOC 2016 wiki page](https://fedoraproject.org/wiki/Summer_coding_ideas_for_2016).

### RPM-OSTree and Fedora Atomic Host

* [Next-generation Super-Privileged Container](https://github.com/projectatomic/atomic/issues/298) Improve building, managing, and updating these container images

* [Atomic Host Package Layering](https://github.com/projectatomic/rpm-ostree/pull/107) mprove the package layering design, support more RPMs, ensure %post scripts are safe, etc

* [Bootstrap with gpgcheck in kickstart](https://github.com/projectatomic/rpm-ostree/issues/190): Add a way for importing a GPG key from the kickstart `ostreesetup` command before the download starts. ["ostreesetup" is described here](https://docs.fedoraproject.org/en-US/Fedora/23/html/Installation_Guide/appe-kickstart-syntax-reference.html)

* [Improve ability to monitor running/canceled transactions](https://github.com/projectatomic/rpm-ostree/issues/210): The rpm-ostree client termination doesn't block the command execution on the rpm-ostreed.  This will cause new rpm-ostree clients to fail immediately because there is a transaction in progress. Change rpm-ostree to be notified of the status of the current transaction and possibly attach to it.

* [Support for end-of-life notification](https://github.com/projectatomic/rpm-ostree/issues/142): Add support for having an `end-of-life` notification to inform users if a particular branch is not supported anymore.

* [rpm-ostree operation history support](https://github.com/projectatomic/rpm-ostree/issues/85): Add support for `atomic history` to display the transactions history. It should work in a similar way to `yum history`.

* [Automatic updates](https://github.com/projectatomic/rpm-ostree/issues/44): Implement a service that automatically upgrades the system when a new image is available.  If the system is not restarting correctly, then rollback to the previous working version. [More details here](https://github.com/projectatomic/rpm-ostree/issues/177).

* [Support metalink for OSTree](https://bugzilla.gnome.org/show_bug.cgi?id=729388): Add support for metalink files and support downloads from a list of mirrors and fetch objects from multiple sources.

* [Drop privileges for HTTP fetches](https://bugzilla.gnome.org/show_bug.cgi?id=730037): The HTTP fetcher code is running in the same process of OSTree.  Move the HTTP fetcher code to another process with less privileges than the main process.

* [Support kpatch](https://github.com/projectatomic/rpm-ostree/issues/118): Support live update for the kernel without rebooting or restarting any processes.

* [Atomic Host Automated Updates](https://github.com/projectatomic/rpm-ostree/issues/177http://etherpad.osuosl.org/fedora-atomic-gsoc-2016) implement a service that automatically upgrades the system when a new image is available. If the system is not restarting correctly, the rollback to the previous working version.


## Applying to Project Atomic GSOC

Atomic GSOC is part of [Fedora GSOC 2016](https://fedoraproject.org/wiki/GSOC_2016).  As such, please submit your proposal to the Fedora Project in GSOC, and indicate clearly in the description that you have a Project Atomic proposal by adding this text at the top:

```
Proposed for Project Atomic
```

We'll take it from there.  Be sure to look for comments and requests for clarification on your proposal.
