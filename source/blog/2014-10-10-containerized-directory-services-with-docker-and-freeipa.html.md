---
title: Containerized Directory Services with Docker and FreeIPA
author: jbrooks
date: 2014-10-10 21:32:44.000000000 Z
published: false
comments: true
---

I've tried out a lot of different software applications in my time, so I've come to appreciate projects and products that make it easy to get up and running quickly and without the need for assembling a whole labful of equipment.

In this vein, the various components that comprise [oVirt](http://www.ovirt.org/Home), the open source virtualization management project, can be piled onto a single piece of hardware in form that works well enough to credibly kick the project's tires. 

Well, mostly. In order to really get your oVirt on, you need to hook up a directory service of some sort. FreeIPA is an obvious choice to provide oVirt with directory services, but due to conflicts between their package sets, oVirt's management engine can't be installed on the same host as FreeIPA.

Sounds like a job for Docker, right? Just in time for the approaching release of [oVirt 3.5](http://www.ovirt.org/OVirt_3.5_Release_Notes), the good people behind the CentOS Dockerfiles repository (the same one I mentioned in a [recent post](http://www.projectatomic.io/blog/2014/09/exploring-web-apps-with-docker/) about trying out WordPress 4.0) have recently added a [FreeIPA Dockerfile](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/freeipa/centos7) to the list of containerized components on offer.

I set out to deploy a dockerized FreeIPA instance on the same machine as the oVirt management engine, to see whether the combination would work well enough for testing oVirt's multiuser capabilities.

I started off with a machine running a minimal install of CentOS 6.5, to which I added the EPEL repository (for Docker) and the oVirt 3.5 RC4 repository:

````
sudo yum install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release35.rpm epel-release
````

Next, I added git, Docker, and the oVirt Engine:

````
sudo yum install -y git docker-io ovirt-engine
````

Then, I set up oVirt Engine, by running the command `engine-setup` and accepting all the defaults suggested by the install script.

With the engine up and running, I started up the Docker service, grabbed the source of the FreeIPA Dockerfile, and kicked off a build of the image:

````
sudo service docker start
git clone https://github.com/CentOS/CentOS-Dockerfiles.git
cd CentOS-Dockerfiles/freeipa/centos7/
sudo docker build -t freeipa-server .
````

Next, as described in the [README](https://github.com/CentOS/CentOS-Dockerfiles/blob/master/freeipa/centos7/README), I ran the container image:

````
docker run --privileged --name freeipa-server-container -ti -h ipa.example.test -e PASSWORD=Secret123 freeipa-server
````

The FreeIPA image is set up to configure itself on first run, a process that takes a couple of minutes. When the setup was complete, I found myself at a bash prompt within the new container (couresy of the optional `-ti` in the run command).  From this shell, I had to make a small configuration tweak to [deal with an issue](http://www.ovirt.org/Troubleshooting#Adding_an_IPA_domain_to_ovirt_engine) between FreeIPA and oVirt Engine.

I needed to modify the file `/etc/dirsrv/slapd-EXAMPLE-TEST/dse.ldif` and change the line `nsslapd-minssf: 0` to `nsslapd-minssf: 1` before stopping and restarting the container. 

From the shell within the container, I could stop the container by typing `exit`, and, once returned to the promt on my test machine, restart the container with the command `docker start -ai freeipa-server-container`.

Once I was back at the shell within my FreeIPA container, I created a new user to use with oVirt:

* `kinit admin` _to authenticate as the FreeIPA admin, using the `Secret123` password from the run command_
* `ipa user-add` _to create my user account, I chose the user name `ouser`_
* `ipa passwd ouser` _to set an initial password for the new user_
* `kinit ouser` _to authenticate as ouser, and change its password, as required by FreeIPA_

After that, I ran `ip a` from the container shell to figure out the container's IP address. With that address in hand, I visited a separate terminal window, outside of the container, and I edited the `/etc/resolv.conf` file in my test machine to include the line `namesever CONTAINER-IP-HERE` so that my machine would use the new containerized FreeIPA for DNS.

Finally, I was ready to hook my containerized FreeIPA to oVirt's management engine, using the account `admin` and the `Secret123` password referenced above, before adding superuser privileges to the `ouser` account and restarting ovirt-engine for the new setup to take effect:

````
engine-manage-domains add --domain=example.test --user=admin --provider=ipa
engine-manage-domains edit --add-permissions --domain=example.test --user=ouser
service ovirt-engine restart
````

And there we have it, a containerized copy of FreeIPA to ride alongside the oVirt management engine, RPM conflicts be damned:

<img src="http://www.projectatomic.io/images/ovirt-freeipa-docker.png">

After playing with this long enough to get it working, I do think that this is a decent option for testing oVirt's various user permission-tied features in a lab setting, but it could use some smoothing-out before I could see using it more broadly. In particular, the way I used the container's internal IP address for the host machine DNS is brittle, since that IP changes at every boot. 

Also, since oVirt Engine and FreeIPA each expect to use port 443 for their web interfaces, I had to stick to accessing FreeIPA through the command line. 

If the engine also ran within a container, I could use Docker's linking functionality to deal with these changing IPs. Soon, I think I'll try to pick up on the [experiments others have begun](http://allthingsopen.com/2013/12/19/building-docker-images-on-fedora/) w/ oVirt Engine and Docker, and delve into running the hypervisor portion of the oVirt stack within a container as well, building on this recent howto on [running libvirtd within a container](http://www.projectatomic.io/blog/2014/10/libvirtd_in_containers/).
