---
title: atomic top, docker top and ps
author: runcom
date: 2015-12-21 17:11:47 UTC
tags: Docker
comments: true
published: true
---

`atomic top` is a new atomic subcommand which will allow you to interactively display the top process information from _all_ of your containers running on a host. It works like standard top command where it will continuously update the top processes. Under the hood `atomic top` is using the Docker's top API to gather information about a particular container. When queried, the Docker daemon uses `ps` to give back results. The same happens with the Docker CLI.

The Docker's `top` command allows users to display the `ps` output for the main process of a given container ID or name. It's handy because it gives you back information about containers running on remote daemons as well.

While developing the `atomic top` subcommand we run through some weird *issues*  when we were interested, for instance, in listing only some `ps` colums.

Let's see how `docker top` is internally implemented and what gotchas and pitfalls you should be aware of when using `ps`.
How does it work?
-
First thing first, the command synopsis from the man page is `docker top [--help] CONTAINER [ps OPTIONS]`. `ps OPTIONS`
refers to any options the `ps` binary accepts.

On linux hosts, when you run `docker top CONTAINER`, the cli sends a request to the docker daemon (which could be running
on a different host) in order to get `ps` information for the given container. It does so by calling the `ps` binary from the host the daemon
is running on.

Internally, when no *ps options* are provided, the daemon firstly gets the PID of the given container, calls out `ps -ef`, then get its output, and finally 
filters out all but the line containing the container's PID. 

Instead, when a user provides  any `ps` options, the daemon simply drops `-ef` and just append user's options to `ps`. For instance, `docker top CONTAINER -o pid,cmd` calls `ps -o pid,cmd`.

So far so good you might think. But to fully understand `docker top` we should be aware of how `ps` works.
Enter `ps`
-
The main *gotcha* to understand about `ps` is that it accepts several kinds of options. Quoting from `man ps`:

> - UNIX options, which may be grouped and must be preceded by a dash.
> - BSD options, which may be grouped and must not be used with a dash.
> - GNU long options, which are preceded by two dashes.

