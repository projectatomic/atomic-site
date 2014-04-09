DO NOT INCLUDE BELOW THIS LINE IN PUBLIC DOCS
=============================================

All TO-DOs are refencing sections in the doocker-build-rhel-images.md document

(TO-DO if included the following sentence would go after the sentence "There are two approaches to building Docker images."   
 
Two of these approaches are inherent in Docker while the third approach came out of work at Red Hat and Fedora to allow Docker to be incorporated into the already established and formal build systems.


(TO-DO if included this would go after the first 2 options.)

### Building Images from RPMs

Run docker inside a mock chroot to build both base and layered images. This approach is useful for more formal build systems.  There are several reasons for building images this way:

* Able to record input and output of docker builds precisely in the build
  system
* Produce actual docker images (with trackable IDs), not just tarballs, as build output.  For more formal build systems it is critical to record images precisely so that build layered images on top will work on the same underlying layer.
* Produce both base and layered images from a similar workflow
* Use a standard build language to specify the base image build
* Use unmodified Dockerfiles to drive layered image builds
* Able to specify exactly which base image is used to build any layered image, and record that relationship in the metadata
* Provide something that can be signed while working on being able to sign docker images directly (*TO-DO whenry - is this a Red Hat reason?*)

To list the installed docker images: 

    # yum list installed "docker-image*"
     docker-image-apache.x86_64  0-5.4.fc20     @/docker-image-apache-0-5.4.fc20.x86_64
    docker-image-base.x86_64    0-5.4.fc20     @/docker-image-base-0-5.4.fc20.x86_64

It is coincidental that these have the same 0-5.4 version. They are built independently and happen to have similar versions.

The base image is built from a "yum --installroot" recipe in the base spec file.  The layered images are built from Dockerfiles taken verbatim from normal `docker build` instructions; in this case, the Apache Dockerfile from the Fedora-dockerfiles repository (*TO-DO whenry where????*).

The rpms carry one file each, being a "docker save" image of the built layers:

    # rpm -ql docker-image-base docker-image-apache
    /opt/docker/images/fedora-0-5.4.fc20-2fa54f924fa1.img
    /opt/docker/images/apache-0-5.4.fc20-2847b6654809.img

The RPMs carry auto-generated rpm metadata about what images they provide, on top of the docker metadata embedded in the images:

    # rpm -q --provides docker-image-base
    docker-image-base = 0-5.4.fc20
    docker-image-base = fedora
    docker-image-base(fedora) = .fc20
    docker-image-base(x86-64) = 0-5.4.fc20
    docker-image-id = 2fa54f924fa15a55a0a1f76b7934a3d8c6dcb3d6ad844f7f845c427140d57962
    # rpm -q --provides docker-image-apache
    docker-image-apache = 0-5.4.fc20
    docker-image-apache(x86-64) = 0-5.4.fc20
    docker-image-id = 2847b6654809c26a7cf5c60afb8e359702ea3ce8f6ed17842edf974f376690b5

These can be used as BuildRequires: too, so it is possible to perform a layered
image build specifying the latest base image for a given release, or requesting
that an exact specific base image be used for the layered image build.

The images can easily be loaded into docker and pushed to a registry.  The
layered images currently include the base layers already, rather than simply
referencing the base image: that's the existing behavior of "docker save", and
means that the layered rpm doesn't actually Require: the base rpm.  But if you
push base and layers to a registry, they will share the same layers where
possible.

(*TO-DO whenry - need to remove/update this*) (We might want to have the layered rpm Require: the specific base image in any
case, just to provide a record in the rpm metadata of exactly which layer we
built on.  That should be easy to add.)

    # cat /opt/docker/images/fedora-0-5.4.fc20-2fa54f924fa1.img | docker load
    # cat /opt/docker/images/apache-0-5.4.fc20-2847b6654809.img | docker load
    # docker images
    REPOSITORY     TAG           IMAGE ID        CREATED             VIRTUAL SIZE
    apache         0-5.4.fc20    2847b6654809    About an hour ago   760.4 MB
    fedora         0-5.4.fc20    2fa54f924fa1    2 hours ago         531.6 MB

Run this image using the normal `docker run` command:

    # docker run -d --name=apache-test -p 8080:80  apache:0-5.4.fc20
    142bfe1590918b852b0d38438d59051e79f370a33e82b860927eb26ee3c395d3
    # curl http://localhost:8080/
    Apache



(TO-DO if included the section below would be in the Which Approach is Right? section)
### Build System for RPMs

For large organizations or ISVs with build systems then they may wish to use the RPM approach. This way they can incorporate into already established processes, track very precisely, and distribute uniformally. 


(TO-DO probably remove this)

Current code is at 

http://git.engineering.redhat.com/git/users/sct/rpm-images/.git/

This includes:
* base image spec file
* layered image spec file and Dockerfile
* mock wrapper to work around a couple of mock requirements
* rpm auto-dependency scripts to autogenerate build ID provides:

There are four issues to be worked around to get this working:
* Running mock as root
* Presenting /sys/fs/cgroup/* inside the mock chroot
* Making the mock chroot have a bind mount at its root
* A docker pivot_root problem with docker-in-chroot

The first 3 are worked around in the spec file and scripts in the repo above;
the last one currently needs a small docker patch, but I think needs a core
docker upstream fix to do properly.

I'll go into more detail on the problems separately.
