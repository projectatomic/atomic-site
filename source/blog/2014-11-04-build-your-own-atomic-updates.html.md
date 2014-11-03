---
title: Build Your Own Atomic Updates
author: jbrooks
date: 2014-11-04 14:00:00 UTC
comments: true
published: true
---

Over the past several weeks, teams within the [CentOS](http://wiki.centos.org/SpecialInterestGroup/Atomic) and Fedora projects have been establishing the processes needed to produce "Atomic Host" variants of their respective distributions. If you haven't already done so, you can check out the latest pre-release [Fedora Atomic](http://fedoraproject.org/get-prerelease#cloud) and [CentOS Atomic](http://cloud.centos.org/centos/7/devel/) images.

Now, consuming an OS that partakes in the hotness of atomic system and application management while consisting of pre-built packages from a distribution you already know and trust is the point of Project Atomic, but you still might want to take the reins and produce your own Atomic updates or add new RPMs of your choosing.

If so, you can, without too much trouble, compose and host your own updated or changed atomic updates right from your Atomic host, or from any other sort of Docker host. Here's how that works:

### Composing and hosting atomic updates 

First, start with a Docker host (I'm using an instance of the [CentOS Atomic](http://lists.centos.org/pipermail/centos-devel/2014-August/011784.html) alpha, but you can use whatever you want) and clone my [byo-atomic](https://github.com/jasonbrooks/byo-atomic) repo.

_I'm not sure why, but when I performed this operation from the CentOS Atomic alpha image, I had to run my `docker build` command below with the `--privileged` argument in order for the `rpm-ostree compose tree` bit to work._

````
# git clone --recursive https://github.com/jasonbrooks/byo-atomic.git
# sudo docker build --rm -t $USER/atomicrepo byo-atomic/.
# sudo docker run -ti -p 80:80 $USER/atomicrepo bash
````

Once inside the container:

#### For CentOS 7:

````
# cd /byo-atomic/sig-atomic-buildscripts
# git checkout master
# git pull
````

If you'd like to add some more packages to your tree, add them in the file `centos-atomic-cloud-docker-host.json` before proceeding with the compose command:

````
# rpm-ostree compose tree --repo=/srv/rpm-ostree/repo centos-atomic-cloud-docker-host.json
````

_The CentOS sig-atomic-buildscripts repo currently includes some key packages built in and hosted from the CentOS [Community Build System](http://cbs.centos.org/koji/). The CBS repos rebuild every 10 minutes, so if your rpm-ostree fails out w/ a repository not found sort of error, wait a few minutes and run the command again._

The compose step will take some time to complete. When it's done, you can run the following command to start up a web server in the container. 

#### For Fedora 21:

The master branch of the fedora-atomic repo contains the definitions required to compose a rawhide-based Fedora Atomic host. If you'd rather compose a f21-based Fedora Atomic host, you'll need to:

````
# cd /byo-atomic/fedora-atomic
# git checkout f21
# git pull
````

If you'd like to add some more packages to your tree, add them in the file `fedora-atomic-docker-host.json` before proceeding with the compose command:

````
# rpm-ostree compose tree --repo=/srv/rpm-ostree/repo fedora-atomic-docker-host.json
````

#### For both Fedora and CentOS:
 
The compose step will take some time to complete. When it's done, you can run the following command to start up a web server in the container. 

````
# sh /run-apache.sh
````

Now, you should be able to visit $YOURHOSTIP:10080/repo and see your new rpm-ostree repo. 

To configure an Atomic host to receive updates from your build machine, edit (as root) the file `/etc/ostree/remotes.d/centos-atomic.conf` or `sudo vi /etc/ostree/remotes.d/fedora-atomic.conf` and add a section like this:

````
[remote "centos-atomic-host"]
url=http://$YOURHOSTIP/repo
branches=centos/7/x86_64/cloud-docker-host;
gpg-verify=false
````

````
[remote "fedora-atomic-host"]
url=http://$YOURHOSTIP/repo
branches=fedora-atomic/21/x86_64/docker-host;
gpg-verify=false
````

With your repo configured, you can check for updates with the command `sudo rpm-ostree upgrade`, followed by a reboot. Don't like the changes? You can rollback with `rpm-ostree rollback`, followed by another reboot.

### Till Next Time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. Ping me at jbrooks in #atomic on freenode irc or [@jasonbrooks](https://twitter.com/jasonbrooks) on Twitter. Also, be sure to check out the [Project Atomic Q&A site](http://ask.projectatomic.io/en/questions/).
