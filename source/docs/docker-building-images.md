# Building Docker Images

Building Docker images is a key feature for DevOps. Here's how to accomplish this task.

## Containers Layers and Images

Docker is known primarily for the following features:

* Resource Management
* Process Isolation
* Security
* Tooling/CLI

Resource management and process isolation come from Linux Containers (LXC). Some security is built into resource management and process isolation. The added security of SELinux is also separate from Docker. The first three features demonstrate the value of containers. Docker, however, provides extra tooling beyond lxc-tools.  

One of the more important features of Docker is *image content management*, or *image layering*. Docker's layered approach to images (or content) provides a very powerful abstraction for building up application containers.  An image provides the foundation layer for a container.  New tools, applications, content, patches, etc. form additional layers on the foundation.  Containers are instantiations of these combined entities, which can then be bundled into it's own image.

Docker allows you to build containers using a Dockerfile.  The Dockerfile describes a base image for the build using the `FROM` instruction. `FROM` implicitly uses a image registry from which the base image is pulled. This can be `docker.io` or some other (perhaps internal) registry. 

The additional layers of a Docker container are created with directives within the Dockerfile.  The `RUN` directive is used to run commands in running image.  Extra packages can be installed using the `RUN` instruction and the Linux distribution's package installation tool. For Fedora and Red Hat Enterprise Linux this tool is `yum`.  Scripts and other content can be added to the layer by using the `ADD` instruction from local directories or a URL.

Once you've added the required additional layers to your base image to make your specific application, you can create an image and add it to a registry for re-use.

These three instructions are the basics for building containers using the Dockerfile. A simple example:

    FROM fedora
    RUN yum install -y gcc
    ADD ./myprogramfiles.tar /tmp  

## Two Approaches to Image Building

There are two approaches to building Docker images.   

Consider the following example: an administrator would like to deploy a new simple web site using Docker container technology. 

The administrator decides that the image needs three components:

* Fedora base image
* Apache Web server
* Web site content

The administrator can build the image in one of the two following ways:

* Interactively, by launching a BASH shell under Fedora to yum install httpd and its dependencies, and then save the image
* Create a Dockerfile that builds the image with the web site included

The first approach involves the administrator using the Docker CLI to instantiate the base image, install the Apache web server, and then create a reusable image for later use with the web site content.  In this scenario, the base Fedora + Apache image can be used as a base for any project that requires those tools.

The second approach involves building a Dockerfile that uses the base Fedora image,  installs the needed Apache packages, and then adds the necessary content. This ensures that the entire web site is complete in one build.  The image created by this build will only serve a single web site and content changes would require a rebuild. 

### Interactively from a Running Fedora Container

