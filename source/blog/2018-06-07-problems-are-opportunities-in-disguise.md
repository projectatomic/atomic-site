---
title: Problems Are Just Opportunities in Disguise
author: tsweeney
date: 2018-06-07 00:00:00 UTC
layout: post
comments: false
categories:
- atomic
- buildah
---

As a father who's ushered one child through their teen years, and with two more in the teens now, I know about problems. Problems with the WiFi not working, or the shoes that are two months old and now two sizes too small. Those are the easy ones, the harder ones come in with sleepovers with their significant others, the broken down car after curfew or the death of a classmate. In my "at-work" life, I was explaining to my scrum master that I'd not been picking off any cards off our board in the past sprint because I'd spent all my time working on issues. He remarked that as a software engineer we're not so much coders as we're problem solvers. I guess I can't escape problems either at work or at home.

Recently one of the folks that talks about Buildah, Podman, and other related container technologies at conferences sent me an email about a problem he was having with a demo script he was hoping to show.

READMORE

This script had worked in the past, but wasn't working now, and the next conference he was going to show it at was just days away. What unfolded from that discussion reminded me of my discussion with my scrum master that not all problems that we face as software engineers are always just a bug in the code. Sometimes it's the environment that our code finds itself in.

The script that had become problematic is a demo script that creates a Fedora 28 based container using Buildah and then installs the nginx httpd server within it. Podman is then used to run the container and to kick off the nginx server. You can find the full script [here](https://github.com/projectatomic/buildah/blob/master/demos/buildah-bud-demo.sh) which is a really great script when you're running it as a demo or to learn about Buildah. However with the deadline before the next conference ticking away, the pause instructions in the script that allow for an explanation during a conference were proving to be too slow while trying to figure out the problem. So I shrunk the script down and it resulted in this:


```
cat ~/tom_nginx.sh
#!/bin/bash

# docker-compatibility-demo.sh
# author : demodude
# Assumptions install buildah, podman & docker
# Do NOT start the docker deamon
# Set some of the variables below

demoimg=dockercompatibilitydemo
quayuser=ipbabble
myname="Demo King"
distro=fedora
distrorelease=28
pkgmgr=dnf # switch to yum if using yum

#Setting up some colors for helping read the demo output
bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
reset=$(tput sgr0)

echo -e "Using ${green}GREEN${reset} to introduce Buildah steps"
echo -e "Using ${yellow}YELLOW${reset} to introduce code"
echo -e "Using ${blue}BLUE${reset} to introduce Podman steps"
echo -e "Using ${cyan}CYAN${reset} to introduce bash commands"
echo -e "Using ${red}RED${reset} to introduce Docker commands"

echo -e "Building an image called ${demoimg}"

set -x
newcontainer=$(buildah from ${distro})
buildah run $newcontainer -- ${pkgmgr} -y update && ${pkgmgr} -y clean all
buildah run $newcontainer -- ${pkgmgr} -y install nginx && ${pkgmgr} -y clean all
buildah run $newcontainer bash -c 'echo "daemon off;" >> /etc/nginx/nginx.conf'
buildah run $newcontainer bash -c 'echo "nginx on OCI Fedora image, built using Buildah" > /usr/share/nginx/html/index.html'
buildah config --port 80 --entrypoint /usr/sbin/nginx $newcontainer
buildah config --created-by "${quayuser}" $newcontainer
buildah config --author "${myname}" --label name=$demoimg $newcontainer
buildah inspect $newcontainer
buildah commit $newcontainer $demoimg
buildah images
containernum=$(podman run -d -p 80:80 $demoimg)
curl localhost # Failed
podman ps
podman stop $containernum
podman rm $containernum

```

In the script you can see that a new Fedora container was created using `buildah from` and then in the next four steps `buildah run` was employed to do some configurations in the container. The first two commands do a `dnf update` and then use dnf again to install nginx and then clean everything up. The next two run commands ready nginx for running, the first one sets up the /etc/nginx/nginx.conf file and sets ‘daemon off' in it, and then the next run command creates the index.html file to be displayed.

The three `buildah config` commands then do a little housekeeping within the container. They set up port 80, set the entrypoint to nginx, and then touch up the created-by, author and label fields in the new container. At this point the container is all set up such that it could run nginx and the `buildah inspect` command lets you walk through the fields and associated metadata of the container to verify all of that.

For the purpose of this script it was decided to run the container and the nginx server using Podman. Podman is a new open source utility for working with Linux containers and Kubernetes pods that emulates many features of the docker command line, but doesn't require a daemon like Docker does.

In order to let Podman run the container, it first must be saved as an image and that's what occurs with the `buildah commit` line. Then finally in the `podman run` line, we started up the container and due to the way that we configured it with the entrypoint and setting up the ports, the nginx server was started up and available for use. It's always nice to say the server is “running” but the proof in the pudding is being able to interact with the server. So a simple `curl localhost` was executed and we should see the index.html which simply contains:

`nginx on OCI Fedora image, built using Buildah`

However with only hours before the next demo, instead it sent back:

`curl: (7) Failed to connect to jappa.cos.redhat.com port 80: Connection refused`

Now that's not good. I talked to the folks on the Podman team and they were not able to reproduce the problem, so this was possibly a problem in Buildah. A flurry of debugging and checking was done in the config code to make sure the ports were being set up properly, the image was getting pulled correctly and then saved. It all checked out. Prior run throughs of the demo had all completed successfully, the nginx server would serve up the index.html as expected. That was odd, and no recent changes to the Buildah code that would likely upset any of that.

So at this point I went ahead and chopped down the original script down to the one in this article and started running it. On my development virtual machine (vm) I was having the problem repeatedly. I added debugging statements and wasn't find anything. Strangely if I replace ‘podman' with ‘docker' in the script, everything worked just fine. As I'm not always very kind to my development vm, I set up a new VM and installed everything nice and fresh and clean.

The first pass through and the script failed there as well, so my development vm wasn't behaving badly by itself. I ran the script a number of times while I was thinking things through, hoping to pick something up from the output that would garner a clue. My next thought was to get into the container and look around in there. So I commented out the stop and rm lines from the script, reran it and used:

`podman exec --tty 129d4d33169f /bin/bash`

Where `129d4d33169f` was the ‘CONTAINER ID' value from the `podman ps` command for the container. I did `curl localhost` there within the container and voilà! I received the output from the index.html that I wanted. I then exited the container and tried the curl command again from the host running the container and this time it worked. Finally light dawned on marblehead. In past testings I'd been playing with an Apache httpd server and trying to connect to it from another session. In those tests if I went too quick, the server would reject me. Could it be that simple?

As it turns out, it was. We added a `sleep 3` line between the `podman run` and the `curl localhost` commands and then everything worked as expected. What's apparently happening is the `podman run` command is starting up the container and nginx server extremely quickly and returning to the command line. If you don't wait a few seconds, the nginx server doesn't have time to start up and start accepting connection requests.

In our testing with Docker, this wasn't the case. I didn't dig into it deeply but my assumption is the time that Docker spends talking to the Docker daemon gives the nginx server enough time to come up fully. This is what really makes Buildah and Podman very useful and powerful, no daemon, less overhead. But you need to take that into account for demos!

So problems are indeed what engineers solve and often times it's not always in the code itself. When looking at problems it often is good to step back a little bit further and not get too focused on the bits and the bytes. This problem helped me to remember this lesson myself. Who knows maybe your next problem will also prove to be an opportunity in disguise.

**Buildah == Simplicity**
