---
comments: true
layout: post
author: jzb
title: CentOS Atomic Host SIG Proposed
date: 2014-06-30 16:16 UTC
tags:
- CentOS
- SIG
- Host
categories:
- Blog
---
<img src="http://www.projectatomic.io/images/centos-logo.png"> Today [we proposed a CentOS Atomic Host](http://lists.centos.org/pipermail/centos-devel/2014-June/011225.html) [Special Interest Group](http://wiki.centos.org/SpecialInterestGroup/) (SIG) on the CentOS Devel mailing list. Since Project Atomic isn't in the business of producing its own distribution, the idea is to work within the CentOS community to develop an Atomic Host based on CentOS. 

If you're interested in participating, the discussion about the SIG will take place on the [CentOS devel mailing list](http://lists.centos.org/mailman/listinfo/centos-devel). Work on the project will be coordinated on the [Atomic devel mailing list](https://lists.projectatomic.io/mailman/listinfo/atomic-devel). 

The next step for the proposal is to have it reviewed by the CentOS Board. The next board meeting is on July 9th, so we hope to have the SIG accepted at that time and make headway towards getting the first CentOS Atomic Host release out the door.

The full proposal is below. If you have comments, please raise them on the CentOS devel or Atomic devel mailing lists. 

READMORE

# Atomic Host SIG Proposal

The CentOS Atomic Host SIG will work on a CentOS-based Atomic Host image that provides a minimal image using rpm-ostree, as well as tools and documentation for users to create their own CentOS/Atomic images with custom package sets.

## Goals

* Ship a minimal CentOS Atomic Host that focuses on running Docker containers in production. 
* Provide ISO images installable with Anacona, and images suited for OpenStack, CloudStack, Amazon Web Services/Eucalyptus, and Google Compute Engine. 
* Provide tools and documentation that can be used to spin custom images from CentOS packages to be deployed with Atomic (rpm-ostree) tools. 
* Provide regular releases as underlying tools (e.g. rpm-ostree) advance, while maintaining stability for in-place upgrades. 
* Establish a time-based release cadence. 
* All code included in the Atomic image will be under an OSI-approved license. 
* Unless differentation is absolutely necessary, all packages common to CentOS core and CentOS Atomic will be identical. 

## Mailing List and Communication

Work for the CentOS Atomic image relevant to CentOS build systems, etc. will take place on centos-devel. Work related to upstream Atomic will take place on the Atomic mailing lists. 

Note that the Atomic community comprises efforts underway with CentOS, Fedora, and Red Hat Enterprise Linux, as well as upstreams like Docker and OpenShift (GearD) so discussions may span several communities and mailing lists.

## SIG Membership

The Atomic Host SIG will have a steering committee and committers. The steering committee will consist initially of Joe Brockmeier, Jason Brooks, Jim Perrin, Brian Proffitt, Greg DeKoenigsberg, and _________ (?). New committers and steering committee members are appointed by the steering committee. 

Committer privileges, once earned, do not expire unless revoked by the steering committee. 

The steering committee will appoint a chair to interface with the CentOS Board. 

## Meetings

The CentOS Atomic SIG will initially meet weekly until all pieces are in place for regular releases, then as needed.

## Roadmap and (Action) TODO List

* Define package set
* Establish builds for target environments (cloud deployments and bare metal)
* Define orchestration tool(s) for CentOS Atomic
* Establish test / QA processes
* Set long-term release cadence, upgrade policies

## Further Info

* Project Atomic (http://projectatomic.io)
* Fedora Atomic Initiative (http://rpm-ostree.cloud.fedoraproject.org/#/)



