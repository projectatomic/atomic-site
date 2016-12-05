---
title: 'Installing an OpenShift Origin Cluster on Fedora 25 Atomic Host: Part 1'
author: dustymabe
date: 2016-12-07 15:23:32 UTC
tags: fedora, atomic, origin, openshift, kubernetes
published: true
comments: true
---

Introduction
============

[Openshift Origin](https://github.com/openshift/origin) is the upstream
project that builds on top of the Kubernetes platform and feeds into the
OpenShift Container Platform product that is available from Red Hat today.
Origin is a great way to get started with Kubernetes, and what better
place to run a container orchestration layer than on top of Fedora
Atomic Host?

We recently released [Fedora
25](https://fedoramagazine.org/fedora-25-released/), along with the
first biweekly release of Fedora 25 Atomic Host. This blog post
will show you the basics for getting a production installation of Origin
running on Fedora 25 Atomic Host using the [OpenShift Ansible
Installer](https://github.com/openshift/openshift-ansible). The
OpenShift Ansible installer will allow you to install a
production-worthy OpenShift cluster. If you'd like to just
try out OpenShift on a single node instead, you can set up OpenShift with
the `oc cluster up` command, which we will detail in a later blog
post.

This first post will cover just the installation. In a later blog post
we'll take the system we just installed for a spin and make sure
everything is working as expected.

Environment
===========

We've tried to make this setup as generic as possible. In this case we
will be targeting three generic servers that are running Fedora 25
Atomic Host. As is common with cloud environments these servers each
have an "internal" private address that can't be accessed from the
internet, as well as a public NATed address that can be accessed from
the outside. Here is the identifying information for the three servers:

|    Role     |  Public IPv4   | Private IPv4 |
|-------------|----------------|--------------|
| master,etcd | 54.175.0.44    | 10.0.173.101 |
| worker      | 52.91.115.81   | 10.0.156.20  |
| worker      | 54.204.208.138 | 10.0.251.101 |

**NOTE** In a real production setup we would want mutiple master
nodes and multiple etcd nodes closer to what is shown in the 
[installation docs](https://docs.openshift.org/latest/install_config/install/advanced_install.html#multiple-masters).

As you can see from the table we've marked one of the nodes as the master
and the other two as what we're calling *worker nodes*. The master node
will run the api server, scheduler and, controller manager. We'll also
run etcd on it. Since we want to make sure we don't starve the node running
etcd, we'll mark the master node as **unschedulable** so that
application containers don't get scheduled to run on it.

The other two nodes, the worker nodes, will have the proxy and the
kubelet running on them; this is where the containers (inside of pods)
will get scheduled to run. We'll also tell the installer to run a
registry and an HAProxy router on the two worker nodes so that we can
perform builds as well as access our services from the outside world via
HAProxy.

The Installer
=============

[Openshift Origin](https://github.com/openshift/origin) uses
[Ansible](https://www.ansible.com/) to manage the installation of
different nodes in a cluster. The code for this is aggregated in the
[OpenShift Ansible
Installer](https://github.com/openshift/openshift-ansible) on GitHub.
Additionally, to run the installer we'll need to
[install Ansible](http://docs.ansible.com/ansible/intro_installation.html#installing-the-control-machine)
on our workstation or laptop.

**NOTE** At this time Ansible 2.2 or greater is **REQUIRED**.

We already have Ansible installed so we can skip to cloning the repo:

    $ git clone https://github.com/openshift/openshift-ansible.git &>/dev/null
    $ cd openshift-ansible/
    $ git checkout 734b9ae199bd585d24c5131f3403345fe88fe5e6
    Previous HEAD position was 6d2a272... Merge pull request #2884 from sdodson/image-stream-sync
    HEAD is now at 734b9ae... Merge pull request #2876 from dustymabe/dusty-fix-etcd-selinux

In order to document this better in this blog post we are specifically
checking out commit `734b9ae199bd585d24c5131f3403345fe88fe5e6` so that
we can get reproducible results, since the Openshift Ansible project
is fast-moving. These instructions will probably work on the latest
master, but you may hit a bug, in which case you should open an issue.

Now that we have the installer we can create an inventory file called
`myinventory` in the same directory as the git repo. This inventory
file can be anywhere, but for this install we'll place it there.

Using the IP information from the table above we create the following
inventory file:

    # Create an OSEv3 group that contains the masters and nodes groups
    [OSEv3:children]
    masters
    nodes
    etcd

    # Set variables common for all OSEv3 hosts
    [OSEv3:vars]
    ansible_user=fedora
    ansible_become=true
    deployment_type=origin
    containerized=true
    openshift_release=v1.3.1
    openshift_router_selector='router=true'
    openshift_registry_selector='registry=true'
    openshift_master_default_subdomain=54.204.208.138.xip.io

    # enable htpasswd auth
    openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
    openshift_master_htpasswd_users={'admin': '$apr1$zgSjCrLt$1KSuj66CggeWSv.D.BXOA1', 'user': '$apr1$.gw8w9i1$ln9bfTRiD6OwuNTG5LvW50'}

    # host group for masters
    [masters]
    54.175.0.44 openshift_public_hostname=54.175.0.44 openshift_hostname=10.0.173.101

    # host group for etcd, should run on a node that is not schedulable
    [etcd]
    54.175.0.44

    # host group for worker nodes, we list master node here so that
    # openshift-sdn gets installed. We mark the master node as not
    # schedulable.
    [nodes]
    54.175.0.44    openshift_hostname=10.0.173.101 openshift_schedulable=false
    52.91.115.81   openshift_hostname=10.0.156.20  openshift_node_labels="{'router':'true','registry':'true'}"
    54.204.208.138 openshift_hostname=10.0.251.101 openshift_node_labels="{'router':'true','registry':'true'}"

Well that is quite a bit to digest isn't it? Don't worry, we'll break
down this file in detail.

Details of the Inventory File
=============================

OK, so how did we create this inventory file? We started with [the
docs](https://docs.openshift.org/latest/install_config/install/advanced_install.html)
and copied one of the examples from there. This type of install we are
doing is called a **BYO** (Bring Your Own) install because we are
bringing our own servers and not having the installer contact a cloud
provider to bring up the infrastructure for us. For reference there is
also a much more detailed [BYO inventory
file](https://github.com/openshift/openshift-ansible/blob/master/inventory/byo/hosts.ose.example)
you can study.

So let's break down our inventory file. First we have the `OSEv3` group
and list the hosts in the `masters`, `nodes`, and `etcd` groups as
children of that group:

    # Create an OSEv3 group that contains the masters and nodes groups
    [OSEv3:children]
    masters
    nodes
    etcd

Then we set a bunch of variables for that group:

    # Set variables common for all OSEv3 hosts
    [OSEv3:vars]
    ansible_user=fedora
    ansible_become=true
    deployment_type=origin
    containerized=true
    openshift_release=v1.3.1
    openshift_router_selector='router=true'
    openshift_registry_selector='registry=true'
    openshift_master_default_subdomain=54.204.208.138.xip.io

Let's run through each of them:

-   `ansible_user=fedora` - `fedora` is the user that you use to connect
    to Fedora 25 Atomic Host.
-   `ansible_become=true` - We want the installer to `sudo` when
    running commands.
-   `deployment_type=origin` - Run OpenShift Origin.
-   `containerized=true` - Run Origin from containers.
-   `openshift_release=v1.3.1` - The version of Origin to run.
-   `openshift_router_selector='router=true'` - Set it so that any nodes
    that have this label applied to them will run a router by default.
-   `openshift_registry_selector='registry=true'` - Set it so that any
    nodes that have this label applied to them will run a registry
    by default.
-   `openshift_master_default_subdomain=54.204.208.138.xip.io` - This
    setting is used to tell OpenShift what subdomain to apply to routes
    that are created when exposing services to the outside world.

Whew.. Quite a bit to run through there! Most of them are relatively
self explanatory but the `openshift_master_default_subdomain` might need
a little more explanation. Basically the value of this needs to be a
[Wildcard DNS Record](https://en.wikipedia.org/wiki/Wildcard_DNS_record)
so that any domain can be prefixed onto the front of the record and it
will still resolve to the same IP address. We have decided to use a free
service called [xip.io](http://xip.io/) so that we don't have to set up
wildcard DNS just for this example.

So for our example, a domain like `app1.54.204.208.138.xip.io` will
resolve to IP address `54.204.208.138`. A domain like
`app2.54.204.208.138.xip.io` will also resolve to that same address.
These requests will come in to node `54.204.208.138`, which is one of
our worker nodes where a *router* (HAProxy) is running. HAProxy will
route the traffic based on the domain used (`app1` vs `app2`, etc) to
the appropriate service within OpenShift.

OK, next up in our inventory file we have some auth settings:

    # enable htpasswd auth
    openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
    openshift_master_htpasswd_users={'admin': '$apr1$zgSjCrLt$1KSuj66CggeWSv.D.BXOA1', 'user': '$apr1$.gw8w9i1$ln9bfTRiD6OwuNTG5LvW50'}

You can use a [multitude of authentication
providers](https://docs.openshift.com/enterprise/3.0/admin_guide/configuring_authentication.html)
with OpenShift. The above statements say that we want to use `htpasswd`
for authentication and we want to create two users. The password for the
`admin` user is `OriginAdmin`, while the password for the `user` user is
`OriginUser`. We generated these passwords by running `htpasswd` on the
command line like so:

    $ htpasswd -bc /dev/stdout admin OriginAdmin
    Adding password for admin user
    admin:$apr1$zgSjCrLt$1KSuj66CggeWSv.D.BXOA1
    $ htpasswd -bc /dev/stdout user OriginUser
    Adding password for user user
    user:$apr1$.gw8w9i1$ln9bfTRiD6OwuNTG5LvW50

OK, now on to the host groups. First up, our `master` nodes:

    # host group for masters
    [masters]
    54.175.0.44 openshift_public_hostname=54.175.0.44 openshift_hostname=10.0.173.101

We have used `54.175.0.44` as the hostname and also set
`openshift_public_hostname` to this same value so that certificates will
use that hostname rather than a *detected* hostname. We're also setting
`openshift_hostname=10.0.173.101` because there is a
[bug](https://github.com/golang/go/issues/17967) where the golang
resolver can't resolve `*.ec2.internal` addresses. This is also
documented as an
[issue](https://github.com/openshift/origin/issues/11962) against
Origin. Once this bug is resolved, you won't have to set
`openshift_hostname`.

Next up we have the `etcd` host group. We're simply re-using the master
node for a single etcd node. In a production deployment, we'd have
several:

    # host group for etcd, should run on a node that is not schedulable
    [etcd]
    54.175.0.44

Finally, we have our worker nodes:

    # host group for worker nodes, we list master node here so that
    # openshift-sdn gets installed. We mark the master node as not
    # schedulable.
    [nodes]
    54.175.0.44    openshift_hostname=10.0.173.101 openshift_schedulable=false
    52.91.115.81   openshift_hostname=10.0.156.20  openshift_node_labels="{'router':'true','registry':'true'}"
    54.204.208.138 openshift_hostname=10.0.251.101 openshift_node_labels="{'router':'true','registry':'true'}"

We include the master node in this group so that the `openshift-sdn`
will get installed and run there. However we do set the master node as
`openshift_schedulable=false` because it is running `etcd`. The last two
nodes are our worker nodes and we have also added the `router=true` and
`registry=true` node labels to them so that the registry and the router
will run on them.

Executing the Installer
=======================

Now that we have the installer code and the inventory file named
`myinventory` in the same directory, let's see if we can ping our hosts
and check their state:

    $ ansible -i myinventory nodes -a '/usr/bin/rpm-ostree status'
    54.175.0.44 | SUCCESS | rc=0 >>
    State: idle
    Deployments:
    ● fedora-atomic:fedora-atomic/25/x86_64/docker-host
           Version: 25.42 (2016-11-16 10:26:30)
            Commit: c91f4c671a6a1f6770a0f186398f256abf40b2a91562bb2880285df4f574cde4
            OSName: fedora-atomic

    54.204.208.138 | SUCCESS | rc=0 >>
    State: idle
    Deployments:
    ● fedora-atomic:fedora-atomic/25/x86_64/docker-host
           Version: 25.42 (2016-11-16 10:26:30)
            Commit: c91f4c671a6a1f6770a0f186398f256abf40b2a91562bb2880285df4f574cde4
            OSName: fedora-atomic

    52.91.115.81 | SUCCESS | rc=0 >>
    State: idle
    Deployments:
    ● fedora-atomic:fedora-atomic/25/x86_64/docker-host
           Version: 25.42 (2016-11-16 10:26:30)
            Commit: c91f4c671a6a1f6770a0f186398f256abf40b2a91562bb2880285df4f574cde4
            OSName: fedora-atomic

Looks like they are up and all at the same state. The next step is to
unleash the installer. Before we do we should note that Fedora has moved
to python3 by default. While Atomic Host still has python2 installed
for legacy package support not all of the modules needed by the installer are
supported in python2 on Atomic Host. Thus, we'll forge ahead and use python3 as the
interpreter for ansible by specifying
`-e 'ansible_python_interpreter=/usr/bin/python3'` on the command line:

    $ ansible-playbook -i myinventory playbooks/byo/config.yml -e 'ansible_python_interpreter=/usr/bin/python3'
    Using /etc/ansible/ansible.cfg as config file
    ....
    ....
    PLAY RECAP *********************************************************************
    52.91.115.81               : ok=162  changed=49   unreachable=0    failed=0   
    54.175.0.44                : ok=540  changed=150  unreachable=0    failed=0   
    54.204.208.138             : ok=159  changed=49   unreachable=0    failed=0   
    localhost                  : ok=15   changed=9    unreachable=0    failed=0

We snipped pretty much all of the output. You can download the log
file in its entirety from [here](/images/2016-12-07_origin-install-output.txt.gz).

So now the installer has run, and our systems should be up and running.
There is only one more thing we have to do before we can take this
system for a spin.

We created two users `user` and `admin`. Currently there is no way to
have the installer associate one of these users with the *cluster admin*
role in OpenShift (we opened a
[request](https://github.com/openshift/openshift-ansible/issues/2877)
for that). We must run a command to associate the `admin` user we
created with cluster admin role for the cluster. The command is
`oadm policy add-cluster-role-to-user cluster-admin admin`.

We'll go ahead and run that command now on the master node via
`ansible`:

    $ ansible -i myinventory masters -a '/usr/local/bin/oadm policy add-cluster-role-to-user cluster-admin admin'
    54.175.0.44 | SUCCESS | rc=0 >>

And now we are ready to log in as either the `admin` or `user` users
using `oc login https://54.175.0.44:8443` from the command line or
visiting the web frontend at `https://54.175.0.44:8443`.

**NOTE** To install the `oc` CLI tool follow [these instructions](https://docs.openshift.org/latest/cli_reference/get_started_cli.html#installing-the-cli)

To Be Continued
===============

In this blog we brought up an OpenShift Origin cluster on three servers
that were running Fedora 25 Atomic Host. We reviewed the inventory file
in detail to explain exactly what options were used and why. In a future
blog post we'll take the system for a spin and inspect some of the
running system that was generated from the installer and also spin up an
application that will run on and be hosted by the Origin cluster.

Cheers!

Dusty
