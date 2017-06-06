---
title: 6 Reasons why CRI-O is the best runtime for Kubernetes
author: runcom
date: 2017-06-06 11:00:00 UTC
comments: true
published: true
tags: kubernetes, containers, cri-o
---

**CRI-O** is a Kubernetes incubator project which is meant to provide an integration path between Open Containers Initiative (OCI) conformant runtimes and the kubelet. Specifically, it implements the Container Runtime Interface (CRI) using OCI conformant runtimes. CRI-O uses [runc](https://github.com/opencontainers/runc) as its default runtime to run Kubernetes pods. For more information you can read a brief introduction [here](https://www.projectatomic.io/blog/2017/02/crio-runtimes/).

Let’s look at the advantages of the CRI-O project.

**1. OPEN GOVERNANCE**

CRI-O is intended to be strictly _openly_ governed and operates under the Kubernetes community.  The shared interests of many collaborators in the container space are looking for stability and compatibility with an ideal of meritocracy.

**2. OPEN SOURCE**

We’d like to first quote [the kind words from Intel](https://github.com/kubernetes-incubator/cri-o/issues/332#issuecomment-275256700):

> It’s been very easy to get the right changes merged into [CRI-O], this is a truly open project.

I believe this quote illustrates that CRI-O exemplifies the spirit of open source development. Any contributor is welcome, we gratefully accept contributions from any other company or individual who wishes to add to the project.  This is clearly backed up by [our contributors statistics](https://github.com/kubernetes-incubator/cri-o/graphs/contributors).  Their contributions are more substantial than just committing “typo fixes” or “README changes”.

CRI-O is new and fast-moving.  We’d love and value your help and input on any aspect of the project.  If you feel brave enough I’d suggest heading over to [our issues list](https://github.com/kubernetes-incubator/cri-o/issues) and start tackling some of the open issues.

It's worth mentioning that, thanks to our_real_ open source spirit, we're also contributing back to Kubernetes and the CRI API by adding tests, fixing bugs and documentation.

**3. LEAN**

CRI-O is made of little pieces.  The ones you’ll see on your host will be: the **CRI-O server** and a small shim called **conmon**. We do not ship other binaries.  All other binaries come from different projects, all glued together to give you the best container runtime for Kubernetes.  Lean means our codebase is small and what that really means is that it’s _easily auditable for bugs_ as well as _providing a small attack surface_.

**4. STABLE**

CRI-O directly implements the Kubernetes Container Runtime Interface and the only supported user is meant to be Kubernetes.  CRI-O is entirely shaped around Kubernetes, you won’t ever see a feature being added if it isn’t strictly necessary for Kubernetes.

We do run upstream Kubernetes node-e2e tests and e2e tests before accepting _any_ patch.  If our CI isn’t green you must fix your code.  Test suites are also run before _any_ release.
In addition to the  Kubernetes tests, CRI-O has its own integration tests and the CRI-O development community is continually adding to them. Unlike other container runtimes meant to work with other container orchestrators, **CRI-O will block a release on any breakage of the Kubernetes test suites**. You read it right, we're going to block a release if it breaks Kubernetes.

By default, CRI-O runs containers with runc. **runc** is part of the Open Containers Initiative and is the de-facto standard for running containers on Linux.

**5. SECURE**

CRI-O is secure by default.  It implements every security feature needed by Kubernetes such as: SELinux, Apparmor, Seccomp, and added/dropped Capabilities.  **As OCI runtimes adds new security features CRI-O will take advantage of them. CRI-O will provide the necessary security for your container needs.**

However if your organization prefers the security provided by virtual machines, CRI-O
is still a very valid solution. CRI-O is the only CRI container runtime which can run virtual machines using [Intel Clear Containers](https://clearlinux.org/features/intel%C2%AE-clear-containers) technology as if they were containers.

If you don’t believe me, [watch the video](https://www.youtube.com/watch?v=gEBSCesjkvA).

**6. BORING!**

CRI-O relies on the Open Containers Initiative specifications for runtime and image, ensuring everything is standardized and _boring_.

I’m just kidding, CRI-O isn’t boring.  What it does instead is to focus on the overall Kubernetes experience when it comes to actually _running_ containers.  Freeing Kubernetes to just focus on _orchestrating_ containers from now on.

I’m very excited about the CRI-O project and look forward to working with you and the other CRI-O contributors to make this project even better.  I hope you can join our development community and please feel free to contact me or leave a reply to this post!  Grazie mille!
