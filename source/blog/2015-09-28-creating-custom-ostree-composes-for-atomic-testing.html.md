---
title: Creating Custom ostree Composes for Atomic Testing
author: miabbott
date: 2015-09-28 09:00:28 UTC
tags: ostree, rpm-ostree, testing, Fedora
published: false
comments: true
---

I recently was tasked with testing a change in the upstream `ostree` code on an Atomic Host.

Well, since Atomic hosts use `ostree` as their distribution model, that means I couldn't just get an RPM and install it that way. (I could have just copied over the compiled binary, but where is the fun in that?)

My task list was as follows:

1.  build `ostree` from source
2.  package `ostree` into an RPM
3.  create an custom `ostree` compose
4.  rebase an existing Atomic host to the custom compose

As someone who hadn't really accomplished any of these tasks before, I had to reach out for some help on multiple occasions, but I got through it all and hopefully this guide will help you along the way.

READMORE

## Practice ostree compose (the verbose version)

Before I get into the some of the details of doing a custom `ostree` compose, I found it was helpful to do a vanilla `ostree` compose to learn some of the mechanics.

I used Brent Baude's [post on the Red Hat Developer Blog](http://developerblog.redhat.com/2015/01/08/creating-custom-atomic-trees-images-and-installers-part-1/) as a guide for doing my first compose. It was critical to my success in this task! I would recommend reviewing that post for more details about how this works.

