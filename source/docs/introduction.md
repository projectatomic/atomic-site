# Introduction to Project Atomic

Project Atomic is an umbrella for many projects related to containers that tie together around [Kubernetes](http://kubernetes.io/).

The first building block of Project Atomic is the "Atomic Host", which
is a lightweight operating system that has been assembled out of
upstream RPM content.  It is designed to run applications in Docker
containers. Atomic Host versions based on CentOS and Fedora are
available, and there is also a downstream enterprise version in Red
Hat Enterprise Linux.

Currently, the host comes out of the box with
[Kubernetes](http://kubernetes.io/) at the core.  A goal however is to
move to a containerized Kubernetes installation, to more easily
support different versions on the same host, such as
[OpenShift v3](https://www.openshift.org/).  The Atomic Host also
comes with several Kubernetes utilites such as
[etcd](https://github.com/coreos/etcd) and
[flannel](https://github.com/coreos/flannel).

The host system is managed via
[rpm-ostree](http://www.projectatomic.io/docs/os-updates/), an open
source tool for managing bootable, immutable, versioned filesystem
trees from upstream RPM content.

Kubernetes uses [Docker](https://www.docker.io/), an open source
project for creating lightweight, portable, self-sufficient
application containers.

Finally, this and several other components are wrapped in the
[atomic](https://github.com/projectatomic/atomic) command which provides
a unified entrypoint.

## How Can Project Atomic Help Me?

* The traditional enterprise OS model with a single runtime environment controlled by the OS and shared by all applications does not meet the requirements of modern application-centric IT.
* The complexity of the software stack, the amount of different stacks, and the speed of change have overwhelmed the ability of a single monolithic stack to deliver in a consistent way.
* Developer/DevOps-led shops seek control over the runtime underneath their applications, without necessarily owning the entire stack.
* VMs provide a means for separation among applications, but this model adds significant resource and management overhead.

Slimming down the host with the Atomic distribution limits the surface area and patch frequency for administrators.  Docker containers offer developers and admins a clear path to delivering consistent and fully tested stacks from development to production.  Containers secured with Linux namespaces, cGroups, and SELinux give isolation close to that of a VM, with much greater flexibility and efficiency.  And simple, easy-to-use tools like Cockpit provide cross-cluster capabilities to deploy and manage applications.
