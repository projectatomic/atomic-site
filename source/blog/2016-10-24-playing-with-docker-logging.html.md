---
title: Better ways of handling logging in containers
author: dwalsh
date: 2016-10-24 10:00:00 UTC
tags: docker, logging, volumes, administration
published: true
comments: true
---

Traditional logging systems, like syslog, do not quite work by default with Containers. This is especially true if they are running without an init system in the container.

## STDIN/STDERR messages in journal

I recently received a [bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1386661) report complaining about logging inside of a docker container.

First the user complained about all of STDOUT/STDERR showing up in the journal. This can actually be configured in the docker daemon using the --log-driver parameter:

```
man dockerd
...

  --log-driver="json-file|syslog|journald|gelf|fluentd|
   awslogs|splunk|etwlogs|gcplogs|none"
  Default driver for container logs. Default is json-file.
  Warning: docker logs command works only for json-file logging driver.
```

Red Hat based Operating Systems use `--log-driver=journald` by default, because we believe log files should be permanently stored on the host system.  The upstream docker default is `json-file`.  With `json-file` the logs are removed when an admin removes the container using `docker rm`. .  Another problem with the `json-file` logger is that tools that maintain logs won’t work with them. ,  We were having problems with containers’ logs filling up the system, and users not knowing what was using up the space.  

If you don't like our default, including the STDOUT/STDERR messages being recorded in the journal, you can edit /etc/sysconfig/docker and change the log-driver.

The bugzilla report then went on to ask about getting syslog and journal messages from the container.  Where do these messages generated inside of the container end up?

## syslog and journal log messages silently dropped by default

One big problem with standard docker containers is that any service that writes messages to syslog or directly to the journal get dropped by default.  Docker does not record any logs unless the messages are written to STDIN/STDERR.  There is no logging service running inside of the container to catch these messages.

## Running a logging system inside of the container

If you want proper logging setup, I would suggest that you investigate running
[systemd inside of a container.](http://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/).  This would setup systemd as pid 1, but would also run journald inside of the container and the syslog and journal messages would be handled the same was as when they are on the hosts.

A lot of people do not want to run a full init system inside of their containers.  Another option would be to have services running on the host listen for these messages.  An administrator can  volume mount in the hosts sockets into your container.  

Let's look into this.

## Getting messages out of the container to the host logging system.

The bug reporter went on to show that volume mounting the /dev/log from the host into the container did not successfully get log messages from the container to the host journal.  They got messages sent to syslog, but not to the journal:

```
# docker run -ti -v /dev/log:/dev/log fedora sh
container# dnf -y install systemd-python
...
container# python <<< "from systemd import journal; journal.send('journald Hello')"
container# logger "logger Hello"
container# exit

# journalctl -b | grep Hello
Oct 19 09:53:28 dhcp-10-19-62-196.boston.devel.redhat.com root[16787]: logger Hello
```

Notice that the "journald Hello" message to the journal does not show up, but the logger message does. The difference is syslog messages sent from the logger command write to /dev/log, and journald on the host is listening for syslog messages there. When it sees the message sent to the bind mounted /dev/log, it logs the message in the journal.

The python `journal.send` call attempts to write "journald Hello" to the  /run/systemd/journald/socket socket.  This socket does not exists inside of the container and the python code silently drops the message.

The following example works for me, binding in the hosts journal socket:

```
# docker run -ti -v /dev/log:/dev/log -v /var/run/systemd/journal/socket:/var/run/systemd/journal/socket fedora sh
container# dnf -y install systemd-python
...
container# python <<< "from systemd import journal; journal.send('journald Hello')"
container# logger "logger Hello"
container# exit

# journalctl -b | grep Hello
Oct 19 09:57:51 dhcp-10-19-62-196.boston.devel.redhat.com python[17523]: journald Hello
Oct 19 09:57:53 dhcp-10-19-62-196.boston.devel.redhat.com root[16787]: logger Hello
```

The `journal.Send` call above connects to /run/systemd/journal/socket and since we leaked it into the container, the messages gets to the host’s journal.

Note: SELinux was in enforcing mode for all of these tests.   We allow container processes to communicate with the journal/syslog sockets on the host by default.

# Conclusion

Handling of logging messages inside of containers can be difficult, most users just ignore this and rely on the applications to read/write STDOUT/STDERR.   Getting syslog and journal messages out of the containers, requires an application to be listening on /dev/log and /run/system/journal/socket.  The application that listens can either be run inside of the container or you can take advantage of volume mounts to listen from outside of the container.
