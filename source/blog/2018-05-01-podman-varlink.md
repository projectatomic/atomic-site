---
title: A remote API for Podman
author: baude
date: 2018-05-01
layout: post
comments: false
categories:
- Blog
tags:
- crio
- libpod
- podman
---
## Podman grows a remote API using Varlink

[Podman](https://github.com/projectatomic/libpod) up to now has been a simple CLI for managing pods and containers. But I wanted to allow other tools like Atomic CLI and Cockpit to interact with the pods/containers created by Podman and other tools.  Execing a CLI tool to do this and screen scraping the output never quite works, so we wanted to add an API.  But I did not want to add a daemon to implement a restAPI.  #nobigfatdaemons.

READMORE

Someone pointed out a new technology that seemed meet most of our needs called [varlink](https://github.com/varlink).  After reviewing the project and talking with the upstream owners, I decided to build the Podman API based on varlink so users and developers can interact with Podman programmatically.

Varlink describes itself as an “interface description format and protocol that aims to make services accessible to both humans and machines in the simplest feasible way.” On their wiki, they document the [ideals](https://github.com/varlink/documentation/wiki/Ideals) that lead to its development. The bottom line for Podman is that varlink has proved to be an effective way to create, publish, and implement a “remote” API over such technologies as REST.

### Installation

First we need to install the Podman and varlink packages.  You will need a minimal version of podman-0.4.4-2 to work with the varlink backend.
```
$ sudo dnf --enablerepo=updates-testing install podman libvarlink-util libvarlink
Last metadata expiration check: 0:00:14 ago on Tue 01 May 2018 07:08:49 PM UTC.
Dependencies resolved.
=============================================================================================================================================================
 Package                                       Arch                    Version                                        Repository                        Size
=============================================================================================================================================================
Installing:
 libvarlink                                    x86_64                  9-1.fc28                                       updates                           43 k
 libvarlink-util                               x86_64                  9-1.fc28                                       updates                           46 k
 podman                                        x86_64                  0.4.4-2.git9924956.fc28                        updates-testing                  5.7 M
Installing dependencies:
 atomic-registries                             x86_64                  1.22.1-2.fc28                                  updates-testing                   39 k
 container-selinux                             noarch                  2:2.55-1.fc28                                  updates-testing                   39 k
 containernetworking-cni                       x86_64                  0.6.0-4.fc28                                   updates-testing                  9.7 M

... omitted for brevity
```

### Start the Podman socket

Podman relies on a Systemd feature called [socket activation](http://0pointer.de/blog/projects/socket-activation.html).  Systemd allows developers to create socket unit files that tells systemd to listen on a particular socket like the unix domain socket /run/io.projectatomic.podman.  When a process connects to this socket, systemd will launch the command specified in the service file with the same name.  The launched command then handles the socket communications.

Podman ships a systemd socket file `io.projectatomic.podman.socket` that will listen for requests.  It must be started for the varlink backend to work.

```
$ cat /usr/lib/systemd/system/io.projectatomic.podman.socket
[Unit]
Description=Pod Manager Socket

[Socket]
ListenStream=/run/io.projectatomic.podman

[Install]
WantedBy=sockets.target
```

Podman also ships a service file `io.projectatomic.podman.service`, which systemd activates when connections come into the socket.

```
$ cat /usr/lib/systemd/system/io.projectatomic.podman.service
[Unit]
Description=Pod Manager
Requires=io.projectatomic.podman.socket
After=io.projectatomic.podman.socket

[Service]
Type=simple
ExecStart=/usr/bin/podman --varlink=unix:/run/io.projectatomic.podman

[Install]
WantedBy=multi-user.target
Also=io.projectatomic.podman.socket
```

Notice the ExecStart line, this is the command that systemd executes when the connection comes in.  You enable the service with the following commands.

```
$ sudo systemctl enable io.projectatomic.podman.socket
Created symlink /etc/systemd/system/multi-user.target.wants/io.projectatomic.podman.service → /usr/lib/systemd/system/io.projectatomic.podman.service.
Created symlink /etc/systemd/system/sockets.target.wants/io.projectatomic.podman.socket → /usr/lib/systemd/system/io.projectatomic.podman.socket.

$ sudo systemctl start io.projectatomic.podman.socket
$ sudo systemctl status io.projectatomic.podman.socket
Failed to dump process list, ignoring: No such file or directory
● io.projectatomic.podman.socket - Pod Manager Socket
  Loaded: loaded (/usr/lib/systemd/system/io.projectatomic.podman.socket; disabled; vendor preset: disabled)
  Active: active (listening) since Sat 2018-04-28 16:00:34 UTC; 9s ago
  Listen: /run/io.projectatomic.podman (Stream)
  CGroup: /system.slice/io.projectatomic.podman.socket
  ```

As you can see, the socket is now active and located at _/run/io.projectatomic.podman_.

### Is it alive?

We can check if the service is alive and responding using the the varlink utility and an endpoint called Ping.

```
$ varlink call unix:/run/io.projectatomic.podman/io.projectatomic.podman.Ping
{
 "ping": {
   "message": "OK"
 }
}
```

The path beginning with “unix://” is considered to be a varlink URI of sorts. The “/run/io.projectatomic.podman” portion refers to the listening socket. And the latter parts refer to the path of the endpoint (or function if you prefer).

### Varlink info and help

One unique design point of the varlink implementation is that it has the ability to help you discover its interfaces and endpoints. The _info_ subcommand will show basic information about the setup.

```
$ varlink info unix:/run/io.projectatomic.podman
Vendor: Atomic
Product: podman
Version: 0.4.4
URL: https://github.com/projectatomic/libpod
Interfaces:
 org.varlink.service
 io.projectatomic.podman
```

Notice the URI for that call is to the socket itself. Using the _help_ subcommand, we can discover more about the implemented API.

```
$ varlink help unix:/run/io.projectatomic.podman/io.projectatomic.podman
# Podman Service Interface
interface io.projectatomic.podman
# Version is the structure returned by GetVersion
type Version (
 version: string,
 go_version: string,
 git_commit: string,
 built: int,
 os_arch: string
)
... omitted for brevity
# System
method Ping() -> (ping: StringResponse)
method GetVersion() -> (version: Version)
... omitted for brevity
# Images
method ListImages() -> (images: []ImageInList)
method TagImage(name: string, tagged: string) -> ()
... omitted for brevity
error ImageNotFound (imagename: string)
error ErrorOccurred (reason: string)
error RuntimeError (reason: string)
```

Here we can see the interface that is implemented called “io.projectatomic.podman” following by a type definition for _Version_. It describes the construct that _GetVersion_ will return. Following the type definitions, we can also see a series of method declarations. The syntax of the method definition is:

_method MethodName(input param:input type) -> (return name: return type)_

And finally, you can see the declaration of known errors that can be returned. In languages such as Python, these are handy because you can “catch” them.

Lets see what GetVersion returns.

```
$ varlink call unix:/run/io.projectatomic.podman/io.projectatomic.podman.GetVersion
{
 "version": {
   "built": 0,
   "git_commit": "",
   "go_version": "go1.10.1",
   "os_arch": "linux/amd64",
   "version": "0.4.4"
 }
}
```

### Cool, I want more

When working with a container runtime, one of the first things users do is see what images have been pulled locally.

```
$ varlink call unix:/run/io.projectatomic.podman/io.projectatomic.podman.ListImages
{
 "images": [
   {
     "containers": 0,
     "created": "2018-04-19 13:03:59 +0000 UTC",
     "id": "388e3e5f0e20ab4cfe89431697e3b1f4ca2e08437e5a33ee1ba3f44bc2cebac7",
     "labels": {
       "license": "MIT",
       "name": "fedora",
       "vendor": "Fedora Project",
       "version": "28"
     },
     "parentId": "",
     "repoDigests": [
       "registry.fedoraproject.org/fedora@sha256:1d2e941e1387a86d95070635f6e843f2d81a414b3e77f81ef4d78f2eb6d1e983"
     ],
     "repoTags": [
       "registry.fedoraproject.org/fedora:28"
     ],
     "size": 0,
     "virtualSize": 0
   }
 ]
}
```

Here you can see the Fedora 28 image is local. We also provide some basic information about the image (similar to podman ps) but nothing compared to an image inspection. Suppose we want to create a shorthand name for the Fedora image. We can use the _TagImage_ endpoint for that.

```
$ varlink call unix:/run/io.projectatomic.podman/io.projectatomic.podman.TagImage '{"name": "388e3e5f0e20ab4cf", "tagged": "f28:latest"}'
{}
````
For simplicity, we can verify the tag with podman.
```
$ sudo podman images
REPOSITORY                          TAG      IMAGE ID       CREATED      SIZE
registry.fedoraproject.org/fedora   28       388e3e5f0e20   9 days ago   263MB
f28                                 latest   388e3e5f0e20   9 days ago   263MB
```

### Python bindings are coming

The varlink command line utility was meant for simple varlink interactions, API debugging, and API discovery. As you saw in the TagImage example, input parameters are done with JSON and that can be tedious on the command line. We are developing python bindings for our API implementation. These bindings will simplify the consumption of our eventual API definitions.  We hope to eventually make this work with javascript and possibly other languages as well.

### Upcoming

If you do test our the varlink setup, you will notice that we have implemented most of the image related methods. I just began to implement the container related functions recently and will likely implement most of those within the upcoming week. The Python bindings will trail these slightly.  

We are always looking for help. Testing? Documentation? Additional Language Bindings?  Additional Interfaces.  Lots of work to be done...