There is a semi-official image called `fedora` (the latest Fedora version) in the public Docker registry.  For more information on this image and the options available, check [the repository page](https://registry.hub.docker.com/_/fedora/).

To run a container with an interactive shell, run the following Docker command on the Project Atomic host:

    # docker run -i -t fedora bash

This has created a running Fedora instance in a Docker container and attached a bash shell to the tty. Inside the container shell, run the following `yum` commands to get the latest updates for Fedora, and to install Apache httpd:

    # yum update -y
    # yum install -y httpd
    # exit

From the Project Atomic host machine, save the new image by finding the container ID and then committing it to a new image name:

    # docker ps -a
    # docker commit c16378f943fe fedora-httpd

Check that this worked by running:

    # docker images

You should see both `fedora-httpd` and `fedora` listed.

The administrator now has a new image that contains a Apache Web server. The adminstrator can build a Dockerfile based on that image and add the appropriate files. Given the relative path to a tarball of the site content, Docker automatically untars or unzips the files in a source tar or zip file into the target directory. Here is the Dockerfile:

    FROM fedora-httpd
    MAINTAINER A D Ministator email: admin@corp.example.com

    # Add the tar file of the web site 
    ADD mysite.tar /tmp/

    # Docker automatically extracted. So move files to web directory
    RUN mv /tmp/mysite/* /var/www/html

    EXPOSE 80

    ENTRYPOINT [ "/usr/sbin/httpd" ]
    CMD [ "-D", "FOREGROUND" ]

The administrator can use this simple Dockerfile as a template for building other web sites. 

Docker build context passed to the daemon requires the Dockerfile and the content for the site.  The path for this build is ` . `, but in practice you should create separate build contexts for each container.  Using `-P` in the run command will automatically connect the EXPOSEd port to a random port available to Docker.

    # docker build -rm -t mysite .
    # docker run -d -P mysite

Use the `docker ps` command to determine the port activated and then use `curl` to inspect the sample content.

    # docker ps
    # curl localhost:49153

This approach is a great way to learn about Docker and building images. It is also good for troubleshooting and prototyping.  It is how `docker.io` teaches you about Docker in their Getting Started web page.

### Using a Dockerfile to build the container

The administrator may decide that building interactively is tedious and error-prone. Instead the administrator could create a Dockerfile that layers on the Apache Web server and the web site content in one build. 

A good practice is to make a sub-directory with a related name and create a Dockerfile in that directory. E.g. a directory called mongo may contain a Dockerfile for a MongoDB image, or a directory called httpd may container an Dockerfile for an Apache web server. Copy or create all other content that you wish to add to the image into the new directory.  Keep in mind that the ADD directive context is relative to this new directory.

    # mkdir httpd
    # cp mysite.tar httpd/

Create the Dockerfile in the httpd directory. This Dockerfile will use the same base image as the interactive command `fedora`:

    FROM fedora
    MAINTAINER A D Ministator email: admin@mycorp.com

    # Update the image with the latest packages (recommended)
    RUN yum update -y; yum clean all

    # Install Apache Web Server
    RUN yum install -y httpd; yum clean all

    # Add the tar file of the web site 
    ADD mysite.tar /tmp/

    # Docker automatically extracted. So move files to web directory
    RUN mv /tmp/mysite/* /var/www/html

    EXPOSE 80

    ENTRYPOINT [ "/usr/sbin/httpd" ]
    CMD [ "-D", "FOREGROUND" ]

Build this Dockerfile from the new httpd directory and run it:

    # docker build -rm -t newsite httpd/ 
    # docker run -d -P newsite

The container build process builds a series of temporary image layers based on the directives in the Dockerfile.  These temporary layers are cached so if you make modifications to the content tarball, it won't completely rebuild and update the Fedora image.  Since each directive is a new layer, you could reduce the number of layers by combining the `RUN yum` directives into a single `RUN` directive:

    RUN yum -y install httpd && yum -y update; yum clean all

Planning your layers will determine how many layers need to be recreated on each build of the container.
 
## Which Approach is Right?

The approach to building images depends on *why* the user is building the image.

### Prototyping and Troubleshooting

If prototyping and trouble shooting then the user probably wants to do an interactive, "*inside the container*" approach. Using this approach the user can take notes of the history of commands used that make sense and what external files may be missing or need changes. These can be ADDed to the Dockerfile.

### Complete Satisfactory Single Build

If the user is satisfied with a specific image that has been build using the interactive approach and they believe it might be reused elsewhere, then it is recommended to use the single Dockerfile approach that builds it all in one build.

## Filesystem Considerations

Now that you understand how Docker layers images, it raises some questions on how best to deploy Docker in your environment. Docker supports several different file system formats. How these work and which one you choose for all or part of your deployment will greatly effect your performance and efficiency.

For information and recommendations on supported filesystems please see [Supported Filesystems](http://www.projectatomic.io/docs/filesystems/).

In many use cases it is beneficial to attach and mount a separate filesystem for Docker's use.  This file system will be mounted on /dev/lib/docker. For information on how to mount /var/lib/docker on a separate file system see [Setting Up Storage](http://www.projectatomic.io/docs/docker-storage-recommendation/).

