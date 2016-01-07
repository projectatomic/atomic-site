---
title: How to Run a More Secure Non-Root User Container
author: dwalsh
date: 2016-01-07 17:40 UTC
tags: docker, privledges
comments: true
published: true
---
I was asked a question about running users inside of a docker container: could they still get privileges?  

Before we begin, here is [more background on Linux capabilities](http://linux.die.net/man/7/capabilities)

We'll start with a simple container where the primary process is running as root.  One can look at the capabilities of the current process via `grep Cap /proc/self/status`.  There is also a `capsh` utility.

READMORE

```
# docker run --rm -ti fedora grep Cap /proc/self/status
CapInh:	00000000a80425fb
CapPrm:	00000000a80425fb
CapEff:	00000000a80425fb
CapBnd:	00000000a80425fb
CapAmb:	0000000000000000
```
Notice that the Effective Capabilities (`CapEff`) is a non-zero value, which means that the process has capabilities.

Using the `pscap` tool, I see that the process has these capabilities:

`chown, dac_override, fowner, fsetid, kill, setgid, setuid, setpcap, net_bind_service, net_raw, sys_chroot,`<br>
`mknod, audit_write, setfcap`

Now let's run a container as non-root using the `-u` option.

```
docker run -u 3267 fedora grep Cap /proc/self/status
CapInh:	00000000a80425fb
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	00000000a80425fb
CapAmb:	0000000000000000
```

Notice that the `CapEff` is all zero, but the bounding set of capabilities (`CapBnd`) is not.  This means if there is a setuid binary included in the image, it would be possible to gain these capabilities. Notice also, not surprisingly, this number matches the previous container's.

So, even though this process is running as non-root inside the container, it could potentially run with the same capabilities as above if the image builder included a setuid binary.

`chown, dac_override, fowner, fsetid, kill, setgid, setuid, setpcap, net_bind_service, net_raw, sys_chroot, mknod,`<br>
`audit_write, setfcap`

Docker has a nice feature where you can drop all capabilities via `--cap-drop=all`.  Now, if we execute the same container with a non-privileged user and drop all capabilities:

```
# docker run --rm -ti --cap-drop=all -u 3267 fedora grep Cap /proc/self/status
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	0000000000000000
CapAmb:	0000000000000000
```

Now this user cannot gain any capabilities on the system.  I would advise almost all users of Docker who run their containers with non-privileged users to use this feature. It adds a lot of security to the system.
