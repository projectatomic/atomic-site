---
title: Logging Docker Container Output to journald
author: dwalsh
date: 2015-04-28 17:26:27 UTC
tags: Docker, logging, journald
comments: true
published: true
---

[Docker](https://www.docker.com/) has added a new feature to allow alternate logging drivers, and soon you'll be able to use `journald` as a supported driver.

With Docker 1.6 they support json-file, which is the old default, syslog, or no logging at all.

READMORE

If you ran your docker daemon with the `--log-driver=syslog` option, any output from a container would go directly to system syslog daemon, and usually end up in /var/log/messages.

I added a patch to support journald as a logging driver, and it was [recently merged](https://github.com/docker/docker/pull/12557).  

In docker-1.7 you will have the option to use `--log-driver=journald` on either your docker daemon to cause all of your container logging to go directly to the journal, or you could use the --log-driver=journald on a docker run/create line, so you could get individual containers running with different logging drivers.

To test this I set up my docker daemon to run with the following options.  

```docker -d --selinux-enabled --log-driver=journald```

Now I run a simple container.

```docker run fedora echo "Dan Walsh was here"```

Then I look up the container ID for the newly created container, and I can use journalctl to examine the content.

```
journalctl MESSAGE_ID=cdf02c627e27
-- Logs begin at Mon 2015-04-06 16:06:42 EDT, end at Fri 2015-04-24 08:40:38 EDT. --
Apr 20 15:06:39 dhcp-10-19-62-196.boston.devel.redhat.com docker[27792]: Dan Walsh was here
```

Currently the `docker logs` command only works with the json-file backend. But I hope to eventually get the docker daemon to communicate with the journald to get this information. Of course if anyone wants to take a stab at this, we would welcome your effort.

As mentioned, the journald backend for `--log-driver` is not shipping in Docker today, but should be available in the 1.7 release. Keep reading here or follow [@projectatomic](https://twitter.com/projectatomic) for updates on new and interesting features in Docker.