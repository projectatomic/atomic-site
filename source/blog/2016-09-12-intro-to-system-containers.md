---
title: Introduction to System Containers
author: giuseppe
date: 2016-09-12 10:00 UTC
tags: runc, oc, system-containers, atomic, skopeo, ostree
published: true
comments: true
---

As part of our effort to reduce the number of packages that are
shipped with the Atomic Host image, we faced the problem of how to
containerize services that are needed before Docker itself is running.
The result: "system containers," a way to run containers in
production using read only images.

System containers use different technologies such as OSTree for the
storage, Skopeo to pull images from a registry, runC to run the
containers and systemd to manage their life cycle.

READMORE

To use system containers you must have [Atomic CLI](https://github.com/projectatomic/atomic) version 1.12 or later
and the [ostree utility](https://github.com/ostreedev/ostree) installed.  Currently, this means you must be running the
[CentOS Continuous Atomic](/blog/2016/07/new-centos-atomic-host-releases-available-for-download/),
but updates for Fedora Atomic should be coming soon.

# Pull an image

An image must be present in the OSTree system repository before we can
use it as a system container.  By using skopeo, the atomic tool can pull an image from
different locations, a registry, the local Docker engine or a tarball,
according to how the image is prefixed:

```
# atomic pull --storage=ostree gscrivano/etcd
Image gscrivano/etcd is being pulled to ostree ...
Pulling layer e4410b03d7db030dba502fef7bfd1dae56a6c48faae63a80fd82450322def2c5
Pulling layer 2176ad01d5670713218844201dc4edb36d2692fcc79ad7008003227a5f80097b
Pulling layer 9086967f25375e976260ad004a6ac3cc75ba020669042cb431904d2914ac1735
Pulling layer c0ee5e1cf412f1fd511aa1c7427c6fd825dfe4969d9ed7462ff8f989aceded7a
Pulling layer 024037bdea19132da059961b3ec58e2aff329fb2fe8ffd8030a65a27d7e7db5f

# atomic pull --storage=ostree dockertar:/tmp/etcd.tar
# atomic pull --storage=ostree docker:etcd
```

Each layer in the image is stored as a separate OSTree branch, this
takes advantage of the layered model used by Docker images, since
`atomic pull` will download only the layers that are not already
available.  All the images are stored into the OSTree system
repository.

Using OSTree as storage has the advantage that if the same file is
present in more layers, it will be stored only once, just like for container
image layers.  A container is installed through hardlinks, the storage is
shared with the OSTree repository "hardlink farm".

`atomic images list` shows the list of the available images:

```
# atomic images list
   REPOSITORY    TAG          IMAGE ID       CREATED            VIRTUAL SIZE   TYPE
gscrivano/etcd   latest       d7c1702506ff   2016-09-08 16:39                  system

```

`atomic images delete` deletes one tag and `atomic images prune`
removes the unused layers:

```
# atomic images delete -f gscrivano/etcd
# atomic images prune
Deleting ociimage/9086967f25375e976260ad004a6ac3cc75ba020669042cb431904d2914ac1735
Deleting ociimage/2176ad01d5670713218844201dc4edb36d2692fcc79ad7008003227a5f80097b
Deleting ociimage/e4410b03d7db030dba502fef7bfd1dae56a6c48faae63a80fd82450322def2c5
Deleting ociimage/c0ee5e1cf412f1fd511aa1c7427c6fd825dfe4969d9ed7462ff8f989aceded7a
Deleting ociimage/024037bdea19132da059961b3ec58e2aff329fb2fe8ffd8030a65a27d7e7db5f

```

# Installation

System images are installed with `atomic install --system` as:

```
# atomic install --system gscrivano/etcd
Extracting to /var/lib/containers/atomic/etcd.0
systemctl daemon-reload
systemd-tmpfiles --create /etc/tmpfiles.d/etcd.conf
systemctl enable etcd

# atomic install --system gscrivano/flannel
Extracting to /var/lib/containers/atomic/flannel.0
systemctl daemon-reload
systemd-tmpfiles --create /etc/tmpfiles.d/flannel.conf
systemctl enable flannel

# systemctl start etcd
# systemctl start flannel
```

The template mechanism allows us to configure settings for images.
For example, we could use the following command to
configure Flannel to use another Etcd endpoint instead of the default
`http://127.0.0.1:2379`:

```
# atomic install --system --set ETCD_ENDPOINTS=http://192.168.122.2:2379 gscrivano/flannel
```

The `atomic containers` verb is used to see containers:

```
# atomic containers list -a
   CONTAINER ID IMAGE                COMMAND              CREATED          STATUS    RUNTIME
   etcd         gscrivano/etcd       /usr/bin/etcd-env.sh 2016-09-08 14:19 running   runc
```


# Uninstallation

Similarly to `atomic install`, `atomic uninstall` is used to uninstall
an installed system container.

```
# atomic uninstall etcd
```


# Structure of a System Image

System images are Docker images with a few extra files that are
exported as part of the image itself, under the directory '/exports'.
In other words, an existing `Dockerfile` can be converted adding the
configuration files needed to run it as a system container (which
translate to an additional `ADD [files] /exports` directive in the
`Dockerfile`).

These files are:

- config.json.template - template for the OCI configuration file that
  will be used to launch the runC container.
- manifest.json - used to define default values for configuration
  variables.
- service.template - template unit file for systemD.
- tmpfiles.template - template configuration file for systemd-tmpfiles.

Not all of them are necessary for every image.

All the files with a `.template` suffix are preprocessed and every
variable in the form `$VARIABLE` or `${VARIABLE}` is replaced with
its value.  This allows to define variables that are set at
installation time (through the `--set` option) as we saw with the
Flannel example.  It is possible to set a default value for these
settings using the `manifest.json` file of the system container image.

If any of these files are missing, atomic will provide a default one.
For instance, if `config.json.template` is not included in the image,
the default configuration will launch the `run.sh` script without any
tty.

There are some variables that are always defined by the atomic tool,
without the need for an user to specify them via `--set`.  Of those,
only `RUN_DIRECTORY` and `STATE_DIRECTORY` can be overriden with
`--set`:

- `DESTDIR` - path where the container is installed on the system
- `NAME` - name of the container
- `EXEC_START` - Start directive for the systemD unit file.
- `EXEC_STOP` - Stop directive for the systemD unit file.
- `HOST_UID` - uid of the user installing the container.
- `HOST_GID` - gid of the user installing the container.
- `RUN_DIRECTORY` - run directory.  `/run` for system containers.
- `STATE_DIRECTORY` - path to the storage directory. `/var/lib/` for
  system containers.

We're excited about the ability of system containers to greatly improve administration
and infrastructure service delivery for Atomic clusters.  Please give them a try
and tell us what you think.
