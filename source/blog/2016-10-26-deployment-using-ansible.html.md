---
title: Containerization and Deployment of application on Atomic host with Ansible-Playbook
author: trishnag
date: 2016-10-26 14:00:00 UTC
published: true
comments: true
tags: atomic host, ansible, applications
---

This mini-tutorial describes how to build [Docker](https://www.docker.com/) image and deploy containerized application on [Atomic](http://www.projectatomic.io/) host using [Ansible](https://www.ansible.com/) Playbook.

Building Docker image for an application and running container/cluster of containers is nothing new. But the idea is to automate the whole process and this is where Ansible playbooks come in to play.

**Note:** You can use any Cloud/Workstation based Image to execute the following task.

## How to automate the containerization and deployment process for a simple Flask application

First, let’s create a simple **Flask Hello-World** application.
This is the directory structure of the entire application.  You can copy these files
from the repository [trishnaguha/fedora-cloud-ansible](https://github.com/trishnaguha/fedora-cloud-ansible):

```
flask-helloworld/
├── ansible
│   ├── ansible.cfg
│   ├── inventory
│   └── main.yml
├── Dockerfile
├── flask-helloworld
│   ├── hello_world.py
│   ├── static
│   │   └── style.css
│   └── templates
│       ├── index.html
│       └── master.html
└── requirements.txt
```

**requirements.txt**:

```
Flask==0.11.1
Jinja2==2.8
```

**hello_world.py**:

```
from flask import Flask, render_template

APP = Flask(__name__)

@APP.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    APP.run(debug=True, host='0.0.0.0')
```

**static/style.css**:

```
body {
  background: #F8A434;
  font-family: 'Lato', sans-serif;
  color: #FDFCFB;
  text-align: center;
  position: relative;
  bottom: 35px;
  top: 65px;
}
.description {
  position: relative;
  top: 55px;
  font-size: 50px;
  letter-spacing: 1.5px;
  line-height: 1.3em;
  margin: -2px 0 45px;
}
```

**templates/master.html**:

```
<!doctype html>
<html>
<head>
    {% block head %}
    <title>{% block title %}{% endblock %}</title>
    {% endblock %}
                                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
                                <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-T8Gy5hrqNKT+hzMclPo118YTQO6cYprQmhrYwIiQ/3axmI1hQomh7Ud2hPOy8SP1" crossorigin="anonymous">
                                <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
                                <link href='http://fonts.googleapis.com/css?family=Lato:400,700' rel='stylesheet' type='text/css'>

</head>
<body>
<div id="container">
    {% block content %}
    {% endblock %}</div>
</body>
</html>
```

**templates/index.html**:

```
{% extends "master.html" %}

{% block title %}Welcome to Flask App{% endblock %}

{% block content %}
<div class="description">

Hello World</div>
{% endblock %}
```

Here's the **Dockerfile** to build the image.  Remember to put your name and email
after MAINTAINER:

```
FROM fedora
MAINTAINER YOUR NAME HERE<your@email.address>

RUN dnf -y update && dnf -y install python-virtualenv && dnf clean all

RUN virtualenv venv
RUN source venv/bin/activate

RUN mkdir -p /app

COPY requirements.txt /app
WORKDIR /app

RUN pip install -r requirements.txt

COPY files/ /app/
WORKDIR /app

ENTRYPOINT ["python"]
CMD ["hello_world.py"]
```

That's everything we need to build the container.  Now let's automate it.

## Ansible playbook for our application

**Create Inventory file:**

```
[atomic]
<IP_ADDRESS_OF_HOST> ansible_ssh_private_key_file=<'PRIVATE_KEY_FILE'>
```

Replace ``IP_ADDRESS_OF_HOST`` with the IP address of the atomic/remote host and ``‘PRIVATE_KEY_FILE’`` with your private key file.


**Create ansible.cfg file:**

```
[defaults]
inventory=inventory
remote_user=<USER>

[privilege_escalation]
become_method=sudo
become_user=root
```

Replace ``USER`` with the user of your remote host (Atomic).

**Create the Playbook main.yml file:**

```
---
- name: Deploy Flask App
  hosts: atomic
  become: yes

  vars:
    src_dir: [Source Directory]
    dest_dir: [Destination Directory]

  tasks:
    - name: Create Destination Directory
      file:
       path: "{{ dest_dir }}/files"
       state: directory
       recurse: yes

    - name: Copy Dockerfile to host
      copy:
       src: "{{ src_dir }}/Dockerfile"
       dest: "{{ dest_dir }}"

    - name: Copy requirements.txt to host
      copy:
       src: "{{ src_dir }}/requirements.txt"
       dest: "{{ dest_dir }}"

    - name: Copy Application to host
      copy:
       src: "{{ src_dir }}/flask-helloworld/"
       dest: "{{ dest_dir }}/files/"

    - name: Make sure that the current directory is {{ dest_dir }}
      command: cd {{ dest_dir }}

    - name: Build Docker Image
      command: docker build --rm -t fedora/flask-app:test -f "{{ dest_dir }}/Dockerfile" "{{ dest_dir }}"

    - name: Run Docker Container
      command: docker run -d --name helloworld -p 5000:5000 fedora/flask-app:test
...
```

Replace ``[Source Directory]`` in ``src_dir`` field in main.yml with your ``/path/to/src_dir`` of the current host.

Replace ``[Destination Directory]`` in ``dest_dir`` field in main.yml with your ``/path/to/dest_dir`` of the remote atomic host.

Issue the following command in order to run the playbook. Make sure you are in the ``ansible`` directory.
``$ ansible-playbook main.yml``.

To verify whether the application is running or not you can curl the localhost on your remote atomic host by
``$ curl http://localhost:5000``.

You can also manage your containers running on remote host using [Cockpit](http://cockpit-project.org/). Check this article to know how to use Cockpit to manage your containers: [Manage-Containers-with-Cockpit](https://fedoramagazine.org/deploy-containers-atomic-host-ansible-cockpit).

Here is the repository that contains Playbooks to deploy containers on Atomic host: [trishnaguha/fedora-cloud-ansible](https://github.com/trishnaguha/fedora-cloud-ansible).
