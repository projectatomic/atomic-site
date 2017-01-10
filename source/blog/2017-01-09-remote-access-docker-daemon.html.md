---
title: Set Up Remote Access for Docker on Atomic Host
author: trishnag, jberkus
date: 2017-01-09 18:00:00 UTC
published: true
comments: true
tags: atomic host, ansible, docker
---


This post will describe how to set up remote command-line access for the [Docker](https://www.docker.com/) daemon running on an Atomic host. This will let you run `docker ps`, `docker run` and other commands from your desktop and manage a server.

We are also going to secure the Docker daemon with TLS (transport layer security) since we are connecting remotely. Before you carry on with the following steps, keep in mind that **any** process on the client that can access the TLS certs now has **full** control of the Docker daemon on the server and can do anything it wants to do. So, only copy those certificates to client hosts completely under your control.

READMORE

First, we will create client certificate and server certificate to secure our Docker daemon, using OpenSSL. For the rest of this post, I am using [Fedora-Atomic](https://getfedora.org/en/atomic/) host as the remote host (Docker daemon) and [Fedora workstation](https://getfedora.org/en/workstation/download/) as my local machine (Docker client).

[Chris Houseknecht](https://twitter.com/CHouseknecht) wrote an [Ansible](https://www.ansible.com/) role which creates all the certificates required automatically, so that there is no need to issue OpenSSL commands manually. Here is the Ansible role repository: [role-secure-docker-daemon](https://github.com/ansible/role-secure-docker-daemon). We'll be cloning it.

```
$ mkdir docker-remote-access
$ cd docker-remote-accessi
$ git clone https://github.com/ansible/role-secure-docker-daemon.git
```

Create an ansible config file, inventory, and playbook file to set up the Docker client and play the role.

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

Replace **IP_OF_ATOMIC_HOST** in the inventory file with the IP of your Atomic host (Docker daemon host) and **PRIVATE_KEY_FILE** with private key file on your local system that you use to log into that host.

Now, we're ready to execute a playbook which will copy all of the files and change settings to make this work.

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

The playbook will create client and server certificates on the Atomic host, fetch the client certificates to the workstation (Docker client), and execute the secure docker setup role.

```
$ ansible-playbook remote-access.yml
```

Make sure tcp port 2376 is opened on the remote host (Docker daemon). If you are using Openstack, add the tcp port in your security rule, and if you are using AWS, add it to the security group.

So now, if you try running any docker command as regular user on your workstation, it will talk to the docker daemon of the Atomic host and execute the command there. You do not need to ssh to the remote host to issue commands, allowing you to launch containerized applications remotely and easily, yet securely.

```
# docker run -d -P training/webapp python app.py
Unable to find image 'training/webapp:latest' locally
Trying to pull repository docker.io/training/webapp ...
sha256:06e9c1983bd6d5db5fba376ccd63bfa529e8d02f23d5079b8f74a616308fb11d: Pulling from docker.io/training/webapp
e190868d63f8: Extracting [======================================>            ] 50.69 MB/65.77 MB
...
Status: Downloaded newer image for docker.io/training/webapp:latest
00f41fb132afbc260c99b3d984af6d64b1a2d567c625500a254970cc5172ba2d
#
# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                     NAMES
00f41fb132af        training/webapp     "python app.py"     31 seconds ago      Up 23 seconds       0.0.0.0:32768->5000/tcp   sleepy_leakey
```

If you get `Cannot connect to the Docker daemon`, then try running `source ~/.bashrc` manually.  If you get `could not read CA certificate "/etc/docker/ca.pem"`, then try logging out of your desktop session and back in.

If you want to copy the playbook more easily, there's a repository [here](https://github.com/trishnaguha/fedora-cloud-ansible/tree/master/docker-remote-access).
