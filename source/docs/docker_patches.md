---
title: "Docker Patches"
---

# List of patches to Docker

Project Atomic includes the development and maintenance of a number of patches to the docker daemon and related tools.

All of the patches that we ship are described in the README.md file on the appropriate branch of [our docker  repository](https://github.com/projectatomic/docker).  If you want to look at the patches for docker-1.12 you would look at [the docker-1.12 branch](https://github.com/projectatomic/docker/tree/docker-1.12).

Each time docker creates a new version, we create a new branch in projectatomic with the version name to match.  The current master is working on docker-1.13.  You can see the current patchset on [the 1.13 branch](https://github.com/projectatomic/docker/tree/docker-1.13).

Patch types are:

* Red Hat: support compatibility with Red Hat Enterprise Linux and related tools.
* Upstream: Patches which were, or will be, submitted to mainstream docker.  Some have been rejected and are being maintained by the Atomic team.
* Backports: Patches which backport fixes from later versions of docker to earlier ones.  

## Table of Patches

| Name               | Type               | PRs           | Status                      |
|--------------------|--------------------|---------------|-----------------------------|
| Add-RHEL-super-secrets-patch | Red Hat | [6075](https://github.com/docker/docker/pull/6075) | Maintaining |
| Add-add-registry-and-block-registry-options-to-docker | Upstream | [11991](https://github.com/docker/docker/pull/11991), [10411](https://github.com/docker/docker/pull/10411) | Rejected, Maintaining |
| Improved-searching-experience | Upstream | | Rejected, Maintaining |
| Add-dockerhooks-exec-custom-hooks-for-prestart/poststop-containers | Upstream | [17021](https://github.com/docker/docker/pull/17021) | Pending |
| Return-rpm-version-of-packages-in-docker-version | Red Hat | [14591](https://github.com/docker/docker/pull/14591) | Maintaining |
| rebase-distribution-specific-build | Upstream | [15364](https://github.com/docker/docker/pull/15364) | Pending |
| System-logging-for-docker-daemon-API-calls | Upstream | [14446](https://github.com/docker/docker/pull/14446) | Blocked |
| Audit-logging-support-for-daemon-API-calls | Upstream | [109](https://github.com/rhatdan/docker/pull/109) | Blocked |
| Add-volume-support-to-docker-build | Upstream | See Below | See Below |

Patches which have been accepted by upstream docker are not represented in this chart.

A list of backport patches will be added to this page later.

## Longer Patch Descriptions

Project Atomic is carrying a series of patches that we feel are required for our users or for our support engineering.

### Add-RHEL-super-secrets-patch.patch

This patch allows us to provide subscription management information from the host into containers for both `docker run` and `docker build`.  In order to get access to RHEL7 and RHEL6 content inside of a container via yum you need to use a subscription.  This patch allows the subscriptions to work inside the container.  The docker upstream thought this was too RHEL specific so told us to carry a patch.

* [6075](https://github.com/docker/docker/pull/6075)

Note: This is our oldest patch.  Other distributions, like [SuSe](https://github.com/SUSE/docker.mirror/commit/76a4eb2f2e79d1abec07dfe33cd99c3d7a4568c3),  are carrying similar patches to allow the hosts subscriptions to be used inside the container to update distribution specific content.

### Add-add-registry-and-block-registry-options-to-docker.patch

Users have been asking for us to provide a mechanism to allow additional registries to be specified in addition to docker.io.  We also want to have Red Hat Content available from our Registry by default. This patch allows users to customize the default registries available.  We believe this closely aligns with the way yum and apt currently work.  This patch also allows users to block images from registries.  Some users do not want software
to be accidentally pulled and run on a machine.  Some users also have no access to the internet and want to setup private registries to handle their content.

* [11991](https://github.com/docker/docker/pull/11991)
* [10411](https://github.com/docker/docker/pull/10411)

**Status**: Upstream docker does not like this patch set, because they want the **docker** experience to be the same everywhere.  If I do a `docker pull fedora`, I always get it from docker.io.  We and our customers do not agree, so we continue to carry this patch.  We prefer the yum/apt method for specifying registries.

### Improved-searching-experience.patch

Red Hat wants to allow users to search multiple registries as described above. This patch improves the search experience.

**Status**:  This patch actually works with the Add-add-registry-and-block-registry-options-to-docke.patch so we need to carry it also.

### Add-dockerhooks-exec-custom-hooks-for-prestart/poststop-containers.patch

With the addition of runc/hooks support we want to add a feature to allow third parties to run helper programs before a docker container gets started and just after the container finishes.

For example we want to add a RegisterMachine hook.

For systems that support systemd/RegisterMachine, this hook would register a machine to the machinectl.  machinectl could then list docker containers along with other virtualization environments like kvm, and systemd-nspawn containers. Over time we would want to implement other machinectl features to get docker containers better integrated into the system.
Another example of a hook  is a log agent that records when a container starts and stops and then sends a message to a monitoring station.

Dockerhooks reads the `/usr/libexec/oci/hooks.d` directory to search for hooks, if the directory exists docker will execute the executables in this directory via runc/libcontainer is using PreStart and PostStop.  It will also send the config.json file as the second parameter.

**Status**: We hope that the upstream docker will expose this feature just like it makes use of these hooks for setting up networking in containers.  So far they haven’t given users the option  to take advantage of these hooks.

* [17021](https://github.com/docker/docker/pull/17021)

### Return-rpm-version-of-packages-in-docker-version.patch

Red Hat Support wants to know the version of the rpm package that docker is running.  This patch allows the distribution to show the rpm version of the client and server using the `docker version` command.  The docker upstream was not interested in this patch. This patch only affects the `docker info` command.

* [14591](https://github.com/docker/docker/pull/14591)

**Status**:   Since this is distribution specific, docker has rejected the patch. But it is required for our support people to easily identify the client and server RPM of the patches in use, so we plan on carrying it.  This patch is also easy to maintain.

### rebase-distribution-specific-build.patch

Current upstream docker tests run totally on Debian.  We want to be able to make sure all tests run on platforms and containers we support.  This patch allows us to run distribution specific tests. This means that `make test` on RHEL7 will use RHEL7-based images for the test, and `make test` on Fedora will use Fedora-based images for the test.  The docker upstream was not crazy about the substitutions done in this patch, and the changes never show up in the version of the docker client/daemon that we ship.

* [15364](https://github.com/docker/docker/pull/15364)

**Status**: Up til now upstream docker does not like the way this works, not sure if there is a good way forward.   This patch set is really only for QA and does not change the way that docker works.

### System-logging-for-docker-daemon-API-calls.patch

Red Hat wants to log all access to the docker daemon.  This patch records all access to the docker daemon in syslog/journald.  Currently docker logs access in its event logs but these logs are not stored permanently and do not record critical information like loginuid to record which user created/started/stopped containers.  We will continue to work with the docker upstream to get this patch merged. The docker upstream indicates that they want to wait until the authentication patches get merged.

* [14446](https://github.com/docker/docker/pull/14446)

**Status**:  This patch is currently blocked because the docker CLI does not have anyway of authenticating the user doing the activity.  All docker currently logs when an activity happens is something like **root** started a container.  With this patch, we can actually log that **dwalsh** started a container, but this only works for local domain socket clients.  We are working with upstream on an [authentication patch](https://github.com/docker/docker/pull/20883) that can identify the user on the client initiating the action.  When/If that patch gets merged we will resubmit and attempt to get this patch merged.

### Audit-logging-support-for-daemon-API-calls.patch

This is a follow on patch to the previous syslog patch, to record all auditable events to the audit log.  We want to get `docker daemon` to some level of common criteria.  In order to do this administrator activity must be audited.

* [109](https://github.com/rhatdan/docker/pull/109)

**Status**: Similar to the System Logging patch, we need to wait for authentication patch gets merged before working this into docker upstream.

### Add-volume-support-to-docker-build.patch

This patch adds the ability to add bind mounts at build-time. This will be helpful in supporting builds with host files and secrets. The `--volume|-v flag` is added for this purpose. Trying to define a volume (ala docker run) errors out. Each bind mounts' mode will be read-only and it will preserve any SELinux label which was defined via the cli (`:[z,Z]`). Defining a read-write mode (`:rw`) will just print a warning in the build output and the actual mode will be
changed to read-only.

**Status**: Upstream docker has continuously blocked all efforts to support volumes in `docker build`.

These 2 below are open but no progress so far in years:

* [18603](https://github.com/docker/docker/issues/18603)
* [14080](https://github.com/docker/docker/issues/14080)

Closed proposals:

* [3949](https://github.com/docker/docker/issues/3949)
* [3156](https://github.com/docker/docker/issues/3156)
* [14251](https://github.com/docker/docker/issues/14251)

Up until now no satisfactory alternatives have arrived, but there are several projects working to build container images outside of docker, including [Ansible](http://docs.ansible.com/ansible/docker_image_module.html) and potentially [dockerramp](https://github.com/jlhawn/dockramp).
