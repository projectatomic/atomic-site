---
title: 'Fedora 27->28 Atomic Host Upgrade Guide'
author: miabbott
date: 2018-05-01
tags: fedora, atomic
published: true
---


# Introduction

This week we put out the [first](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2018-May/msg00001.html)
release of Fedora 28 Atomic Host. Some quick notes:

- For Fedora 28 we are using a [unified repo](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2018-March/msg00012.html)
  that will serve up the Fedora 28 Atomic Host and Atomic Workstation
  content.  This includes all the content for the multi-arch platforms
  `aarch64` and `ppcle64`.

For today we'll talk about updating an existing Fedora 27 Atomic Host
system to Fedora 28. We'll cover preparing the system for upgrade and
performing the upgrade.

READMORE

**NOTE:** If you really don't want to upgrade to Fedora 28 see the
          later section: *Appendix B: Fedora 27 Atomic Host Life Support*.

# Preparing for Upgrade

Before we update to Fedora 28 Atomic Host we should check to
see that we have at least a few GiB of free space in our root
filesystem. The update to Fedora 28 can cause your system to
retrieve more than 1 GiB of new content (not shared with Fedora
27) and thus we'll need to make sure we have plenty of free space.

**NOTE:** Luckily if you skip this step OSTree will perform
          [filesystem checks](https://github.com/ostreedev/ostree/pull/987)
          to make sure that upgrade will error gracefully before filling
          up the filesystem.

In previous releases of Fedora Atomic Host, the storage profile that was
used created two logical volumes (LV) by default.  One LV was used for
containers and container images, the other LV was used by the root
filesystem.  The LV for the root filesystem was fairly small and thus,
users could run out of space in that LV when doing an upgrade.

Starting in Fedora 27, the storage profile was switched to a single LV
that was shared between the root filesystem and container storage. This
alleviates some of the storage problems that could occur during upgrades.
If you find that your host requires more disk space to perform the
upgrade, you will need to increase the amount of storage available to
the volume group and grow the root filesystem LV.

# Upgrading

Now we should be ready for the upgrade. If you are hosting any services
on your instance you may want to prepare for them to have some downtime.

**NOTE:** If you are running Kubernetes you should check out the later
          section on Kubernetes: *Appendix A: Upgrading Systems with Kubernetes*.

**NOTE:** If you are running OpenShift Origin (i.e. via being set up
          by the
          [openshift-ansible installer](http://www.projectatomic.io/blog/2016/12/part1-install-origin-on-f25-atomic-host/))
          the upgrade should not need any preparation.

Currently we are on Fedora 27 Atomic Host using the
`fedora/27/x86_64/atomic-host` ref.

```nohighlight
[vagrant@fedora27ah-dev ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                    Commit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
```


In order to do the upgrade we need to add the location of
the Fedora 28 repository as a new remote (similar to a
git remote) for `ostree` to know about:

```nohighlight
[vagrant@localhost ~]$ sudo ostree remote add --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-primary fedora-atomic-28 https://kojipkgs.fedoraproject.org/atomic/repo/
```

You can see from the command that we are adding a new remote known as
`fedora-atomic-28` with a remote url of `https://kojipkgs.fedoraproject.org/atomic/repo/`
We are also setting the `gpgkeypath` variable in the configuration for
the remote. This tells OSTree that we want commit signatures to be
verified when we download from a remote.

Now that we have our `fedora-atomic-28` remote we can do the upgrade!

```nohighlight
$ sudo rpm-ostree rebase fedora-atomic-28:fedora/28/x86_64/atomic-host

24 delta parts, 10 loose fetched; 277589 KiB transferred in 136 seconds
Copying /etc changes: 21 modified, 0 removed, 59 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Upgraded:
  GeoIP 1.6.11-3.fc27 -> 1.6.12-3.fc28
  GeoIP-GeoLite-data 2018.04-1.fc27 -> 2018.04-1.fc28
  NetworkManager 1:1.8.6-1.fc27 -> 1:1.10.6-1.fc28
  NetworkManager-libnm 1:1.8.6-1.fc27 -> 1:1.10.6-1.fc28
  NetworkManager-team 1:1.8.6-1.fc27 -> 1:1.10.6-1.fc28
  acl 2.2.52-18.fc27 -> 2.2.52-20.fc28
  atomic 1.22.1-1.fc27 -> 1.22.1-2.fc28
  atomic-devmode 0.3.7-2.fc27 -> 0.3.7-4.fc28
  atomic-registries 1.22.1-1.fc27 -> 1.22.1-2.fc28
  attr 2.4.47-21.fc27 -> 2.4.47-23.fc28
...
  python3-libsemanage-2.7-12.fc28.x86_64
  python3-policycoreutils-2.7-18.fc28.noarch
  python3-pytz-2017.2-7.fc28.noarch
  python3-setools-4.1.1-6.fc28.x86_64
Run "systemctl reboot" to start a reboot
[vagrant@fedora27ah-dev ~]$ sudo systemctl reboot
[vagrant@fedora27ah-dev ~]$ Connection to 192.168.121.101 closed by remote host.
Connection to 192.168.121.101 closed.
```

After reboot we can log in and see the status:

```nohighlight
$ vagrant ssh
Last login: Tue May  1 15:20:44 2018 from 192.168.121.1
[vagrant@fedora27ah-dev ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://fedora-atomic-28:fedora/28/x86_64/atomic-host
                   Version: 28.20180425.0 (2018-04-25 19:14:57)
                    Commit: 94a9d06eef34aa6774c056356d3d2e024e57a0013b6f8048dbae392a84a137ca
              GPGSignature: Valid signature by 128CF232A9371991C8A65695E08E7E629DB62FB1

  ostree://fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                    Commit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
[vagrant@fedora27ah-dev ~]$ cat /etc/os-release | head -n 2
NAME=Fedora
VERSION="28 (Atomic Host)"
```

We are now on Fedora 28 Atomic Host. Now is a good time to check your
services (most likely running in containers) to see if they are still
working. If not, then you always have the rollback command: `sudo
rpm-ostree rollback`.

**NOTE:** Over time you can see updated commands for upgrading Atomic
          Host between releases by visiting [this](https://fedoraproject.org/wiki/Atomic_Host_upgrade)
          wiki page.

# Appendix A: Upgrading Systems with Kubernetes

In Fedora 27 Atomic Host we have removed Kubernetes from the OSTree
that we ship with the host. This enables users to only download/install
kubernetes if they want to and also gives the users that are using
kubernetes the flexibility to use whatever version they may want.

You can still install Kubernetes via package layering, or you can use
system containers to run kubernetes fully containerized. Please check
out Jason Brooks' [series](link) (links coming soon) on this topic.

# Appendix B: Fedora 27 Atomic Host Life Support

As with Fedora 26 we will keep updating the Fedora 27 Atomic Host tree
but we won't be performing regular testing on that tree and there will
be no more formal releases for Fedora 27. Please move to Fedora 28 to
take advantage of regular testing and formal releases every two weeks.

# Conclusion

As in the past, the transition to Fedora 28 Atomic Host should be an
easy process. If you have issues or want to be involved in the future
direction of Atomic Host please join us in IRC (#atomic on
[freenode](https://freenode.net/)) or on the
[atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
mailing list.

