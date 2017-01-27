# Compose Your Own Atomic Updates

Project Atomic hosts are built from standard RPM packages which have been composed into filesystem trees using rpm-ostree. This guide provides a method for customizing existing filesystem trees or creating new trees.

## Requirements

* a machine running CentOS or Fedora for composing filesystem trees
* a web server for hosting these tree repositories

## Process

* The `rpm-ostree` program takes as input a manifest file that describes the target system, and commits the result to an OSTree repository.
* This tree is made available via web server, for Atomic hosts to consume.

## Example Dockerfile

The tree compose and hosting functions can both be performed in a container, if you choose. The simple Dockerfile below will suffice, or you may use a similarly-configured Fedora or CentOS machine:

```
FROM fedora:25

# install needed packages

RUN dnf install -y rpm-ostree git python; \
dnf clean all

# create working dir, clone fedora atomic definitions

RUN mkdir -p /srv; \
cd /srv; \
git clone https://pagure.io/fedora-atomic.git; \

# create and initialize repo directory

mkdir -p /srv/repo && \
cd /srv/ && \
ostree --repo=repo init --mode=archive-z2; \

# make a cache dir

mkdir -p /srv/cache

# expose default SimpleHTTPServer port, set working dir

EXPOSE 8000
WORKDIR /srv

# start SimpleHTTPServer

CMD python -m SimpleHTTPServer
```

## Build, Run and Enter the Container

````
docker build --rm -t $USER/atomicrepo .

docker run --privileged -d -p 8000:8000 --name atomicrepo $USER/atomicrepo

docker exec -it atomicrepo bash 
````

## Compose Your Custom Tree

The Dockerfile above pulls in the definition files for Atomic CentOS and Atomic Fedora, which may be modified to produce a custom tree. The tree manifest syntax is documented [here](https://github.com/projectatomic/rpm-ostree/blob/master/docs/manual/treefile.md). 

For example, here's how to produce a version of the Atomic Fedora 25 tree that adds the `fortune` command:

````
cd fedora-atomic

git checkout f25

vi fedora-atomic-docker-host.json
````

Now, in the `"packages":` section of `fedora-atomic-docker-host.json`, and insert a line like this: `"fortune-mod",`. 

Next, compose the new tree with the command:

````
rpm-ostree compose tree  --cachedir=/srv/cache  --repo=/srv/repo fedora-atomic-docker-host.json
````

## Configure Your Atomic Host with the New Repository

To configure an Atomic host to receive updates from your build machine, run a pair of commands like the following to add a new "withfortune" repo definition to your host, and then rebase to that tree:

````
sudo ostree remote add withfortune http://$YOUR_IP:8000/repo --no-gpg-verify

sudo rpm-ostree rebase withfortune:fedora-atomic/25/x86_64/docker-host
````

Once the rebase operation is complete, run `sudo systemctl reboot` to reboot into your updated tree.
