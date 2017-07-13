---
title: Unprivileged containers with bwrap-oci and bubblewrap
author: giuseppe
date: 2017-07-12 13:00 UTC
tags: bwrap-oci, usernamespaces, bubblewrap, unprivileged, containers
published: true
comments: true
---
The introduction of user namespaces in the Linux kernel has opened the
doors to running containers as default user logins via e.g. ssh or desktop.
On Fedora, bwrap-oci lets you make use of this feature, as I will
demonstrate.

The concept behind user namespaces is quite simple: UIDs and GIDs in
a user namespace are converted to a different set in the parent
namespace, so that an application thinks it's executed as root while
instead a not privileged user is running it.
User namespaces are not limited to altering  an application's UID/GID
mappings, a user can keep capabilities in the new namespace and
together with other namespaces perform privileged operations there
that are unprivileged in the parent namespace.  For example, an
application with a new network namespace can create firewall rules
that only affect its namespace.  This offers extra security since the
container is limited to the user that is running it, so even if
something goes wrong the process has no more privileges than the user
who runs it (unless things go *very* wrong!).

READMORE

At the time of writing this post, the changes required into bubblewrap
and bwrap-oci are not part of a stable release yet.

If you’d like to try the demo out, you’ll need to build the
development version for both of them.  You can get the last source
from the git repos here:

- [bubblewrap](https://github.com/projectatomic/bubblewrap.git)
- [bwrap-oci](git@github.com:projectatomic/bwrap-oci.git)

You can install the needed libraries with `sudo dnf build bubblewrap
bwrap-oci`.

After you've cloned the git repos, you can build bubblewrap and
bwrap-oci doing the usual:
```
autoreconf -f
./configure
sudo make install
```

This was the only time you needed root access through the demo.

If you are not already familiar with
it, [bubblewrap](https://github.com/projectatomic/bubblewrap) is the
core technology used by Flatpak for running sandboxed applications and
take advantage of user namespaces in the kernel.  It has a simple but
effective CLI interface:

$ bwrap --uid 0 --gid 0 --ro-bind / / bash -c \
   'echo "I am $(whoami) but cannot do much, see..."; touch pizza'
I am root but cannot do much, see...
touch: cannot touch 'pizza': Read-only file system

Bubblewrap needed a few features added to run privileged containers:
- allowing configuration of namespaces from an external application
- run a container without bubblewrap process reaping zombie processes
- allow Usernamespace linux capabilities to be left in the container.

[OCI runtime spec format](https://github.com/opencontainers/runtime-spec/blob/master/spec.md) describes
how to run a container using a standard JSON format.  The runtime spec
format is used by runC.

[bwrap-oci](https://github.com/projectatomic/bwrap-oci) is a tool that
bridges the gap between an OCI container and bubblewrap.  It
translates the JSON description into a list of arguments that
bubblewrap can understand.

One limitation with user namespaces is that a non privileged user, a
user process not holding `CAP_SETUID`/`CAP_SETGID` , is only allowed
to map one user in the new namespace.  This is fine for most
containers, but prevents  running containers that require multiple
different UIDS, for example systemd based containers.   Systemd needs
a range of uids/gids to be defined for its execution so that some
system services can be run as non root user (User= in a .service
file).
We  want to remove this limitation.   bwrap-oci uses a set of tools
that are part of the shadow-utils package: newuidmap and newgidmap to
circumvent this limitation.

newuidmap and newgidmap  are setuid root applications that configure
an user/group mapping in a new user namespace.  Since they run as
root, they can allow a user to create usernamespaces with multiple
user mappings.
This is of course very risky in principle since any user could map an
uid/gid in the parent namespace to the user namespace gaining full
control over it.  The system administrator limits the mappings done by
these tools to what is defined in /etc/subuid and /etc/subgid.  The
administrator defines a range  of uid/gid that each user can set for
their user namespaces, of course this is disabled by default.  Each
line in the file /etc/subuid file specifies the user in the parent
namespace, the initial uid of the range and the range length.  Same
thing for /etc/subgid and gids.

For example on my system, for my user I have defined this:

```
$ id -u
1000

$ grep ^gscrivano /etc/subgid
gscrivano:110000:65536
```

This allows my login process to use “newuidmap” to setup any mapping
in a new user namespace that points back to my uid 1000 and any other
defined in the additional range [110000, 110000+65536)

The uid/gid mapping done by bwrap-oci follows these two rules:

The uid/gid defined in the OCI config.json file (i.e. the uid/gid used
to exec the sandboxed program) must be  mapped to the uid/gid of the
user in the parent namespace.
Any other uid/gid in the range [0, AVAILABLE_UIDS] is mapped to the
additional ids defined for the user in the parent namespace, as
described above.

At this point we have all we need to run systemd as a non privileged
user.

In the bwrap-oci repository there is a [demo](https://github.com/projectatomic/bwrap-oci/blob/master/demos/run-systemd/run_demo.sh)
on how to setup a container, for simplicity I’ll skip the steps
required to build it here.

Run a container with bwrap-oci is extremely easy once you have the
rootfs with all the files required by the container and the
config.json,

I am not root:

```
$ id -u
1000
```

And I do not have any current capabilities:

```
$ grep ^Cap /proc/self/status
CapInh:    0000000000000000
CapPrm:    0000000000000000
CapEff:    0000000000000000
CapBnd:    0000003fffffffff
CapAmb:    0000000000000000
```

In order to run a container I am required to have a json file
describing the application to run and a rootfs directory structure
containing the application:

```
$ ls -l
-rw-rw-r--.  1 gscrivano gscrivano   5741 Jul  7 11:53 config.json
drwxrwxr-x. 18 gscrivano gscrivano   4096 Jul  6 12:26 rootfs
```

Now I use bwrap-oci to run the container:

```
$ bwrap-oci run systemd-demo
systemd 231 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
Detected virtualization container-other.
Detected architecture x86-64.

Welcome to Fedora 25 (Twenty Five)!

....
```

Thus, "systemd --system" running as an unprivileged init container!

From another shell, we can get a list of the containers known by bwrap-oci:

```
$ bwrap-oci list
NAME                          PID       STATUS    BUNDLE
systemd-demo               7412      running   /home/gscrivano/systemd-container
```

Systemd halts the machine on receiving the signal `SIGRTMIN+3`.  I use
directly the value of `SIGRTMIN+3` until “bwrap-oci kill” understands
signal names (you can also use directly kill -SIGRTMIN+3 $PID):

```
$ bwrap-oci kill systemd-demo 37
```

In the first shell we can see that systemd container is stopped now.


# Future directions:

Improve the integration of bwrap-oci tool into atomic. We'd like to
get more containers that we use now with ‘atomic install --system’ to
work with ‘atomic install --user’.  The main difference will be to use
bwrap-oci instead of runC as the containers backend.
User containers will use “systemd --user” instead of the system
systemd as we do with system containers to manage their life cycle.

The etcd container already works with bwrap-oci/bwrap and you should
be able to fully run it with “atomic install --user” and “systemctl
--user”.
