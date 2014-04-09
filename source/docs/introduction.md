# Introduction to Project Atomic

Project Atomic facilitates application-centric IT architecture by providing an end-to-end solution for deploying containerized applications quickly and reliably, with "atomic" update and rollback for application and host alike.

The core of Project Atomic is the Project Atomic Controller. This is a lightweight operating system that has been assembled out of upstream RPM content. It isdesigned to run applications in Docker containers. Controllers based on Red Hat Enterprise Linux and Fedora are available now. Controllers based on CentOS will be available soon. 
 
Project Atomic controllers inherit the full features and advantages of their base distributions. This includes systemd, which provides container-dependency managment and fault recovery. It also includes journald, which provides secure aggregation and attribution of container logs. Project Atomic builds on these features, using the following components, which have been tailored for containerized-application management:

* [Docker](https://www.docker.io/), an open-source project for creating lightweight, portable, self-sufficient application containers. 
* [geard](https://github.com/smarterclayton/geard), an open-source project for installing and linking Docker containers into systemd, and for coordinating those Docker containers across hosts.  geard is the core of the next-generation of OpenShift.
* [rpm-OSTree](http://rpm-ostree.cloud.fedoraproject.org/#/), an open-source tool for managing bootable, immutable, versioned filesystem trees from upstream RPM content. 
* [systemd](http://www.freedesktop.org/wiki/Software/systemd/), an open-source system and service manager for Linux. 

## Understanding Atomic Updates
