Building Docker Images
====================== 

## Containers Versus Images

Docker is known primarily for the following features:

* Resource Management
* Process Isolation
* Security
* Tooling/CLI

The first two features come from Linux Containers (LXC). There is some security built into resource management and process isolation. The added security of SELinux is also separate from Docker. So the first three features are really about the value of containers. Docker does provide extra tooling beyond lxc-tools.  

One of the more important features of Docker is managing image content or *image layering*. Docker's layered approach to images (or content) provides a very powerful abstraction for building up application containers. 

Docker allows you to build images using a Dockerfile.  The Dockerfile describes a base image, from which to start building, using the `FROM` instruction. The `FROM` implicitly uses a image registry from which to pull that base image. This can be the `docker.io` or some other (perhaps internal) registry. Extra packages can be installed using the `RUN` instruction and the Linux distributions package installation tooling. For Fedora and Red Hat Enterprise Linux this tool is `yum`.  Other content can be added using the `ADD` instruction.  These three instructions are the basics for building images using the Dockerfile. A simple example:

    FROM fedora
    RUN yum install -y gcc
    ADD ./myprogramfiles.tar /tmp  

## Two Approaches to Image Building

There are two approaches to building Docker images.   

Consider the following example: An administrator would like to deploy a new simple website using Docker container technology. 

The administrator decides their image needs three components:

* RHEL 7 base image
* Apache Web server
* The addition of their own web site content.

There are two ways the administrator can build the require image:

* Create a Dockerfile that will build a the image and the web-site
* Interactively by running the RHEL 7 base image and in a bash shell yum install httpd and its dependencies and then save the image

The first approach would be to build a Dockerfile that uses the base RHEL image and installs the needed Apache packages an then ADDs the necessary files. That way the entire website is complete in one build. We will examine this approach a little later. The administrator decides that the RHEL 7 + Apache web server layered image is reusable for other future web sites. So an Apache Web server image based on RHEL 7 is what is first required. 

### Interactively from a Running RHEL 7 Container

Assuming an image called `rhel7` in a Docker registry, run the following Docker command on a Docker host machine:

    # docker run -i -t rhel7 bash

This returns a shell prompt. Inside the container shell run a couple of normal `yum` commands to get the latest updates for RHEL 7 and install Apache httpd:

    # yum update -y
    # yum install -y httpd
    # exit

From the host machine save the new image by first finding the container ID and then committing it to a new image name:

    # docker ps -a
    # docker commit c16378f943fe rhel7-httpd

Now push the image to the registry using the image ID. In this example the registry is on registry-host and listening on port 5000. Default Docker commands will push to the default `docker.io` registry. Instead push to the local registry which is on a host called registry-host. In order to do this tag the image with the host name, or IP address, and port of the registry: 

    # docker tag rhel7-httpd registry-host:5000/myadmin/rhel7-httpd
    # docker push registry-host:5000/myadmin/rhel7-httpd

You can check that this worked by running:

    # docker images

You should see both `rhel7-httpd` and `registry-host:5000/myadmin/rhel7-httpd` listed.

Now the administrator has a new image that contains a Apache Web server. The adminstrator can build a Dockerfile based on that image and add the appropriate files. Docker will automatically untar/unzip the files in a source tar/zip file into the target directory. Here is the Dockerfile:

    FROM registryhost:5000/whenry/rhel7-httpd
    MAINTAINER A D Ministator email: admin@mycorp.com

    # Add the tar file of the web site 
    ADD ./mysite.tar /tmp/

    # Docker automatically extracted. So move files to web directory
    RUN mv /tmp/mysite/* /var/www/html

    EXPOSE 80

    ENTRYPOINT /usr/sbin/httpd -DFOREGROUND

Now the administrator can use this simple Dockerfile as a template for building lots of other web sites. 

Simply build and run from the directory where the Dockerfile and content is located.  The '.' in the `docker build` command signifies where the Dockerfile is located :

    # docker build -rm --tag=mysite .
    # docker run -d mysite

This approach is a great way to learn about Docker and building images. It is also a great way for trouble shooting are protyping.  It is how `docker.io` teaches you about Docker in their Getting Started web page.

### Using One Docker file form a Base Image

Alternatively the administrator may decide that building interactively is a bit tedious and perhaps error prone. Instead the administrator could build a single Dockerfile that layers on the Apache Web server and the web site content in one build. 

A good practice is to make a subdirectory with a related name and create a Dockerfile in that directory. E.g. a directory called mongo may contain a Dockerfile for a MongoDB image, or a directory called httpd may container an Dockerfile for an Apache web server. Copy or create all other content that you wish to add to the image into the new directory.  

    # mkdir httpd
    # cd httpd
    # cp mysite.tar .

Create the Dockerfile. This Dockerfile assumes a base image called rhel7:

    FROM rhel7
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

This basically dependends on *why* the user is building the image.

### Prototyping and Troubleshooting

If prototyping and trouble shooting then the user probably wants to do an interactive, "*inside the container*" approach. Using this apprach the user can take notes of the history of commands used that make sense and what external files may be missing or need changes. These can be ADDed to the Dockerfile.

### Complete Satisfactory Single Build

If the user is satisfied with a specific image that has been build using the interactive approach and they believe it might be reused elsewhere, then it is reocommeded to use the single Dockerfile approach that builds it all in one build.

## File System Considerations

Now that you understand how Docker layers images, it raises some questions on how best to deploy Docker in your environment. Docker supports several different file system formats. How these work and which one you choose for all or part of your deployment will greatly effect your performance and efficiency.

For information and recommendations on file systems please see <link to Alex page>

In many use cases it is beneficial to attach and mount a separate file system for Docker's use.  This file system will be mounted on /dev/lib/docker. For information on how to mount /var/lib/docker on a separate file system see <link William's mount /var/lib/docker page>

