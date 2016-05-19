---
title: Introducing Commissaire
author: smilner
date: 2016-05-19 12:00:00 UTC
published: true
comments: true
tags: commissaire, management, kubernetes, openshift
---

What the heck is commissaire? I'm glad you asked! Commissaire is a new
component of Project Atomic that aims to simplify life for cluster
administrators.  It provides a simple, script-friendly REST interface
for cluster-wide maintenance operations like system upgrades and
rolling restarts.

Instead of starting from scratch, Commissaire utilizes common
technologies such as Ansible for communicating with cluster nodes, and
interfaces with OpenShift and Kubernetes.

![Architecture](http://commissaire.readthedocs.io/en/latest/_images/commissaire-flow-diagram.png)

### Current Features:

* [Simple REST interface](http://commissaire.readthedocs.io/en/latest/endpoints.html)
* [Plug-in based authentication
framework](http://commissaire.readthedocs.io/en/latest/authentication_devel.html)
* [Restart hosts in a container
cluster](http://commissaire.readthedocs.io/en/latest/operations.html#restart)
* [Upgrade hosts in a container
cluster](http://commissaire.readthedocs.io/en/latest/operations.html#upgrade)
* [Bootstrap new hosts into an existing
cluster](http://commissaire.readthedocs.io/en/latest/operations.html#bootstrapping)
* [Command line interface](https://github.com/projectatomic/commctl)

# Running The Service

If you are curious to give the current development source a try check
out the [Manual
Installation](http://commissaire.readthedocs.io/en/latest/gettingstarted.html)
instructions

### Getting Involved
The project is still young, making it a great time to get involved and
help shape the service. Everyone is welcome to give ideas, feedback,
patches or just come say hi! For more information on contributing code
see [Development
Setup](http://commissaire.readthedocs.io/en/latest/development.html#development-setup)

* **Freenode IRC**: #atomic
* **Email List**: atomic-devel@projectatomic.io
* [Commissaire source](https://github.com/projectatomic/commissaire)
* [Commctl Source](https://github.com/projectatomic/commctl)
* [Documentation](http://commissaire.readthedocs.io/en/latest/index.html)
