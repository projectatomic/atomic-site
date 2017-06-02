---
title: Containerizing open-vm-tools – Part 1: The Dockerfile and constructing a systemd unit file
author: dphillips
date: 2017-03-23 16:00:00 UTC
published: true
comments: true
tags: atomic, fedora, vmware
---
This post was originally published on Red Hat Developers, the community to learn, code, and share faster. To read the original post, click ["here"] (https://developers.redhat.com/blog/2017/03/23/containerizing-open-vm-tools-part-1-the-dockerfile-and-constructing-a-systemd-unit-file/).

While validating OpenShift Container Platform on a VMware platform the usage of Atomic OS was also a requirement. In the
initial reference architecture, the decision was made to use Red Hat Enterprise Linux as the platform. This platform was then customized and
the same packages as in Atomic was installed via Ansible and Red Hat Network. The github repo with those playbooks are ["here"]
(https://github.com/openshift/openshift-ansible-contrib/tree/master/reference-architecture/vmware-ansible).
These playbooks will guide you start to finish to deploying OCP on VMware vCenter utilizing RHEL 7.

The next step in the VMware platform was to prepare a Dockerfile that would suffice in providing the privileges required for VMware’s open-vm-tools
package. As per VMware’s ["github site"] (https://github.com/vmware/open-vm-tools) for open-vm-tools the package provides the following functionality:

* The ability to perform virtual machine power operations gracefully.
* Execution of VMware provided or user configured scripts in guests during various power operations.
* The ability to run programs, commands and file system operation in guests to enhance guest automation.
* Authentication for guest operations.
* Periodic collection of network, disk, and memory usage information from the guest.
* Generation of heartbeat from guests to hosts so VMwares HA solution can determine guests availability.
* Clock synchronization between guests and hosts or client desktops.
* Quiescing guest file systems to allow hosts to capture file-system-consistent guest snapshots.
* Execution of pre-freeze and post-thaw scripts while quiescing guest file systems.
* The ability to customize guest operating systems immediately after powering on virtual machines.
* Enabling shared folders between host and guest file systems on VMware Workstation and VMware Fusion.
* Copying and pasting text, graphics, and files between guests and hosts or client desktops.

Here is the Dockerfile:

```
FROM registry.access.redhat.com/rhel7.3

ENV SYSTEMD_IGNORE_CHROOT=1

RUN yum -y --disablerepo=\* --enablerepo=rhel-7-server-rpms install yum-utils && \
  yum-config-manager --disable \* && \
  yum-config-manager --enable rhel-7-server-rpms && \
  yum clean all

RUN yum -y install file open-vm-tools perl open-vm-tools-deploypkg net-tools iproute systemd util-linux && \
yum clean all

LABEL Version=1.0
LABEL Vendor="Red Hat" License=GPLv3

LABEL RUN="docker run  --privileged -v /proc/:/hostproc/ -v /sys/fs/cgroup:/sys/fs/cgroup  -v /var/log:/var/log -v /run/systemd:/run/systemd -v /sysroot:/sysroot -v=/var/lib/sss/pipes/:/var/lib/sss/pipes/:rw -v /etc/passwd:/etc/passwd -v /etc/shadow:/etc/shadow -v /tmp:/tmp:rw -v /etc/sysconfig:/etc/sysconfig:rw -v /etc/resolv.conf:/etc/resolv.conf:rw -v /etc/nsswitch.conf:/etc/nsswitch.conf:rw -v /etc/hosts:/etc/hosts:rw -v /etc/hostname:/etc/hostname:rw -v /etc/localtime:/etc/localtime:rw -v /etc/adjtime:/etc/adjtime --env container=docker --net=host  --pid=host IMAGE"

ADD service.template config.json /exports/

CMD /usr/bin/vmtoolsd
```

The yum install covers the packages required for both guest customization and for manipulation of the virtual machine via the container layer. The systemd package for instance is required to allow a reboot. The environment variable, SYSTEMD_IGNORE_CHROOT allows for the container to skip the chroot check for a reboot. The
customization initiates a reboot after the filesystem files are modified:
- /tmp - open-vm-tools extracts its perl customization scripts here
- /etc/sysconfig/ - This is where all of the network customization files are stored including: network, network-scripts, etc.
- /etc/resolv.conf - DNS configuration for the VM
- /etc/nsswitch.conf - The name server switch file allows for authentication against sssd, ldap, etc.
- /etc/hosts - local name resolution
- /etc/hostname - hostname configuration for RHEL 7.
- /etc/adjtime - Time configuration for systemd.  
- /etc/shadow and /etc/password - This allows open-vm-tools to authenticate as a local user on the running virtual machine.
- /var/lib/sss/pipes - This is for SSSD configurations.
- /var/log/ - Logging for guest customizations and other VMware debugging.

One of the missing files here is /etc/localtime. This particular file does not work with a bind mount as the link is flattened after the mount. This customization is accomplished via mounting the entire / filesystem into /host. Then the customization that sets time will require a small modification:

On the vCenter server: /usr/lib/vmware-vpx/imgcust/linux/imgcust-scripts/RedHatCustomization.pm
line number 542

```
 if(defined $ENV{'SYSTEMD_IGNORE_CHROOT'})
   {
     Utils::ExecuteCommand("ln -sf /usr/share/zoneinfo/$tz /host/etc/localtime");
   }
   else
   {
     Utils::ExecuteCommand("ln -sf /usr/share/zoneinfo/$tz /etc/localtime");
   }
```

There is an existing bugzilla for an update to VMware’s vCenter moving forward.

Once, the Dockerfile image has been built:

```
docker built —rm -t openvmtools
```

The container can be set to start automatically by adding a systemd unit file. The following file is modified from the system unit file installed with the open-vm-tools RPM.

```
vi /etc/systemd/system/vmtoolsd
[Unit]
Description=Service for virtual machines hosted on VMware
Documentation=http://github.com/vmware/open-vm-tools
ConditionVirtualization=vmware
Requires=docker.service
After=docker.service

[Service]
#ExecStart=/usr/bin/vmtoolsd
ExecStart=/usr/bin/docker run  --privileged -v /:/host -v /proc/:/hostproc/ -v /sys/fs/cgroup:/sys/fs/cgroup  -v /var/log:/var/log -v /run/systemd:/run/systemd -v /sysroot:/sysroot -v=/var/lib/sss/pipes/:/var/lib/sss/pipes/ -v /etc/passwd:/etc/passwd -v /etc/shadow:/etc/shadow -v /tmp:/tmp -v /etc/sysconfig:/etc/sysconfig -v /etc/resolv.conf:/etc/resolv.conf -v /etc/nsswitch.conf:/etc/nsswitch.conf -v /etc/hosts:/etc/hosts -v /etc/hostname:/etc/hostname -v /etc/adjtime:/etc/adjtime --env container=docker --net=host --pid=host  openvmtools
ExecStop=/usr/bin/docker stop -t openvmtools
TimeoutStopSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target

```

Now by enabling then systemd service you should be able to utilize open-vm-tools via a container in atomic.

```
systemctl enable vmtoolsd
systemctl start vmtoolsd
```

This concludes the first part of the containerizing open-vm-tools guide. In the next article, the requirements for utilizing this image as a runc system container will be discussed.

Containerizing open-vm-tools part 2: Turning the Docker image into a system container for consumption in Atomic
