geard 
=====

geard is an opinionated tool for installing Docker images as containers onto a systemd-enabled Linux operating system (systemd 207 or newer). 

geard allows an administrator to easily ensure a given Docker container will *always* run on the system by creating a systemd unit describing a docker run command.  It will execute the Docker container processes as children of the systemd unit, allowing auto restart of the container, customization of additional namespace options, the capture stdout and stderr to journald, and audit/seccomp integration to those child processes.

Each created systemd unit can be assigned a unique Unix user for quota and security purposes.  An SELinux MCS category label will automatically be assigned to the container to separate it from the other containers on the system, and containers can be set into  systemd slices with resource constraints.

A container may also be optionally enabled for public key SSH access for a set of known keys under the user identifier associated with the container.  On SSH to the host, they'll join the running namespace for that container.

geard may be run as a command:

    $ sudo gear install pmorie/sti-html-app my-sample-service

to install the public image <code>pmorie/sti-html-app</code> to systemd on the local box with the service name "ctr-my-sample-service".  The command can also start as a daemon and serve API requests over HTTP (port 43273 is the default):

    $ sudo gear daemon
    2014/02/21 02:59:42 ports: searching block 41, 4000-4099
    2014/02/21 02:59:42 Starting HTTP on :43273 ...

You can also use the gear command against a remote daemon:

    $ gear stop localhost/my-sample-service
    $ gear install pmorie/sti-html-app localhost/my-sample-service.1 localhost/my-sample-service.2
    $ gear start localhost/my-sample-service.1 localhost/my-sample-service.2

The gear daemon and local commands must run as root to interface with the Docker daemon over its Unix socket and systemd over DBus.

geard exposes *primitives* for dealing with containers across hosts and is intended to work closely with a Docker installation - as the plugin system in Docker evolves, many of these primitives may move into plugins of Docker itself.

### What's a gear?

A gear is an isolated Linux container and is an evolution of the SELinux jails used in OpenShift.  For those familiar with Docker, it's a started container with some bound ports, some shared environment, some linking, some resource isolation and allocation, and some opionated defaults about configuration that ease use.  Here's some of those defaults:

**Gears are isolated from each other and the host, except where they're explicitly connected**

   By default, a container doesn't have access to the host system processes or files, except where an administrator explicitly chooses, just like Docker.

**Gears are portable across hosts**

   A gear, like a Docker image, should be usable on many different hosts.  This means that the underlying Docker abstractions (links, port mappings, environment files) should be used to ensure the gear does not become dependent on the host system.  The system should make it easy to share environment and context between gears and move them among host systems.

**Systemd is in charge of starting and stopping gears and journald is in charge of log aggregation**

   A Linux container (Docker or not) is just a process.  No other process manager is as powerful or flexible as systemd, so it's only natural to depend on systemd to run processes and Docker to isolate them.  All of the flexibility of systemd should be available to customize gears, with reasonable defaults to make it easy to get started.

**By default, every gear is quota bound and security constrained**

   An isolated gear needs to minimize its impact on other gears in predictable ways.  Leveraging a host user id (uid) per gear allows the operating system to impose limits to file writes, and using SELinux MCS category labels ensures that processes and files in different gears are strongly separated.  An administrator might choose to share some of these limits, but by default enforcing them is good.

   A consequence of per gear uids is that each container can be placed in its own user namespace - the users within the container might be defined by the image creator, but the system sees a consistent user.

**The default network configuration of a container is simple**

   By default a container will have 0..N ports exposed and the system will automatically allocate those ports.  An admin may choose to override or change those mappings at runtime, or apply rules to the system that are applied each time a new gear is added.  Much of the linking between containers is done over the network or the upcoming Beam constructs in Docker.


### Actions on a container

Here are the initial set of supported container actions - these should map cleanly to Docker, systemd, or a very simple combination of the two.  Geard unifies the services, but does not reinterpret them.

