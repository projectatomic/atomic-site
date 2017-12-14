---
title: Composing custom OSTree update for Fedora 27 Atomic Host
author: sinnykumari
date: 2017-12-13
published: false
comments: false
tags: atomic, fedora, multi-arch, ostree
---

With Fedora 27, we ship [Atomic Host on multiple architectures](http://www.projectatomic.io/blog/2017/11/fedora-atomic-27-on-multiarch/) which includes aarch64, ppc64le, and x86_64. We also provide Atomic Host updates for these arches every two weeks so that we can provide a tested, stable, and up-to-date OS. Fedora Atomic Host is built using traditional RPM packages available in the Fedora repository. For example, Fedora 27 Atomic Host is formed using  packages from the Fedora 27 repository which are further composed into [OSTree repository](https://ostree.readthedocs.io/en/latest/manual/introduction/) using rpm-ostree. It is possible to compose and host your own custom-built OSTree repository containing additional features. This article will further guide you on how to compose your own custom OSTree repository and update system from your own hosted OSTree repo.

READMORE

# Composing and hosting custom Atomic OSTree
We will be composing a custom Fedora 27 OSTree repository on x86_64. For ease of use, we will compose and host OSTree repo in a Docker container. You can also compose it on a Virtual Machine or bare metal.

> `Note:` If you are trying this on aarch64 or ppc64le, replace any mention of x86_64 with the right architecture value wherever used in commands.

## Requirement
- A virtual machine or bare metal system with Fedora installed, preferably Fedora 27 which is the latest stable release.
- Docker installed and service running on the machine.

Install Docker and run its service on the system where you are planning to run the container:

```
$ sudo dnf install docker
$ sudo systemctl start docker
```

## Dockerfile
Create a Dockerfile with the following content which we will use to build a Docker container using Fedora27 as its base and on top of it some additional setup is being done.

```
$ cat Dockerfile
FROM fedora:27

# Update, install specified packages and clean cached information
RUN dnf update -y && dnf install -y git python rpm-ostree; \
dnf clean all

# Create specified directories
RUN mkdir -p /srv /srv/repo /srv/cache

# Set /srv as working directory and clone fedora-atomic repository into it
WORKDIR /srv
RUN git clone https://pagure.io/fedora-atomic.git

# Initialize a new empty repository in /srv/repo/ directory in archive mode
RUN ostree --repo=repo init --mode=archive-z2

# Expose default SimpleHTTPServer port and start SimpleHTTPServer
EXPOSE 8000
CMD python -m SimpleHTTPServer
```

> `Note:` If you are trying to compose OSTree on aarch64 or ppc64le then modify the first line of your Dockerfile from `FROM fedora:27` to `FROM docker.io/fedora:27`. This is needed because Docker first tries to pull in the Fedora 27 image from registry.fedoraproject.org which only contains x86_64 images for now.

## Build Docker image and run container

Now, we will build a Docker image from the Dockerfile we just created. In this example, our Dockerfile is available in the current directory.

```
$ sudo docker build --rm -t $USER/atomicrepo .
```

The Docker image has been created in the system which can be accessed with name $USER/atomicrepo. To view available images, run:

```
$ sudo docker images
```

Launch a container in the background from image $USER/atomicrepo we just created which listens on port 8000.

```
$ sudo docker run --privileged -d -p 8000:8000 --name atomicrepo $USER/atomicrepo
```

We now have a running container with SimpleHTTPServer running inside it. Let's get shell access to this container to work further:

```
$ sudo docker exec -it atomicrepo bash
```

We are now inside a running container with current working directory set to /srv.

```
# pwd
/srv
```

## Composing OSTree repository

While building the image, we cloned fedora-atomic repository into `/srv/` directory. We will use content from the fedora-atomic repository as reference to build custom OSTree. Let's checkout f27 branch of the fedora-atomic repo:

```
# cd fedora-atomic
# git checkout f27
```

File `fedora-atomic-host-base.json` in the `fedora-atomic` repo is the [treefile](https://rpm-ostree.readthedocs.io/en/latest/manual/treefile/) containing details about the target system. It has a list of packages which will be composed into our new OSTree. Add or remove package names as required in your custom OSTree repo. In this example, I have added `elfutils` in the `packages` list.

Also, feel free to give your own ref name if desired by editing the content of the `ref` section. rpm-ostree will automatically replace `${basearch}` by architecture name (x86_64, ppc64le or aarch64) on which you are composing your OSTree.
In this example, I have changed `ref` to `fedora/27/${basearch}/atomic-host-custom`.

Let's compose ostree using rpm-ostree:

```
# rpm-ostree compose tree  --cachedir=/srv/cache  --repo=/srv/repo fedora-atomic-host-base.json
```

On successful compose, you will see this at the end:

```
Committing: [=======================================================================================================================================] 100%
Metadata Total: 7915
Metadata Written: 3585
Content Total: 32682
Content Written: 25647
Content Bytes Written: 1083483773
fedora/27/x86_64/atomic-host-custom => 93b1d9f8b929916762260bfd31e1b5b9568c0da83110df9425f41e4b44115fc4
```
The last line contains the OSTree ref name followed by a commit number.

To view available commits, run:

```
# ostree log --repo=/srv/repo/ fedora/27/x86_64/atomic-host-custom
commit 93b1d9f8b929916762260bfd31e1b5b9568c0da83110df9425f41e4b44115fc4
Date:  2017-12-10 13:11:50 +0000
Version: 27
(no subject)
```

In the commit log,  the `Version` value gets updated with additional commits made in ref fedora/27/x86_64/atomic-host-custom. Values are in incremental fashion, i.e. 27.1, 27.2, 27.3, and so on.

# Updating Atomic Host system with custom OSTree

Now, if you have a host machine or virtual machine with Atomic Host already running, let's try to update the system with the custom update repository we just created.

```
$ sudo ostree remote add fedora-atomic-custom http://YOUR_IP:8000/repo --no-gpg-verify
$ cat /etc/ostree/remotes.d/fedora-atomic-custom.conf
[remote "fedora-atomic-custom"]
url=http://YOUR_IP:8000/repo
gpg-verify=false
```

Here, YOUR_IP is the IP address of the system on which your `atomicrepo` container is running. Make sure that the IP address is reachable from the target system where the update process will take place.

Now, update the Atomic Host system with our locally hosted ostree repo using `rpm-ostree rebase`.

```
$ sudo rpm-ostree rebase fedora-atomic-custom:fedora/27/x86_64/atomic-host-custom
```

In our example, fedora-atomic-custom is the remote name which we previously added. Reboot your system to apply changes.

```
$ sudo systemctl reboot
$ sudo rpm-ostree status
State: idle
Deployments:
● fedora-atomic-custom:fedora/27/x86_64/atomic-host-custom
                   Version: 27 (2017-12-10 13:11:50)
                BaseCommit: 93b1d9f8b929916762260bfd31e1b5b9568c0da83110df9425f41e4b44115fc4
           LayeredPackages: libabigail

  fedora-atomic:fedora/27/x86_64/atomic-host
                   Version: 27.16 (2017-11-28 23:08:35)
                BaseCommit: 86727cdbc928b7f7dd0e32f62d3b973a8395d61e0ff751cfea7cc0bc5222142f
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: libabigail
```

## Rollback to previous tree
In case you didn't like updating to your custom OSTree, no worries. It's very easy to switch back to a previous commit using the Atomic rollback feature:

```
$ sudo rpm-ostree rollback
```

Reboot your system and it will be back to what you had earlier.

# Conclusion

Now you know how easy it is to create your own custom OSTree repository and serve it as update to all Atomic Host systems you want to keep in sync. All you have to do is keep updating the treefile and re-run the `rpm-ostree compose` process on the server side, then run `rpm-ostree upgrade` on client side once you have rebased the client system to the right ref. If something goes wrong, use the `rpm-ostree rollback` feature and it will take you to the previous working Atomic Host system.

So, give it a try and let us know how it worked for you in the #atomic IRC channel.
