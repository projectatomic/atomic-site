---
title: 'Announcing the Fedora Layered Image Build Service'
author: amiller
date: 2016-12-13 16:00:00 UTC
tags: fedora, atomic, containers, docker
published: true
comments: true
---
It is with great pleasure that the Fedora Project Announces the availability
of the [Fedora Docker Layered Image Build Service](https://fedoraproject.org/wiki/Changes/Layered_Docker_Image_Build_Service) to the Fedora Contributor
Community!  The new service will provide trustworthy, consistent application
images for Fedora Atomic and CentOS Atomic as well as other platforms.

READMORE

With this announcement we are opening availability of the Docker Layered
Image Build Service for the [Docker Layered Images](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/) that the [Fedora Cloud
SIG](https://fedoraproject.org/wiki/Cloud) has been the primary maintainers of on GitHub into DistGit as
official components of Fedora. From there we will be extending an invitation
to all Fedora Contributors to maintain Docker Layered Image Containers for
official release by the Fedora Project. Currently this effort is to enable
the Fedora Cloud/Atomic WG goals which target [Fedora Atomic Host](https://getfedora.org/en/atomic/download/) as a
primary deliverable to power the future of Cloud. This is also to enable the
[Fedora Modularity](https://fedoraproject.org/wiki/Modularity) work be delivered as Containers in the future as Fedora
becomes fundamentally more modular in nature.

## How do I get started?

Contributors will go through a similiar process to RPM Review Requests. There will be [Container Reviews](https://fedoraproject.org/wiki/Container:Review_Proces) as well as
[Container Guidelines](https://fedoraproject.org/wiki/Container:Guidelines).
At this time the Cloud/Atomic WG will maintain the Guidelines as well as
the Review Process along with input from all Fedora Contributors. This may
change later with the formation of a Fedora Container Committee (similar to
the Fedora Packaging Committee).

Please note that both the Guidelines and the Review Process are likely to
evolve along with the Container technologies as we move into the future so
we encourage community members to check the documentation for updates.

For more information, please see the [Fedora Community Blog post on the Layered Image Build Service](https://communityblog.fedoraproject.org/fedora-docker-layered-image-build-service-now-available/).
