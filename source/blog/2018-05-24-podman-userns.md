---
title: User namespaces support in Podman
author: giuseppe
date: 2018-05-24 00:00:00 UTC
layout: post
comments: false
categories:
- Blog
---

## User namespaces support in Podman

We recently added support for user namespaces to
[Podman](https://github.com/projectatomic/libpod).  This has some major
benefits for security and added flexibility when running
containers.  It allows processes to have privileges inside of the
container, but no privileges if they escape the container.

READMORE

[User namespaces](https://lwn.net/Articles/532593/) are a kernel
mechanism for allowing a process to see a different uids/gids mapping
than it has in reality.  It permits mapping multiple ranges of
uids/gids from the host to completely different values into the
container process.

This enables things like having `root` in the container but the
process actually runs with a UID that is not root outside of the
container.  This means if the processes in the container manages to
break out of the container, they will be treated as normal
non-privileged processes on the host, and the non-privileged UID will
be used for checking the access to the file system resources.  Of
course other security mechanisms like SELinux would also still be in
effect, but this adds another layer of protection.

Another interesting security aspect is that each container can have
its own uids/gids mapped from the host.  In case of breakage, a
container not only has a more limited attack area to the host where it
has no root access, but other containers have another level of
security as their uids/gids are different.  User namespaces are like
Discretionary Access Control at its best.

# Changes to the Podman CLI

Podman offers two ways to use user namespaces:
### Directly specify the mappings

Podman can specify the uids/gids directly using `--uidmap` and `--gidmap`.

The first way is the most immediate, to verify what happens in a
container we check the /proc/self/uid_map file.  It shows the uid
mappings in place for the specified process.

```console
# cat /proc/self/uid_map
         0          0 4294967295

# podman  run --uidmap=0:100000:70000 --gidmap=0:200000:70000 alpine cat /proc/self/uid_map
         0          100000      70000
```

The `uid_map` table has three columns, the first one is the initial ID
for the range in the new namespace, the second one is the initial ID
in the parent namespace, and the third is the size of the mapping.  In
this case, we have specified only one mapping where the UIDs [0-6999]
in the container are mapped to the host UIDs [100000-16999].
Similarly for the GIDs, we can look up the `gid_map` file.


The process has a different UID/GID inside the container than it has
from the host:

```console
# bin/podman run --rm  --uidmap=0:11111:70000 --gidmap=0:20000:70000 alpine sh -c 'id - u; sleep 10'
0
```

(from the host)

```console
$ pgrep -U 11111 -a
27513 sh -c id -u; sleep 10
27574 sleep 10
```

### Use /etc/subuid and /etc/subgid
Podman can specify the mappings defined in /etc/subuid and /etc/subgid
with the --subuidname and --subgidname options.
On my system I have allocated 65536 UIDs/GIDs starting at 110000 for
the user “gscrivano”.

```console
# grep gscrivano /etc/subuid
gscrivano:110000:65536
# grep gscrivano /etc/subgid
gscrivano:110000:65536
```

I can use these settings with:
```console
# podman  run --subuidname gscrivano --subgidname=gscrivano alpine cat /proc/self/uid_map
         0     110000      65536
```

## Drawbacks
The linux kernel does not currently support user namespace in the file
system.  We have been working for a few years to get file system
support (Shifting file system), but the work continues, we don’t know
when this will be finally supported.  Without file system support,
files in the container image that will be used by a user namespace
`root`, need to have their inode owners/groups match.  This means, If
you are running a container with root mapped to UID 60000, then the
actual files in the container image have to be owned by UID 60000.

We can work around the lack of file system support in user space by
chowning the files on disk to match the user namespace to which you
want to run the container.   If an image does not exist, the first
time podman pulls the image, it will be chowned to match the user
namespace.  The container/storage layer does this automatically when
pulling new images.  In this case performance will not be affected.
However, If you choose to use the same image again with a different
user namespace, container/storage will `chown` the entire file system
to match the new user namespace, this will cause a long pause, while
new inodes are created for every object in the images file system, a
Fedora image can take 30 seconds.

While we wait for a better support from the kernel, we are looking
into using reflinks where possible, like XFS, for copying files.
Reflinks permit to share the data blocks from different inodes, so
that we can have files with different attributes but pointing to the
same data blocks on the file system, this also speeds-up the copy of a
file as we don’t have to copy all of its data.  If you have a file
system you can mount at /var/lib/containers, you should turn on
reflink.

```console
# mkfs.xfs -m reflink=1 /dev/sda1
# mount /dev/sda1 /var/lib/containers
```

Now if you run the podman command on two different user namespaces, if
the container image was fedora, it will take approximately 15 seconds,
doubling the speed.  File system engineers on our team are working on
some enhancements to Overlay File systems, that could even take this
down to a couple of seconds, ten times the default, which we hope to
have merged soon.

But the real nirvana would be to get file UID Shifting into the file
system which would be instantaneous.

## Bottom Line
Podman has grown support for running one or more containers in user
namespace.  Users can choose to run all containers in a single user
Namespace giving them better security against container breakout
against the host.  They can also run each container with a different
User Namespace giving them better container separation between their
containers.
