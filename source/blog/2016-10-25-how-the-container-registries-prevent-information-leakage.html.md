---
title: How container registries prevent information leakage
author: runcom
date: 2016-10-25 13:41:13 UTC
published: true
comments: true
tags: docker, skopeo, troubleshooting, registry
---

Recently people have been reporting unexpected errors when doing a `skopeo copy` versus a `docker pull`:  [1347805](https://bugzilla.redhat.com/show_bug.cgi?id=1347805), [235](https://github.com/projectatomic/skopeo/issues/235), and [27281](https://github.com/docker/docker/issues/27281).

[Skopeo](https://github.com/projectatomic/skopeo) is a command-line tool that that does various operations with container images and container image registries, including pulling the images to the host.  It is also used under the covers by the [atomic](https://github.com/projectatomic/atomic) command-line tool.

This post explains why those weird errors can come up when pulling images.

Let's see what happens when a user tries to pull an image from the docker hub and the image doesn't exist:

```
$ docker pull thisimagedoesntexist
Using default tag: latest
Trying to pull repository docker.io/library/thisimagedoesntexist ...
Pulling repository docker.io/library/thisimagedoesntexist
Error: image library/thisimagedoesntexist:latest not found
```

We get an 'image not found', as expected, right?

Let's try the same with skopeo copy:

```
$ skopeo --tls-verify=false copy docker://thisimagedoesntexist oci:what
FATA[0002] Error initializing image from source docker://thisimagedoesntexist:latest: unauthorized: authentication required
```

What?

Why are we getting an `unauthorized error` message?

Let's see what's really happening under the hood:

The docker daemon:

1. Attempts to contact a V2 registry
2. V2 registry returns 'unauthorized: authentication required'
3. Daemon falls back and try to pull the same image from a V1 registry
4. Attempt to contact a V1 registry
5. V1 registry isn't deployed, we get a 404
6. The docker command line interprets the 404 as an image not found

Skopeo:

1. Attempts to contact a V2 registry
2. V2 registry returns 'unauthorized: authentication required'
3. Skopeo errors out and shows the  'unauthorized: authentication required'

## Why is docker trying to contact a V1 registry?

Docker still  supports the old V1 registry API (remember [docker-registry](https://github.com/docker/docker-registry)?).
Some registry deployments use both V1 and V2 registries.  When the docker engine fails to get a V2 Image, it falls back and tries to contact a V1 registry that may have the image.

Yes, but:

## Why does skopeo return 'unauthorized'?

The V2 registry API is designed to prevent information leaks about private repositories (GitHub does the same, if you’re wondering).

From the first example above, *library/imagedoesntexist* could be a private repository/image (or not!).  The registry can't tell you that the repository/image doesn't exist; it can only tell you that you're not authorized to access it.

In fact, if you have a private repository/image on the docker hub and try to pull it with skopeo, you still get 'unauthorized' (unless you're logged in of course).
Skopeo only supports V2 registries. Since V1 registries are being purged, we decided to not add support for V1 to Skopeo.

Let's see some examples with a private image named *runcom/what*:

If *runcom/what* is a private image and I'm *not* logged in:

```
$ skopeo --tls-verify=false copy docker://runcom/what oci:what
FATA[0001] Error initializing image from source docker://runcom/what:latest: unauthorized: authentication required
```

As you can see it's not telling me whether the image exists or not on the registry. It just tells me that I'm not authorized to pull the image.

Now, if *runcom/what* is a private image and I'm logged in:

```
$ skopeo --tls-verify=false copy docker://runcom/what oci:what
FATA[0002] Error initializing image from source docker://runcom/what:latest: manifest unknown: manifest unknown
```

The above error is indeed an 'image not found' (e.g., a 404 from the V2 registry). Since I’m logged in,  I have the rights to understand if the image is on the registry.

Let's see what happens with docker instead when I'm not logged in:

```
$ docker pull runcom/what                                                     
Using default tag: latest
Trying to pull repository docker.io/runcom/what ...
Pulling repository docker.io/runcom/what
Error: image runcom/what:latest not found
```

Well, remember the docker engine falls back to V1? Let’s have a look at the docker engine logs to really understand why it felt back to V1. We see the following error message:

```
Oct 24 16:51:19 localhost.localdomain docker[1408]: time='2016-10-24T16:51:19.548329131+02:00' level=debug msg='GET https://registry-1.docker.io/v2/runcom/what/manifests/latest'
Oct 24 16:51:20 localhost.localdomain docker[1408]: time='2016-10-24T16:51:20.113460151+02:00' level=error msg='Attempting next endpoint for pull after error: unauthorized: authentication required'
```

Great. Exactly like skopeo, before falling back to V1, it’s correctly telling us that I’m unauthorized to pull the image (note, it’s not telling me anything about the existence of that image on the docker hub!)

If I try to pull the same image but this time logged in, I'll get the same image not found error, but this time I can spot the following in the logs:

```
Oct 24 16:54:11 localhost.localdomain docker[1408]: time='2016-10-24T16:54:11.706002616+02:00' level=debug msg='GET https://registry-1.docker.io/v2/runcom/what/manifests/latest'
Oct 24 16:54:12 localhost.localdomain docker[1408]: time='2016-10-24T16:54:12.283006158+02:00' level=error msg='Attempting next endpoint for pull after error: manifest unknown: manifest unknown'
```

The errors in the logs are exactly the same as the ones we get with skopeo. Just that docker falls back and tries a V1 registry while skopeo doesn’t fall back.

That means that skopeo is indeed providing the correct error message from the V2 registry while docker is reporting 'image not found' because it hides the real/correct unauthorized error from the V2 registry and only shows the V1 error.  Docker command line might actually be giving you bogus information, when the container image is actually stored in V2, but reports the image does not exist when you are not logged in.  When upstream docker eventually drops backward support for V1, it will report the same error that skopeo does.

I hope this post will shed some light about why these errors differ between docker and skopeo.
