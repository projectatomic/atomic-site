---
title: Contribute to Atomic Host Documentation
author: trishnag
date: 2017-04-07 18:00:00 UTC
published: true
comments: true
tags: atomic, doc, contribute
---

[Project Atomic](http://www.projectatomic.io/) is developing at fast pace and documentation needs to follow the pace of the developments.
The Documentation is going to be maintained on [Atomic-host-docs](https://github.com/projectatomic/atomic-host-docs) repository which uses
AsciiDoc as markup language and AsciiBinder to build the Documentation. Atomic Host Documentation will also support Fedora Atomic Documentation
and CentOS Atomic Documentation from within the same repository as AsciiBinder has ability to build Docs with multiple distros
and versions.


Atomic Host Documentation focuses on covering Docs required for Atomic Host Introduction, Installation,
Cluster set up with Kuberenetes/Openshift etc to how to compose, manage and deploy Atomic Host and its various application.


## Requirements:

* [AsciiDoc](http://asciidoctor.org/docs/what-is-asciidoc/#what-is-asciidoc) markup language to write Docs.
* [Asciidoctor](http://asciidoctor.org/) that acts as text processor to convert AsciiDoc content to HTML5, DocBook and others.
* [AsciiBinder](http://www.asciibinder.org/) that helps to build, maintain documentation in easier way.


## Set up Development Environment:

The following steps clone the repository, creates development environment: installs required libraries/packages
on your local system which are required in order to write/build Doc for Atomic Host.

```
$ sudo yum/dnf install ansible
$ git clone https://github.com/projectatomic/atomic-host-docs.git
$ cd atomic-host-docs/
$ git checkout -b branchname
$ ansible-playbook setup.yml --ask-sudo-pass
```


## How to Write Doc:

Atomic Host Documentation uses AsciiDoc markup language. You can have a look at the
[Reference](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference) for AsciiDoc Syntax.

The following procedure demonstrates how to write and build Doc.

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

Container contains applications in a way to keep itself isolated from the host system that it runs on and
container allows developer to package an application with all of it parts, such as libraries and other packages
it needs to run and ship it all as one package.
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

Now go to the root directory of the repo. The following command will build the Documentation.

```
$ asciibinder
```

## Verify:

A new directory will be created named *_preview*. You will be able to browse Documentation from there that you just build.


This is how it will look like after the Doc is build:

![Contribution Guide Demo](https://trishnag.files.wordpress.com/2017/03/contribution-guide-demo.png)


## Join and Help:

If you are looking forward to contribute to Atomic Host Docs, this URL contains the topics that is required to be documented: https://github.com/projectatomic/atomic-host-docs/issues.


## Mailing list and IRC:

* http://lists.projectatomic.io/mailman/listinfo/atomic
* http://lists.projectatomic.io/mailman/listinfo/atomic-devel

IRC: #atomic on Freenode server.
