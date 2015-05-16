---
author: dwalsh
comments: true
layout: post
title: Running Syslog Within a Docker Container
date: 2014-09-11 20:06 UTC
tags:
- Syslog
- Docker
- RHEL
- systemd
- journald
categories:
- Blog
---
Recently I received a [bug report](https://bugzilla.redhat.com/show_bug.cgi?id=1139734) on Docker complaining about using rsyslogd within a container.  
 
The user ran a RHEL7 container, installed rsyslog, started the daemon, and then sent a logger message, and nothing happened.

``` 
# docker run -it --rm rhel /bin/bash
# yum -y install rsyslog
# /usr/sbin/rsyslogd
# logger "this is a test"
``` 
 
No message showed up in `/var/log/messages` within the container, or on the host machine for that matter.
 
The user then looked and noticed that `/dev/log` did not exist and this was where logger was writing the message. The user thought this was a bug.
 
The problem was that in RHEL7 and Fedora we now use journald, which listens on `/dev/log` for incoming messages. In RHEL7 and Fedora, rsyslog actually reads messages from the journal via its API by default.
 
But not all docker containers run systemd and journald. (Most don't). In order to get the rsyslogd to work the way the user wanted, he would have to modify the configuration file, `/etc/rsyslogd.conf`:
 
* In `/etc/rsyslog.conf` remove `$ModLoad imjournal`.
* Set `$OmitLocalLogging` to `off`.
* Make sure `$ModLoad imuxsock` is present.
* Also comment out: `$IMJournalStateFile imjournal.state`.
 
After making these changes rsyslogd will start listening on `/dev/log` within the container and the logger messages will get accepted by rsyslogd and written to `/var/log/messages` within the container.
 
If you wanted to logging messages to go to the host logger, you could "volume" mount `/dev/log` into the container.

``` 
# docker run -v /dev/log:/dev/log -it --rm rhel /bin/bash
# logger "this is a test"
``` 

The message should show up in the host's journalct log, and if you are running rsyslog on the host, the message should end up in `/var/log/messages`.
