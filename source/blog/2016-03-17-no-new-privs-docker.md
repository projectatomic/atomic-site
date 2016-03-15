---
title: Docker credentials store
author: runcom
date: 2016-03-15 10:00:00 UTC
tags: docker
published: true
comments: true
---

Red Hat staff working on Project Atomic have contributed support for a `no-new-privileges` option to [docker](https://github.com/docker/docker/pull/20727).
This flag has already been included in [runc](https://github.com/opencontainers/runc/pull/557) and the Open Container Initiative
[spec](https://github.com/opencontainers/specs/pull/290).

The new flag supports, in Docker, a security feature that was added to the Linux kernel back in 2012 under the name `no_new_privs`. The kernel feature works as follows:

* A process can set the `no_new_privs` bit
in the kernel that persists across fork, clone and exec.
* The `no_new_privs` bit ensures that the process or its
children processes do not gain any additional privileges.
* A process isn't allowed to unset the `no_new_privs` bit
once it is set.
* Processes with `no_new_privs` are not allowed to change uid/gid or gain any other capabilities, even if the process executes setuid binaries or executables with file capability bits set.
* `no_new_privs` also prevents LSMs like SELinux from transitioning to process labels that have access not allowed to the current process.  This means an SELinux process is only allowed to transition to a process type with less privileges.

For more details see [kernel documentation](https://www.kernel.org/doc/Documentation/prctl/no_new_privs.txt)

Here is an example showcasing how it helps in Docker:

Create a setuid binary that displays the effective uid:

```
[$ dockerfiles]# cat testnnp.c
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char *argv[])
{
        printf("Effective uid: %d\n", geteuid());
        return 0;
}
[$ dockerfiles]# make testnnp
cc     testnnp.c   -o testnnp
```

Now we will add the binary to a docker image:

```
[$ dockerfiles]# cat Dockerfile
FROM fedora:latest
ADD testnnp /root/testnnp
RUN chmod +s /root/testnnp
ENTRYPOINT /root/testnnp

[$ dockerfiles]# docker build -t testnnp .
Sending build context to Docker daemon 12.29 kB
Step 1 : FROM fedora:latest
 ---> 760a896a323f
Step 2 : ADD testnnp /root/testnnp
 ---> 6c700f277948
Removing intermediate container 0981144fe404
Step 3 : RUN chmod +s /root/testnnp
 ---> Running in c1215bfbe825
 ---> f1f07d05a691
Removing intermediate container c1215bfbe825
Step 4 : ENTRYPOINT /root/testnnp
 ---> Running in 5a4d324d54fa
 ---> 44f767c67e30
Removing intermediate container 5a4d324d54fa
Successfully built 44f767c67e30
```

Now we will create and run a container without `no-new-privileges`:

```
[$ dockerfiles]# docker run -it --rm --user=1000  testnnp
Effective uid: 0
```
This shows that even though you requested a non privileged user (UID=1000) to run your container,
that user would be able to become root by executing the setuid app on the container image.

Running with `no-new-privileges` prevents the uid transition while running a setuid binary:

```
[$ dockerfiles]# docker run -it --rm --user=1000 --security-opt=no-new-privileges testnnp
Effective uid: 1000
```

As you can see above the container process is still running as UID=1000, meaning that even if the
image has dangerous code in it, we can still prevent the user from escalating privileges.

If you want to allow users to run images as a non-privileged UID, in most cases you would want to
prevent them from becoming root.  `no_new_privileges` is a great tool for guaranteeing this.
