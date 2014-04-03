## Docker and filesystems

A core part of the docker model is the efficient use of layered images
and containers based on images. To implement this docker relies
heavily on various filesystem features in the kernel. This document
will explain how this works and give some advice in how to best use it.

### Storage backends

The basis of the filesystem use in Docker is the storage backend
abstraction. A storage backend allows you to store a set of layers
each addressed by a unique name. Each layer is a filesystem tree that
can be mounted when needed and modified.  New layers can be started
from scratch, but they can also be created with a specified parent.
This means that they start out with the same content as the parent
layer, but over time they may diverge. This is typically implemented
in the backend by some form of copy-on-write in order to allow the
create operation to be fast.

Some backends also have extra operations that allow efficient
computation of the differences between layers. These operations all
have fallback implementations, but they can be slower as they have to
compare all the files in the layers.

Based on the layer abstraction Docker implements the highlevel
concepts of images and containers.

Each Docker image on the system is stored as a layer, with the parent
being the layer of the parent image. To create such an image a new
layer is created (based on the right parent) and then the changes in
that image are applied to the newly mounted filesystem.

Containers are a bit more complicated. Each containers has two layers,
one (called the "init" layer), which is based on an image layer and a
child of that which contains the actual container content. The init
layer contains a few files that must always exist in docker containers
(e.g. `/.dockerinit)`. Commiting a container (and thus creating an
image) involves finding all the changes from the init layer to the
container layer and applying those to a new layer based on the same
image the container used.

### The 'vfs' backend

The vfs backend is a very simple fallback that has no copy-on-write
support. Each layer is just a separate directory. Creating a new layer
based on another layer is done by making a deep copy of the base layer
into a new directory.

Since this backend doesn't share diskspace use between layers, and
since creating a new layer is a slow operation this is not a very
practical backend. However, it still has its uses, for instance to
verify other backends against, or if you need a super robust (if slow)
backend that works everywhere.

### The `devicemapper` backend

The devicemapper backend uses the device-mapper thin provisioning
module (dm-thinp) to implement layers. Device-mapper is the kernel
part of the LVM2 logical volumes system, so this is is a block-level
copy-on-write system.

The thin provisioning module takes two block devices (the data and the
metadata devices) and creates a "pool" of space that can be used to
create other block devices from. Such block devices are "thinly
provisioned" meaning they start out empty, and the parts that are
unused are not allocated. Additionally it is possible to take a
copy-on-write snapshot of a device, producing a new device.

On first startup Docker creates a base device on the thin pool,
containing a empty ext4 filesystem. All other layers are (directly or
indirectly) snapshots of this base layer. The filesystem has a fixed
size, which means that all the images and containers have a maximal
size. By default this size is 10GB, although due to the thin
provisioning the devices doesn't use much space on the pool.

In order to set up a thin pool you need two block devices, which is
not always something users want to deal with. So, by default Docker
creates two regular files inside
`/var/lib/docker/devicemapper/devicemapper` called `data` and
`metadata` and uses loopback to create block devices of these for the
thin pool. These files are by default 100GB (data) and 2GB (metadata),
but they are "sparse" meaning that unused blocks are not mapped, and
thus does not take space on the host filesystem.  Additionally there
is and external file
(`/var/lib/docker/devicemapper/devicemapper/json`) that contains the
mapping from Docker layer names to thin pool ids.

The loopback setup makes it very easy to start using docker on any
machine, but it is not the most efficient way to use devicemapper. On
production servers it is recommended that you set up the docker thin
pool to use real block devices. For best performance the metadata
device should be on a SSD driver, or at least on a different spindle
from the data device.

In order to support multiple docker instances on a system the thin
pool will be named something like `docker-0:33-19478248-pool`, where
the `0:30` part is the minor/major device nr and `19478248` is the
inode number of the /var/lib/docker/devicemapper directory. The same
prefix is used for the actual thin devices.

### The `btrfs` backend

The brtfs backend requires `/var/lib/docker` to be on a btrfs filesystem
and uses the filesystem level snapshotting  to implement layers.

Each layer is stored as a btrfs subvolume inside
`/var/lib/docker/btrfs/subvolumes` and start out as a snapshot of the
parent subvolume (if any).

This backend is pretty fast, however btrfs has historically had
stability issues. You might want to have /var/lib/docker on a
different filesystem than the rest of your system to mitigate this.

### The `aufs` backend

The aufs backend uses the aufs union filesystem. This is not supported
on the upstream kernel and most distributions (including any from Red
Hat), and thus it is not generally useful.

The backend stores each layer as an regular directory, containing
regular files and special aufs metadata. This makes up for all the files
unique to that layer, as well as information about which files are
removed from the previous layer. It then relies on the aufs filesystem
to combine all the layers into a single mountpoint. Any changes to
this mountpoint goes into the topmost layer.

### Comparison of the backends

All backends except the vfs one shares diskspace between base
images. However, they work on different levels, so the behaviour is
somewhat different. Both devicemapper and btrfs share data on the
block level, so a single change in a file will cause just the block
containing that byte being duplicated. However the aufs backend works
on the file level, so any change to a file means the entire file will
be copied to the top layer and then changed there. The exact behaviour
here therefore depends on what kind of write behaviour an application
does.

However, any kind of write-heavy load inside a container (such as
databases or large logs) should generally be done to a volume. A
volume is a plain directory from the host mounted into the container,
which means it has none of the overhead that the storage backends may
have. It also means you can easily access the data from a new
container if you update the image, or if you want to access the same
data from multiple concurrent containers.
