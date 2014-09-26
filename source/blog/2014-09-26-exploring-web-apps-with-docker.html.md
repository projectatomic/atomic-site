---
author: jbrooks
comments: true
layout: post
title: "Exploring Web Apps with Docker"
date: 2014-09-26
tags:
- Atomic
- Docker
categories:
- Blog
---
Dockermania has been running wild, and it seems as though there's an advocate for swapping in the containerization technology wherever we once turned to virtual machines. While Docker [won't (yet) fit the bill](https://opensource.com/business/14/9/security-for-docker) in all of these cases, containers are great for trying out new or updated Web applications on your local machine. 

Rather than tax your speedy but space-constrained notebook SSD with a library of different virtual machines, you can stack up a series of containers on a single VM. 

When WordPress hit its big 4.0 release earlier this month, I fired up an instance of the new [Fedora 21 Atomic image alpha](http://fedoraproject.org/en/get-prerelease#cloud) on my notebook to check out the new WordPress release, in Dockerized form.

Now, for a popular app like WordPress, you can expect to find a ready-to-deploy image in the [Docker Registry](https://registry.hub.docker.com/_/wordpress/). However, I prefer to choose my own image operating system, and to have a clearer view into the components behind the application at hand. 

Anyway, WordPress is super easy to install, and the projects behind my OSes of choice, [Fedora](https://github.com/fedora-cloud/Fedora-Dockerfiles) and [CentOS](https://github.com/CentOS/CentOS-Dockerfiles), maintain sets of base component Dockerfiles for things like databases and Web servers that I can quickly plug together with the WordPress source.

After ssh'ing into my Atomic host, I started by cloning the Fedora-Dockerfiles git repo and changing into that directory:

````
git clone https://github.com/fedora-cloud/Fedora-Dockerfiles.git
cd Fedora-Dockerfiles
````
Next I'll built myself a MariaDB container:

````
sudo docker build --rm -t jbrooks/mariadb mariadb/.
````

The MariaDB Dockerfile didn't need any changes, but I tweaked the Apache Dockerfile just a bit to pull in the WordPress source, decompress it, and drop it into the right spot in the container image:

````
vi apache/Dockerfile
````

Immediately below the line `RUN yum -y install httpd && yum clean all`, I added the following lines:

````
RUN yum -y install php php-mysql php-gd && yum clean all
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
RUN tar xvzf /wordpress.tar.gz
RUN mv /wordpress/* /var/www/html/
RUN chown -R apache:apache /var/www/
````

Next, I deleted the line, `RUN echo "Apache" >> /var/www/html/index.html`, saved, and exited my editor before building the Apache/WordPress image:

````
sudo docker build --rm -t jbrooks/wordpress apache/.
````

Then, I fired up the database container, and then spun up the WordPress container, with a link to the database:

````
sudo docker run --name=mariadb -d -p 3306:3306 jbrooks/mariadb
sudo docker run -d --name wordpress --link mariadb:mariadb -p 80:80 jbrooks/wordpress
````

Finally, I keyed the IP address of my Atomic host into my Web browser address bar, and clicked my way through the WordPress installer. As noted in the MariaDB Dockerfile README, the container comes with a default `testdb` database, a `testdb` user, and a password of `mysqlPassword`. Since I was just kicking the tires of WordPress, I didn't bother to change these, but you can find details on changing them in the README. 

After a clicking through the rest of the installer, WordPress 4.0:

<img src="http://www.projectatomic.io/images/wordpress-screen.png">
