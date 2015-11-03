---
title: What Happened at the 2nd Big Docker Meetup in Brno, Czech Republic on 15 October 2015 @ 6 pm
author: bexelbie
date: 2015-10-23 12:52:32 UTC
tags: Docker, Event
comments: true
published: false
---

<a href="https://plus.google.com/photos/111655466984621162361/albums/6205968149218406801/6205968150060842418?pid=6205968150060842418&oid=111655466984621162361"><img src="https://lh6.googleusercontent.com/-M4Fe5iq6_Uc/ViAHJt_DvbI/AAAAAAAAO4A/gYCxoHSqWTA/w779-h438-no/NI2S1352.jpg" width="200" height="115"></a>The [Docker Brno Meetup](http://www.meetup.com/Docker-Brno/events/225508213/) group had its second big meeting on 15 October 2015 at 6 pm at the [Impact Hub](http://maps.google.com/maps?f=q&hl=en&q=Cyrilsk%C3%A1+7%2C+Brno%2C+cz) in Brno, Czech Republic.  This meeting followed up a monthly set of more informal gatherings in pubs around the city and the [first meeting on 18 May 2015](http://www.projectatomic.io/blog/2015/05/docker-meetup-brno/).

The meeting was attended by about a 100 people.  [Jan Bleha](https://twitter.com/JanBleha), the main organizer and our host for the evening surveyed the crowd with some demographic questions:

  * ~20 people were visiting from other cities
  * ~20 people are currently studying at University
  * ~85% of the group is actively experimenting with containers

[Václav Pavlín](http://www.twitter.com/vpavlin) from Red Hat presented, ["Nulecule: Packaging, Distributing & Deploying Container Applications the Cloud Way."](https://drive.google.com/a/redhat.com/file/d/0B5OHcgvKZLcdSGV6Q1BiOTVYUlE/view) He notes that docker brought us container packaging and made container portability more accessible.  However, a container image is just a filesystem and some metadata about the image, but not dependencies and installation considerations.  This creates a challenge for multi-container applications as there is no built-in way to specify dependencies and other installation parameters.  We could use labels, but that could lead to a mess of labels and still no clear way to execute them or a clean way to let people know how to run or use the image.  

The current UX of choice for muli-container applications is the README or the even more scary `curl http://really.not.dangerous.com/install.sh | bash` No one likes these options as is evidenced by everyone packaging their own version of tools.  For example, there are 454 MariaDB images on DockerHub right now.

The Nulecule specification provides a way to specify all of the images that are required to run an application and provides for their discovery.  It also cleanly defines how the containers interelate and what parameters, storage, etc. they require.  It also allows them to be operated on as a group and to be handed off to various orchestration providers easily, even though the orchestrators currently all have unique and mostly incompatible format for their specifications.  Atomic App is the reference implementation of the Nulecule spec, and with the '/usr/bin/atomic' helper command can reduce a multi-container application to a single line `atomic run application` or without the helper, a single long docker command.

The specification is open and not dependent on a specific container technology or orchestrator.  It allows for easy tweaking of application meta-data and parameters when moving between environments, i.e. from DEV to TEST to PRODUCTION.

In a follow-up demo, Vaclav showed off the standard [guestbook-go example](https://github.com/projectatomic/nulecule/tree/master/examples/guestbook-go) and a single line installation of [Gitlab](https://github.com/navidshaikh/nulecule/tree/fix-160/examples/gitlab-centos7-atomicapp).

[Yury Tsarev](https://cz.linkedin.com/in/yurytsarev) from GoodData presented, ["Test Driven Infrastrucure with Docker, Test Kitchen and Serverspec"](https://drive.google.com/a/redhat.com/file/d/0B5OHcgvKZLcdcFJkbGZVQkZvTnM/view)  Yury strongly believes that infrastructure code should be treated like any other code.  This means apply a test driven development model, storing it in a source control system and building a regression test suite.  He suggests doing this with [Test Kitchen](http://kitchen.ci), a pluggable and extensible test orchestrator that originated in the Chef community.  Using Test Kitchen's [docker provider](http://github.com/portertech/kitchen-docker), a docker container can be used to simulate a machine under test.  Then [Serverspec](http://serverspec.org) can verify that the configuration code, Puppet in Yury's case, properly setup the machine.  Shell mocking is used to bypass external dependencies and docker limitations.

This method creates an infrastructure change process that is: write a spec; verify it tests red; write puppet code; verify it tests green; commit via a pull request.  This leverages test-driven development and adds the benefits of scratch environment testing, testing in isolation, easy testing of permutations, resource efficiency, fast feedback and a naturally growing regression suite.

At this point we took a break for some networking time, indepth Q&A, and some beer provided by our sponsors, [Red Hat](http://community.redhat.com), [Seznam.cz](http://onas.seznam.cz) and [GoodData](http://www.gooddata.com/).

[Matteo Ferraroni](https://cz.linkedin.com/in/matteoferraroni) from Digital-blue presented, ["Ceph and Docker: How to get persistent storage on the cloud."](https://drive.google.com/a/redhat.com/file/d/0B5OHcgvKZLcdaHhnR1JaX1VRNEk/view)  They have been challenged to provide persistent storage on hosts in the cloud when migrating containers from host-to-host.  While persistent storage isn't always best practice, some applications, such as Databases, need persistent storage.  Initially they used Fleet as an orchestrator, but whenever they had a migration from host-to-host they lost their storage.  This is because most hypervisors and orchestrators provide storage as a data volume from the local host.  They have implemented a solution where they let the container mount a device exposed by the Ceph RADOS (Reliable Automatic Distributed   Ojbect Store) protocol.  The container then mounts it as a normal filesystem via fstab.  This is superior to data-only containers (--volumes-from) and mapped host filesystems (-v) as you elminiate the risk of orphaned data nodes if a container gets deleted and the data isn't cleaned up.

Ceph is a unified distributed storage system designed for performance, reliability and scalability.  It works with lots of systems including most cloud providers and OpenStack.  Ceph stores client data as objects in storage pools.  Its CRUSH algorithm calculates placement for scalability, rebalacing and recovery.  There are always at least 2 copies of data at any time.  The workflow is only two steps: Ceph maps the raw storage to a device in the kernel and the device is mounted in the container (requires the --cap-add=SYS_ADMIN flag).  To ensure that everything works, a systemd ExecStartPre script is executed to map the storage and retrieve the proper device name.  The device name is then passed to the container in the ExecStart.  This is done via systemd because many orchestrators (including Fleet and Mesos) cannot execute commands on the host before starting the container.  An ExecStopPost script ensures that storage is unmounted properly.

Performance has been near SAN quality and is mostly affected by the networking between the Ceph infrastructure components.  This has been superior to NFS as there is no need to worry about limitations around network, fail over, etc.  Additionally, NFS doesn't provide object storage, which is a requirement in this case.

[Tomáš Nožička](https://cz.linkedin.com/in/tnozicka/en) from Seznam.cz presented, ["Using Docker for Advanced Testing: Building Packages for Multiple Distributions and Altogether."](https://drive.google.com/a/redhat.com/file/d/0B5OHcgvKZLcdblhIOFEzTnJpRHc/view)  This strategy was inspired by his team's development an open source C++14 wrapper for libmyusqlclient.  They wanted to be able to use a dockerized mysql server in tests during the build process.  They also wanted to use docker to build for multiple distributions and to ensure a clean build environment with clean dependencies.  However, you cannot build packages which have tests that require docker using docker using todays standard tools.

Two options were considered for how to resolve this.  The first is to run docker-next-to-docker where you mount the host docker daemon's socket into the container.  But this shares the daemon and cache across tests and may not be as clean and secure as desired.  This also requires careful work to ensure the docker client and server are in sync.  This is hard across distributions.

Therefore they went with docker-in-docker using the docker:dind image from Docker Hub.  Their solution, [dbuilder](https://github.com/seznam/dbuilder), leverages this to provide a separate docker daemon and cache to each build/test container.  This open-source framework also provides a yaml configruation file mechanism for Dockerfiles so that you do not have to manage all of the permutations required for different environments and distributions.

Tomáš also provided some general comments on what they are seeing with docker in production.  They have some challenges related to logging as logstash was running too slowly in their production environment.  Right now they are bind mounting out the logs and collecting them, but are looking at other options.  They continue to find service discovery and orchestration to be thorny problems are are still exploring the plethora of options available.

In closing, Jan, asked our audience some more questions and we learned that:

  * ~50% of our group runs containers somewhere in production
  * ~60% of our group uses docker in production
  * Only about 10 people have jobs that are defined to include docker
  * Only about 12 people are running applications that use 3 or more images

Before the meeting, a small group of system administrators, programmers and enthusiasts, who had never used Docker before, got together for a Docker 101 workshop ([slides](http://redhat.slides.com/jkarasek/docker101#/)). This workshop, lead by two Red Hat engineers, Peter Schiffer and [Josef Karasek](http://redhat.slides.com/jkarasek), was intended to ease the first steps with Docker for the participants. After a brief talk on the the theory behind containers the particpants (who all showed up with docker preinstalled) practiced pulling docker images from Docker hub, creating new images, and running containers. Additional topics covered during the workshop were container networking, volumes and linking of multiple containers.

I want to thank Jan Bleha for organizing the event, [Jiri Folta](https://photos.google.com/share/AF1QipPQlkx06KQ4sOwEB6PH3GczQxJwI_tNMNbwPPvzFl2XDQ3oWUrdx7A0Ml-GcVMjew?key=blNtZ1o3VmVuaGYwS2N5Um90NkY4cFI5Sk5WMGNn) for the great photos and Red Hat, seznam.cz and GoodData for sponsoring the venue and refreshments.