For this example, I booted up the latest [Fedora 22 Cloud image](https://getfedora.org/en/cloud/download/) in a VM on my workstation. (Additionally, Fedora 22 Server or Workstation should work.)

The first step was to install the necessary tools, which are `git` and `rpm-ostree-toolbox`

    # dnf install git rpm-ostree-toolbox

With the tools installed, we are going to do a `git clone` of the [fedora-atomic git repo](https://git.fedorahosted.org/cgit/fedora-atomic.git) which contains the necessary input files for creating a Fedora Atomic `ostree` compose. (Additionally, I first made a 'working' directory to perform the compose in.)

    # mkdir /home/working
    # cd /home/working
    # git clone https://git.fedorahosted.org/cgit/fedora-atomic.git

This cloned repo includes a number of branches, including **f22**, which contains the files necessary for doing a Fedora 22 Atomic compose. Since I had the best luck with this branch, we're going to use this for the example.

    # cd fedora-atomic
    # git checkout f22

With the right branch selected we can do a compose right away with the `rpm-ostree-toolbox` command. I'll dig into some of the options right after this.

    # cd /home/working
    # rpm-ostree-toolbox treecompose -c fedora-atomic/config.ini  --ostreerepo /srv/rpm-ostree/fedora-atomic/22/

This command is going to generate a lot of output, so you can sit back and watch all the magic happens while we discuss the various options passed to the `rpm-ostree-toolbox` command.

The `treecompose` sub-command is pretty self-explanatory; it tells `rpm-ostree-toolbox` that we want to do a new `ostree` compose.

The `-c fedora-atomic/config.ini` option tells `rpm-ostree-toolbox` to use the config file specified in the fedora-atomic repo (also kind of self-explanatory). I'm not going to get into the details of the config file at the moment; the blog post linked above has some additional details about the config file.

The `--ostreerepo /srv/rpm-ostree/fedora-atomic/22/` option instructs `rpm-ostree-toolbox` where the resulting `ostree` compose will land on the disk. You don't have to create the directory structure beforehand; the toolbox will create it as part of its job.

If everything was successful, the last few lines of output that `rpm-ostree-toolbox` will produce, looks like this:

<pre><code>...
Moving /boot
Using boot location: both
Copying toplevel compat symlinks
Adding tmpfiles-ostree-integration.conf
Ignored user missing from new passwd file: root
Ignored user missing from new passwd file: root
Committing '/var/tmp/rpm-ostree.HI9E5X/rootfs.tmp' ...
Labeling with SELinux policy 'targeted'
fedora-atomic/f22/x86_64/docker-host => edbe79d713059e4ce5c73346112ef5a33beb54683ddf41b8a6afc81c1dc28083
Complete
fedora-atomic/f22/x86_64/docker-host => edbe79d713059e4ce5c73346112ef5a33beb54683ddf41b8a6afc81c1dc28083
</code></pre>

With our freshly composed `ostree`, let's see if we can actually use it with an Atomic host.

First, we'll make the new `ostree` compose available on the network with the built-in `trivial-httpd` server that comes with the `ostree` command. We just point it to the location of the `ostree` that was just composed (`/srv/rpm-ostree/fedora-atomic/22/`)

    # ostree trivial-httpd -p - /srv/rpm-ostree/fedora-atomic/22/
    43620

Note the number that is printed out; this is the port which the `ostree` compose is being served via HTTP. We'll need this number in the next step.

Next, I booted up a [Fedora 22 Atomic host](https://getfedora.org/cloud/download/atomic.html) in a VM and checked the existing `rpm-ostree status`.

<pre><code>f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSION   ID             OSNAME            REFSPEC
* 2015-05-21 19:01:46     22.17     06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host
</code></pre>

Then I added a new `ostree` remote that pointed to the trivial-httpd server and verified the remotes configured:

<pre><code>f22-atomic-host# ostree remote add f22-test http://192.168.122.219:43620 --no-gpg-verify
f22-atomic-host# ostree remote list -u
f22-test http://192.168.122.219:43620
fedora-atomic http://dl.fedoraproject.org/pub/fedora/linux/atomic/22/
</code></pre>

Then we can use `rpm-ostree rebase` to pull down the compose to the Atomic host

<pre><code>
f22-atomic-host# rpm-ostree rebase f22-test:fedora-atomic/f22/x86_64/docker-host

37 metadata, 38 content objects fetched; 86458 KiB transferred in 4 secondsCopying /etc changes: 25 modified, 0 removed, 42 added
Transaction complete; bootconfig swap: yes deployment count change: 1
Deleting ref 'fedora-atomic:fedora-atomic/f22/x86_64/docker-host'
Removed:
  docker-storage-setup-0.0.4-2.fc22.noarch
Added:
  iptables-services-1.4.21-14.fc22.x86_64
</code></pre>

Not a lot happened with this rebase, since only two packages had changed. But this was a successful rebase and we can try rebooting into it with `systemctl reboot`. But first, we can check `rpm-ostree status` to see how the new deployment has landed.

<pre><code>f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSION   ID             OSNAME            REFSPEC
  2015-09-23 13:52:23     22        edbe79d713     fedora-atomic     f22-test:fedora-atomic/f22/x86_64/docker-host      
* 2015-05-21 19:01:46     22.17     06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host 
</code></pre>

After the reboot, we can check `rpm-ostree status` again. But we should also see if that `docker-storage-setup` package was actually removed.

<pre><code>f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSION   ID             OSNAME            REFSPEC                                            
* 2015-09-23 13:52:23     22        edbe79d713     fedora-atomic     f22-test:fedora-atomic/f22/x86_64/docker-host      
  2015-05-21 19:01:46     22.17     06a63ecfcf     fedora-atomic     fedora-atomic:fedora-atomic/f22/x86_64/docker-host 
f22-atomic-host# rpm -qi docker-storage-setup
package docker-storage-setup is not installed
</code></pre>

There! We did an `ostree` compose and had an Atomic host rebase to it successfully!

## Practice custom ostree compose

With the vanilla compose under out belt, let's try to add some packages to our compose. The mechanics are the same that is covered in the blog post mentioned earlier, so I'm going to keep these steps relatively short.

For the custom `ostree` compose, we are going to add `emacs` and `vim`. This is done by creating a custom JSON file in the fedora-atomic git checkout on the Fedora system where we did the original compose.

<pre><code># cat /home/working/fedora-atomic/fedora-atomic-editors.json
{
  "include": "fedora-atomic-docker-host.json",
  "packages": ["emacs", "vim"]
}
</code></pre>

Then we create a new profile in the `fedora-atomic/config.ini` file. The profile is indicated by the new **[editors]** section in the file:

<pre><code># tail /home/working/fedora-atomic/config.ini
ref         = %(os_name)s/%(release)s/%(arch)s/%(tree_name)s
yum_baseurl = https://dl.fedoraproject.org/pub/fedora/linux/releases/22/Everything/%(arch)s/os/
# lorax_additional_repos = http://127.0.0.1/fedora-atomic/local-overrides
lorax_include_packages = fedora-productimg-atomic
docker_os_name = fedora

[editors]
tree_name = editors
ref       = %(os_name)s/%(release)s/%(arch)s/%(tree_name)s
tree_file = %(os_name)s-editors.json
</code></pre>

Now we can do a new compose using nearly the same `rpm-ostree-toolbox` command as before. The only change is we supply the `-p editors` argument to the command, which instructs the toolbox to use the new **editors** profile we created.

    # cd /home/working/
    # rpm-ostree-toolbox treecompose -c fedora-atomic/config.ini --ostreerepo /srv/rpm-ostree/fedora-atomic/22/ -p editors

After that compose has completed, we can do the same steps to serve up the tree on the network and rebase to it on the Atomic host.

    # ostree trivial-httpd -p - /srv/rpm-ostree/fedora-atomic/22/
    52867

On the Atomic host, we'll add another remote pointing to the new port and then do a rebase. Note that when we do the rebase, we specify the **editors** ref.

<pre><code>f22-atomic-host# ostree remote add f22-editors http://192.168.122.219:52867 --no-gpg-verify
f22-atomic-host# ostree remote list -u
f22-editors http://192.168.122.219:52867 
f22-test http://192.168.122.219:43620
fedora-atomic http://dl.fedoraproject.org/pub/fedora/linux/atomic/22/ 
f22-atomic-host# rpm-ostree rebase f22-editors:fedora-atomic/f22/x86_64/editors
668 metadata, 13543 content objects fetched; 192236 KiB transferred in 19 secondsCopying /etc changes: 25 modified, 0 removed, 43 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Freed objects: 100.5 MB
Deleting ref 'f22-test:fedora-atomic/f22/x86_64/docker-host'
Added:
  GConf2-3.2.6-11.fc22.x86_64
  ImageMagick-libs-6.8.8.10-9.fc22.x86_64
  OpenEXR-libs-2.2.0-1.fc22.x86_64
  adwaita-cursor-theme-3.16.2.1-1.fc22.noarch
  adwaita-icon-theme-3.16.2.1-1.fc22.noarch
...
  vim-common-2:7.4.640-4.fc22.x86_64
  vim-enhanced-2:7.4.640-4.fc22.x86_64
  vim-filesystem-2:7.4.640-4.fc22.x86_64
  xorg-x11-font-utils-1:7.5-28.fc22.x86_64
# rpm-ostree status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC                                       
  2015-09-23 14:55:56     22         bed6673466     fedora-atomic     f22-editors:fedora-atomic/f22/x86_64/editors  
* 2015-09-23 13:52:23     22         edbe79d713     fedora-atomic     f22-test:fedora-atomic/f22/x86_64/docker-host 
</code></pre>

You can see that a number of packages were added in support of `emacs` and `vim`. And when we reboot into the new deployment, we can confirm that `emacs` and `vim` are installed.

<pre><code>f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC                                       
* 2015-09-23 14:55:56     22         bed6673466     fedora-atomic     f22-editors:fedora-atomic/f22/x86_64/editors  
  2015-09-23 13:52:23     22         edbe79d713     fedora-atomic     f22-test:fedora-atomic/f22/x86_64/docker-host 
f22-atomic-host# rpm -qa | grep emacs
emacs-common-24.5-2.fc22.x86_64
emacs-24.5-2.fc22.x86_64
emacs-filesystem-24.5-2.fc22.noarch
f22-atomic-host# rpm -qa | grep vim
vim-enhanced-7.4.640-4.fc22.x86_64
vim-filesystem-7.4.640-4.fc22.x86_64
vim-minimal-7.4.640-4.fc22.x86_64
vim-common-7.4.640-4.fc22.x86_64
f22-atomic-host# file /usr/bin/vim
/usr/bin/vim: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=ab955a8dd49fcab6dcbc0a08178fe498a33f384e, stripped
f22-atomic-host# file /usr/bin/emacs
/usr/bin/emacs: symbolic link to `/etc/alternatives/emacs'
</code></pre>

Another tree composed and rebased to! Onward to building `ostree` from source!

## Building ostree from source

To start, we are going to need all the tools and dependencies that building `ostree` requires. The easiest way to do this is to use `yum-builddep`. On the Fedora server where we have been doing the composes, install those dependencies.

    # yum-builddep ostree

Once those dependencies have been installed, we can clone the [ostree repo](https://github.com/GNOME/ostree.git)

<pre><code># cd /home/working 
# git clone https://github.com/GNOME/ostree.git
Cloning into 'ostree'...
remote: Counting objects: 15576, done.
remote: Compressing objects: 100% (29/29), done.
remote: Total 15576 (delta 14), reused 0 (delta 0), pack-reused 15547
Receiving objects: 100% (15576/15576), 7.61 MiB | 1.87 MiB/s, done.
Resolving deltas: 100% (10184/10184), done.
Checking connectivity... done.
</code></pre>

Then we can try building it. The [README.md](https://github.com/GNOME/ostree/blob/master/README.md) in the `ostree` repo has some straightforward instructions on how to do this. I picked up some additional options to be used from [Colin Walters](https://github.com/cgwalters) along the way.

First, we use the `autogen.sh` script:

<pre><code># cd /home/working/ostree/
# env NOCONFIGURE=1 ./autogen.sh
Submodule 'bsdiff' (https://github.com/mendsley/bsdiff) registered for path 'bsdiff'
Submodule 'libglnx' (https://git.gnome.org/browse/libglnx) registered for path 'libglnx'
Cloning into 'bsdiff'...
remote: Counting objects: 224, done.
remote: Total 224 (delta 0), reused 0 (delta 0), pack-reused 224
Receiving objects: 100% (224/224), 52.41 KiB | 0 bytes/s, done.
Resolving deltas: 100% (86/86), done.
Checking connectivity... done.
Submodule path 'bsdiff': checked out '1edf9f656850c0c64dae260960fabd8249ea9c60'
Cloning into 'libglnx'...
remote: Counting objects: 204, done.
remote: Compressing objects: 100% (204/204), done.
remote: Total 204 (delta 128), reused 0 (delta 0)
Receiving objects: 100% (204/204), 63.31 KiB | 0 bytes/s, done.
Resolving deltas: 100% (128/128), done.
Checking connectivity... done.
Submodule path 'libglnx': checked out 'e684ef07f03dd563310788c90b3cdb00bac551eb'
autoreconf: Entering directory `.'
autoreconf: configure.ac: not using Gettext
autoreconf: running: aclocal --force -I m4 ${ACLOCAL_FLAGS}
autoreconf: configure.ac: tracing
autoreconf: running: libtoolize --copy --force
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `build-aux'.
libtoolize: copying file `build-aux/ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
autoreconf: running: /usr/bin/autoconf --force
autoreconf: running: /usr/bin/autoheader --force
autoreconf: running: automake --add-missing --copy --force-missing
configure.ac:11: installing 'build-aux/compile'
configure.ac:31: installing 'build-aux/config.guess'
configure.ac:31: installing 'build-aux/config.sub'
configure.ac:7: installing 'build-aux/install-sh'
configure.ac:7: installing 'build-aux/missing'
Makefile.am: installing 'build-aux/depcomp'
parallel-tests: installing 'build-aux/test-driver'
autoreconf: Leaving directory `.'
</code></pre>

Then we use `./configure` with some of those extra options

    # ./configure --prefix=/usr --libdir=/usr/lib64 --sysconfdir=/etc

The end result should look something like this:

<pre><code>...
config.status: executing libtool commands
    OSTree 2015.8
    ===============
    introspection:                                yes
    libsoup (retrieve remote HTTP repositories):  yes
    libsoup TLS client certs:                     yes
    SELinux:                                      yes
    libarchive (parse tar files directly):        yes
    static deltas:                                yes
    documentation:                                no
    gjs-based tests:                              yes
    dracut:                                       no
    mkinitcpio:                                   no
</code></pre>

Now we can use `make` (I've removed a lot of the output generated by `make`...)

<pre><code># make
make  all-recursive
make[1]: Entering directory '/home/working/ostree'
Making all in .
make[2]: Entering directory '/home/working/ostree'
...
  GISCAN   OSTree-1.0.gir
  GICOMP   OSTree-1.0.gir
make[2]: Leaving directory '/home/working/ostree'
make[1]: Leaving directory '/home/working/ostree'
</code></pre>

And you should have a functional `ostree` command in the current directory

<pre><code># pwd
/home/working/ostree
# ./ostree --version
ostree 2015.8
  +libsoup +gpgme +libarchive +selinux
</code></pre>

Now that we've proved we can build `ostree` from source, let's package it in an RPM so that we can include it in a custom `ostree` compose. Thankfully, the folks working on `ostree` have made it very simple. We just need to make sure we have the `rpm-build` package (and dependencies) installed.

    # dnf install rpm-build

To create the RPM, we go into the `ostree/packaging` directory and just run a simple `make` command specifying the **rpm** target. There will be a ton of output generated, probably some warnings too, but if it gets to `exit 0` at the end, it has more than likely been successful.

<pre><code># cd /home/working/ostree/packaging/
# ls
91-ostree.preset  Makefile.dist-packaging  ostree.spec.in  rpmbuild-cwd
# make -f Makefile.dist-packaging rpm
rm -f *.tar.xz
set -x; \
echo "PACKAGE=ostree"; \
TARFILE_TMP=ostree-2015.8.16.g1181833.tar.tmp; \
...
Processing files: ostree-debuginfo-2015.8.16.g1181833-3.fc22.x86_64
Checking for unpackaged file(s): /usr/lib/rpm/check-files /home/working/ostree/packaging/tmp-packaging/.build/ostree-2015.8.16.g1181833-3.fc22.x86_64
Wrote: /home/working/ostree/packaging/tmp-packaging/x86_64/ostree-2015.8.16.g1181833-3.fc22.x86_64.rpm
Wrote: /home/working/ostree/packaging/tmp-packaging/x86_64/ostree-devel-2015.8.16.g1181833-3.fc22.x86_64.rpm
Wrote: /home/working/ostree/packaging/tmp-packaging/x86_64/ostree-grub2-2015.8.16.g1181833-3.fc22.x86_64.rpm
Wrote: /home/working/ostree/packaging/tmp-packaging/x86_64/ostree-debuginfo-2015.8.16.g1181833-3.fc22.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.JgCDTd
+ umask 022
+ cd /home/working/ostree/packaging/tmp-packaging
+ cd ostree-2015.8.16.g1181833
+ rm -rf /home/working/ostree/packaging/tmp-packaging/.build/ostree-2015.8.16.g1181833-3.fc22.x86_64
+ exit 0
</code></pre>

We can inspect the results and look for the newly created RPM files:

<pre><code># pwd
/home/working/ostree/packaging/
# ls -l *rpm
-rw-r--r--. 1 root root 319928 Sep 22 20:11 ostree-2015.8.14.ged86160-3.fc22.x86_64.rpm
-rw-r--r--. 1 root root 926916 Sep 22 20:11 ostree-debuginfo-2015.8.14.ged86160-3.fc22.x86_64.rpm
-rw-r--r--. 1 root root 115440 Sep 22 20:11 ostree-devel-2015.8.14.ged86160-3.fc22.x86_64.rpm
-rw-r--r--. 1 root root   7448 Sep 22 20:11 ostree-grub2-2015.8.14.ged86160-3.fc22.x86_64.rpm
</code></pre>

Sure enough, there are our new `ostree` RPM files! Now we can use them in another custom `ostree` compose.

## Creating custom ostree composes with local repos

To include these new `ostree` RPMs in a custom compose, we have to create a local `yum` repo first. This is easily accomplished with the `createrepo` command.

    # dnf install createrepo

With the `createrepo` tool installed, we're going to copy over the RPMs into a directory (can be named anything you like) that will be used as our local `yum` repo. And then use `createrepo` to make it a local repo.

<pre><code># mkdir -p /srv/local-repo
# cp /home/working/ostree/packaging/*rpm /srv/local-repo/
# createrepo /srv/local-repo/
Spawning worker 0 with 4 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs complete
</code></pre>

Now we are going create a custom repo file in the `fedora-atomic` directory we were using before.

<pre><code># cd /home/working/fedora-atomic/
# cat local-testing.repo
[local-testing]
name=ostree local-testing
baseurl=file:///srv/local-repo/
enabled=0
gpgcheck=0
metadata_expire=1d
</code></pre>

With the repo file in place, we can create another custom JSON file that includes our local repo and `ostree` package we want to include in the `ostree` compose

<pre><code># cat fedora-atomic-ostree-testing.json
{
  "include": "fedora-atomic-docker-host.json",
  "repos": ["local-testing"],
  "packages" : ["ostree"]
}
</code></pre>

And include a profile in the `config.ini` file for our special `ostree` package

<pre><code># cat config.ini
...
[ostree-testing]
tree_name = ostree-testing
ref = %(os_name)s/%(release)s/%(arch)s/%(tree_name)s
tree_file = %(os_name)s-ostree-testing.json
</code></pre>

Finally, we use `rpm-ostree-toolbox` as before to create our compose, specifying the **ostree-testing** profile

    # cd /home/working
    # rpm-ostree-toolbox treecompose -c fedora-atomic/config.ini --ostreerepo /srv/rpm-ostree/fedora-atomic/22/ -p ostree-testing

It is useful during this step to inspect the file list that is generated during the compose to make sure the right version of the package is included in the compose:

    ---> Package ostree.x86_64 0:2015.8.16.g1181833-3.fc22 will be installed

When the compose is complete, serve it up with `ostree trivial-httpd` and point your Atomic host at the new remote.

<pre><code>...
Moving /boot
Using boot location: both
Copying toplevel compat symlinks
Adding tmpfiles-ostree-integration.conf
Ignored user missing from new passwd file: root
Ignored user missing from new passwd file: root
Committing '/var/tmp/rpm-ostree.SU5O5X/rootfs.tmp' ...
Labeling with SELinux policy 'targeted'
fedora-atomic/f22/x86_64/ostree-testing => d6b2df2246475378bb42399e52886acf145e8a5d6f85c5854cada650de727521
Complete
fedora-atomic/f22/x86_64/ostree-testing => d6b2df2246475378bb42399e52886acf145e8a5d6f85c5854cada650de727521
# ostree trivial-httpd -p - /srv/rpm-ostree/fedora-atomic/22/
38824
</code></pre>

On the Atomic host:

<pre><code>f22-atomic-host# ostree remote add f22-ostree-testing http://192.168.122.219:38824 --no-gpg-verify
f22-atomic-host# rpm-ostree rebase f22-ostree-testing:fedora-atomic/f22/x86_64/ostree-testing
21 metadata, 30 content objects fetched; 86750 KiB transferred in 2 secondsCopying /etc changes: 25 modified, 0 removed, 44 added
Transaction complete; bootconfig swap: yes deployment count change: 0
Freed objects: 100.6 MB
Deleting ref 'f22-editors:fedora-atomic/f22/x86_64/editors'
Changed:
  ostree-2015.8.16.g1181833-3.fc22.x86_64
  ostree-grub2-2015.8.16.g1181833-3.fc22.x86_64
Removed:
  GConf2-3.2.6-11.fc22.x86_64
  ImageMagick-libs-6.8.8.10-9.fc22.x86_64
...
  rest-0.7.93-1.fc22.x86_64
  urw-fonts-3:2.4-20.fc22.noarch
  vim-common-2:7.4.640-4.fc22.x86_64
  vim-enhanced-2:7.4.640-4.fc22.x86_64
  vim-filesystem-2:7.4.640-4.fc22.x86_64
  xorg-x11-font-utils-1:7.5-28.fc22.x86_64
f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSION    ID             OSNAME            REFSPEC
  2015-09-23 16:59:39     22         d6b2df2246     fedora-atomic     f22-ostree-testing:fedora-atomic/f22/x86_64/ostree-testing
* 2015-09-23 14:55:56     22         bed6673466     fedora-atomic     f22-editors:fedora-atomic/f22/x86_64/editors     
</code></pre>

When we reboot into the new deployment, we can verify that the custom built `ostree` package was included in the tree.

<pre><code>f22-atomic-host# rpm-ostree status
  TIMESTAMP (UTC)         VERSIONID             OSNAME            REFSPEC                                               
* 2015-09-23 16:59:39     22     d6b2df2246     fedora-atomic     f22-ostree-testing:fedora-atomic/f22/x86_64/ostree-testing  
  2015-09-23 14:55:56     22     bed6673466     fedora-atomic     f22-editors:fedora-atomic/f22/x86_64/editors                
f22-atomic-host# rpm -qa | grep ostree
ostree-2015.8.16.g1181833-3.fc22.x86_64
ostree-grub2-2015.8.16.g1181833-3.fc22.x86_64
rpm-ostree-2015.3-8.fc22.x86_64
f22-atomic-host# ostree --version
ostree 2015.8
  +libsoup +gpgme +libarchive +selinux
</code></pre>

Success!

This likely just scratches the surface of what you can do with custom `ostree` composes. But it is the first step.

I want to give a shout out to all those people who helped along the way:

*   [Brent Baude](https://github.com/baude) - who did all the hard work by documenting the custom tree compose steps on the Red Hat Developer Blog
*   [Colin Walters](https://github.com/cgwalters) - who is the architect of `ostree` and taught me how to build it from source
*   [Matthew Barnes](https://github.com/mbarnes) - who fielded all my questions about packaging `ostree` into an RPM, creating a local repo with it, and doing a custom compose with that repo

Please let me know if you have any questions or feedback. Or drop in at #atomic on Freenode.