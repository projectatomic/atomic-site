---
title: Running a Containerized Cockpit UI from Cloud-init
author: jbrooks
date: 2015-08-26 20:13:21 UTC
tags: cockpit, fedora, atomic, systemd, cloud-init, docker
published: false
comments: true
---

Fedora 22's Atomic Host dropped most of packages for the web-based server UI, [cockpit](http://cockpit-project.org/), from its system tree in favor of a containerized deployment approach. [Matt Micene](https://twitter.com/cleverbeard) blogged about [running cockpit-in-a-container with systemd](http://www.projectatomic.io/blog/2015/06/running-cockpit-as-a-service/), but people have [expressed interest](https://fedorahosted.org/cloud/ticket/105) in learning how to start this container automatically, with cloud-init.

### cloud-init and cockpit

Referencing the sample `cockpitws.service` file from [Matt's post](http://www.projectatomic.io/blog/2015/06/running-cockpit-as-a-service/), and using cloud-init's [cloud-config-write-files](http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/examples/cloud-config-write-files.txt) functionality, I started out with this service file:

```
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

Next, I converted the service file to base 64, for inclusion in the cloud-init user-data file:

 ```
$ base64 cockpitws.service

W1VuaXRdCkRlc2NyaXB0aW9uPUNvY2twaXQgV2ViIEludGVyZmFjZQpSZXF1aXJlcz1kb2NrZXIuc2VydmljZQpBZnRlcj1kb2NrZXIuc2VydmljZQoKW1NlcnZpY2VdClJlc3RhcnQ9b24tZmFpbHVyZQpSZXN0YXJ0U2VjPTEwCkV4ZWNTdGFydD0vdXNyL2Jpbi9kb2NrZXIgcnVuIC0tcm0gLS1wcml2aWxlZ2VkIC0tcGlkIGhvc3QgLXYgLzovaG9zdCAtLW5hbWUgJXAgZmVkb3JhL2NvY2twaXR3cyAvY29udGFpbmVyL2F0b21pYy1ydW4gLS1sb2NhbC1zc2gKRXhlY1N0b3A9LS91c3IvYmluL2RvY2tlciBzdG9wIC10IDIgJXAKCltJbnN0YWxsXQpXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAo=
```

Referencing another of Matt's posts, [on cloud-init](http://www.projectatomic.io/blog/2014/10/getting-started-with-cloud-init/), I made this simple user-data file, which combines the write-files cloud-config bit for writing the service file with the [cloud-config-run-cmds](http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/examples/cloud-config-run-cmds.txt) feature for enabling and starting the service:

```
#cloud-config
password: atomic
chpasswd: { expire: False }
ssh_pwauth: True
write_files:
-   encoding: b64
    content: W1VuaXRdCkRlc2NyaXB0aW9uPUNvY2twaXQgV2ViIEludGVyZmFjZQpSZXF1aXJlcz1kb2NrZXIuc2VydmljZQpBZnRlcj1kb2NrZXIuc2VydmljZQoKW1NlcnZpY2VdClJlc3RhcnQ9b24tZmFpbHVyZQpSZXN0YXJ0U2VjPTEwCkV4ZWNTdGFydD0vdXNyL2Jpbi9kb2NrZXIgcnVuIC0tcm0gLS1wcml2aWxlZ2VkIC0tcGlkIGhvc3QgLXYgLzovaG9zdCAtLW5hbWUgJXAgZmVkb3JhL2NvY2twaXR3cyAvY29udGFpbmVyL2F0b21pYy1ydW4gLS1sb2NhbC1zc2gKRXhlY1N0b3A9LS91c3IvYmluL2RvY2tlciBzdG9wIC10IDIgJXAKCltJbnN0YWxsXQpXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAo=
    owner: root:root
    path: /etc/systemd/system/cockpitws.service
    permissions: '0644'
runcmd:
- [ systemctl, daemon-reload ]
- [ systemctl, enable, cockpitws.service ]
- [ systemctl, start, --no-block, cockpitws.service ]
```

Matt's cloud-init post continues to describe how to create an iso image for use with virtualization tools that lack built-in support for cloud-init -- I was able to use this user-data file to create an iso image that folds in cockpit deployment. 

This same chunk of text can be used with platforms that do support cloud-init, as well. For instance, on OpenStack, I pasted the text above into the `Customization Script` field of the `Post-Creation` tab within OpenStack dashboard `Launch Instance` dialog:

![](images/openstack-cloud-init-cockpit.png)

Upon booting up a new Fedora Atomic 22 VM using this cloud-init configuration, I see that the cockpitws service has started, and that docker is pulling down the cockpit image as expected. Once the container is running, you'll be able to access the cockpit ui at port 9090 of your atomic host.

A visit to the cockpit interface shows the running container:

![](images/cloud-init-cockpit-1.png)

The services section of the cockpit ui shows the cockpitws service in place:

![](images/cloud-init-cockpit-2.png)

 On subsequent reboots, the cockpit container image will already be in place, and should start automatically.