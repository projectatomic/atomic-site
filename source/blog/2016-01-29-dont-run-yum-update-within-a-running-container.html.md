---
title: Don't run yum update within a running container
author: baude
date: 2016-01-29 14:28:54 UTC
published: false
comments: true
---

Recently I have been reviewing a massive collection of Dockerfiles and interacting with customers
and ISVs alike.  In this time, I have seen all sorts of actions being taken for container design and how
those containers should be run.  One such action that I really struggle with is when users are either told
or take the initiative themselves to update packages in a running container.  For example, they execute something like:

```
docker run -it foobar yum -y update

```
While there could be a litany of reasons for doing this,  consider the consequences the potential consequences:

* Only the container itself is updated, the image remains unchanged.
* If you were running 10 of these containers, that would result in 10 separate yum updates.
* With multiple updated containers, perhaps at different times, each container could potentially have different packages in it.
* The author of the image may not have tested with the updated packages and therefore you may encounter undesirable results.

That said, there are certainly a lot of images on various registries that have grown stale or are not updated with the frequency users desire.  Clearly in this case, it would be ideal if there was an automated build service from the provider that would rebuild the images if its packages were updated.

Absent of that, I think there is a better way.  If we follow the container paradigm, it would be more prudent to update **the image** in question rather than the container.  This can simply be done with docker where you would use the image from the registry as a seed image and then run yum update to create a new image.  The Dockerfile could be as simple as:

```
# Use the image from the registry as a seed
FROM 192.168.122.161:5000/foobar

# Run yum update and then clean the cache
RUN yum -y update && yum clean all
```
Then build the image and name it with some obvious marker to differentiate it:

```
docker build -t foobar-updated .
```

Now instead of running an image based on *foobar*, use *foobar-updated* instead.

By following this paradigm, you are now able to push the image through your lifecycle testing and verify functionality. All you need to do is stop the exisiting containers and start news one based on your newly updated image.  You will now have consistent and well formed images.

### Atomic verify can help

The verify subcommand of the [atomic application](https://github.com/projectatomic/atomic) can also be helpful in this scenario.  It can be used to determine if an image or its layers have been updated.  It uses the _Version_ label to store its version as metadata within the image.  For more information about labels, see the [ContainerApplicationGenericLabels](https://github.com/projectatomic/ContainerApplicationGenericLabels) github repository. Carrying our example from earlier, suppose we have pulled our *foobar* image from a registry like so:

```
docker pull 192.168.122.161:5000/foobar
```
Using the advise from above where we then use that image as a seed image, we rebuild *foobar* having run a yum update and now have a *foobar-updated* image present on our system.  This can be observed with using docker:

```
# docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
foobar-updated                latest              9045d1c4d8c0        5 minutes ago       194.7 MB
192.168.122.161:5000/foobar   latest              ff7d910bca97        7 minutes ago       194.7 MB
```

Now suppose the foobar image is updated, we can use *atomic verify* to identify that:

```
# sudo ./atomic verify -v foobar-updated

foobar-updated contains the following images:

     Local Version                  Latest Version
     -------------                  --------------
     foobar-updated-1.0-5-updated   foobar-updated-1.0-5-updated
     foobar-1.0-5                   foobar-1.0-6                   *

     * = version difference
```

Notice how the version level has been updated from 1.0.5 to 1.0.6 on the remote registry.  This is a signal that we should now use the new version on the
registry and if desired, we should rebuild our local -updated version updates as needed.
