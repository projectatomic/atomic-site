---
title: Contribute to the Atomic Host Documentation!
author: trishnag
date: 2017-04-10 22:00:00 UTC
published: true
comments: true
tags: atomic, docs, atomic host, contributions
---

[Project Atomic](http://www.projectatomic.io/) is changing rapidly and documentation needs to follow the pace of development.  That's why we need your help!

The new documentation is going to be maintained through the [Atomic-host-docs](https://github.com/projectatomic/atomic-host-docs) repository, which uses
AsciiDoc as markup language and AsciiBinder to build the documentation pages. More importantly, AsciiBinder will allow us to produce both Fedora Atomic
and CentOS Atomic documentation from the same source repository using a concept called "distros."

Our plans for the documentation include a complete revamp of the current pages, per [our outline](https://github.com/projectatomic/atomic-host-docs/blob/master/outline.txt) in the repo.  The Atomic Host docs should eventually completely cover installation and setup, quickstarts for trying it out, deployment of Kubernetes and/or OpenShift clusters, and how to compose your own OStrees and deployment.

That's where you come in.  We need help writing docs, and converting docs and blog posts from other sources into the new documentation structure.  Read further for how to set up for a doc build.

READMORE

## Requirements:

* [AsciiDoc](http://asciidoctor.org/docs/what-is-asciidoc/#what-is-asciidoc) markup language to write Docs.
* [Asciidoctor](http://asciidoctor.org/) that acts as text processor to convert AsciiDoc content to HTML5, DocBook and others.
* [AsciiBinder](http://www.asciibinder.org/) that helps to build, maintain documentation in easier way.


## Set up Development Environment:

The following steps clones the repository, creates a development environment, and installs required libraries/packages
on your local system which are required in order to write/build the documentation.  

```
$ sudo yum/dnf install ansible
$ git clone https://github.com/projectatomic/atomic-host-docs.git
$ cd atomic-host-docs/
$ git checkout -b branchname
$ ansible-playbook setup.yml --ask-sudo-pass
```

(some Fedora users may also need to install python2-dnf for the playbook to run)

## How to Write Docs:

Atomic Host Documentation uses the AsciiDoc markup language. You can have a look at the
[Reference](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference) for AsciiDoc Syntax.

The following example demonstrates how to write and build it:

```
$ mkdir container
$ touch container/overview.adoc
```

*container/overview.adoc*

```
[[container-overview]]
= Container Overview
{product-author}
{product-version}
:data-uri:
:icons:

Linux Containers have emerged as a key open source application packaging and delivery technology, combining lightweight application isolation with the flexibility of image-based deployment methods.

I love Containers!!!
```

After the Doc is ready, we need to make entry in *_topic_map.yml* file. This file tells AsciiBinder which topic groups and topics to generate.

*_topic_map.yml*

```
---
Name: Tools
Dir: container
Topics:
  - Name: Overview
    File: overview
```

Now go to the root directory of the repo. The following command will build the docs:

```
$ asciibinder
```

## Verify:

A new directory will be created named *_preview*, where you will be able to browse the documentation you just built.

Here's how our example would look after a doc build:

![Contribution Guide Demo](/images/doc-build-screenshot.png)


## Join and Help:

If you are looking to contribute to Atomic Host Docs, take a look at our list of [needs doc tickets]( https://github.com/projectatomic/atomic-host-docs/issues).

You can ask questions and collaborate on Github, or over email and IRC:

* [Atomic User List](http://lists.projectatomic.io/mailman/listinfo/atomic)
* [Atomic Developer List](http://lists.projectatomic.io/mailman/listinfo/atomic-devel)

IRC: #atomic and #fedora-cloud on Freenode server.

## More to Come

We're working on CI/CD for documentation deployment and an all-new documentation site.  Once that's built, all regular doc contributors will be able to push changes directly to the documentation build pipeline.  And, of course, the pipeline will use containerized tools running on Atomic Host!
