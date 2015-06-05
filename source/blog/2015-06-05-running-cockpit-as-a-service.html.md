---
title: Running Cockpit as a service in Fedora 22 Atomic Host
author: mmicene
date: 2015-06-05 04:00:00 UTC
layout: post
comments: true
categories: 
  - Blog
---


With the release of Fedora 22 Atomic host, the Cockpit Project team changed the way cockpit was delivered.  We now have a super-privileged container (SPC) for the web service (cockpit-ws) with the bridge, shell, and docker components installed by default on the Atomic host.  You can read more about the change on the [Cockpit Project wiki page](https://github.com/cockpit-project/cockpit/wiki/Atomic).

```
cockpit-shell-0.55-1.fc22.noarch
cockpit-docker-0.55-1.fc22.x86_64
cockpit-bridge-0.55-1.fc22.x86_64
```

READMORE

This means you can simply run `atomic run fedora/cockpitws` as root or with sudo and cockpit will be running on port 9090.  

### Inspecting the new SPC
Very simple, but that means you'll need to manually restart cockpit after a reboot.  To make the cockpitws container start and stop with the system, we need a systemd unit file.

Using `atomic info`, look at the LABELs the Cockpit Project team used in the Dockerfile for the SPC.

```
[fedora@atomic-cockpit ~]$ sudo atomic info fedora/cockpitws
RUN          : /usr/bin/docker run -d --privileged --pid=host -v /:/host IMAGE /container/atomic-run --local-ssh
INSTALL      : /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /container/atomic-install
UNINSTALL    : /usr/bin/docker run -ti --rm --privileged -v /:/host IMAGE /cockpit/atomic-uninstall
```

These LABELs are used by `atomic` to determine what docker command line to build when `atomic run`, `atomic install`, or `atomic uninstall` are issued.  In order to make the systemd unit file behavior match the `atomic run` behavior, we'll the RUN label as our model.

### Install the container
Install the cockpitws container using `atomic`.

```
[fedora@atomic-cockpit ~]$ sudo atomic install fedora/cockpitws
/usr/bin/docker run -ti --rm --privileged -v /:/host fedora/cockpitws /container/atomic-install
+ sed -e /pam_selinux/d -e /pam_sepermit/d /etc/pam.d/cockpit
+ mkdir -p /host/etc/cockpit/ws-certs.d
+ chmod 755 /host/etc/cockpit/ws-certs.d
+ chown root:root /host/etc/cockpit/ws-certs.d
+ mkdir -p /host/var/lib/cockpit
+ chmod 775 /host/var/lib/cockpit
+ chown root:wheel /host/var/lib/cockpit
+ /bin/mount --bind /host/etc/cockpit /etc/cockpit
+ /usr/sbin/remotectl certificate --ensure
```

There's a few things going on here in the install method.  

Note that we're exposing the Atomic host root directory to the container at `/host`.  As a SPC, this allows the container to access the host filesystem and make changes. The install method creates a set of directories in `/etc` and `/var` to persist configs.  This means that we don't need any particular cockpitws container to stick around, any cockpitws container will be able to read the appropriate state from the host.  We can upgrade the cockpit image and not worry about losing data.  Since `/etc` and `/var` are writable on an Atomic host, and `/etc` content will be appropriately merged on a tree change, cockpit data will also survive an `atomic host upgrade` as well.

### Set up the systemd unit
With the container available to docker, we'll build the systemd unit file next.  For local systemd unit files, we want them to reside in /etc/systemd/system.

```
[fedora@atomic-cockpit ~]$ sudo vi /etc/systemd/system/cockpitws.service

[Unit]
Description=Cockpit Web Interface
Requires=docker.service
After=docker.service

[Service]
Restart=on-failure
RestartSec=10
ExecStart=/usr/bin/docker run --rm --privileged --pid host -v /:/host --name %p fedora/cockpitws /container/atomic-run --local-ssh
ExecStop=-/usr/bin/docker stop -t 2 %p

[Install]
WantedBy=multi-user.target
```

The `ExecStart` line in the unit file looks nearly identical to the RUN label, with one change.  When running containers from systemd, we don't want to use `docker -d`, instead we want either `docker -a` or `docker --rm`.  We're using `docker --rm` here since we don't need this particular container instance to survice a restart.  We are going to name container using the `%p` tag to pick up the systemd service name, just to make it easier to find in `docker ps`.

Now we can reload systemd to read the new unit file, enable the service to start on reboot, and then start the new cockpitws service.

```
[fedora@atomic-cockpit ~]$ sudo systemctl daemon-reload

[fedora@atomic-cockpit ~]$ sudo systemctl enable cockpitws.service 
Created symlink from /etc/systemd/system/multi-user.target.wants/cockpitws.service to /etc/systemd/system/cockpitws.service.

[fedora@atomic-cockpit ~]$ sudo systemctl start cockpitws.service 

[fedora@atomic-cockpit ~]$ sudo systemctl status cockpitws.service 
● cockpitws.service - Cockpit Web Interface
   Loaded: loaded (/etc/systemd/system/cockpitws.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2015-06-05 14:56:17 UTC; 9s ago
 Main PID: 1595 (docker)
   Memory: 0B
   CGroup: /system.slice/cockpitws.service
           └─1595 /usr/bin/docker run --rm --privileged --pid host -v /:/host...

Jun 05 14:56:17 atomic-cockpit.localdomain systemd[1]: Starting Cockpit Web I...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + sed -e /pam_selinu...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + mkdir -p /host/etc...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + chmod 755 /host/et...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + chown root:root /h...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + mkdir -p /host/var...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + chmod 775 /host/va...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + chown root:wheel /...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + /bin/mount --bind ...
Jun 05 14:56:17 atomic-cockpit.localdomain docker[1595]: + /usr/sbin/remotect...
Hint: Some lines were ellipsized, use -l to show in full.
```

Now that the service is up and running, point your web brower at port 9090 on the Atomic host and you should see the Cockpit login page.  Log in with the `fedora` credentials and you should be ready to go.  You can add other hosts to this Cockpit instance, with the knowledge that reboots and upgrades to the host or the container won't affect the configuration.
