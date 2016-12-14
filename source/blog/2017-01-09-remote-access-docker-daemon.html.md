---
title: Access Docker Daemon of Atomic Host remotely
author: trishnag, jberkus
date: 2017-01-09 14:00:00 UTC
published: true
comments: true
tags: atomic host, ansible, docker
---


This post will describe how to access [Docker](https://www.docker.com/) daemon of Atomic host remotely. Note that we are also going to secure the Docker daemon with TLS since we are connecting via Network.
Before you carry on with the following steps keep in mind that ANY process on the client that can access the TLS certs now has FULL root access on the server and can do anything it wants to do. Therefore we will want to give access of Docker daemon of server only to the specific client host that can be trusted.

TLS (Transport Layer Security) provides communication security over computer network. We will create client cert and server cert to secure our Docker daemon. OpenSSL package will be used to to create the cert keys for establishing TLS connection.

I am using [Fedora-Atomic](https://getfedora.org/en/atomic/) host as remote(Docker Daemon) and [workstation](https://getfedora.org/en/workstation/download/) as my local machine(Docker Client).

Thanks to [Chris Houseknecht](https://twitter.com/CHouseknecht) for writing an [Ansible](https://www.ansible.com/) role which creates all the certs required automatically, so that there is no need to issue openssl commands manually. Here is the Ansible role repository: [role-secure-docker-daemon](https://github.com/ansible/role-secure-docker-daemon). Clone it to your present working host.

```
$ mkdir docker-remote-access
$ cd docker-remote-accessi
$ git clone https://github.com/ansible/role-secure-docker-daemon.git
```

Create ansible config file, inventory and playbook file to setup Docker client, Docker Daemon and play the role.

```
$ touch ansible.cfg inventory remote-access.yml
$ ls
ansible.cfg  inventory  remote-access.yml role-secure-docker-daemon
```

Here is the Directory structure:

```
$ tree docker-remote-access/
docker-remote-access/
├── ansible.cfg
├── inventory
├── remote-access.yml
└── role-secure-docker-daemon
```

**ansible.cfg**:

```
$ vim ansible.cfg
[defaults]
inventory=inventory
```

**inventory**:

```
$ vim inventory
[daemonhost]
'IP_OF_ATOMIC_HOST' ansible_ssh_private_key_file='PRIVATE_KEY_FILE'
```

Replace **IP_OF_ATOMIC_HOST** in the inventory file with the IP of your Atomic host (Docker Daemon host) and **PRIVATE_KEY_FILE** with private key file on your local system.

**remote-access.yml**:

```
$ vim remote-access.yml
---
- name: Docker Client Set up
  hosts: daemonhost
  gather_facts: no
  tasks:
    - name: Make ~/.docker directory for docker certs
      local_action: file path='~/.docker' state='directory'

    - name: Add Environment variables to ~/.bashrc
      local_action: lineinfile dest='~/.bashrc' line='export DOCKER_TLS_VERIFY=1\nexport DOCKER_CERT_PATH=~/.docker/\nexport DOCKER_HOST=tcp://{{ inventory_hostname }}:2376\n' state='present'

    - name: Source ~/.bashrc file
      local_action: shell source ~/.bashrc

- name: Docker Daemon Set up
  hosts: daemonhost
  gather_facts: no
  remote_user: fedora
  become: yes
  become_method: sudo
  become_user: root
  roles:
    - role: role-secure-docker-daemon
      dds_host: "{{ inventory_hostname }}"
      dds_server_cert_path: /etc/docker
      dds_restart_docker: no
  tasks:
    - name: fetch ca.pem from daemon host
      fetch:
        src: /root/.docker/ca.pem
        dest: ~/.docker/
        fail_on_missing: yes
        flat: yes
    - name: fetch cert.pem from daemon host
      fetch:
        src: /root/.docker/cert.pem
        dest: ~/.docker/
        fail_on_missing: yes
        flat: yes
    - name: fetch key.pem from daemon host
      fetch:
        src: /root/.docker/key.pem
        dest: ~/.docker/
        fail_on_missing: yes
        flat: yes
    - name: Remove Environment variable OPTIONS from /etc/sysconfig/docker
      lineinfile:
        dest: /etc/sysconfig/docker
        regexp: '^OPTIONS'
        state: absent

    - name: Modify Environment variable OPTIONS in /etc/sysconfig/docker
      lineinfile:
        dest: /etc/sysconfig/docker
        line: "OPTIONS='--selinux-enabled --log-driver=journald --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem -H=0.0.0.0:2376 -H=unix:///var/run/docker.sock'"
        state: present

    - name: Remove client certs from daemon host
      file:
        path: /root/.docker
        state: absent

    - name: Reload Docker daemon
      command: systemctl daemon-reload
    - name: Restart Docker daemon
      command: systemctl restart docker.service
```

The playbook will create client and server certs on the Atomic host and fetch the client certs to the workstation(local machine) and perform role operations.

```
$ ansible-playbook remote-access.yml
```

Make sure tcp port 2376 is opened of your atomic instance. If you are using Openstack, add the tcp port in your security rule.

So now if you try running any docker command as regular user on your workstation it will talk to the docker daemon of the Atomic host and execute the command there. You do not need to manually ssh and issue docker command on your Atomic host.

Repository of the playbook is [here](https://github.com/trishnaguha/fedora-cloud-ansible/tree/master/docker-remote-access).
