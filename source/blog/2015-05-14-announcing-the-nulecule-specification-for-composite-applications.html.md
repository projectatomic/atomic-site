---
title: Announcing the Nulecule Specification for Composite Applications
author: johnmark
date: 2015-05-14 20:47:56 UTC
tags: nulecule, atomic, composite apps, docker, rkt
comments: true
published: true
---

**UPDATE: Nulecule and Atomic App are discontinued.**

Those of us in Project Atomic have been creating a platform-neutral specification, [called Nulecule](http://github.com/projectatomic/nulecule/) ([noo-le-kyul](http://simpsons.wikia.com/wiki/Made-up_words)), to help developers and admins build and launch composite, multi-container applications. You’ll find an excellent description of the problem and our solution at the [RHEL Blog](http://rhelblog.redhat.com/2015/05/15/the-atomic-app-concept-it-all-starts-when-a-nulecule-comes-out-of-its-nest/).

We’ve also created [Atomic App](http://github.com/projectatomic/atomicapp/) as a way to run these applications using the Nulecule spec. If you just want to dive in and do stuff, just follow those links and go crazy. Read on for more.

READMORE

![](/images/nulecule-diagram.png)

So why are we doing this? Containers are remaking the IT landscape, rapidly disrupting previously entrenched technologies. They’re great, except when they’re not, and anyone trying to do serious work with them will run up against serious roadblocks. But we can’t expect the container ecosystem to be well-defined yet given how recent its emergence has been. There are many gaps yet to be filled, but every challenge brings an opportunity. In this case, the opportunity is to get it right this time: building manageability into applications and creating a standardized approach that allows for easier configuration of scalable, composite applications.

In this iteration of remaking the IT landscape, the mantra to be followed is “MYSM”, which is to say “make your stuff manageable.” Linux and the other components that make up the LAMP stack enabled a massive ecosystem of open source software, but they were severely lacking in the manageability area, creating an opportunity for a variety of configuration management tools that compensated for gaps in the software. Java guys always shook their heads at LAMP developers, noting their lack of integration with management tooling. Unfortunately, experiencing the benefits of manageability that came with JMX and the ease of deployment of WAR files meant forcing oneself to learn Java frameworks. What was an open source developer to do?

One answer is to containerize applications, and isolate services so that you can build applications from components that can be updated and developed separately. However, while it’s relatively simple to manage single containers, multi-container applications become unwieldy to manage. That’s where Nulecule comes in.

Nulecule defines a pattern and model for packaging complex multi-container applications, referencing all their dependencies, including orchestration metadata, in a single container image for building, deploying, monitoring, and active management. Just create a container with a Nulecule file and the app will “just work.” In the Nulecule spec, you define orchestration providers, container locations and configuration parameters in a graph, and the Atomic App implementation will piece them together for you with the help of Kubernetes and Docker. The Nulecule specification supports aggregation of multiple composite applications, and it’s also container and orchestration agnostic, enabling the use of any container and orchestration engine.

**Nulecule Specification Highlights**

* Application description and context maintained within a single container through extensible metadata.
* Composable definition of complex applications through inheritance and composition of containers into a single, standards-based, portable description.
* Simplified dependency management for the most complex applications through a directed graph to reflect relationships.
* Container and orchestration engine agnostic, enabling the use of any container technology and/or orchestration technology.

We hope you find the specification, as well as our implementation and runtime, useful. If you do, let us know. If you find that there are limitations of the spec with respect to working on other implementations, we want to know about it. We want to create a solution for both developer tools creators as well as management frameworks. In an ideal world, Nulecule would be supported by both dev and ops-specific tooling, from Apache CloudStack, OpenStack, ManageIQ, and Ansible on the operations side, as well as VisualStudio, Docker Compose, OpenShift, and Eclipse on the developer front.

Given that there are now multiple popular container formats, orchestration engines, and policy management tools, we think it’s a good time to lay the groundwork for a common definition of composite applications and a common language to describe them. Obviously, there will be many implementations of multi-container application frameworks. If they speak a common language, it will make the lives of developers and operators much easier.

We have created a [few examples](https://github.com/projectatomic/nulecule/tree/master/examples) to help get you started. The first, and easiest, example is called '[helloapache](https://github.com/projectatomic/nulecule/tree/master/examples/helloapache/)'. It's a single pod based on the centos/httpd image, but you can use your own. You'll need to run this from a workstation that has the Atomic CLI and a kubectl client that can connect to a kubernetes master. Watch the [demo video](https://www.youtube.com/watch?v=3FOjZ4IuqTA).

For a more complex example, here’s one that shows deploying OpenStack using Docker as the sole provider and answerfile.conf to do an unattended install. Watch the [video here](https://www.youtube.com/watch?v=NGOnG8czBk0).

And here's another example that demonstrates a chained, composite application deployed with Atomic App, Docker and Kubernetes. Watch the [demo video here](http://youtu.be/DzO5k73I4IA).

We've come a long way on Nulecule in a short time, but there’s a lot more to do. We’re really excited about sharing the work we’ve done so far, and look forward to collaborating with the larger community to develop Nulecule and make deploying complex containerized applications easier.

Community conversations:

* IRC: #nulecule on freenode
* [GitHub repository for Nulecule](http://github.com/projectatomic/nulecule/)
* [GitHub repository for Atomic App](http://github.com/projectatomic/atomicapp/)
* [Container-tools mailing list](https://www.redhat.com/mailman/listinfo/container-tools)

Happy Nuleculing!
