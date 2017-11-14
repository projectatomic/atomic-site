---
# Used for pa.io/blog
title: 'Fedora 26->27 Atomic Host Upgrade Guide'
author: dustymabe
date: 2017-11-14 18:00:00 UTC
tags: fedora, atomic
published: true
---


# Introduction

This week we put out the [first](/blog/2017/11/fedora-atomic-27-features/)
release of Fedora 27 Atomic Host. Some quick notes:

- In Fedora 27 Atomic Host we removed kubernetes from the base OSTree.
  We will have a post tomorrow about the upgrade steps for Kubernetes users.

- For Fedora 27 we are currently sticking with the non-unified repo
  approach as opposed to a unified repo. *TL;DR* nothing is changing
  for now but we expect to implement a unified repo as described
  [here](http://www.projectatomic.io/blog/2017/06/future-plans-for-fedora-atomic-release-life-cycle/)
  during the F27 release cycle.

For today we'll talk about updating an existing Fedora 26 Atomic Host
system to Fedora 27. We'll cover preparing the system for upgrade and
performing the upgrade.

READMORE

**NOTE:** If you really don't want to upgrade to Fedora 26 see the
          end section: *Appendix B: Fedora 26 Atomic Host Life Support*.

# Preparing for Upgrade

Before we update to Fedora 27 Atomic Host we should check to
see that we have at least a few GiB of free space in our root
filesystem. The update to Fedora 27 can cause your system to
retrieve more than 1 GiB of new content (not shared with Fedora
26) and thus we'll need to make sure we have plenty of free space.

**NOTE:** If you skip this step, OSTree will perform
          [filesystem checks](https://github.com/ostreedev/ostree/pull/987)
          to make sure that upgrade will error gracefully before filling
          up the filesystem.

The system we are upgrading today is a Vagrant box. Let's see how
much free space we have:

```nohighlight
[vagrant@localhost ~]$ sudo df -kh /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  3.0G  1.6G  1.5G  52% /
```

Only `1.5G` free means we probably need to expand our root filesystem
to make sure we don't run out of space. Let's check to see if we have
any free space:

```nohighlight
[vagrant@localhost ~]$ sudo vgs
  VG       #PV #LV #SN Attr   VSize  VFree
  atomicos   1   2   0 wz--n- 40.70g 22.66g
[vagrant@localhost ~]$ sudo lvs
  LV             VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-root-lv atomicos -wi-ao---- 15.11g                                                    
  root           atomicos -wi-ao----  2.93g
```

We can see that we have `22.66g` free and that our `atomicos/root`
logical volume is `2.93g` in size. We'll go ahead and increase the
size of the root volume group by 3 GiB.

```nohighlight
[vagrant@localhost ~]$ sudo lvresize --size=+3g --resizefs atomicos/root
  Size of logical volume atomicos/root changed from 2.93 GiB (750 extents) to 5.93 GiB (1518 extents).
  Logical volume atomicos/root successfully resized.
meta-data=/dev/mapper/atomicos-root isize=512    agcount=4, agsize=192000 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=768000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 768000 to 1554432
[vagrant@localhost ~]$ sudo lvs
  LV             VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-root-lv atomicos -wi-ao---- 15.11g                                                    
  root           atomicos -wi-ao----  5.93g
```

As part of that command we also resized the filesystem all in one shot.
We can see that by checking again the filesystem usage.

```nohighlight
[vagrant@localhost ~]$ sudo df -kh /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  6.0G  1.6G  4.5G  26% /
```

# Upgrading

Now we should be ready for the upgrade. If you are hosting any services
on your instance you may want to prepare for them to have some downtime,
or better fail them over to another node.

**NOTE:** If you are running Kubernetes, you will want to check tomorrow's post
          on upgrading Kubernetes.

**NOTE:** If you are running OpenShift Origin (set up
          by the
          [openshift-ansible installer](http://www.projectatomic.io/blog/2016/12/part1-install-origin-on-f25-atomic-host/)
          or otherwise)
          the upgrade should not need any preparation.  Just make sure that
          your services are redundant enough to survive the node being
          unavailable during upgrade.

Currently we are on Fedora 26 Atomic Host using the
`fedora/26/x86_64/atomic-host` ref.

```nohighlight
[vagrant@localhost ~]$ rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora/26/x86_64/atomic-host
                   Version: 26.157 (2017-10-29 14:42:37)
                    Commit: c099633883cd8d06895e32a14c63f6672072430c151de882223e4abe20efa7ca
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
```


In order to do the upgrade we need to add the location of
the Fedora 27 repository as a new remote (similar to a
git remote) for `ostree` to know about:

```nohighlight
[vagrant@localhost ~]$ sudo ostree remote add --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-27-primary fedora-atomic-27 https://kojipkgs.fedoraproject.org/atomic/27
```

You can see from the command that we are adding a new remote known as
`fedora-atomic-27` with a remote url of `https://kojipkgs.fedoraproject.org/atomic/27`.
We are also setting the `gpgkeypath` variable in the configuration for
the remote. This tells OSTree that we want commit signatures to be
verified when we download from a remote.

Now that we have our `fedora-atomic-27` remote we can do the upgrade!

```nohighlight
[vagrant@localhost ~]$ sudo rpm-ostree rebase fedora-atomic-27:fedora/27/x86_64/atomic-host

2684 metadata, 15674 content objects fetched; 423335 KiB transferred in 191 seconds                                                                                                                                                          
Copying /etc changes: 23 modified, 0 removed, 57 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Upgraded:
  GeoIP 1.6.11-1.fc26 -> 1.6.11-3.fc27
  GeoIP-GeoLite-data 2017.10-1.fc26 -> 2017.10-1.fc27
  NetworkManager 1:1.8.2-1.fc26 -> 1:1.8.4-2.fc27
  ...
  ...
  shim-x64-13-0.7.x86_64
  snappy-1.1.4-5.fc27.x86_64
Run "systemctl reboot" to start a reboot
[vagrant@localhost ~]$ sudo reboot
Connection to 192.168.121.76 closed by remote host.
Connection to 192.168.121.76 closed.
```

After reboot we can log in and see the status:

```nohighlight
$ vagrant ssh
[vagrant@localhost ~]$ rpm-ostree status
State: idle
Deployments:
● fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.1 (2017-11-10 11:54:36)
                    Commit: d428d3ad8ecf44e53d138042bad56a10308883a0c5d64b9c51eff27fdc9da82c
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4

  fedora-atomic:fedora/26/x86_64/atomic-host
                   Version: 26.157 (2017-10-29 14:42:37)
                    Commit: c099633883cd8d06895e32a14c63f6672072430c151de882223e4abe20efa7ca
              GPGSignature: Valid signature by E641850B77DF435378D1D7E2812A6B4B64DAB85D
[vagrant@localhost ~]$
[vagrant@localhost ~]$ cat /etc/fedora-release
Fedora release 27 (Twenty Seven)
```

We are now on Fedora 27 Atomic Host. Now is a good time to check your
services (most likely running in containers) to see if they are still
working. If not, then you always have the rollback command: `sudo
rpm-ostree rollback`.

**NOTE:** Over time you can see updated commands for upgrading Atomic
          Host between releases by visiting [this](https://fedoraproject.org/wiki/Atomic_Host_upgrade)
          wiki page.

# Appendix A: Upgrading Systems with Kubernetes

In Fedora 27 Atomic Host we have removed kubernetes from the OSTree
that we ship with the host. This enables users to only download/install
kubernetes if they want to and also gives the users that are using
kubernetes the flexibility to use whatever version they may want.

You can still install kubernetes via package layering, or you can use
system containers to run kubernetes fully containerized. Tomorrow (November
15) we will have instructions on how to make the transition.

# Appendix B: Fedora 26 Atomic Host Life Support

As with Fedora 25, we will keep updating the Fedora 26 Atomic Host tree.
However, we won't be performing regular testing on that tree, and there will
be no more formal releases for Fedora 26. Please upgrade to Fedora 27 to
take advantage of regular testing and formal releases every two weeks.

# Conclusion

As in the past, the transition to Fedora 27 Atomic Host should be an
easy process. If you have issues or want to be involved in the future
direction of Atomic Host please join us in IRC (#atomic on
[freenode](https://freenode.net/)) or on the
[atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
mailing list.
