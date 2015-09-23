---
title: Introducing Image Metadata Labels for Software Vendors
author: aweiteka
date: 2015-09-15 19:11:07 UTC
tags: docker, atomic, labels
published: false
comments: true
---

Docker image metadata can be arbitrarily extended using the LABEL directive in a Dockerfile. This is a great way to annotate an image and enable automation:
* How to run or install an image
* Who built an image
* URLs for documentation or other support information

We've been encouraging the docker community to standardize these LABELs in an open source way through the [Container Application Generic Labels repository](https://github.com/projectatomic/ContainerApplicationGenericLabels/). Recent [pull requests](https://github.com/projectatomic/ContainerApplicationGenericLabels/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aclosed+author%3Aaweiteka+vendor) added a new vendor directory for software companies to document metadata that is specific to their particular needs. As a point of reference, Red Hat released their [LABEL metadata](https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/labels.md) and [image naming policy](https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/names.md) to the community.

Software companies may submit a pull request creating documentation about metadata their tooling or application depends on.
