---
title: Atomic App 0.6.2 released with new index CLI command
author: cdrage
date: 2016-07-27 16:55:00 UTC
tags: atomicapp, Nulecule, releases
published: true
comments: true
---

This release of Atomic App introduces the new `atomicapp index` command.

We add this command in order to give a quick overview of all available featured and tested Nuleculized applications on [github.com/projectatomic/nulecule-library](https://github.com/projectatomic/nulecule-library). The ability to generate your own list is available as well with the `atomicapp index generate` command.

READMORE

The main features of this release are:

* Addition of the `atomicapp index` command
* Correct file permissions are now when extracting Nuleculized containers
* OpenShift connection issue bugfix


## `atomicapp index`

This release adds the addition of the `atomicapp index` command. By using the `atomicapp index list` command, Atomic App will retrieve a container containing a valid `index.yml` and output all available Nulecule containers. This index can also be updated by using `atomicapp index update`.


**atomicapp index list**

Outputs the list of available containers located at `~/.atomicapp/index.yml`.

```
▶ atomicapp index list
INFO   :: Atomic App: 0.6.2 - Mode: Index
ID                        VER      PROVIDERS  LOCATION                                             
postgresql-atomicapp      1.0.0    {D,O,K}    docker.io/projectatomic/postgresql-centos7-atomicapp 
flask_redis_nulecule      0.0.1    {D,K}      docker.io/projectatomic/flask-redis-centos7-atomicapp
redis-atomicapp           0.0.1    {D,O,K}    docker.io/projectatomic/redis-centos7-atomicapp      
gocounter                 0.0.1    {D,K}      docker.io/projectatomic/gocounter-scratch-atomicapp  
mariadb-atomicapp         1.0.0    {D,O,K}    docker.io/projectatomic/mariadb-centos7-atomicapp    
helloapache-app           0.0.1    {D,K,M}    docker.io/projectatomic/helloapache                  
mongodb-atomicapp         1.0.0    {D,O,K}    docker.io/projectatomic/mongodb-centos7-atomicapp    
etherpad-app              0.0.1    {D,O,K}    docker.io/projectatomic/etherpad-centos7-atomicapp   
apache-centos7-atomicapp  0.0.1    {D,K,M}    docker.io/projectatomic/apache-centos7-atomicapp     
wordpress-atomicapp       2.0.0    {D,O,K}    docker.io/projectatomic/wordpress-centos7-atomicapp  
skydns-atomicapp          0.0.1    {K}        docker.io/projectatomic/skydns-atomicapp             
guestbookgo-atomicapp     0.0.1    {O,K}      docker.io/projectatomic/guestbookgo-atomicapp        
mariadb-app               0.0.1    {D,K}      docker.io/projectatomic/mariadb-fedora-atomicapp     
gitlab-atomicapp          1.2.0    {D,K}      docker.io/projectatomic/gitlab-centos7-atomicapp 
```

**atomicapp index update**

Updates the `index.yml` file.

```
▶ atomicapp index update
INFO   :: Atomic App: 0.6.2 - Mode: Index
INFO   :: Updating the index list
INFO   :: Pulling latest index image...
INFO   :: Skipping pulling docker image: projectatomic/nulecule-library
INFO   :: Copying files from image projectatomic/nulecule-library:/index.yaml to /home/wikus/.atomicapp/index.yaml
INFO   :: Index updated
```

**atomicapp index generate**

Generates a valid `index.yml` file to use in listing all available containers.

```
▶ atomicapp index generate ./nulecule-library
INFO   :: Atomic App: 0.6.1 - Mode: Index
INFO   :: Generating index.yaml from ./nulecule-library
INFO   :: index.yaml generated
```

Want to get started using Atomic App? Have a look at our extensive [start guide](https://github.com/projectatomic/atomicapp/blob/master/docs/start_guide.md), or use Atomic App as part of the Atomic CLI on an [Atomic Host](http://www.projectatomic.io/download/).

For a full list of changes between 0.6.1 and the 0.6.2 please see [the commit log](https://github.com/projectatomic/atomicapp/commits/0.6.2).
