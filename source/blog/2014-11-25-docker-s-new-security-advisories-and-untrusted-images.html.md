---
author: dwalsh
title: "Docker's New Security Advisories and Untrusted Images"
date: 2014-11-25 21:50 UTC
tags:
- CVE
- Security
- SELinux 
- Docker
categories:
- Blog
---
Docker has released two CVE's with the newest version (docker-1.3.2) regarding two privilege escalation flaws. They are only an issue when running untrusted images.

##Yawn!!!

I question whether they should be CVE's at all. People need to realize that installing a Docker image is the equivalent of installing an RPM or a Debian .deb package.

* If you install an RPM or Debian package from an untrusted source on your machine, then you should expect your machine will get owned.  
* If you install a Docker image from an untrusted source on your machine, then you should expect your machine will get owned.

My fear with these CVEs is that people will start to assume Docker is unsafe or full of vulnerabilties. Check out [this article](http://www.theregister.co.uk/2014/11/25/docker_vulnerabilities/) on The Register, for example.

Docker has to spend time working on fixing the vulnerabilities, and people will get the false sense of security that docker can install untrusted images securely. Of course as soon as a user starts a container on the untrusted image, who knows what is going to happen? If the container runs any code as root, your machine can be owned. Remember, [containers *do not* contain](http://opensource.com/business/14/7/docker-security-selinux).

## It's All About Trust

The bottom line here? Do not run untrusted Docker images. Treat a Docker image the same way you would treat other software you install on your machine. It should be from a source you trust. You should not blindly install software from a third party just to get the latest version of a project or to save a little time. 

To address this, [Red Hat is building a certification process for Docker images](http://www.redhat.com/en/about/press-releases/red-hat-announces-certification-for-containerized-applications-extends-customer-confidence-and-trust-to-the-cloud), similar to what we do for third party software.

For folks who are using Fedora or CentOS, make sure that you're getting your images from the official Fedora and CentOS Docker repositories or from repositories you trust &ndash; if you're using one of the many third-party images, you don't have a good way to confirm the origin of the software. Whether you're running Docker 1.3.2 or 1.0, untrusted containers are unsafe, period.
