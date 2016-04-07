---
title: Developing with Mesos-Marathon provider on Atomic Developer Bundle (ADB)
author: dharmit
date: 2016-04-07
layout: post
comments: true
published: true
categories:
- Blog
tags:
- mesos
- marathon
- vagrant
- developer tools
- atomic developer bundle
---

Since the 1.6.0 release, the [Atomic Developer Bundle
(ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle)
includes support for Mesos-Marathon as an orchestrator. This is in conjunction
with the support for Mesos-Marathon that was added to
[Atomic App](https://github.com/projectatomic/atomicapp) 0.3.0. This feature
supports developers choosing to work with atomicapps on Mesos-Marathon.

Mesos Marathon is a distributed control system which can be used for container
orchestration in large server clusters.  Some Docker-based infrastructure teams
use Mesos instead of Kubernetes. Learn more here:

- [Mesos](http://mesos.apache.org/)
- [Marathon](http://mesosphere.github.io/marathon/)

READMORE

### Starting the Vagrant box

A [Vagrantfile](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/components/centos/centos-mesos-marathon-singlenode-setup/Vagrantfile)
has been created that will use the ADB and provision it with a fully setup and
configured single node Mesos-Marathon installation.

One can either clone the ADB repo to use this setup or download only the
Vagrantfile and Ansible playbook. To avoid any errors, it'd be best to clone
the repo and spin up the vagrant box:

~~~
$ git clone https://github.com/projectatomic/adb-atomic-developer-bundle/
$ cd adb-atomic-developer-bundle/components/centos/centos-mesos-marathon-singlenode-setup/
$ vagrant up
~~~

If you need help with setting up Vagrant or a virtualization provider, refer
[this
document](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/docs/installing.rst).

Note that when you do `vagrant up`, the [Ansible
playbook](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/components/centos/centos-mesos-marathon-singlenode-setup/provisioning/playbook.yml),
used to do the provisioning, downloads certain packages from the Internet.
Hence, the time for box to get ready for use is directly dependent on your
Internet connection. It pulls around 130 MB from the Internet.

### Developing on the box

This section focuses on running containerized applications in the newly created
Mesos-Marathon box with the help of
[Atomic App](http://www.projectatomic.io/docs/atomicapp/).

#### Install Atomic App

Since the current ADB release doesn't have the latest version of Atomic App, we
want to install it. The Atomic App [installation
section](https://github.com/projectatomic/atomicapp#installing-atomic-app) on
its GitHub repo explains how to install the current release.

#### Setup Mesos-DNS

In this example, I am using Mesos-DNS as a service discovery mechanism for
Mesos. However, you can use any tool of your choice and code your application
accordingly.

To setup Mesos-DNS, download the binary from its
[releases](https://github.com/mesosphere/mesos-dns/releases) page. Copy it to a
location in the `$PATH` variable or modify the `$PATH` variable - whatever is
convenient to you. I copied to /usr/bin/:

~~~
$ sudo yum -y install wget bind-utils    # we'll need bind-utils for dig
$ wget https://github.com/mesosphere/mesos-dns/releases/download/v0.5.1/mesos-dns-v0.5.1-linux-amd64
$ sudo mv mesos-dns-v0.5.1-linux-amd64 /usr/bin/mesos-dns
$ sudo chmod +x /usr/bin/mesos-dns
~~~

Create a directory under `/etc` to store configuartion for Mesos-DNS. And create
a file `config.json` under it with contents like below:

~~~
$ sudo mkdir /etc/mesos-dns
$ cat /etc/mesos-dns/config.json
{
    "zk": "zk://10.0.2.2:2181/mesos",
    "refreshSeconds": 60,
    "ttl": 60,
    "domain": "mesos",
    "port": 53,
    "resolvers": ["8.8.8.8"],
    "timeout": 5,
    "listener": "10.2.2.2",
    "httpon": true,
    "httpport": 8123

}
~~~

Replace 10.0.2.2 in above output to the IP of your vagrant box. This IP is of
the system on which ZooKeeper is running.

Next, start Mesos-DNS from the command line or using Marathon. Mesos-DNS
documentation suggests to use Marathon as it'll ensure that the Mesos-DNS
service is restarted in event of any failure. I prefer checking from the
command line before deploying it using Marathon.

~~~
$ sudo mesos-dns -config=/etc/mesos-dns/config.json
~~~

If Mesos-DNS was deployed successfully, you should be able to make DNS lookups
using it as your server. Make sure to edit your `/etc/resolv.conf` to have the IP
of system running Mesos-DNS as the first entry for nameserver:

~~~
$ cat /etc/resolv.conf
nameserver 10.2.2.2
nameserver 8.8.8.8
~~~

Now you can perform DNS lookups:

~~~
$ dig marathon.mesos
$ dig mesos-dns.marathon.mesos
$ dig master.mesos
$ dig slave.mesos
~~~

All of the above lookups will be answered by Mesos-DNS if the setup is correct.

#### Deploy a Flask + Redis based page visit counter app

This is an atomic app based on the Nulecule specification that creates a 2-tier
application based on Flask and Redis. Every time you access the web page, a
message is displayed which indicates the number of times the web page was
accessed. And this counter is incremented upon each access.

To make this example work, make sure that Mesos-DNS is configured. The IP
address of the server hosting Mesos-DNS needs to be the first nameserver entry
in `/etc/resolv.conf` file. This makes it the primary DNS server. Related
documentation [link](http://mesosphere.github.io/mesos-dns/docs/#slave-setup).

For the Redis container in this repo, go ahead and create a directory
`/opt/redis` on the Vagrant box. This is for the sake of persistence. Also,
you need to apply below SELinux context to `/opt/redis` on the host:

~~~
$ sudo mkdir /opt/redis
$ sudo chcon -Rt svirt_sandbox_file_t /opt/redis
~~~

With that setup in place, you can simply do:

~~~
$ atomicapp run --provider=marathon dharmit/flask_redis
~~~

Above command will download three Docker images:

1. Image containing information about our Nulecule'ized application
2. Flask Docker image
3. Redis Docker image

The repository containing the code for this Flask application can be found on
this [link](https://github.com/dharmit/flask_redis_nulecule_app).

#### Checking the application

If all went well, Marathon web UI or `docker ps` on the shell should give you
information about the port on the Vagrant box that's mapped to the port 5000
inside the Flask container. In my case it was 31364.

~~~
$ curl localhost:31364
<div align=center><img src='https://pbs.twimg.com/profile_images/458352291767013376/K9nN_rhH_400x400.png'><h1>This page has been visited 1 times!</h1><br></div>
~~~

Please share feedback about your experience with the process of setting up
Mesos-Marathon provider on ADB. You can do this by engaging with developrs on
`#nulecule` IRC channel on Freenode or open an issue under [ADB repo on
github](https://github.com/projectatomic/adb-atomic-developer-bundle).
