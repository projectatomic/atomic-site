---
title: 'Fedora 25->26 Atomic Host Upgrade Guide'
author: dustymabe
date: 2017-08-01
tags: fedora, atomic
published: false
---


# Introduction

In July we put out the
[first](http://www.projectatomic.io/blog/2017/07/fedora-atomic-26-release/) 
and
[second](http://www.projectatomic.io/blog/2017/07/fedora-atomic-july-25/)
releases of Fedora 26 Atomic Host. In this blog post we'll cover
updating an existing Fedora 25 Atomic Host system to Fedora 26.
We'll cover preparing the system for upgrade and performing the upgrade.

**NOTE:** If you really don't want to upgrade to Fedora 26 see the
          later section: *Appendix B: Fedora 25 Atomic Host Life Support*.

# Preparing for Upgrade

Before we update to Fedora 26 Atomic Host we should check to
see that we have at least a few GiB of free space in our root
filesystem. The update to Fedora 26 can cause your system to 
retrieve more than 1GiB of new content (not shared with Fedora
25) and thus we'll need to make sure we have plenty of free space.

**NOTE:** Upstream OSTree has implemented some
          [filesystem checks](https://github.com/ostreedev/ostree/pull/987) 
          to make sure that upgrades will stop themselves before filling up the
          filesystem and possibly corrupting your system. 

The system we are upgrading today is a Vagrant box. Let's see how
much free space we have:

```nohighlight
[vagrant@host ~]$ sudo df -kh /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  3.0G  1.4G  1.6G  47% /
```

Only `1.6G` free means we probably need to expand our root filesystem
to make sure we don't run out of space. Let's check to see if we have
any free space:

```nohighlight
[vagrant@host ~]$ sudo vgs
  VG       #PV #LV #SN Attr   VSize  VFree 
  atomicos   1   2   0 wz--n- 40.70g 22.60g
[vagrant@host ~]$ sudo lvs
  LV          VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-pool atomicos twi-a-t--- 15.09g             0.13   0.10                            
  root        atomicos -wi-ao----  2.93g                                                    
```

We can see that we have `22.60g` free and that our `atomicos/root`
logical volume is `2.93g` in size. We'll go ahead and increase the
size of the root volume group by 3 GiB.

```nohighlight
[vagrant@host ~]$ sudo lvresize --size=+3g --resizefs atomicos/root 
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
[vagrant@host ~]$ sudo lvs
  LV          VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  docker-pool atomicos twi-a-t--- 15.09g             0.13   0.10                            
  root        atomicos -wi-ao----  5.93g                                                    
```

As part of that command we also resized the filesystem all in one shot.
We can see that by checking again the filesystem usage.

```nohighlight
[vagrant@host ~]$ sudo df -kh /
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/atomicos-root  6.0G  1.4G  4.6G  24% /
```

# Upgrading

Now we should be ready for the upgrade. If you are hosting any services
on your instance you may want to prepare for them to have some downtime.

**NOTE:** If you are running Kubernetes you should check out the later 
          section on Kubernetes: *Appendix A: Upgrading Systems with
          Kubernetes*.

**NOTE:** If you are running OpenShift Origin (i.e. via being set up
          by the
          [openshift-ansible installer](http://www.projectatomic.io/blog/2016/12/part1-install-origin-on-f25-atomic-host/))
          the upgrade should not need any preparation.

Currently we are on Fedora 25 Atomic Host using the 
`fedora-atomic/25/x86_64/docker-host` ref.

```nohighlight
[vagrant@host ~]$ rpm-ostree status
State: idle
Deployments:
● fedora-atomic:fedora-atomic/25/x86_64/docker-host
                Version: 25.154 (2017-07-04 01:38:10)
                 Commit: ce555fa89da934e6eef23764fb40e8333234b8b60b6f688222247c958e5ebd5b
```


In order to do the upgrade we need to add the location of
the Fedora 26 repository as a new remote (similar to a 
git remote) for `ostree` to know about:

```nohighlight
[vagrant@host ~]$ sudo ostree remote add --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-26-primary fedora-atomic-26 https://kojipkgs.fedoraproject.org/atomic/26
```
You can see from the command that we are adding a new remote known as
`fedora-atomic-26` with a remote url of `https://kojipkgs.fedoraproject.org/atomic/26`.
We are also setting the `gpgkeypath` variable in the configuration for
the remote. This tells OSTree that we want commit signatures to be 
verified when we download from a remote. This is something new that was
enabled for Fedora 26 Atomic Host.

Now that we have our `fedora-atomic-26` remote we can do the upgrade!

```nohighlight
[vagrant@host ~]$ sudo rpm-ostree rebase fedora-atomic-26:fedora/26/x86_64/atomic-host

Receiving metadata objects: 0/(estimating) -/s 0 bytes
Signature made Sun 23 Jul 2017 03:13:09 AM UTC using RSA key ID 812A6B4B64DAB85D
  Good signature from "Fedora 26 Primary <fedora-26-primary@fedoraproject.org>"

Receiving delta parts: 0/27 5.3 MB/s 26.7 MB/355.4 MB
Signature made Sun 23 Jul 2017 03:13:09 AM UTC using RSA key ID 812A6B4B64DAB85D
  Good signature from "Fedora 26 Primary <fedora-26-primary@fedoraproject.org>"

27 delta parts, 9 loose fetched; 347079 KiB transferred in 105 seconds                                                                                                                                            
Copying /etc changes: 22 modified, 0 removed, 58 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Upgraded:
  GeoIP 1.6.11-1.fc25 -> 1.6.11-1.fc26
  GeoIP-GeoLite-data 2017.04-1.fc25 -> 2017.06-1.fc26
  NetworkManager 1:1.4.4-5.fc25 -> 1:1.8.2-1.fc26
  ...
  ...
  setools-python-4.1.0-3.fc26.x86_64
  setools-python3-4.1.0-3.fc26.x86_64
Run "systemctl reboot" to start a reboot
[vagrant@host ~]$ sudo reboot
Connection to 192.168.121.217 closed by remote host.
Connection to 192.168.121.217 closed.
```

After reboot we can log in and see the status:

```nohighlight
$ vagrant ssh
[vagrant@host ~]$ rpm-ostree status
State: idle
Deployments:
● fedora-atomic-26:fedora/26/x86_64/atomic-host
                Version: 26.91 (2017-07-23 03:12:08)
                 Commit: 0715ce81064c30d34ed52ef811a3ad5e5d6a34da980bf35b19312489b32d9b83
           GPGSignature: 1 signature
                         Signature made Sun 23 Jul 2017 03:13:09 AM UTC using RSA key ID 812A6B4B64DAB85D
                         Good signature from "Fedora 26 Primary <fedora-26-primary@fedoraproject.org>"

  fedora-atomic:fedora-atomic/25/x86_64/docker-host
                Version: 25.154 (2017-07-04 01:38:10)
                 Commit: ce555fa89da934e6eef23764fb40e8333234b8b60b6f688222247c958e5ebd5b
[vagrant@host ~]$ cat /etc/fedora-release 
Fedora release 26 (Twenty Six)
```

We are now on Fedora 26 Atomic Host. Now is a good time to check your
services (most likely running in containers) to see if they are still
working. If not, then you always have the rollback command: `sudo
rpm-ostree rollback`.

**NOTE:** Over time you can see updated commands for upgrading Atomic
          Host between releases by visiting [this](https://fedoraproject.org/wiki/Atomic_Host_upgrade)
          wiki page.

# Appendix A: Upgrading Systems with Kubernetes

Fedora 25 Atomic Host ships with Kubernetes **v1.5.3**, and Fedora 26
Atomic Host ships with Kubernetes **v1.6.7**. **Before** upgrading systems
participating in an existing Kubernetes cluster from 25 to 26, there
are a few configuration changes to make.

## Node Servers

In Kubernetes 1.6, the `--config` argument is no longer valid. If
your `KUBELET_ARGS` in `/etc/kubernetes/kubelet` point to the manifests
directory using the `--config` argument, then you need to change
the argument name to `--pod-manifest-path`. Also in `KUBELET_ARGS`, you 
need to add the argument `--cgroup-driver=systemd`.

For example, if your `/etc/kubernetes/kubelet` file starts with the
following:

```nohighlight
KUBELET_ARGS="--kubeconfig=/etc/kubernetes/kubelet.kubeconfig --config=/etc/kubernetes/manifests --cluster-dns=10.254.0.10 --cluster-domain=cluster.local"
```

Then it should be changed to be:

```nohighlight
KUBELET_ARGS="--kubeconfig=/etc/kubernetes/kubelet.kubeconfig --pod-manifest-path=/etc/kubernetes/manifests --cluster-dns=10.254.0.10 --cluster-domain=cluster.local --cgroup-driver=systemd"
```

## Master Servers

### Staying With etcd2 

From Kubernetes 1.5 to 1.6 upstream 
[shifted](https://kubernetes.io/docs/tasks/administer-cluster/upgrade-1-6/)
from using version 2 of the etcd API to version 3. The 
[Kubernetes documentation](https://github.com/kubernetes/kubernetes/blob/93b144c/CHANGELOG.md#internal-storage-layer-1)
instructs users to **add** two arguments to the `KUBE_API_ARGS` variable
in the `/etc/kubernetes/apiserver` file:

```nohighlight
--storage-backend=etcd2 --storage-media-type=application/json
```

This will ensure that any pods, services or other objects stored in etcd
will continue to be found by Kubernetes once you've completed your upgrade.

### Moving To etcd3

If you later wish to migrate your etcd data to the v3 API, stop your
etcd and kube-apiserver services and, run the following command to 
migrate to etcd3:

**NOTE:** The following command assumes your data is stored in
          `/var/lib/etcd`.


```nohighlight
# ETCDCTL_API=3 etcdctl --endpoints https://YOUR-ETCD-IP:2379 migrate --data-dir=/var/lib/etcd
```

Then remove the `--storage-backend=etcd2` and `--storage-media-type=application/json`
arguments from the `/etc/kubernetes/apiserver` file and restart the etcd
and kube-apiserver services.


# Appendix B: Fedora 25 Atomic Host Life Support

We have [decided](https://pagure.io/atomic-wg/issue/303)
to keep updating the `fedora-atomic/25/x86_64/docker-host`
ref every day when Bodhi runs within Fedora. A new update will
get created every day. However, we recommend you upgrade to Fedora 26,
because we are focusing future testing and development efforts on on
Fedora 26 Atomic Host and thus the Fedora 25 OSTrees don't get
tested.


# Conclusion

The transition to Fedora 26 Atomic Host should be a smooth process.
If you have issues or want to be involved in the future direction of Atomic
Host please join us in IRC (#atomic on
[freenode](https://freenode.net/)) 
or on the [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel)
mailing list.


