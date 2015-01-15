---
title: Deploying a Containerized Gitlab Instance with Kubernetes
author: jbrooks
date: 2015-01-15 23:42:33 UTC
tags: docker, kubernetes, centos, gitlab
published: false
comments: true
---

Back in November, I wrote about how to [try out Kubernetes](http://www.projectatomic.io/blog/2014/11/testing-kubernetes-with-an-atomic-host/), the open source system for managing containerized applications across multiple hosts, using Atomic Hosts. In that post, I walked through a deployment of the Kubernetes project's multicontainer "Hello World" application. 

This time, I thought I'd explore running a more real-world application on Kubernetes, while looking into a few alternate methods of spinning up a Kubernetes cluster.

For the application, I picked Gitlab, an open source code collaboration platform that resembles and works like the popular Github service. I run a Gitlab instance internally here at work, and I wanted to explore moving that application from its current, virtual machine-based home, toward a shiny new containerized future.

READMORE

### Gitlab, Dockerized
The Gitlab project [provides a Dockerfile](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/docker) for creating a containerized "Omnibus" instance of the application that smushes together a Redis key-value store, Postgres database, and Nginx web server into a single container. However, since Docker best practices dictate that individual application elements be deployed as separate containers, I turned to a [multi-container installation option](https://github.com/sameersbn/docker-gitlab) created by community member [Sameer Naik](https://twitter.com/sameersbn).

I set out first to convert Sameer's implementation from Ubuntu to [CentOS](https://github.com/jasonbrooks/docker-gitlab), which wasn't too terribly complicated and mostly involved translating Debian-style package names to their RPM-world equivalents. The trickiest bits of the conversion involved editing the bash scripts used to install Gitlab from source and perform configuration chores in the Gitlab container. Looking ahead, I'm interested in taking a look at Ansible as an alternative to these somewhat-ungainly bash scripts.

For the Redis and Postgres containers required by Gitlab, I simply reached for a pair of off-the-shelf Dockerfiles provided by the CentOS project in its [CentOS-Dockerfiles](https://github.com/CentOS/CentOS-Dockerfiles) repository.

### Assembling a Kubernetes Cluster

Once I had a Dockerized, CentOS-based set of containers to work with, I turned to bringing up a Kubernetes cluster. The [Ansible+Atomic method](http://www.projectatomic.io/blog/2014/11/testing-kubernetes-with-an-atomic-host/) I wrote about last time still works fine, but I wanted to explore a couple other Kubernetes deployment options.

I looked into three new methods for turning up a Kubernetes cluster: [Vagrant](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/vagrant.md), [OpenStack Heat](https://github.com/larsks/heat-kubernetes), and Google's [Container Engine](https://cloud.google.com/container-engine/).

I didn't manage to get a cluster up and running with Vagrant, at least not with my chosen provider of libvirt. The scripts that ship with Kubernetes for Vagrant are hard-coded to the VirtualBox provider. I typically test within a KVM environment, and while nesting KVM within KVM works well, VirtualBox within KVM does not, and I wasn't interested in parting with a bare metal machine for this test. In any case, I stumbled across about [running Vagrant with libvirt on Fedora](http://blog.obnox.de/vagrant-with-lxc-and-libvirt-on-fedora/) that I expect will come in handy soon.

If you're a VirtualBox+Vagrant adherent, though, this looks like a pretty easy way to get up and running with a test cluster.

Getting Kubernetes running with OpenStack Heat was pretty simple, after I ensured that I'd outfitted my OpenStack cloud not only with Heat itself, but also the Heat CloudWatch API, on which this stack depends. Also, in order to use Atomic Host instances for my master and minions, I had to create a snapshot of a [Fedora Atomic](https://getfedora.org/en/cloud/download/) or [CentOS Atomic](http://buildlogs.centos.org/monthly/7/) instance on which I'd run `sudo atomic upgrade`, as this Heat stack requires the recently-added Flannel for networking.

From there, I needed only clone the [heat-kubernetes](https://github.com/larsks/heat-kubernetes) repository, create a `local.yaml` file corresponding to my environment, and run `heat stack-create -f kubecluster.yaml -e local.yaml my-kube-cluster` to kick off the stack.

If you don't have an OpenStack cloud handy, it's pretty simple to spin up a new Kubernetes cluster via Google's [Container Engine](https://cloud.google.com/container-engine/), which automates the creation of a set of VMs running Debian and hosting the necessary bits for Kubernetes' master and minions.

### Deploying Gitlab

With a Kubernetes cluster of our choice ready for action, the steps required to start up an instance of Gitlab are pretty similar to those for the Kubernetes "Hello World" guestbook application.

First, clone my [docker-gitlab](https://github.com/jasonbrooks/docker-gitlab) repository:

````
git clone https://github.com/jasonbrooks/docker-gitlab.git
````

Alongside the Dockerfile for Gitlab, and a set of scripts and files required for building that container, this repository contains a set of Kubernetes json files for defining the pods and services for gitlab, redis and postgresql.

I've pushed containers for redis, postgresql and gitlab to the Docker hub under my user name, jasonbooks, but you can follow the build instructions in the repo's README to build and push your own containers, if you wish. Just swap out `jasonbrooks` for your own registry location in the "pod" json files to use the containers you've built. You can also edit the json files to choose a new database password.

Kick off the commands below to get redis and postgresql running. It's important to start these up before starting gitlab, because pods are only aware of the environment variables of previously-started pods, and this is how gitlab will figure out where its database and key value store can be found:

````
kubectl --server=http://KUBE_MASTER:8080 create -f redis-pod.json 
kubectl --server=http://KUBE_MASTER:8080 create -f redis-service.json 
kubectl --server=http://KUBE_MASTER:8080 create -f postgres-pod.json 
kubectl --server=http://KUBE_MASTER:8080 create -f postgres-service.json
````

Then, monitor `kubectl --server=http://KUBE_MASTER:8080 get pods` until the redis and postgresql pods are `Running`:

````
NAME                IMAGE(S)               HOST                LABELS              STATUS
redis               jasonbrooks/redis      10.0.0.4/           name=redis          Running
postgresql          jasonbrooks/postgres   10.0.0.4/           name=postgresql     Running
````

Now, start up the Gitlab pod:

````
kubectl --server=http://KUBE_MASTER:8080 create -f gitlab-pod.json
````

After another run of `kubectl --server=http://KUBE_MASTER:8080 get pods` indicates that the gitlab pod is running, you can monitor the initialization of gitlab with the command `kubectl --server=http://KUBE_MASTER:8080 log gitlab`. When the logs indicate that `sidekiq`, `unicorn`, `cron`, `nginx`, and `sshd` are up and running, you should be able to access the Gitlab web interface from port 10080 on your minion, and Gitlab's ssh from port 10022.

Now, minions can change, and we probably prefer to stick with the default ports 80 and 22 for web and ssh. Here's where the service files for Gitlab come into play. We need more than one service file for our Gitlab pod because each service can only handle a single port (for now, at least).

You can edit the files `gitlab-service-http.json` and `gitlab-service-ssh.json` and replace `STATIC_IP_HERE` with a static IP of your choice. Then, fire off a couple of commands to create the services:

````
kubectl --server=http://KUBE_MASTER:8080 create -f gitlab-service-ssh.json
kubectl --server=http://KUBE_MASTER:8080 create -f gitlab-service-http.json
````

To make this actually work, you'll need to figure out a mechanism for sending traffic directed toward your static IP to your minions. On GCE, which offers a built-in load balancer feature, I set a forwarding rule to send traffic for ports 22-80 to my pool of minions. I imagine I could configure OpenStack and its [load balancer-as-a-service](http://docs.openstack.org/api/openstack-network/2.0/content/lbaas_ext.html) to perform the same task, but I haven't tried that out yet.


### Next Steps

So, am I ready to ditch my virtual machine for a fancy new Docker/Kubernetes based Gitlab installation? Not quite yet. I have a few more areas to understand, so keep an eye out for an upcoming blog post that covers these and other issues:

* Data persistence w/ Kubernetes -- this appears to be a matter of referencing volumes in the pod definition files
* Work out an application migration and update strategy
* Settle on load-balancing tooling and configuration
* Clean up my gitlab container configuration scripts, probably with Ansible

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. Ping me at jbrooks in #atomic on freenode irc or [@jasonbrooks](https://twitter.com/jasonbrooks) on Twitter. Also, be sure to check out the [Project Atomic Q&A site](http://ask.projectatomic.io/en/questions/).
