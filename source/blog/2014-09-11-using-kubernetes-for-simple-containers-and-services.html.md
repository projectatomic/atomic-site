---
author: jzb
comments: true
layout: post
title: Using Kubernetes for Simple Containers and Services
date: 2014-09-11 18:47 UTC
tags:
- Kubernetes
- MongoDB
- Docker
- AMQP Broker
- Pulp
- QPID
- Cluster
categories:
- Blog
---
Mark Lamourine is working on an excellent series of posts that demonstrate how you'd use [Kubernetes](https://github.com/GoogleCloudPlatform/kubernetes) to run services using Docker containers. The latest is [Kubernetes: Simple Containers and Services](http://cloud-mechanic.blogspot.com/2014/09/kubernetes-simple-containers-and.html).

The most recent post explores creating the subsidiary services for a [Pulp](http://www.pulpproject.org/) service within a Kubernetes cluster:

> As mentioned elsewhere, Kubernetes is a service which is designed to bind together a cluster of container hosts, which can be regular hosts running the etcd and kubelet daemons or they can be specialized images like Atomic or CoreOS.  They can be private or public services such as Google Cloud

> For Pulp, I need to place a MongoDB and a QPID container within a Kubernetes cluster and create the infrastructure so that clients can find it and connect to it.  For each of these I need to create a Kubernetes Service and a Pod (group of related containers).

Note that the latest post builds on this series:

* [Intro to Containerized Applications: Docker and Kubernetes](http://cloud-mechanic.blogspot.com/2014/08/intro-to-containerized-applications.html)
* [Docker: A simple service container example with MongoDB](http://cloud-mechanic.blogspot.com/2014/08/docker-simple-service-container-example.html)
* [Docker: A QPID Message Broker Container](http://cloud-mechanic.blogspot.com/2014/09/docker-qpid-message-broker-container.html)

Keep an eye on Mark's blog "[Under the Hood of Cloud Computing](http://cloud-mechanic.blogspot.com/) for future installments. 
