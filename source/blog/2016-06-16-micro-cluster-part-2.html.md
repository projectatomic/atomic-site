---
title: Building a Sub-Atomic Cluster, Part 2
author: jberkus
date: 2016-06-16 12:43:00 UTC
tags: docker, atomic host, kubernetes, events
published: true
comments: true
---
I'm continuing to kit out the Sub-Atomic Cluster, in the process it's received some upgrades.  Thanks to John Hawley of the Minnowboard Project at Intel, I now have a nice power supply instead of the tangle of power strips, and in a couple days I'll also have more SSD storage.  You can see here that one node is in a nice blue metal case: that's Muon, which we'll be raffling off at [DockerCon](http://2016.dockercon.com/). Come by booth G14 to see the cluster and for a chance to win the Muon!

![picture of minnowboard cluster](https://photos.smugmug.com/Computers/ContanersContainersContainers/i-tpXMt68/0/M/IMG_20160615_181254-M.jpg)

While I'm waiting for those, though, I might as well get this set up as a proper Kubernetes cluster.  Ansible is my tool for doing this.

READMORE

One way to set up Kubernetes clusters&mdash;and the only way which has been specifically configured for Atomic&mdash;is [Kubernetes Ansible](https://github.com/kubernetes/contrib/tree/master/ansible).  I actually use [Jason Brooks' fork](https://github.com/jasonbrooks/contrib/tree/atomic/ansible), though, because there's a few Atomic-specific fixes in it.  

So, next I plugged my laptop into the Sub-Atomic Cluster router.  I logged into each host and did three things:

1. Added an SSH key for keyless auth as the "atomic" user
2. Started timesyncd
3. Started Cockpit

Step 2 is one of those things I learned the hard way.  Timesyncd isn't started by default on Fedora Atomic Host, and etcd and Kubernetes behave fairly badly if the hosts in the cluster show very different times.  In fact, Ansible config will fail.  [I have an issue open](https://fedorahosted.org/cloud/ticket/161) and this should get fixed in the future.  For now, the way you enable it is:

```
timedatectl set-ntp true
```

[Cockpit](http://cockpit-project.org/) is a terrific GUI for managing your Linux hosts and more.  In future posts, we'll talk about using Cockpit to manage Kubernetes; for now, it's useful to launch a cockpit instance to manage each host.  For example, I can use it to check which containers are running on one node:

![cockpit UI for containers](subatomic_host_cockpit_1.png)

The way to launch these is to call them using the `atomic` command:

```
atomic run cockpit/ws

/usr/bin/docker run -d --privileged --pid=host -v /:/host cockpit/ws /container/atomic-run --local-ssh
0ad2d2b10a1fdd7d1220920e9b0c594901885db85dda706a5404433da6f44e70
```

Now I'm ready to do Ansible.  Since there are a bunch of dependencies, I set up a container running Fedora 23.  I installed the Ansible 1.9 package because Kubernetes-ansible isn't up to current releases.  If you're using a Fedora 24 container, use [this COPR](https://copr.fedorainfracloud.org/coprs/jasonbrooks/ansible1.9.4/).  

After installing the other dependencies, I cloned Jason's repository in the container.  Next I had to configure it.  The first part of that was to create an inventory file:

```
emacs inventory

[masters]
192.168.1.100

[etcd]
192.168.1.100

[nodes]
192.168.1.101
192.168.1.102
192.168.1.103
192.168.1.104
```

As you can see, we've got a master and four kubelets, which are the four nodes.  We're setting up single-node etcd, which is not a production setup.  That's mostly because I'm waiting on my msata SSDs; I don't want to run etcd on a board which has only a microSD as storage, given the number of writes etcd does.  Once I have the new hardware, I'll be able to do an HA setup for Kubernetes.

I also had to make some changes to `group_vars/all.yml`:

```
ansible_ssh_user: atomic

...

# If a password is needed to sudo to root that password must be set here
ansible_sudo_pass: MY_SUDO_PASS
```

That is, since Ansible is going to be logging into hosts using a user with sudo, I need to give it that user and its password.  The rest of the defaults work pretty well for a demo cluster, so I'm going to accept them.  The main reason one would change anything would be to change the various networks in order to avoid conflicting with your local network, but I've already avoided that with a private router.

Now, I can run Ansible:

```
./setup.sh

PLAY [all] ********************************************************************

TASK: [pre-ansible | Get os_version from /etc/os-release] *********************
ok: [192.168.1.100]

...

PLAY RECAP ********************************************************************
192.168.1.100              : ok=280  changed=11   unreachable=0    failed=0   
192.168.1.101              : ok=170  changed=32   unreachable=0    failed=0   
192.168.1.102              : ok=170  changed=32   unreachable=0    failed=0   
192.168.1.103              : ok=170  changed=32   unreachable=0    failed=0   
192.168.1.104              : ok=170  changed=32   unreachable=0    failed=0   
```

If your output ends in the above, setup was successful.  If not, you'll need to scroll back through the output to see what failed.  My first time around, I got a bunch of "expired certificate" failures, which was caused by the timesyncd issue.

What Ansible just set up for me included the following:

* Kubernetes with SSL support
* Docker with Flannel network overlay
* Single-node etcd

Things it did not set up for me include:

* Docker registry
* Cockpit Kubernetes
* applications
* high availability

We'll get to those later.  For now, let's see how Kubernetes is doing:

```
-bash-4.3# kubectl get nodes
NAME       STATUS     AGE
electron   Ready      57s
muon       Ready      23s
neutron    Ready      1m
photon     Ready      2m
```

Looks good for now.  More later, or stop by the booth at [DockerCon](http://2016.dockercon.com/).
