# Guidance for Docker Image Authors

Docker image authors have multiple concerns for their images:

* Is my image easy to use?
* Is my image easy to base another image on?
* Does my image behave in a performant manner?

There are many details which can affect the answers to these questions.  We've created this 
document to help image authors create images for which the answer is 'yes' across the board.

## Learn About Creating Images with Dockerfiles

There are two ways to create a docker image:

* Create a container and alter its state by running commands in it; create an image with
   `docker commit`
* Create a `Dockerfile` and create an image with `docker build`

Most image authors will find that using a `Dockerfile` is a much easier way to repeatably create
an image.  A `Dockerfile` is made up of <i>instructions</i>, several of which will be discussed in this guide.

You can find the complete `Dockerfile` instruction reference
[here](http://docs.docker.io/en/latest/reference/builder/#id5).

## Use `MAINTAINER`

The `MAINTAINER` instruction sets the <i>Author</i> field of the image.  This is useful for
providing an email contact for your users if they have questions for you.

## Know the Differences Between CMD and ENTRYPOINT

There are many details of how the Dockerfile `CMD` and `ENTRYPOINT` instructions work, and
expressing exactly what you want is key to ensuring users of your image have the right
experience.  These two instructions are similar in that they both specify commands that run in an
image, but there's an important difference: `CMD` simply sets a command to run in the image if no
arguments are passed to `docker run`, while `ENTRYPOINT` is meant to make your image behave like a
binary.  The rules are essentially:

* If your `Dockerfile` uses only `CMD`, the provided command will be run if no arguments are
   passed to `docker run`
* If your `Dockerfile` uses only `ENTRYPOINT`, the arguments passed to `docker run` will always
   be passed to the entrypoint; the entrypoint will be run if no arguments are passed to `docker
   run`
* If your `Dockerfile` declares both `ENTRYPOINT` and `CMD`, and no arguments are passed to 
   `docker run`, then the argument(s)  to `CMD` will be passed to the declared entrypoint

Be careful with using `ENTRYPOINT`; it will make it more difficult to get a shell inside your
image.  While it may not be an issue if your image is designed to be used as a single command,
it can frustrate or confuse users that expect to be able to use the idiom:

    # docker run -i -t <your image> /bin/bash

Then entrypoint of an image can be changed by the `--entrypoint` option to `docker run`.  If you
choose to set an entrypoint, consider educating your users on how to get a shell in your image 
with:

    # docker run -i --entrypoint /bin/bash -t <your image>

## Know the Difference Between Array and String Forms of CMD and ENTRYPOINT

There are also two different forms of both `CMD` and `ENTRYPOINT`: array and string forms:

* Passing an array will result in the exact command being run.  Example: `CMD [ "ls", "/" ]`
* Passing a string will prefix the command with `/bin/sh -c`.  Example: `CMD ls /`

The `-c` option affects how the shell interprets arguments.  We recommend 
[reading up](http://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash)
on this option's behavior or using array syntax.

## Always `exec` in Wrapper Scripts

Many images use wrapper scripts to do some setup before starting a process for the software being
run.  It is important that if your image uses such a script, that script should use `exec` so that
the script's process is replaced by your software.  If you do not use `exec`, then signals sent by
docker will go to your wrapper script instead of your software's process.  This is not what you
want - as illustrated by the following example:

Say that you have a wrapper script that starts a process for a server of some kind.  You start
your container (using `docker run -i`), which runs the wrapper script, which in turn starts your
process.  Now say that you want to kill your container with `CTRL+C`.  If your wrapper script used
`exec` to start the server process, docker will send `SIGINT` to the server process, and everything
will work as you expect.  If you didn't use `exec` in your wrapper script, docker will send 
`SIGINT` to the process for the wrapper script - and your process will keep running like nothing
happened.

## Always EXPOSE Important Ports

The `EXPOSE` instruction makes a port in the container available to the host system and other 
containers.  While it is possible to specify that a port should be exposed with a `docker run` 
invocation, using the `EXPOSE` instruction in a `Dockerfile` makes it easier for both humans and
software to use your image by explicitly declaring the ports your software needs to run:

* Exposed ports will show up under `docker ps` associated with containers created from your image
* Exposed ports will also be present in the metadata for your image returned by `docker inspect`
* Exposed ports will be linked when you link one container to another

For more information about ports and docker, please check out the 
[docker documentation](http://docs.docker.io/en/latest/use/port_redirection/).

## Use Volumes Appropriately
 
The `VOLUME` instruction and the `-v` option to `docker run` tell docker to store files in a directory on the host
instead of in the container's file system.  Volumes give you a couple of key benefits:

* Volumes can be shared between containers using `--volumes-from`
* Changes to large files are faster

Volumes obey different rules from normal files in containers:

* Changes made to volumes are not included in the next `docker commit`
* Volumes are a reference counted resource - they persist as long as there are containers using 
   them

### Sharing Volumes Between Containers

It is possible to share the volumes created by one container with another by using the
`--volumes-from` parameter to docker run.  For example, say we make a container named 'ContainerA'
that has a volume:

    # docker run -i  -v /var/volume1-name 'ContainerA' -t fedora /bin/bash

We can share the volumes from this container with another container:

    # docker run -i --volumes-from ContainerA -t fedora /bin/bash

In `ContainerB`, we will see `/var/volume1` from `ContainerA`.  For more information about sharing
volumes, please check out the 
[docker documentation](http://docs.docker.io/en/latest/use/working_with_volumes/)

### When to Use Volumes

We recommend that you use volumes in the following use-cases:

1.  You want to be able to share a directory between containers
2.  You intend on writing large amounts of data to a directory, for example, for a database

## Use USER

By default docker containers run as `root`.  A docker container running as root has <b>full control</b>
of the host system.  As docker matures, more secure default options may become available.  For now,
requiring `root` is dangerous for others and may not be available in all environments.  Your image
should use the `USER` instruction to specify a non-root user for containers to run as.  If your 
software does not create its own user, you can create a user and group in the `Dockerfile` as follows:

    RUN groupadd -r swuser -g 433 && \
    useradd -u 431 -r -g swuser -d <homedir> -s /sbin/nologin -c "Docker image user" swuser && \
    chown -R swuser:swuser <homedir>

### Reusing an Image with a Non-root User

The default user in a `Dockerfile` is the user of the parent image.  For example, if your image is
derived from an image that uses a non-root user `swuser`, then `RUN` commands in your
`Dockerfile` will run as `swuser`.

If you need to run as root, you should change the user to root at the beginning of your
`Dockerfile` then change back to the correct user with another `USER` instruction:

    USER root
    RUN yum install -y <some package>
    USER swuser