*   Create a new system unit file that runs a single docker image (install and start a container)

        $ gear install pmorie/sti-html-app localhost/my-sample-service --start
        $ curl -X PUT "http://localhost:43273/container/my-sample-service" -H "Content-Type: application/json" -d '{"Image": "pmorie/sti-html-app", "Started":true}'

*   Stop, start, and restart a container

        $ gear stop localhost/my-sample-service
        $ curl -X PUT "http://localhost:43273/container/my-sample-service/stopped"
        $ gear start localhost/my-sample-service
        $ curl -X PUT "http://localhost:43273/container/my-sample-service/started"
        $ gear restart localhost/my-sample-service
        $ curl -X POST "http://localhost:43273/container/my-sample-service/restart"

*   Deploy a set of containers on one or more systems, with links between them:

        # create a simple two container web app
        $ gear deploy deployment/fixtures/simple_deploy.json localhost

    The links between containers are iptables based rules - try curling 127.0.0.1:8081 to see the second web container.

        # create a mongo db replica set (some assembly required)
        $ gear deploy deployment/fixtures/mongo_deploy.json localhost
        $ sudo switchns --container=db-1 -- /bin/bash
        > mongo 192.168.1.1
        MongoDB shell version: 2.4.9
        > rs.initiate({_id: "replica0", version: 1, members:[{_id: 0, host:"192.168.1.1:27017"}]})
        > rs.add("192.168.1.2")
        > rs.add("192.168.1.3")
        > rs.status()
        # wait....
        > rs.status()

    The argument to initiate() sets the correct hostname for the first member, otherwise the other members cannot connect.

*   View the systemd status of a container

        $ gear status localhost/my-sample-service
        $ curl "http://localhost:43273/container/my-sample-service/status"

*   Tail the logs for a container (will end after 30 seconds)

        $ curl "http://localhost:43273/container/my-sample-service/log"

*   List all installed containers (for one or more servers)

        $ gear list-units localhost
        $ curl "http://localhost:43273/containers"

*   Create a new empty Git repository

        $ curl -X PUT "http://localhost:43273/repository/my-sample-repo"

*   Link containers with local loopback ports (for e.g. 127.0.0.2:8081 -> 9.8.23.14:8080). If local ip isn't specified, it defaults to 127.0.0.1

        $ gear link -n=127.0.0.2:8081:9.8.23.14:8080 localhost/my-sample-service

*   Set a public key as enabling SSH or Git SSH access to a container or repository (respectively)

        $ gear keys --key-file=[FILE] my-sample-service
        $ curl -X POST "http://localhost:43273/keys" -H "Content-Type: application/json" -d '{"Keys": [{"Type":"authorized_keys","Value":"ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=="}], "Containers": [{"Id": "my-sample-service"}]}'

*   Enable SSH access to join a container for a set of authorized keys (requires 'gear install --isolate')

        TODO: add fixture public and private key for example

*   Build a new image from a source URL and base image

        $ curl -X POST "http://localhost:43273/build-image" -H "Content-Type: application/json" -d '{"BaseImage":"pmorie/fedora-mock","Source":"git://github.com/pmorie/simple-html","Tag":"mybuild-1"}'

*   Fetch a Git archive zip for a repository

        $ curl "http://localhost:43273/repository/my-sample-repo/archive/master"

*   Set and retrieve environment files for sharing between containers (patch and pull operations)

        $ gear set-env localhost/my-sample-service A=B B=C
        $ gear env localhost/my-sample-service
        $ curl "http://localhost:43273/environment/my-sample-service"
        $ gear set-env localhost/my-sample-service --reset

    You can set environment during installation

        $ gear install ccoleman/envtest localhost/env-test1 --env-file=deployment/fixtures/simple.env

    Loading environment into a running container is dependent on the "docker run --env-file" option in Docker master from 0.9.x after April 1st.  You must start the daemon with "gear daemon --has-env-file" in order to use the option - this option will be made the default after 0.9.1 lands and the minimal requirements will be updated.

Note: foreground execution is currently not in Docker master - see https://github.com/alexlarsson/docker/tree/forking-run for some prototype work demonstrating the concept.


