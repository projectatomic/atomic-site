---
title: Introducing Image Metadata Labels for Software Vendors
author: aweiteka
date: 2015-09-23 14:12:22 UTC
tags: docker, atomic, labels
comments: true
published: true
---

Docker image metadata can be arbitrarily extended using the LABEL directive in a Dockerfile. This is a great way to annotate an image and enable automation:

* How to run or install an image
* Who built an image
* URLs for documentation or other support information

We've been encouraging the docker community to standardize these LABELs in an open source way through the [Container Application Generic Labels repository](https://github.com/projectatomic/ContainerApplicationGenericLabels/). Recent [pull requests](https://github.com/projectatomic/ContainerApplicationGenericLabels/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aclosed+author%3Aaweiteka+vendor) added a new vendor directory for software companies (or FOSS projects) to document metadata that is specific to their particular needs. 

As a point of reference, Red Hat released their [LABEL metadata](https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/labels.md) and [image naming policy](https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/names.md) to the community. This might be a useful reference for other folks building their own metadata.

Have metadata for your project? Just submit a pull request to help create documentation about metadata your tooling or application depends on. Have questions? Ask on the [atomic-devel](http://lists.projectatomic.io/mailman/listinfo/atomic-devel) mailing list, or create an issue in the GitHub repository.
