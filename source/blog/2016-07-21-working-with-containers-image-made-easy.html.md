---
title: 'Working with containers'' images made easy Part 1: skopeo'
author: runcom
date: 2016-07-21 08:58:20 UTC
tags: docker,containers,skopeo,OCI,kubernetes
published: false
comments: true
---

This is the first part of a series of posts about containers' images. In this first part we're going to focus on `skopeo`.

Back in March I published a [post](http://www.projectatomic.io/blog/2016/03/skopeo-inspect-remote-images/) about [skopeo](https://github.com/projectatomic/skopeo), a new tiny binary to help people interact with Docker registries. Its job has been limited to _inspect_ (_skopeo_ is greek for _looking for_, _observe_) images on remote registries as opposed to `docker inspect` which is working for locally pulled images. The requirement for such a tool was to move away from carrying a patch in our `projectatomic/docker` because upstream [closed our proposal](https://github.com/docker/docker/pull/14258) of inspecting images on registries.

### The tool

Since then, we've been adding more features to `skopeo`, such as downloading image layers (via `skopeo layers`), and eventually we came up with a nice abstraction to the problem of _downloading_, _inspecting_, and _uploading_ images (without even the need to have Docker installed on the system). We called this new abstraction `copy` and here is a straightforward example about how to use it:

```sh
# skopeo copy <source> <destination>

$ id -u
1000

 # let's say we want to download the Fedora 24 docker image from the Docker Hub and store it on a local directory
$ mkdir fedora-24
$ skopeo copy docker://fedora:24 dir:fedora-24
$ tree fedora-24 
fedora-24
├── 7c91a140e7a1025c3bc3aace4c80c0d9933ac4ee24b8630a6b0b5d8b9ce6b9d4.tar
├── f9873d530588316311ac1d3d15e95487b947f5d8b560e72bdd6eb73a7831b2c4.tar
└── manifest.json

0 directories, 3 files
```

You can see from the output  above that `skopeo copy` successfully downloaded the Fedora 24 image - as in, it downloaded all its layers plus the image manifest. 

You can also notice the whole operation has been done with an unprivileged user - while Docker needs you to be `root` to even do a `docker pull`.

What can you do with that `fedora-24` directory now? There come the fun. A nice new addition to the [atomic](https://github.com/projectatomic/atomic) tool has been the so called _system containers_ - they are containers meant to be working before the Docker daemon comes up and they're powered by the community project [runc](https://github.com/opencontainers/runc) which is part of the [Open Container Initiative](https://www.opencontainers.org/). Basically those containers are setup by:

1. download the image layers and manifest with `skopeo`
2. setup a new [ostree](https://wiki.gnome.org/action/show/Projects/OSTree?action=show&redirect=OSTree) repository which will be the root filesystem of our system container
3. import downloaded layers in the order they come in the image manifest
4. create a systemd unit file to run `runc` with said filesystem
5. spawn the service
6. enjoy

If the above sounds rather complex, the `atomic` tool already provides a `--system` flag which can be used to create a system container:

```sh
$ sudo atomic install --system --name system-container gscrivano/spc-helloworld
Missing layer b037963d9b4419ffe09694c450bd33a06d24945416109aeb2937c7a8595252d9
Missing layer a1b129b466881845cdf628321bf7ed597b3d0cad0b8dd01564f78a4417c750fe
Missing layer a8a1c0600345270e055477e8f282d1318f0cef0debaed032cd1ba1e20eb2a35e
Missing layer 236608c7b546e2f4e7223526c74fc71470ba06d46ec82aeb402e704bfdee02a2
Extracting to /var/lib/containers/atomic/spc.0
systemctl enable spc
Created symlink from /etc/systemd/system/multi-user.target.wants/spc.service to /etc/systemd/system/spc.service.
systemctl start spc

# verify the service is running smoothly
$ sudo systemctl status spc  
● spc.service - Hello World System Container
   Loaded: loaded (/etc/systemd/system/spc.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2016-07-22 09:27:47 CEST; 5s ago
 Main PID: 10405 (runc)
    Tasks: 10 (limit: 512)
   CGroup: /system.slice/spc.service
           ├─10405 /bin/runc start spc
           └─spc
             ├─10416 /bin/sh /usr/bin/run.sh
             └─10435 nc -k -l 8081 --sh-exec /usr/bin/greet.sh

Jul 22 09:27:47 localhost.localdomain systemd[1]: Started Hello World System Container.

# we know our system container is listening on port 8081 so let's test it out!
$ nc localhost 8081                 
HTTP/1.1 200 OK
Connection: Close

Hi World

```

---

The new `skopeo copy` command isn't just limited to download to local directories. Instead, it can do almost all sort of download/upload between:

- docker registries -> local diretories
- docker registries -> docker registries (`skopeo copy docker://myimage docker://anotherrepo/myimage`)
- docker registries -> [Atomic registry](http://www.projectatomic.io/registry/) (`atomic:` prefix)
- docker registries -> [OCI image-layout](https://github.com/opencontainers/image-spec/blob/master/image-layout.md) directories (`oci:` prefix)
- and viceversa in any combination!

Possibilities seems endless, being able to pull as an unprivileged user also open the doors to work with unprivileged _sanboxes_ like [Flatpak](http://flatpak.org/), [bubblewrap](https://github.com/projectatomic/bubblewrap).  
As part of this unprileged capability we're working on [a new feature in the Atomic tool](https://github.com/projectatomic/atomic/pull/483) which will be able to pull images to the calling user home directory  and later run any containers from those images (by also remapping files ownership to the one of the calling user).

Supporting the [Open Container Initiative](https://www.opencontainers.org/) by early implementing the [image specification](https://github.com/opencontainers/image-spec) had also great advantages as we eventually helped the specification itself where things weren't totally clear and defined. We're continuosly adding wider support as the specification moves along also in areas like images signing and layers federation.

The next post will take care of explaining how we extracted some core components from `skopeo` and moved them to a set of reusable libraries.