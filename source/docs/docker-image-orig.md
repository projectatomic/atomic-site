# Building Docker Images

Building Docker images is a key feature for DevOps. Here's how to accomplish this task.

## Containers Versus Images

Docker is known primarily for the following features:

* Resource Management
* Process Isolation
* Security
* Tooling/CLI

Resource management and process isolation come from Linux Containers (LXC). Some security is built into resource management and process isolation. The added security of SELinux is also separate from Docker. The first three features demonstrate the value of containers. Docker, however, provides extra tooling beyond lxc-tools.  

One of the more important features of Docker is *image content management*, or *image layering*. Docker's layered approach to images (or content) provides a very powerful abstraction for building up application containers. 

Docker allows you to build images using a Dockerfile.  The Dockerfile describes a base image, from which the image can be built using the `FROM` instruction. `FROM` implicitly uses a image registry from which the base image is pulled. This can be `docker.io` or some other (perhaps internal) registry. Extra packages can be installed using the `RUN` instruction and the Linux distribution's package installation tool. For Fedora and Red Hat Enterprise Linux this tool is `yum`.  Other content can be added by using the `ADD` instruction.  These three instructions are the basics for building images using the Dockerfile. A simple example:

    FROM fedora
    RUN yum install -y gcc
    ADD ./myprogramfiles.tar /tmp  

## Two Approaches to Image Building

There are two approaches to building Docker images.   

Consider the following example: an administrator would like to deploy a new simple website using Docker container technology. 

The administrator decides that the image needs three components:

* Fedora base image
* Apache Web server
* Web site content

The administrator can build the image in one of the two following ways:

* Create a Dockerfile that builds the image with the website included
* Interactively, by running the Fedora base image using a BASH shell to yum install httpd and its dependencies, and then save the image

The first approach involves building a Dockerfile that uses the base Fedora image and installs the needed Apache packages, and then ADDs the necessary files. This ensures that the entire website is complete in one build. We will examine this approach later. The administrator decides that the Fedora + Apache web server layered image is reusable for other future web sites. This means that an Apache Web server image based on Fedora is what is first required. 

### Interactively from a Running Fedora Container

There is a semi-official image called `fedora` (the latest Fedora version) in the public Docker registry.  For more information on this image and the options available, check the repository page.

To run a container with an interactive shell, run the following Docker command on the Project Atmoic host:

    # docker run -i -t fedora bash

This has created a running Fedora instance in a Docker container and attached a bash shell to the tty. Inside the container shell, run the following `yum` commands to get the latest updates for Fedora, and to install Apache httpd:

    # yum update -y
    # yum install -y httpd
    # exit

From the host machine, save the new image by finding the container ID and then committing it to a new image name:

    # docker ps -a
    # docker commit c16378f943fe fedora-httpd

Now push the image to the registry using the image ID. In this example the registry is on registry-host and listening on port 5000. Default Docker commands will push to the default `docker.io` registry. Instead, push to the local registry, which is on a host called *registry-host*. To do this, tag the image with the host name or IP address, and the port of the registry: 

    # docker tag fedora-httpd registry-host:5000/myadmin/fedora-httpd
    # docker push registry-host:5000/myadmin/fedora-httpd

Check that this worked by running:

    # docker images

You should see both `fedora-httpd` and `registry-host:5000/myadmin/fedora-httpd` listed.

The administrator now has a new image that contains a Apache Web server. The administrator can build a Dockerfile based on that image and add the appropriate files. Docker automatically untars or unzips the files in a source tar or zip file into the target directory. Here is the Dockerfile:

    FROM registryhost:5000/whenry/fedora-httpd
    MAINTAINER A D Ministator email: admin@corp.example.com

    # Add the tar file of the web site 
    ADD ./mysite.tar /tmp/

    # Docker automatically extracted. So move files to web directory
    RUN mv /tmp/mysite/* /var/www/html

    EXPOSE 80

    ENTRYPOINT /usr/sbin/httpd -DFOREGROUND

The administrator can use this simple Dockerfile as a template for building other web sites. 

Build and run from the directory where the Dockerfile and content is located.  The '.' in the `docker build` command signifies where the Dockerfile is located :

    # docker build -rm --tag=mysite .
    # docker run -d mysite

This approach is a great way to learn about Docker and building images. It is also good for troubleshooting and prototyping.  It is how `docker.io` teaches you about Docker in their Getting Started web page.

Recommendation: It would be good to expose port 80 and define the entry point in the `fedora-httpd` image and then merely add the files in the final Dockefile. That way the application only has to worry about the files needed for the new website.  

### Using a Single Dockerfile 

The administrator may decide that building interactively is tedious and error-prone. Instead the administrator could build a single Dockerfile that layers on the Apache Web server and the web site content in one build. 

A good practice is to make a sub-directory with a related name and create a Dockerfile in that directory. E.g. a directory called mongo may contain a Dockerfile for a MongoDB image, or a directory called httpd may container an Dockerfile for an Apache web server. Copy or create all other content that you wish to add to the image into the new directory.  

    # mkdir httpd
    # cd httpd
    # cp mysite.tar .

Create the Dockerfile. This Dockerfile assumes a base image called fedora:

    FROM fedora
    MAINTAINER A D Ministator email: admin@mycorp.com

    # Update the image with the latest packages (recommended)
    RUN yum update -y; yum clean all

    # Install Apache Web Server
    RUN yum install -y httpd; yum clean all

    # Add the tar file of the web site 
    ADD ./mysite.tar /tmp/

    # Docker automatically extracted. So move files to web directory
    RUN mv /tmp/mysite/* /var/www/html

    EXPOSE 80

    ENTRYPOINT /usr/sbin/httpd -DFOREGROUND

Simply build this Dockerfile from the new httpd directory and run it:

    # docker build -rm --tag=mysite .
    # docker run -d mysite 

It's worth noting from the above that in order to reduce the amount of temporary image layers it is recommended to add `; yum clean all` after each `RUN yum` step.
 
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

