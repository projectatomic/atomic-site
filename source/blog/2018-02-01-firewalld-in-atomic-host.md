---
title: 'Firewalld in Atomic Host'
author: dustymabe
date: 2018-02-01 18:00:00 UTC
tags: fedora, atomic
published: true
---

# TL;DR

Fedora Atomic Host (and derivatives) will now include the `firewalld`
package in the base OSTree that is tested, delivered, and released
every two weeks. Existing users should observe no change as it won't
be enabled by default.

# Firewalld in Atomic Host

In the past we have had requests to have `firewalld` in Atomic Host
to enable a better interface into firewall management for
administrators and management software. It turns out that if you have
lots of rules to manage, or even multiple pieces of software trying to
manage different sets of rules on a single system, then `iptables`
becomes a limitation pretty quickly.

Atomic Host users do have the ability to package layer `firewalld`,
but [live changes to the host](https://www.projectatomic.io/blog/2017/06/rpm-ostree-v2017.6-released/)
are currently experimental. Since rebooting during system provisioning
in certain environments is not desirable, and `firewalld` is
relatively small, the [Fedora Atomic Working Group](https://pagure.io/atomic-wg)
[decided](https://pagure.io/atomic-wg/issue/372) to include `firewalld` in the 
base OSTree. 

In order to not affect existing users the `firewalld` service will be
disabled by default. Existing users should observe no change in behavior.
Users who want to use `firewalld` can enable/start the service and start
using it immediately.

# Scenarios

So you're an existing or new user of Atomic Host. What does this mean
for you?

## I have Atomic Host systems that are already running:

You can `rpm-ostree upgrade` like normal. The new `firewalld` package
will be delivered as part of updates but won't be enabled so
you should see no change in functionality.

## I use the Atomic Host cloud/vagrant images to start new systems:

Nothing will change here. We 
[explicitly disable](https://pagure.io/fedora-kickstarts/blob/master/f/fedora-atomic.ks#_28-30)
the firewall in the cloud image kickstarts since cloud environments
typically have a higher level firewall mechanism, like security
groups.

## I install new systems interactively using the ISO:

You should be able to interactively install Atomic Host just fine.
`firewalld` will not be enabled by default.

## I install new systems using the ISO with a kickstart file:

In this case if you don't have a `firewall ...` line in the kickstart
file then you **need** to add one to say what you want to do. You have
three options:

1. `firewall --enable`
1. `firewall --disable`
1. `firewall --use-system-defaults`

The first two options are pretty clear. The last option is a little
more unclear. This option was actually added to 
[anaconda](https://github.com/rhinstaller/anaconda/pull/1271)
/
[pykickstart](https://github.com/rhinstaller/pykickstart/pull/203)
to enable us to ask anaconda to **leave the system defaults** in place
so that we could deliver a default 
[in the OSTree](https://pagure.io/fedora-atomic/pull-request/103)
and have Anaconda respect that default.


# Migrating a system to use firewalld

If you have booted a system and you want to configure it to use
firewalld then you can simply enable/start it using `systemctl`.
It's a good idea to also restart docker, which does some detection
on startup to determine what firewall management tool is used.
You can do this by either restarting the docker service or rebooting
your system so all services restart. 

```
# systemctl enable firewalld
# systemctl start firewalld
# systemctl restart docker
```

# Using firewalld with OpenShift Origin

If you want to use firewalld with OpenShift and you use the 
[OpenShift Ansible](https://github.com/openshift/openshift-ansible)
installer then you [can now](https://github.com/openshift/openshift-ansible/pull/6763)
set a few variables in your inventory file to tell the installer
you want it to use `firewalld` to manage the firewall. Here are
the few variables:


```
[OSEv3:vars]
os_firewall_use_firewalld=true
openshift_enable_unsupported_configurations=true
```
