---
author: jbrooks
title: Build Your Own Atomic Host on Fedora 20
date: 2014-04-16 14:01 UTC
tags:
- Fedora
- Atomic
- Docker
categories:
- Blog
---

The application as shipping container metaphor behind the [Docker project's](https://www.docker.io/) name and logo paints an attractive picture for developers: spawn a container on your local machine, fill it with code, and then ship it off to your far-flung users.

While the app is where the action happens, I can't help but wonder what sort of ships await our containers when they arrive at the dock. No matter how well you've crafted or carefully you've packed your cargo, your application will only make it as far as its ship can take it.

Maybe the best thing about Project Atomic is the way it addressess both the shipping container and the ship itself, the former with Docker, and the latter with an intriguing (if less catchily-named) project called rpm-ostree. 

We can use rpm-ostree to take a set of packages from one of our friendly neighborhood RPM-based Linux distributions, assemble it into a "just-enough" OS image, and then deploy and manage hosts based on that image in a manner that more closely matches the container model than do traditional OSes.

Project Atomic has kicked off with a host image, based on Fedora 20, that you can download and use right away, but if you're like me, you're looking for a way to build your own customized Atomic images. Here's how to do it:

## The Build Machine

For a build machine, I've been using a Fedora 20 minimal install with all updates. There are various configuration tweaks required on your build host for now, so it's probably that you set aside a separate machine for this -- I run it on a virtual machine.

## Software Repositories

We have to install rpm-ostree, and some complementary packages, on our build host, as well as make available to our host the packages we intend to include in our Atomic image.

I've assembled the required packages for F20 in this [Copr repository](http://copr.fedoraproject.org/coprs/jasonbrooks/rpm-ostree/). (If you're not familiar with Copr, you can [learn about it here](https://fedorahosted.org/copr/), but, more or less, it's like Personal Package Archives for Fedora/CentOS.

````
cat > /etc/yum.repos.d/jasonbrooks-rpm-ostree.repo << EOF
[rpm-ostree]
name=Copr repo for rpm-ostree owned by walters
baseurl=http://copr-be.cloud.fedoraproject.org/results/jasonbrooks/rpm-ostree/fedora-20-x86_64/ 
gpgcheck=0
enabled=0
metadata_expire=1h
EOF
````

While an F20 build host already knows about F20 packages, rpm-ostree gets hung up on the `$releasever` variable that appears in the Fedora repo files by default. I have a separate repo file that pulls together the fedora, fedora-updates and fedora-updates-testing repos into a single repo file, with the release version hard-coded:


````
cat > /etc/yum.repos.d/fedora-20-atomic.repo << EOF
[fedora-20]
name=Fedora 20 x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-20&arch=x86_64
enabled=0
gpgcheck=0
metadata_expire=1h

[fedora-20-updates]
name=Fedora 20 updates x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f20&arch=x86_64
enabled=0
gpgcheck=0
metadata_expire=1h

[fedora-20-updates-testing]
name=Fedora 20 updates testing x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-testing-f20&arch=x86_64
enabled=0
gpgcheck=0
metadata_expire=1h
EOF
````
## Build Machine Installation, Configuration

Next, let's install some needed packages:

````
yum -y install --enablerepo rpm-ostree \
screen httpd yum-utils \
libgsystem \
ostree rpm-ostree-autobuilder \
binutils nss-altfiles
````

Then, we need to edit /etc/nsswitch.conf to include `altfiles`, like this:

````
passwd: files altfiles 
group:  files altfiles
````

Also, it's necessary ([for now](https://bugzilla.redhat.com/show_bug.cgi?id=1060423)) to disable SELinux on the build machine:

````
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config && cat /etc/selinux/config
````

Now, we'll set up a repository from which our eventual Atomic hosts will fetch upgrades:

````
mkdir /srv/rpm-ostree &&
cd /srv/rpm-ostree &&
mkdir -p repo &&
ostree --repo=repo init --mode=archive-z2 &&
cat > /etc/httpd/conf.d/rpm-ostree.conf <<EOF
DocumentRoot /srv/rpm-ostree
<Directory "/srv/rpm-ostree">
Options Indexes FollowSymLinks
AllowOverride None
Require all granted
</Directory>
EOF
````

Then, we'll add a systemd service file for the rpm-ostree-autobuilder service, enable that service, along with httpd, and finally ensure that our firewall is open to http traffic:

````
cat > /etc/systemd/system/rpm-ostree-autobuilder.service <<EOF
[Unit]
Description=RPM-OSTree autobuilder

[Service]
WorkingDirectory=/srv/rpm-ostree
ExecStart=/usr/bin/rpm-ostree-autobuilder

[Install]
WantedBy=multi-user.target
EOF
````
````
systemctl daemon-reload &&
systemctl enable httpd &&
systemctl start httpd &&
systemctl reload httpd &&
systemctl enable rpm-ostree-autobuilder &&
systemctl start rpm-ostree-autobuilder &&
firewall-cmd --add-service=http &&
firewall-cmd --add-service=http --permanent
````

Now, reboot your build machine to let our SELinux-disabling take effect:

````
systemctl reboot
````

## Tree-Building Time

Upon reboot, the rpm-ostree-autobuilder service should start, and begin looking, in the `/srv/rpm-ostree` directory, for a `products.json` file to define the trees and images to build.

A products.json that corresponds to the initial Project Atomic images is available [in this gist](https://gist.github.com/jasonbrooks/10749644). A products.json that produces multiple images (based on rawhide) is available in Colin Walters' [Fedora Atomic Initiative repository](https://github.com/cgwalters/fedora-atomic/blob/master/products.json).

Some notes on products.json:

* The `"repo"` line of your products.json file should point to the repo directory on your build machine. If you want to use a separate machine to host updates, you can rsync the /srv/rpm-ostree/repo directory on your build machine to a separate server, and set that `"repo"` value accordingly.

* The `"releases"` line should include a list of yum repositories that match the names of the repos we configured above (or whatever other repos you want to use).

* The `"products"` section includes the `"packages"` specific to a particular image, and a `"units"` section listing systemd services to start by default.

The rpm-ostree-autobuilder will periodically check for products.json changes, and build accordingly, but you can spur a new build by running the command 

````
rm -rf cache/raw/images images/auto cache/packageset*.txt && echo treecompose | rpm-ostree-autobuilder console
````

from your /srv/rpm-ostree directory. (that first, `rm` command is due to a caching bug and ought to be unecessary before too long)

The ostree assembly process takes a while to complete. You can monitor the treecompose with:

````
tail -F /srv/rpm-ostree/tasks/treecompose/treecompose/log*
````

Eventually, the log will read "Complete," and you can monitor the image-building with:

````
tail -F /srv/rpm-ostree/tasks/ensure-disk-caches/ensure-disk-caches/output.txt /srv/rpm-ostree/tasks/zdisks/zdisks/output.txt
````

When that completes, the log will say, "Completed compression, renaming to..." and you'll be able to download your image in the tree (where exactly depends on your products.json) under YOURBUILDERHOST/images/auto/.../latest-qcow2.xz.

The builder produces qcow2 images. You can use the `qemu-img` tool to convert this image to raw, VDI (VirtualBox), VMDK (VMWare) and VHD (Hyper-V). Here's how you convert from qcow2 to vdi:

````
xz -d latest-qcow2.xz && 
qemu-img convert -f qcow2 latest-qcow2 -O vdi latest.vdi
````

## Upgrading, Atomically

Once you're up and running in your new image, you can fetch updates with the command `rpm-ostree upgrade`. If you've followed along with me, step by step, you won't have configured gpg signing, and rpm-ostree will tell you to add `gpg-verify=false` to your remote configuration. The relevant config file lives at `/ostree/repo/config`.

Of course, you won't have any upgrades available right out of the gate, but once enough time goes by for new packages to enter Fedora's update repo, or, once you've added packages to your products.json and run the treecompose command above, you'll be able to pull down these changes with `rpm-ostree upgrade`, followed by a reboot.

Don't like the changes? You can rollback with `rpm-ostree rollback`, followed by a reboot.

## Till Next Time

If you run into trouble following this walkthrough, I’ll be happy to help you get up and running or get pointed in the right direction. Ping me at jbrooks in #atomic on freenode irc or [@jasonbrooks](https://twitter.com/jasonbrooks) on Twitter. Also, be sure to check out the [Project Atomic Q&A site](http://ask.projectatomic.io/en/questions/).

