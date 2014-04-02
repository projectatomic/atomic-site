# Introduction to Project Atomic

Project Atomic facilitates application-centric IT architecture by providing an end-to-end solution for deploying containerized applications quickly and reliably, with "atomic" update and rollback for application and host alike.

At the core of the project is the Project Atomic Controller, a lightweight operating system assembled from upstream RPM content and designed to run applications in Docker containers. Controllers based on Red Hat Enterprise Linux or Fedora are available now, with CentOS-based Controllers available soon. 

Project Atomic controllers inherit the full features and advantages of their base distributions, such as systemd for managing container dependencies and fault recovery, and journald for secure aggregation and attribution of container logs. Project Atomic builds on these features with components tailored to managing containerized applications:

* [Docker](https://www.docker.io/), an open-source project to easily create lightweight, portable, self-sufficient containers from any application. 
* [geard](https://github.com/smarterclayton/geard), a client and daemon for installing and linking Docker containers into systemd and coordinating those across hosts.  geard is the core of the next-generation of OpenShift.
* [rpm-OSTree](http://rpm-ostree.cloud.fedoraproject.org/#/), a tool for managing bootable, immutable, versioned filesystem trees from upstream RPM content. 
* [systemd](http://www.freedesktop.org/wiki/Software/systemd/), a system and service manager for Linux. 

## Understanding Atomic Updates


