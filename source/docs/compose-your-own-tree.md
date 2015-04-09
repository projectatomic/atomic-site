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

````
FROM fedora:21

# install needed packages

RUN yum install -y rpm-ostree git polipo; \
yum clean all

# create working dir, clone fedora and centos atomic definitions

RUN mkdir -p /home/working; \
cd /home/working; \
git clone https://github.com/CentOS/sig-atomic-buildscripts; \
git clone https://git.fedorahosted.org/git/fedora-atomic.git; \

# create and initialize repo directory

mkdir -p /srv/rpm-ostree/repo && \
cd /srv/rpm-ostree/ && \
ostree --repo=repo init --mode=archive-z2

# expose default SimpleHTTPServer port, set working dir

EXPOSE 8000
WORKDIR /home/working

# start web proxy and SimpleHTTPServer

CMD polipo; pushd /srv/rpm-ostree/repo; python -m SimpleHTTPServer; popd
````

## Build, Run and Enter the Container

````
docker build --rm -t $USER/atomicrepo .

docker run --privileged -d -p 8000:8000 --name atomicrepo $USER/atomicrepo

docker exec -it atomicrepo bash 
````

## Compose Your Custom Tree

The Dockerfile above pulls in the definition files for Atomic CentOS and Atomic Fedora, which may be modified to produce a custom tree. The tree manifest syntax is documented [here](https://github.com/projectatomic/rpm-ostree/blob/master/doc/treefile.md). 

For example, here's how to produce a version of the Atomic Fedora 21 tree that adds the `fortune` command:

````
cd fedora-atomic

git checkout f21

vi fedora-atomic-docker-host.json
````

Now, in the `"packages":` section of `fedora-atomic-docker-host.json`, and insert a line like this: `"fortune-mod",`. 

Currently, the fedora-atomic git repo is missing the yum repository file for Fedora's updates, so we'll want to add this as well. Change the line `"repos": ["fedora-21"],` to `"repos": ["fedora-21", "updates"],` and then save and close the file. 

Finally, we need to download that Fedora updates repository file into the `fedora-atomic` directory, and replace occurrences of `$releasever` in the file with `21` (important for when the release version of your composer does not match the release version of the tree you're composing). 

````
curl -o fedora-21-updates.repo https://git.fedorahosted.org/cgit/fedora-repos.git/plain/fedora-updates.repo?h=f21
sed -i 's/\$releasever/21/g' fedora-21-updates.repo
````

Next, compose the new tree with the command:

````
rpm-ostree compose tree  --proxy=http://127.0.0.1:8123  --repo=/srv/rpm-ostree/repo fedora-atomic-docker-host.json
````

The `--proxy` argument is optional but strongly recommended -- with this option you can avoid continually redownloading the packages every compose. The Dockerfile above provides for [Polipo](http://www.pps.univ-paris-diderot.fr/~jch/software/polipo/) as a proxy.

## Configure Your Atomic Host with the New Repository

To configure an Atomic host to receive updates from your build machine, run a pair of commands like the following to add a new "withfortune" repo definition to your host, and then rebase to that tree:

````
sudo ostree remote add withfortune http://$YOUR_IP:8000/repo --no-gpg-verify

sudo rpm-ostree rebase withfortune:fedora-atomic/f21/x86_64/docker-host
````

Once the rebase operation is complete, run `sudo systemctl reboot` to reboot into your updated tree.
