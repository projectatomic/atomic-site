---
author: jbrooks
comments: true
layout: post
title: "Docker as Development Middleman"
date: 2014-09-15
tags:
- Atomic
- Docker
categories:
- Blog
---

When compared to dynamic sites based on WordPress or Drupal, staticly generated blog and Web sites (like this one) can go a long way toward simplifying deployment and maintenance. There's no database or server-side code to maintain, and, when paired with a service like Github or Gitlab, you can accept posts or other contributions from anyone, via pull request.

However, while simplifying certain areas, static sites introduce a bit more complexity in other areas. Among the handful of Middleman-based static sites that our team at Red Hat help maintain, we've seen the specter of "works on my laptop" arise. 

With Middleman, authors preview content on their local machine, using Middleman's built-in development server. There isn't much setup required to run this development server, but when the same Middleman code runs on different machines, with different operating systems, and different assortments of Ruby gems, things don't always work as expected.

Enter Docker, which makes it easy to enforce a common application environment for users on different machines. Here's how I'm using Docker to write and preview this post:

First, I'll make sure that git and docker are installed on my Fedora 20 notebook, and I'll add myself to the docker group on my machine.

````
sudo yum install -y git docker-io
````
````
sudo usermod -a -G docker $USER
````
For the group add to take effect, you must log out and back in, or run `su - $USER` before continuing.

Then, I'll cruise over to Github, [make a fork](https://github.com/projectatomic/atomic-site/fork) of the Project Atomic Web site repo, and clone my new repo:

````
git clone git@github.com:jasonbrooks/atomic-site.git && cd atomic-site
````

There's a script named `docker.sh` in the repository that builds and runs a Docker container for running local development version of the projectatomic.io site.

I have a couple of modifications for the script and Dockerfile, which make it easier to viewing changes to the site as I write.

First, in the `Dockerfile` included in the repo, I change the FROM line to `FROM fedora:20`, which is the official Fedora image. If you'd prefer a CentOS image, you can change this line to `FROM centos:centos7`. If you do, you'll also need to add `tar` and `patch` to the list of packages to install in line 5. 

I also remove line 11, `ADD source /tmp/source`, because rather than roll the site source into my image, I'm going to point to the source directory in my checkout of the site. This way, I can add and edit posts without rebuilding the image.

Next, I edit the `docker.sh` script included in the repo such that the `docker run` command reads:

````
docker run -p 4567:4567 -v "$(pwd)"/source:/tmp/source:ro middleman
````
Finally, I modify the SELinux context of my checked-out source directory to allow my Docker container to read it:
````
chcon -Rt svirt_sandbox_file_t source/
````
To build and run the container, simply run:
````
sh docker.sh
````
After a short time (shorter, naturally, if you have an image already cached on your machine), the Middleman development server will be running on your machine at http://0.0.0.0:4567. When you add to or edit the posts and other files within the source directory in your checked-out repo, you can refresh the page in your browser to see your changes.

