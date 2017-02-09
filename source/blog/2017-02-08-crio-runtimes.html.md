---
title: CRI-O and Alternative Runtimes in Kubernetes
author: runcom
date: 2017-02-08 12:00:00 UTC
published: true
comments: true
tags: kubernetes, cri-o, containers, fedora, atomic
---

The introduction of the [Container Runtime Interface](https://github.com/kubernetes/kubernetes/blob/master/pkg/kubelet/api/v1alpha1/runtime/api.proto) in Kubernetes 1.5.0 as an alpha feature opens the door for plugging alternative [container runtimes](http://programmableinfrastructure.com/components/container-runtime/) in the [kubelet](https://kubernetes.io/docs/admin/kubelet/) more easily, instead of relying on the default docker runtime. Those new runtimes may include virtual machines based ones, such as runv and Clear Containers, or standard Linux containers runtimes like rkt.

READMORE

In stable Kubernetes, you can run your pods with Docker underneath by default, with the option to use rkt if you need to.
There was no easy way to plug new runtimes other than diving into the Kubernetes source code and hoping your shiny new runtime gets accepted as a patch.
However, the [OCI runtime specification](https://github.com/opencontainers/runtime-spec) helps to standardize how runtimes start and run your containers. That means, as long as your runtime follows the OCI runtime specification, there's a standardized way to run a container. In the Kubernetes land, that means the Container Runtime Interface can take advantage of OCI runtimes and allow to easily swap runtime without ever touching the source code.

Project Atomic contributors who work for Red Hat, together with contributors from many of the top Linux, open source and container companies, started working on [CRI-O](https://github.com/kubernetes-incubator/cri-o).
[Announced in September as &quot;ocid&quot;](https://www.redhat.com/en/about/blog/running-production-applications-containers-introducing-ocid), CRI-O is a new Kubernetes incubator project which is meant to provide an integration path between OCI conformant runtimes and the kubelet. Specifically, it implements the Container Runtime Interface (CRI) using OCI conformant runtimes.
CRI-O uses [runc](https://github.com/opencontainers/runc) as its default runtime to run Kubernetes pods.

The good news is you're not locked to runc. CRI-O supports any container runtime as long as it is conformant to the OCI runtime specification. Anyone can plug their favourite runtime according to their needs with little tweaks in CRI-O.

We worked with Intel engineers to give their OCI container runtime, [Clear Containers](https://clearlinux.org/features/intel%C2%AE-clear-containers), the ability to work seamlessly with CRI-O. [In their words](https://github.com/kubernetes-incubator/cri-o/issues/332#issuecomment-275256700):

"It's been very easy to get the right changes merged into [CRI-O], this is a truly open project.""

We're excited to have CRI-O and Clear Containers running together. I have created a small demo of this integration to show how the kubelet is seamlessly running pods with Clear Containers underneath:

<iframe width="960" height="720" src="https://www.youtube.com/watch?v=gEBSCesjkvA?rel=0" frameborder="0" allowfullscreen></iframe>
