---
title: "What does --selinux-enabled do?"
author: dwalsh
date: 2016-07-11 12:00:00 UTC
tags: security, selinux, docker
published: true
comments: true
---

I recently answered an email asking about --selinux-enabled in the docker daemon, I thought others might wonder about this so I wrote this blog.

> I'm currently researching the topic of `--selinux-enabed` in docker and what it is doing when set to TRUE.
>
> From what I'm seeing, it simply will set context and labels to the services (docker daemon) when SELinux is enabled on the system and not using OverlayFS.
>
> But I'm wondering if that is even correct, and if so, what else is happening when setting `--selinux-enabled` to TRUE.

--selinux-enabled on the docker daemon causes it to set SELinux labels on the containers.  Docker reads the contexts file `/etc/selinux/targeted/contexts/lxc_contexts` for the default context to run containers.

```
cat /etc/selinux/targeted/contexts/lxc_contexts
process = "system_u:system_r:svirt_lxc_net_t:s0"
content = "system_u:object_r:virt_var_lib_t:s0"
file = "system_u:object_r:svirt_sandbox_file_t:s0"
sandbox_kvm_process = "system_u:system_r:svirt_qemu_net_t:s0"
sandbox_kvm_process = "system_u:system_r:svirt_qemu_net_t:s0"
sandbox_lxc_process = "system_u:system_r:svirt_lxc_net_t:s0"
```

Docker by default uses a confined SELinux type `svirt_lxc_net_t` to isolate the container processes from the host, and it generates a unique MCS label to allow SELinux to prevent one container process from attacking other container processes and content.

If you don't specify `--selinux-enabled`, docker does not execute SELinux code to set labels. When docker launches a container process, the system falls back to default transition policy.  This means the container processes will either run as docker_t or spc_t (Depending on the version of policy you have installed.) Both of these types are unconfined.  SELinux will provide no security separation for these container processes.

> In addition, I'm also wondering what the impact will be, when `--selinux-enabed` is set to TRUE together with `--icc` to TRUE? Does it have any impact or is it unrelated.
>
> Could it be possible that with `--icc` and `--selinux-enabed` set to TRUE that we might have challenges when communicating between Containers when the connection is not specified (as it should be, when `--icc` is set to FALSE).

It's unrelated. `--icc FALSE` sets up iptables rules that prevent containers from connecting to each other over the local network to each other.  The default SELinux policy allows all network connectivity between containers.

> Also, does anybody know what will happen if I run `docker` with `--selinux-enabled` for a while (so start containers, pull images, etc.) and then restart the daemon with `--selinux-enabled`. Is it possible that it does impact the environment somehow and that certain activities need to be done or shouldn't this affect the service at all?

The only potential problem I can think of would be volume mounting being mislabeled.  If you volume mount content off of the host with `-v /source/path:/dest/path:Z` and SELinux is disabled, docker will not set up labels for the container.  If you later turn on `--selinux-enabled` these containers would not be able to read/write the content in the mounted volume.  Thinking about this further, I am not sure what labels the containers created while `--selinux-disabled` was set.  These pre-created containers would probably continue to run with an unconfined domain, and newer containers would run with confinement.
