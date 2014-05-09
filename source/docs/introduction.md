# Introduction to Project Atomic

Project Atomic facilitates application-centric IT architecture by providing an end-to-end solution for deploying containerized applications quickly and reliably, with "atomic" update and rollback functionality for application and host alike.

The core of Project Atomic is the Project Atomic Host. This is a lightweight operating system that has been assembled out of upstream RPM content. It is designed to run applications in Docker containers. Hosts based on Red Hat Enterprise Linux and Fedora are currently available. Hosts based on CentOS will be available soon.

Project Atomic hosts inherit the full features and advantages of their base distributions. This includes systemd, which provides container-dependency management and fault recovery. It also includes journald, which provides secure aggregation and attribution of container logs. Project Atomic builds on these features, using the following components, which have been tailored for containerized-application management:

* [Docker](https://www.docker.io/), an open-source project for creating lightweight, portable, self-sufficient application containers.
* [rpm-OSTree](http://rpm-ostree.cloud.fedoraproject.org/#/), an open-source tool for managing bootable, immutable, versioned filesystem trees from upstream RPM content.
* [systemd](http://www.freedesktop.org/wiki/Software/systemd/), an open-source system and service manager for Linux.
* [geard](https://github.com/smarterclayton/geard), an open-source project for installing and linking Docker containers into systemd, and for coordinating those Docker containers across hosts.  geard is the core of the next-generation of OpenShift.

## How Can Project Atomic Help Me?

* The traditional enterprise model with a single runtime environment controlled by the operating system and shared by all applications does not meet the requirements of modern application-centric IT.
* The complexity of the software stack, the amount of different stacks, and the speed of change have overwhelmed the ability of a single monolithic stack to deliver in a consistent way.
* Developer/DevOps-led shops seek control over the runtime underneath their applications, without necessarily owning the entire stack.
* Virtual machines provide a means for separation among applications, but this model adds significant resource and management overhead.

Slimming down the host with the Atomic distribution limits the surface area and patch frequency for administrators.  Docker containers offer developers and administrators a clear path to delivering consistent and fully tested stacks from development to production.  Containers secured with Linux namespaces, cGroups, and SELinux provide isolation close to that of a virtual machine, with much greater flexibility and efficiency.  Additionally, simple and easy-to-use tools like geard and Cockpit provide cross-cluster capabilities for deploying and managing applications.
