---
author: dwalsh
layout: post 
comments: true
title: "Yet Another Reason Containers Don't Contain: Kernel Keyrings"
date: 2014-09-15 17:39 UTC
tags:
- SELinux
- Kernel
- Security
- Docker
categories:
- Blog
---
I see people rushing to set up Web sites and PaaS Servers that allow random people to upload Docker container images, and I feel like I am the voice in the wilderness. Remember, containers do not contain!
 
## Containers Do Not Contain
 
As I stated in [my posts](http://opensource.com/business/14/7/docker-security-selinux) [on OpenSource.com](https://opensource.com/business/14/9/security-for-docker), not all of the operating system is namespaced. Parts that are not namespaced can potentially allow containers to attack each other, or the host, or at the very least will allow leakage of information into the containers.
 
## Another Example  
 
I got a [Bugzilla report on an SELinux issue](https://bugzilla.redhat.com/show_bug.cgi?id=1138601) about one container attempting to use the kernel keyring of another container. Kernel keyrings are separated based on UID. That means there is one kernel keyring for root.  
 
The kernel's keyring is **not** namespaced.
 
By Default in RHEL7 and Fedora 20/21 Kerberos is storing the credential cache, KEYS, in the kernel keyring.
 
This means that if root in one container attempts to contact Kerberos and stores its keys in the kernel keyring, the other containers can look at the content, **only** if you have disabled SELinux. (And I have heard that some of you do!)
 
If you have not disabled SELinux, the second container will not be allowed to use the keyring, meaning that Kerberos will break in the second container.
 
Sadly if you create a keyring as root on the host then this will leak into any container you have running on in the future.  And this keyring potentially would not be blocked by SELinux.
 
This is a bigger problem than just root using containers.  If you wanted to set up multiple Apache services each running within a container, they would run as UID=60, but only one UID=60 kernel keyring would exist.  This means these would have all of the same problems.  
 
What other parts of the kernel are we going to see this problem?  I don't know, but I figure they're out there. Abstract namespaces would be my guess at a probable problem.
 
Remember, we are just in our infancy of building these container environments. Let's crawl before we walk.