What the above means is that doing `ps -ef` and `ps ef` (notice there's no dash in the second command) produces a totally different output:

```sh
# UNIX options
$ ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 19:32 ?        00:00:01 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
root         2     0  0 19:32 ?        00:00:00 [kthreadd]
root         3     2  0 19:32 ?        00:00:00 [ksoftirqd/0]
root         5     2  0 19:32 ?        00:00:00 [kworker/0:0H]
root         6     2  0 19:32 ?        00:00:00 [kworker/u16:0]
root         7     2  0 19:32 ?        00:00:00 [rcu_sched]
root         8     2  0 19:32 ?        00:00:00 [rcu_bh]
root         9     2  0 19:32 ?        00:00:00 [rcuos/0]
[...]

# BSD options
$ ps ef
PID TTY      STAT   TIME COMMAND
 3206 tty2     Ssl+   0:00 /usr/libexec/gdm-x-session --run-script gnome-session XDG_SEAT=seat0 LOGNAME=runcom USER=r
 3212 tty2     Sl+    0:10  \_ /usr/libexec/Xorg vt2 -displayfd 3 -auth /run/user/1000/gdm/Xauthority -nolisten tcp -
 3265 tty2     Sl+    0:00  \_ dbus-daemon --print-address 4 --session XDG_SEAT=seat0 LOGNAME=runcom USER=runcom USER
 3268 tty2     Sl+    0:00  \_ /usr/libexec/gnome-session-binary XDG_VTNR=2 XDG_SESSION_ID=1 GUESTFISH_INIT=\e[1;34m
 3341 tty2     Sl+    0:00      \_ /usr/libexec/gnome-settings-daemon XDG_VTNR=2 XDG_SESSION_ID=1 HOSTNAME=localhost.
 3427 tty2     SLl+   0:25      \_ /usr/bin/gnome-shell XDG_VTNR=2 XDG_SESSION_ID=1 GUESTFISH_INIT=\e[1;34m HOSTNAME=
 3449 tty2     Sl     0:00      |   \_ ibus-daemon --xim --panel disable XDG_VTNR=2 XDG_SESSION_ID=1 GUESTFISH_INIT=\
 3454 tty2     Sl     0:00      |       \_ /usr/libexec/ibus-dconf XDG_VTNR=2 XDG_SESSION_ID=1 GUESTFISH_INIT=\e[1;34
[...]
```

The first command (with the dash) is showing every process on the system (`-e` stands for **Select all processes**, `-f` stands for **Do full-format listing**).
In the second command `e` stands for **Show the environment after the command.** and `f` means the same as the UNIX variant.

By default, `ps` (**without flags**) selects all processes with the same effective user ID (euid=EUID) as the current user and associated with the same terminal as the invoker.  
However, there's an hidden note within the man page lines which says:

> The use of BSD-style options will also change the process selection to include processes on other terminals (TTYs) that are owned by you

So the second command shows what `ps` alone would have shown along with all other processes, owned by me, on different terminals (TTYs). This is clearly different from `ps -ef` which shows **all** processes in the system.

To achieve the same as `ps -ef` using BSD options you would have done `ps aux` instead. I'll leave to the reader understanding what `aux` does here.

To sum up this section:

-  `ps` shows all processes with the same effective user ID (euid=EUID) as the current user and associated with the same terminal as the invoker
- `ps -ef` shows **all** processes in the system and it's using UNIX options
- `ps  ef` is the same as `ps`,  it shows processes owned by me **but** it will show processes on other terminals (TTYs)
- I should have used `ps aux` to show **all** processes in the system using BSD options
- this isn't fun
- **TTYs are evil for `ps`**

When problems arise
-
Enough `ps` basics. Let's see how having those different UNIX/BSD options may cause troubles. Specifically, let's see  this with `docker top` and understand why I wrote **TTYs are evil for `ps`**.

Fire up two containers, one without a TTY and another with:

```sh
$ docker run -d fedora /usr/bin/vi # this won't have a TTY allocated
bb910bada1373d639d6ba98557a0f1319bf0164d0d3e3347adef4dff8a155862

$ docker run -ti fedora /bin/bash # this will have a TTY, as specified by -ti
[root@4a4fa008ac25 /]#

$ docker ps # in another terminal
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
4a4fa008ac25        fedora              "/bin/bash"         About a minute ago   Up About a minute                       distracted_ptolemy
bb910bada137        fedora              "/usr/bin/vi"       About a minute ago   Up About a minute                       loving_einstein
```

Now run `docker top`:

```sh
$ docker top 4a4fa008ac25
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                9046                2048                0                   20:36               pts/6               00:00:00            /bin/bash

$ docker top bb910bada137
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                8952                2048                0                   20:35               ?                   00:00:00            /usr/bin/vi
```

Everything works fine, both containers show `ps` output correctly. Notice how the first container - the *interactive* one - does have a TTY allocated - `pts/6` - while the other just shows `?`. 

From the previous sections we know that Docker is internally running `ps -ef` to get the list of all processes running on the system and filters out all lines but the line containing the container main process PID. We also know that the list contains all process on every TTY - which clearly includes processes with and without TTYs. So far so good again.

Now let's play around with columns. Let's say I'm interested in having only the `PID` column and the `CMD` column. I remember the option was `o`, or `-o`.. Whatever...Let's run `docker top` to filter out the colums we're not interested in, I'm going to use `o` now:

```sh
$ docker top 4a4fa008ac25 o pid,cmd 
PID                 CMD
9046                /bin/bash

$ docker top bb910bada137 o pid,cmd
PID                 CMD
```

What?! no output from the second `docker top`? Why? Maybe I should use `-o` instead:

```sh
$ docker top 4a4fa008ac25 -o pid,cmd
PID                 CMD

$ docker top bb910bada137 -o pid,cmd
PID                 CMD
8952                /usr/bin/vi
```

Great, now results are inverted and I'm not getting any output for the second container.

Breathe. Let's get a step back.

TTYs are evil in `ps`
-
Remember that `ps` with BSD options shows processes on other terminals (TTYs)? While empty or UNIX options selects all processes with the same effective user ID (euid=EUID) as the current user and **associated with the same terminal as the invoker**? The invoker in both cases is root from the docker daemon itself which also doesn't have a TTY (remember this):

```sh
$ ps -eo cmd,tty | grep docker
/usr/bin/docker daemon -D - ? # no TTY 
```

So, let's see what's happening in each case (given the invoker has no TTY as shown above):

- `docker top 4a4fa008ac25 -o pid,cmd`
	- container has TTY allocated
	- no output because the process **isn't** associated with the same terminal as the invoker  

- `docker top bb910bada137 -o pid,cmd`
	- container has no TTY 
	- output because the process **is** associated, apparently, with the same terminal as the invoker

- `docker top 4a4fa008ac25 o pid,cmd`
	- container has TTY 
	- output because BSD options shows processes on other  TTYs unless the TTY isn't allocated (try with `ps o tty`)

- `docker top bb910bada137 o pid,cmd`
	- container has a no TTY 
	- no output because BSD options shows all processes on other TTYs unless the TTY isn't allocated (try with `ps o tty`)
	
Clear. Well. Now that we _slightly_ understand how `docker top` and `ps` works, let's fix the above weird scenario by running the commands with the correct options:

```sh
# UNIX options
$ docker top 4a4fa008ac25 -eo pid,cmd
PID                 CMD
9046                /bin/bash

$ docker top bb910bada137 -eo pid,cmd
PID                 CMD
8952                /usr/bin/vi

# BSD options 
$ docker top 4a4fa008ac25 axo pid,cmd
PID                 CMD
9046                /bin/bash

$ docker top bb910bada137 axo pid,cmd
PID                 CMD
8952                /usr/bin/vi
```
I suggest you to go and have a look at the whole `man ps` to get a better sight on all of this. **Take special care of the BSD `a` and `x` options as we used them above to solve the issue**.

`atomic top`
-
`atomic top` is using the same way `docker top` queries for `ps` information. It slightly differs from `docker top` because it's using `ncurses` to have an interactive panel to list containers information, order colums, automatically add and remove containers and more. Following is a screenshot of what you'll have in the next atomic versions: 

![](images/atomic_top.png)

As a sidenote, if you want to list additional colums in `atomic top` you would just add `-o` with the fieds you're interested, as in:

```sh
$ sudo atomic top -o uid,gid

[..interactive and super cool panel :)..]
```

___

I hope I've covered the basics to avoid getting frustrated by the common pitfalls you could incur while using `ps`, `docker top`, and `atomic top`. This will also hopefully avoid anyone from filing bug reports against `docker top` when the wrong options are provided :)

Huge thanks for inspiration to **Brent Baude** and **Daniel Walsh**.