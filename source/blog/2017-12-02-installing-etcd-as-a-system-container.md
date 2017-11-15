---
title: Installing etcd as a System container
author: smilner
date: 2017-10-20 20:00:00 UTC
published: false
comments: true
tags: atomic, etcd, system containers, runc, containers
---

System Containers exist as a way to provide containerized services to a host before traditional container runtimes are ready. System
Containers do this by utilizing a runc and systemd units and do not deviate from the OCI standards. Let's look at how someone can
use a system containers to install the ever popular etcd today on Fedora 27 Atomic Host!

READMORE


## Atomic Host

The first thing one must have is Fedora 27 Atomic Host installed. As a reminder, Atomic Host allows people to use immutable infrastructure
to deploy and scale your containerized applications. Project Atomic builds OSes, tools, and containers for cloud native platforms.

To grab a copy of the Fedora 27 version of Atomic Host head on over to the [get fedora page for atomic](https://getfedora.org/en/atomic/download/).


## Installing etcd

As one would expect the ``atomic`` command is used for pulling, installing, updating, deleting, and manipulating system containers.
Let's install the [etcd system container](https://admin.fedoraproject.org/pkgdb/package/container/etcd/) from the
[Fedora Layered Image Build System](https://docs.pagure.org/releng/layered_image_build_service.html) with the following command:

```
$ sudo atomic install --system --name=etcd registry.fedoraproject.org/f26/etcd:latest
Pulling layer 01aae00bf9e4a7301133bac6641015fc1677a19ef13844f5b274cf6233515fdf
Pulling layer 9dbaf15c249f7ed8a76b8f2b785cc603172af8271e18cf28884bca36f7e39311
Extracting to /var/lib/containers/atomic/etcd.0
Created file /etc/etcd/etcd.conf
Created file /usr/local/bin/etcdctl
systemctl daemon-reload
systemd-tmpfiles --create /etc/tmpfiles.d/etcd.conf
systemctl enable etcd
$
```

What did we do? Let's break it down:

* ``sudo atomic``: We are executing the atomic command with root privileges
* ``install``: We are denoting we want to install a container
* ``--system``: And the type of the container we want to install is a system container
* ``--name etcd``: The name of the container should be etcd
* ``registry.fedoraproject.org/f26/etcd:latest``: This is the image to use when creating the container

The output shows us:

* The layers that were pulled
* Where the containers root file system was extracted
* Files that were created by the install of the container
* systemd reload, tmpfiles, and service enablement


## Configuration at Install Time

System Containers allow for options to be set at install time. These options may be used for templating file
contents, file names, and directory names. How does one figure out what options are available? The
``atomic`` command of course!

```
# atomic info --storage ostree registry.fedoraproject.org/f26/etcd
Image Name: registry.fedoraproject.org/f26/etcd:latest
<snip/>

Template variables with default value, but overridable with --set:
ADDTL_MOUNTS: 
CONF_DIRECTORY: {SET_BY_OS}
<snip/>
ETCD_DEBUG: false
ETCD_DISCOVERY: 
ETCD_DISCOVERY_FALLBACK: proxy
ETCD_DISCOVERY_PROXY: 
ETCD_DISCOVERY_SRV: 
ETCD_ELECTION_TIMEOUT: 1000
ETCD_ENABLE_PPROF: false
ETCD_HEARTBEAT_INTERVAL: 100
ETCD_INITIAL_ADVERTISE_PEER_URLS: 
ETCD_INITIAL_CLUSTER: 
ETCD_INITIAL_CLUSTER_STATE: new
ETCD_INITIAL_CLUSTER_TOKEN: etcd-cluster
<snip/>
ETCD_SNAPSHOT_COUNT: 10000
ETCD_STRICT_RECONFIG_CHECK: false
ETCD_TRUSTED_CA_FILE: 
ETCD_WAL_DIR: 
PIDFILE: {SET_BY_OS}
RUN_DIRECTORY: {SET_BY_OS}
STATE_DIRECTORY: {SET_BY_OS}
UUID: {SET_BY_OS}
```

As one can see there are quite a few options available. In fact, there are so many options
some have been left out above for the sake of blog post readability. If we wanted
to install the etcd container with, say, ``ETCD_DEBUG`` set to ``true`` and
``ETCD_SNAPSHOT_COUNT`` set to ``10500`` we would do the following install command:

```
$ sudo atomic install --system --name=etcd \
  --set ETCD_DEBUG=true \
  --set ETCD_SNAPSHOT_COUNT=10500 \
  registry.fedoraproject.org/f26/etcd:latest
```


## Running etcd

Since we named the container etcd the systemd service will also be called etcd. We could have called it anything
but for the sake of simplicity etcd was used. So let's take a look at the service:

```
$ sudo systemctl status etcd    
● etcd.service - Etcd Server
   Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: inactive (dead)
```


As expected the service is currently not running but is enabled. So let's start it up!

```
$ sudo systemctl start etcd
$ sudo systemctl status etcd
● etcd.service - Etcd Server
   Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: disabled)       
   Active: active (running) since Wed 2017-10-25 15:03:31 EDT; 13s ago
 Main PID: 1210 (runc)
    Tasks: 8 (limit: 4915)
   Memory: 16.0K
      CPU: 3ms
   CGroup: /system.slice/etcd.service
           └─1210 /bin/runc --systemd-cgroup run etcd
<snip/>
```

Well, that was easy!


## Using Etcd

The quickest way to check an etcd service is making REST calls. Atomic Host already has ``curl``
installed so let's use that:

```
$ curl 127.0.0.1:2379/v2/keys/
{"action":"get","node":{"dir":true}}
$
```

We can see from the output that etcd is indeed running and responding to connections. Let's
ensure it's also storing data:

```
$ curl -X PUT -d value="system container service" 127.0.0.1:2379/v2/keys/test
{"action":"set","node":{"key":"/test","value":"system container service","modifiedIndex":4,"createdIndex":4}}
$ curl 127.0.0.1:2379/v2/keys/test
{"action":"get","node":{"key":"/test","value":"system container service","modifiedIndex":4,"createdIndex":4}}
$
```

As we can see it's storing and returning data fine. Remember when we installed the container and saw
some files were created? One of them was ``etcdctl`` and was placed in ``/usr/local/bin/``. This means
that we should have access to the traditional ``etcdctl`` command.

```
$ etcdctl ls -r
/test
$ etcdctl get test         
system container service
$
```

## Configuration
Since we installed the etcd system container without any special options we'll need to edit
the configuration file directly to make configuration changes. Just as it did with the ``etcdctl``
the system container install created ``/etc/etcd/etcd.conf``. This file is used to configure etcd
allowing the admin to modify it just as they would if they installed etcd via rpm or source install.

```
$ sudo vi /etc/etcd/etcd.conf
$ sudo systemctl restart etcd
```

## Conclusion

System Containers provide a way of running containerized system services early in the boot process and exposing
administration in a way that operators have come to expect. Find more system containers via the
[system containers development](https://github.com/projectatomic/atomic-system-containers/) and start
containerizing your system services on Atomic Host!
