---
title: 'Fedora 28->29 Atomic Host Upgrade Guide'
author: dustymabe
date: 2018-10-31
tags: fedora, atomic
published: true
---


# Introduction

This week we put out the [first](https://lists.projectatomic.io/projectatomic-archives/atomic-devel/2018-October/msg00006.html)
release of Fedora 29 Atomic Host. This will be the last major release
of Fedora Atomic Host as we prepare for [Fedora CoreOS](https://coreos.fedoraproject.org/)
which will be released in Fedora 30.

In this post we'll quickly list some known issues and then talk about updating 
an existing Fedora 28 Atomic Host system to Fedora 29. We'll cover preparing
the system for upgrade and performing the upgrade.

READMORE

**NOTE:** If you really don't want to upgrade to Fedora 29 see the
          later section: *Appendix B: Fedora 28 Atomic Host Life Support*.

# Known Issues

- Device timeout when installing from ISO with swap space. 

We found [an issue](https://pagure.io/atomic-wg/issue/513)
where instances installed via the ISO image via anaconda were
having long boot times because of device timeouts. We traced
this down to [a bug in dracut](https://bugzilla.redhat.com/show_bug.cgi?id=1641268)
and this will be fixed in the next release.

- Incompatibilities with OpenShift Origin >= 3.11 and Kubernetes >= 1.10.4

In newer versions of `systemd` an API was removed that was needed by
older versions of OpenShift/Kubernetes. It is recommended that you
upgrade to Origin 3.11 or Kubernetes > 1.10.4 before moving to Fedora
29 Atomic Host. If you must use an older version of OpenShift/Kubernetes
with Fedora 29 Atomic Host please see the later section: 
*Appendix A: Using older versions of Kubernetes/OpenShift on Fedora 29 Atomic Host*.
Discussion of this issue can be found in the [pagure ticket](https://pagure.io/atomic-wg/issue/512).

# Preparing for Upgrade

Before we update to Fedora 29 Atomic Host we should check to
see that we have at least a few GiB of free space in our root
filesystem. The update to Fedora 29 can cause your system to
retrieve more than 1 GiB of new content (not shared with Fedora
28) and thus we'll need to make sure we have plenty of free space.

**NOTE:** Luckily if you skip this step OSTree will perform
          [filesystem checks](https://github.com/ostreedev/ostree/pull/987)
          to make sure that upgrade will error gracefully before filling
          up the filesystem.


# Upgrading

Now we should be ready for the upgrade. If you are hosting any services
on your instance you may want to prepare for them to have some downtime.

Currently we are on Fedora 28 Atomic Host using the
`fedora/28/x86_64/atomic-host` ref.

```nohighlight
[vagrant@host ~]$ rpm-ostree status
State: idle
AutomaticUpdates: disabled
Deployments:
● ostree://fedora-atomic:fedora/28/x86_64/atomic-host
                   Version: 28.20181007.0 (2018-10-07 20:43:44)
                    Commit: 8df48fa2e70ad1952153ae00edbba08ed18b53c3d4095a22985d1085f5203ac6
              GPGSignature: Valid signature by 128CF232A9371991C8A65695E08E7E629DB62FB1
```


In order to do the upgrade we need to add the location of
the Fedora 28 repository as a new remote (similar to a
git remote) for `ostree` to know about:

```nohighlight
[vagrant@host ~]$ sudo ostree remote add --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-29-primary fedora-atomic-29 https://dl.fedoraproject.org/atomic/repo/
```

You can see from the command that we are adding a new remote known as
`fedora-atomic-29` with a remote url of `https://dl.fedoraproject.org/atomic/repo/`
We are also setting the `gpgkeypath` variable in the configuration for
the remote. This tells OSTree that we want commit signatures to be
verified when we download from a remote.

Now that we have our `fedora-atomic-29` remote we can do the upgrade!

```nohighlight
[vagrant@host ~]$ sudo rpm-ostree rebase fedora-atomic-29:fedora/29/x86_64/atomic-host
26 delta parts, 9 loose fetched; 264197 KiB transferred in 44 seconds        
Upgraded:                                      
  NetworkManager 1:1.10.12-1.fc28 -> 1:1.12.4-1.fc29        
  NetworkManager-libnm 1:1.10.12-1.fc28 -> 1:1.12.4-1.fc29
  NetworkManager-team 1:1.10.12-1.fc28 -> 1:1.12.4-1.fc29
  acl 2.2.53-1.fc28 -> 2.2.53-2.fc29                
  atomic 1.22.1-2.fc28 -> 1.22.1-27.gitb507039.fc29       
  atomic-devmode 0.3.7-4.fc28 -> 0.3.7-6.fc29        
  atomic-registries 1.22.1-2.fc28 -> 1.22.1-27.gitb507039.fc29
  attr 2.4.48-3.fc28 -> 2.4.48-3.fc29              
...
  python-unversioned-command-2.7.15-10.fc29.noarch
  python3-pyyaml-4.2-0.1.b4.fc29.x86_64
Run "systemctl reboot" to start a reboot
[vagrant@host ~]$ sudo systemctl reboot
[vagrant@host ~]$ Connection to 192.168.121.95 closed by remote host.
Connection to 192.168.121.95 closed.
```

After reboot we can log in and see the status:

```nohighlight
$ vagrant ssh 
Last login: Wed Oct 31 21:14:44 2018 from 192.168.121.1
[vagrant@host ~]$ rpm-ostree status
State: idle
AutomaticUpdates: disabled
Deployments:
● ostree://fedora-atomic-29:fedora/29/x86_64/atomic-host
                   Version: 29.20181025.1 (2018-10-25 14:46:54)
                    Commit: 4a999b4b303b47468ff1464051a14fd075d2e7b8bb647584b7cc80fed48cf27b
              GPGSignature: Valid signature by 5A03B4DD8254ECA02FDA1637A20AA56B429476B4

  ostree://fedora-atomic:fedora/28/x86_64/atomic-host
                   Version: 28.20181007.0 (2018-10-07 20:43:44)
                    Commit: 8df48fa2e70ad1952153ae00edbba08ed18b53c3d4095a22985d1085f5203ac6
              GPGSignature: Valid signature by 128CF232A9371991C8A65695E08E7E629DB62FB1
[vagrant@host ~]$
[vagrant@host ~]$ cat /etc/os-release | head -n 2
NAME=Fedora
VERSION="29.20181025.1 (Atomic Host)"
```

We are now on Fedora 29 Atomic Host. Now is a good time to check your
services (most likely running in containers) to see if they are still
working. If not, then you always have the rollback command: `sudo
rpm-ostree rollback`.

**NOTE:** Over time you can see updated commands for upgrading Atomic
          Host between releases by visiting [this](https://fedoraproject.org/wiki/Atomic_Host_upgrade)
          wiki page.

# Appendix A: Using older versions of Kubernetes/OpenShift on Fedora 29 Atomic Host

Due to [an issue](https://pagure.io/atomic-wg/issue/512) that arises from the
combination of the version of systemd that ships with Fedora 29 Atomic Host,
and the version of runc that's bundled with Kubernetes and with OpenShift
Origin, users of certain Kubernetes and OpenShift Origin releases must take
steps to keep their Kubernetes or Origin clusters running following an upgrade to 29.

Users running Kubernetes releases older than v1.10.4 or OpenShift Origin
releases older than v3.11 would do best to upgrade their Kubernetes or
Origin clusters to a more recent version before undertaking an upgrade
to Fedora 29 Atomic Host.

For users who prefer to upgrade to 29 without changing their cluster
version, it's possible to work around the issue by changing the
`cgroupdriver` for both docker and for either the kubelet or the
orgin-node component from its default value of `systemd` to `cgroupfs`.

## For docker (applies to both Kubernetes and OpenShift Origin clusters):

```nohighlight
# cp /usr/lib/systemd/system/docker.service /etc/systemd/system/
# sed -i 's/cgroupdriver=systemd/cgroupdriver=cgroupfs/' /etc/systemd/system/docker.service
```

## For kubelet (applies to Kubeadm-based Kubernetes clusters):

```nohighlight
# sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/' /etc/systemd/system/kubelet.service.d/kubeadm.conf
```

## For origin-node (applies to OpenShift Origin clusters):

```nohighlight
# vi /etc/origin/node/node-config.yaml
```

Add the following element to the `kubeletArguments:` section:

```nohighlight
cgroup-driver:
  - "cgroupfs"
```

After making these changes, rebase to 29 as directed above. After reboot
the nodes should return in `Ready` state as expected.

# Appendix B: Fedora 28 Atomic Host Life Support

As with Fedora 27 we will keep updating the Fedora 28 Atomic Host tree
but we won't be performing regular testing on that tree and there will
be no more formal releases for Fedora 28. Please move to Fedora 29 to
take advantage of regular testing and formal releases every two weeks.

# Conclusion

As in the past, the transition to Fedora 29 Atomic Host should be an
easy process. If you have issues please join us in IRC (#atomic on
[freenode](https://freenode.net/)) or on the
[atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
mailing list.

