---
title: Update Kernel arguments on Atomic Host
author: rubao
date: 2018-03-06 17:00:00 UTC
published: true
comments: false
tags:
- atomic
- rpm-ostree
---

Users or adminstrators may want to change [kernel arguments](https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html) of Atomic Host for various reasons.
Before, it seemed hard for the users to do so due to many of
the steps involved, and the harmful consequeces that can occur if users accidentally
make a mistake in the changing process.

In this post, I want to introduce a command(rpm-ostree ex kargs) that
allows users to change kernel arguments on Atomic Host. This command simplifies
the process of changing kernel arguments into few simple commands. This command also
currently lies beneath [rpm-ostree](https://github.com/projectatomic/rpm-ostree),
and because of that, it benefits from many of the cool features from rpm-ostree.
One of them is `rpm-ostree rollback`, which can allow users to undo their old changes
they do not want.

Note: This command is still under experimentation, so if you have seen any
unexpected behavior happening, please report an issue to rpm-ostree. This
post also might be a bit difficult to understand without prior knowledge to
rpm-ostree and Atomic Host, please bear that in mind when reading this.


READMORE

Let's demonstrate some of the options that can be done with this command!

# Display the current kernel arguments

The rpm-ostree ex kargs command can allow users to see the kernel arguments
from different locations, including the current kernel arguments, arguments
from /proc/cmdline as well as kernel arguments from a specific deployment


The command following will show the kernel arguments from first bootable entry
in your grub.cfg:
```
[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0
```

This command will show you the kernel arguments from the first deployment
```
[root@localhost ~]# rpm-ostree ex kargs --deploy-index=0
The kernel arguments are:
no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0
```

This will show you the current kernel arguments being used in /proc/cmdline
```
[root@localhost ~]# rpm-ostree ex kargs  --import-proc-cmdline
The kernel arguments are:
no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0

```

# Changing the kernel arguments

Similarly, you can fetch kernel arguments from three different locations mentioned above,
but for readability and simplicty, we are only demoing with the first one(first
bootable entry) here.

You have four different options of changing kernel arguments in the command, all of those
will create a deployment, meaning its changes can be revertable. A more detailed description
will be shown by `rpm-ostree ex kargs --help`

## 1: Add one or multiple kernel arguments to the list

The user can append the argument using append option, and the format for the value
pair will be in terms of key=value. The changes are rollbackable as mentioned earlier.

```
[root@localhost ~]# rpm-ostree ex kargs --append=test_add=test
Copying /etc changes: 21 modified, 0 removed, 87 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Kernel arguments updated.
Run "systemctl reboot" to start a reboot
```

Now we want to verify if the changes got added to the grub.cfg, because
that is what is going to be used when user boots into the system

```
[root@localhost ~]# cat /boot/grub2/grub.cfg | grep test_add=test
linux16 /ostree/fedora-atomic-9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/vmlinuz-4.14.13-300.fc27.x86_64 no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.1/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0 test_add=test
linux16 /ostree/fedora-atomic-9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/vmlinuz-4.14.13-300.fc27.x86_64 no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.1/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0 test_add=test ds=nocloud\;h=localhost\;i=devmode\;s=/usr/share/atomic-devmode/cloud-init.
```

Now we want to show that changes are rollbackable
```
[root@localhost ~]# systemctl reboot
Connection to 192.168.121.188 closed by remote host.
Connection to 192.168.121.188 closed.

[root@localhost ~]# rpm-ostree rollback
Moving '772ab185b0752b0d6bc8b2096d08955660d80ed95579e13e136e6a54e3559ca9.0' to be first deployment
Transaction complete; bootconfig swap: yes deployment count change: 0
Run "systemctl reboot" to start a reboot
[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0

```

## 2: Replace one or multiple arguments

To replace the value, the input will be in the form of key=oldvalue=newvalue, or when there
is only one single key value pair, you can replace it by key=newvalue. Note, to avoid duplication,
we skip the process of changing the actual grub.cfg here.

```
[root@localhost ~]# rpm-ostree ex kargs --replace no_timer_check=""=test_val --replace net.ifnames=0=new_val
Copying /etc changes: 21 modified, 0 removed, 92 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Kernel arguments updated.
Run "systemctl reboot" to start a reboot
[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
no_timer_check=test_val console=tty1 console=ttyS0,115200n8 net.ifnames=new_val biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.1/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0

[root@localhost ~]# rpm-ostree ex kargs --replace no_timer_check="" --replace net.ifnames=0
Copying /etc changes: 21 modified, 0 removed, 92 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Kernel arguments updated.
Run "systemctl reboot" to start a reboot
[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
no_timer_check console=tty1 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0
```

## 3: Delete one or multiple arguments

To delete one or more kernel arguments, the input will be in the form of key=value format. Similarly, when
there is only one single key=value pair, we allow users to delete argument by key name.

```
[root@localhost ~]# rpm-ostree ex kargs --delete no_timer_check --delete console=tty1
Copying /etc changes: 21 modified, 0 removed, 92 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Kernel arguments updated.
Run "systemctl reboot" to start a reboot
[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.1/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0

```

## 4: Allow user to do all above actions using an editor

Note: the kernel arguments were from the previous section, and the example below will show
you the already changed ones because it is hard to demo from a separate editor side.

```
[root@localhost ~]# rpm-ostree ex kargs --editor

======================================EDITOR SCREEN=================================================
# Please enter the kernel arguments. Each kernel argument# should be in the form of key=value.
# Lines starting with '#' will be ignored. Each key=value pair should be
# separated by spaces, and multiple value associated with one key is allowed.
# Also, please note that any changes to the ostree argument will not be
# effective as they are usually regenerated when bootconfig changes.
test=test console=ttyS0,115200n8 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root
=====================================END OF EDITOR SCREEN===========================================
Copying /etc changes: 21 modified, 0 removed, 92 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Kernel arguments updated.
Run "systemctl reboot" to start a reboot

[root@localhost ~]# rpm-ostree ex kargs
The kernel arguments are:
test=test console=ttyS0,115200n8 biosdevname=0 rd.lvm.lv=atomicos/root root=/dev/mapper/atomicos-root ostree=/ostree/boot.0/fedora-atomic/9a9b350be75846811cbb0b1fd7b3d42a49908ed1265bc59e292bb4a34674332c/0
```

# More information:
- [Upstream pull request](https://github.com/projectatomic/rpm-ostree/pull/1013)
- [Original proposal](https://github.com/projectatomic/rpm-ostree/issues/594)
```

