** Project Atomic has switched to using [Kubernetes](http://kubernetes.io/) for conainer management **
** The following should be considered deprecated and is left here for historical reference **


geard 
=====

geard is a command line client for installing [Docker](https://www.docker.io) images as containers onto a systemd-enabled Linux operating system (systemd 207 or newer).  It may be run as a command:

    $ sudo gear install pmorie/sti-html-app my-sample-service

to install the public image <code>pmorie/sti-html-app</code> to systemd on the local machine with the service name "ctr-my-sample-service".  The command can also start as a daemon and serve API requests over HTTP (default port 43273) :

    $ sudo gear daemon
    2014/02/21 02:59:42 ports: searching block 41, 4000-4099
    2014/02/21 02:59:42 Starting HTTP on :43273 ...

The `gear` CLI can connect to this agent:

    $ gear stop localhost/my-sample-service
    $ gear install pmorie/sti-html-app localhost/my-sample-service.1 localhost/my-sample-service.2
    $ gear start localhost/my-sample-service.1 localhost/my-sample-service.2

The geard agent exposes operations on containers needed for [large scale orchestration](https://github.com/openshift/geard/blob/master/docs/orchestrating_geard.md) in production environments, and tries to map those operations closely to the underlying concepts in Docker and systemd.  It supports linking containers into logical groups (applications) across multiple hosts with [iptables based local networking](https://github.com/openshift/geard/blob/master/docs/linking.md), shared environment files, and SSH access to containers.  It is also a test bed for prototyping related container services that may eventually exist as Docker plugins, such as routing, event notification, and efficient idling and network activation.

The gear daemon and local commands must run as root to interface with the Docker daemon over its Unix socket and systemd over DBus.

### To learn more about geard, visit https://openshift.github.io/geard.
