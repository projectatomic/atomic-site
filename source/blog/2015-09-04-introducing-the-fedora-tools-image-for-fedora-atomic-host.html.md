---
title: Introducing the “fedora-tools” Image for Fedora Atomic Host
author: jeder
date: 2015-09-04 16:07:35 UTC
tags: Fedora, Docker, Atomic, Performance, Debugging
published: true
comments: true
---

Borrowing from the [developerblog](http://developerblog.redhat.com/2015/03/11/introducing-the-rhel-container-for-rhel-atomic-host/) entry, here's an introduction the “rhel-tools” image for RHEL Atomic Host.

When Red Hat’s performance team first started experimenting with Atomic, it became clear that our needs for low-level debug capabilities were at odds with the stated goal of Atomic to maintain a very small footprint.  If you consider your current production environment, most standard-builds do not include full debug capabilities, so this is nothing new.  What is new, is that on RHEL you could easily install any debug/tracing/analysis utility, but on Atomic:

`
-bash-4.2# dnf
bash: dnf: command not found
`

Whoops!  What’s this now???  If you haven’t played with Fedora Atomic yet, keep the first rule of Atomic in mind:

You don’t install software on Atomic.  You build containers on RHEL, CentOS, or Fedora, then run them on Atomic... sysadmin tools are no exception.

We always knew we needed an equivalent for Fedora... and we're happy to announce today the availability of the [fedora-tools image](https://hub.docker.com/r/fedora/tools/).

READMORE

# How Do I Use This Thing?

Here’s a [short video](https://youtu.be/W4D-TPge9-E) that shows how to use the tools container to do common "root"-require system administrator tasks:

* sosreport
* Snooping bridge traffic
* System service container (sadc/sar)
* Using the "perf" profiling tool

<iframe width="420" height="315" src="https://www.youtube.com/embed/W4D-TPge9-E" frameborder="0" allowfullscreen></iframe>

# Real-World Usage in the Field

One capability that we love having in the tools container is gdb.  gdb is an interactive debugger used to troubleshoot application crashes by analyzing process core dumps.

Here's a quick demo of how to analyze userspace core dumps on Atomic, using the tools container.

```
-bash-4.3# atomic host status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
* 2015-09-01 22:50:33     22.102     132444ceed     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
 2015-08-26 17:38:55     22.98      8b40b4d962     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
```

Download the Fedora and new Fedora Tools images:

```
-bash-4.3# docker pull fedora
latest: Pulling from docker.io/fedora
...
Status: Downloaded newer image for docker.io/fedora:latest

-bash-4.3# docker pull fedora/tools
latest: Pulling from docker.io/fedora/tools
...
Status: Downloaded newer image for docker.io/fedora/tools:latest
```

Launch a tools container:

```
-bash-4.3# atomic run --name tools fedora/tools
docker run -it --name tools --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=tools -e IMAGE=fedora/tools -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host fedora/tools
[root@f22-atomic /]# exit
exit
```

Now for the demo part... let's run a daemonized container that runs the sleep command.  Sleep could represent any daemonized application.  We are going to crash it, and analyze the core dump with gdb.

```
-bash-4.3# docker run -d fedora sleep infinity
9921bdd687eea85faa3f0365bb510c4e4e5df142295a2c8775e4c4a0912376a6
```

Get the pid of the process we are going to crash.

```
-bash-4.3# pid=$(pgrep sleep)
```

Using the gcore utility from the gdb package, crash the sleep pid within the container we created.

```
-bash-4.3# docker run fedora/tools gcore -o /host/tmp/democore $!
ptrace: No such process.
You can't do that without a process to debug.
The program is not being run.
gcore: failed to create /host/tmp/democore.1822
```

Ahh, why did that fail?  It failed because of PID namespace isolation.  A normal docker run invocation gives you a dedicated PID namespace for that container, starting with PID 1.

```
-bash-4.3# docker run -it fedora/tools ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  45860  2632 ?        Rs+  19:10   0:00 ps aux
```

So, the value of $pid does not exist inside this new container.  But... if you use ```--pid=host```, which is what the atomic run command does for you, you skip the PID namespace creation for the container, and operate in the host's PID namespace, where the value of $pid is valid.

```
-bash-4.3# atomic run fedora/tools pgrep sleep
1822
```

Now let's use the tools container to try and take a gcore of the sleep process running in another container.

```
-bash-4.3# atomic run fedora/tools gcore -o /host/tmp/democore $pid
warning: Target and debugger are in different PID namespaces; thread lists and other data are likely unreliable
0x00007fc297ba62c0 in __nanosleep_nocancel () from /lib64/libc.so.6
warning: target file /proc/2240/cmdline contained unexpected null characters
warning: Memory read failed for corefile section, 8192 bytes at 0x7ffe73d4e000.
Saved corefile /host/tmp/democore.1822
```

Okay, this time we were able to save a core at /host/tmp/democore.1822.  But what is /host ?  /host is a volume mount that Red Hat has chosen to standardize on for its super-privileged containers.  This list of options is embedded in the tools image label:

```
# docker inspect fedora/tools | grep RUN
            "RUN": "docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"
```

So, a tools image launched with the ```atomic``` command will be launched as above, including the ```-v/:/host``` volume.  This gives us a handy way to write stuff to the host from within a container, such as when using gcore and choosing where it should write out the core dump.

Also, notice the warning about being in different PID namespaces.  This warning means that certain data within the core file will not make sense when read back in a different PID namespace in which our gdb process will run.  It gives the example of thread lists, which for our sake can be thought of as PID namespaces.

Back on the Atomic host system, we can see the core file was in fact written to /tmp:

```
-bash-4.3# file /tmp/democore.$pid
/tmp/democore.2240: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style, from 'sleep'
```

We can now use the tools container to run gdb, and analyze the core dump:

```
-bash-4.3# atomic run fedora/tools gdb /host/tmp/democore.$pid -q -ex bt -batch
[New LWP 2240]
Core was generated by `sleep'.
#0  0x00007fc297ba62c0 in ?? ()
"/host/tmp/democore.2240" is a core file.
Please specify an executable to debug.
#0  0x00007fc297ba62c0 in ?? ()
#1  0x0000000000403e0f in ?? ()
#2  0x000000000001869f in ?? ()
#3  0x0000000000000000 in ?? ()
-bash-4.3#
```

The magic numbers above can be resolved into human-readable function names by installing the corresponding debuginfo package:

```
# dnf install --disablerepo=* --enablerepo=fedora-debuginfo coreutils-debuginfo
```
# sosreport

Unfortunately, the container support for sosreport has not yet been merged into Fedora.  We've discussed this, and are working quickly to update the Fedora tools image accordingly.

# Go Forth and Debug!

For more information, head over to the Red Hat Customer Portal and check out the [official rhel-tools documentation](https://access.redhat.com/articles/1336853).
