---
title: Using Volumes with Docker can Cause Problems with SELinux
author: dwalsh
date: 2015-06-15 17:52:00 UTC
tags: SELinux, Volumes, Docker
comments: true
published: true
---

When using SELinux for controlling processes within a container, you need to make sure any content that gets volume mounted into the container is readable, and potentially writable, depending on the use case.

By default, Docker container processes run with the `system_u:system_r:svirt_lxc_net_t:s0` label.  The `svirt_lxc_net_t` type is allowed to read/execute most content under /usr, but it is not allowed to use most other types on the system. 

READMORE

If you want to volume mount content under `/var`, for example, into a container you need to set the labels on this content.  In the `docker run` man page we mention this.

```
man docker-run
...
When  using  SELinux,  be  aware that the host has no knowledge of container SELinux policy. Therefore, in the above example, if SELinux policy  is enforced,  the /var/db directory is not  writable to the container. A "Permission Denied" message will occur and an avc: message in the host's syslog.

To  work  around  this, at time of writing this man page, the following command needs to be run in order for the  proper  SELinux  policy  type label to be attached to the host directory:

# chcon -Rt svirt_sandbox_file_t /var/db
```

This got easier recently since Docker finally merged a patch which will be showing up in docker-1.7 (We have been carrying the patch in docker-1.6 on RHEL, CentOS, and Fedora).

This patch adds support for "z" and "Z" as options on the volume mounts (-v).

For example:

```
  docker run -v /var/db:/var/db:z rhel7 /bin/sh
```
Will automatically do the `chcon -Rt svirt_sandbox_file_t /var/db` described in the man page.

Even better, you can use `Z`.

```
  docker run -v /var/db:/var/db:Z rhel7 /bin/sh
```

This will label the content inside the container with the exact MCS label that the container will run with, basically it runs `chcon -Rt svirt_sandbox_file_t -l s0:c1,c2 /var/db` where `s0:c1,c2` differs for each container.

I have a [bug](https://bugzilla.redhat.com/show_bug.cgi?id=1230098)
 that was reported to me, that might become common. The user got AVC's that looked like the following.

Raw Audit Messages

_type=AVC msg=audit(1433926625.524:1347): avc:  denied  { write } for  pid=29280 comm="launch" name="addons" dev="dm-2" ino=2491404 scontext=system_u:system_r:svirt_lxc_net_t:**s0:c147,c266** tcontext=system_u:object_r:svirt_sandbox_file_t:**s0:c372,c410** tclass=dir permissive=0_

Notice the bolded MCS labels. 

The problem here was the user created a volume and labeled it from one container with the "Z" for one container, then attempted to share it in another container.  Which SELinux denied since the Multi-Category Security (MCS) labels differed. 

I told the reporter that he needs to mount it using Z or z, since at some point the volume got a different containers labels on it.

Your container processes are running with this label, `system_u:system_r:svirt_lxc_net_t:s0:c147,c266` Notice the `s0:c147,c266`
The volume mount is labeled `system_u:object_r:svirt_sandbox_file_t:s0:c372,c410` Notice the MCS label `s0:c372,c410` MCS Security prevents read/write of content with different MCS labels. However it will allow read/write of content labeled with an s0 label.

If you volume mount a image with `-v /SOURCE:/DESTINATION:z` docker will automatically  relabel the content for you to s0. If you volume mount with a "Z", then the label will be specific to the container, and not be able to be shared between containers.
