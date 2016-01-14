---
title: atomic diff
author: baude
date: 2016-01-07 20:34:42 UTC
published: false
comments: true
---

The original mission of the [atomic application](https://github.com/projectatomic/atomic) to install, manage, and run container images using container Labels, has slowly been growing.  We have been concentrating on ease of use and value-add functions for containers and images. We recently added the `atomic diff` command.  This command allows you to differentiate between two container images. This is critically important if you are like me and you have hundreds of container images on your system. I also use it when I pull an updated image from a repository and want to see what has changed.

**Note:** While docker itself has a subcommand called diff, it is only useful when trying to determine the difference between a container and its image.  It does not compare two different docker objects looking for differences amongst them.

The atomic diff command is fairly simple to run.  By default it will provide a file level diff between the two docker-based objects grouped by:

* files only found in docker object A
* files only found in docker object B
* files found in both docker objects but differ

It can optionally also evaluate the differences between those same objects if they are RPM-based.  Looking at a real-world example will probably illuminate its usefulness more readily.

For this example, I have created two simple images that use the CentOS base image as a seed image. In one image I have added the package wget and in the other, I have added the package less.  The two Dockerfiles respectively are:

```
FROM docker.io/centos:latest
RUN yum -y install less && yum clean all

```
```
FROM docker.io/centos:latest
RUN yum -y install wget && yum clean all
```

And my docker images looks like:

```
REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
centos_with_less    latest              29ef3785d2d7        About a minute ago   217.2 MB
centos_with_wget    latest              3b32e38b6eb0        18 minutes ago       214.3 MB
docker.io/centos    latest              c8a648134623        2 weeks ago          196.6 MB
```
To perform an atomic diff of these two images, we simply issue the atomic diff command followed by the two image ID's or names.  Because we are not passing any additional switches to the atomic command, the output will look like:
```
$ sudo atomic diff centos_with_less centos_with_wget
Files only in centos_with_less:
     /bin/gtroff
     /bin/troff
     /bin/lessecho
     /bin/lesspipe.sh
     /bin/lesskey
     /bin/gtbl
     /bin/zsoelim
     /bin/gnroff
     # content ommited for space

Files only in centos_with_wget:
     /bin/wget
     /run/secrets
     /etc/wgetrc
     /usr/bin/wget
     /usr/share/locale/en_GB/LC_MESSAGES/wget.mo
     # content ommited for space

Common files that are different:
     /var/lib/yum/history/history-2015-12-23.sqlite
     /var/lib/yum/history/history-2015-12-23.sqlite-journal
     /var/lib/rpm/Packages
     /var/lib/rpm/Group
     /var/lib/rpm/Name
     /var/lib/rpm/Sha1header
     # content ommited for space
```

In these results, we can observe all three potential groups or categories.  In the output of 'Files only in centos_with_less', we can see evidence of the less RPM by the groff related RPM dependency.  In the 'Files only in centos_with_wget' output, we see the wget binary itself.  And in the 'Common files that are different' category, we can see that both docker objects have a file called '/var/lib/Packages' but they differ, which makes good sense as that file is altered by yum/rpm when a package is added or removed.

I also mentioned earlier that atomic diff can differentiate between two RPM-based docker objects.  This can be done by adding the -r or --rpms switch to the atomic diff command.  In the next example, I will perform an atomic diff passing -r to evaluate the RPMs and -n which tells atomic diff to not evaluate the files (as we did above).

```
$ sudo atomic diff -r -n centos_with_less centos_with_wget

centos_with_less                  | centos_with_wget
--------------------------------- | ---------------------------------
CentOS Linux release 7.2.1511 (   | CentOS Linux release 7.2.1511 (  
Core)                             | Core)
--------------------------------- | ---------------------------------
groff-base-0-1.22.2               |
less-0-458                        |
                                  | wget-0-1.14

```

By default, we only show the RPMs that differ.  If you pass the -v (verbose) flag, it will show all the common RPMs as well.

One useful switch is the --json switch which output the results in json format.  This can be handy if you have a tool that perhaps analyzes the results because you can pipe the ouput into your own tooling.  An example of the JSON-based output is as follows:

```{
    "centos_with_less": {
        "release": "CentOS Linux release 7.2.1511 (Core) \n",
        "all_rpms": [
            "acl-0-2.2.51",
            "audit-libs-0-2.4.1",
            "basesystem-0-10.0",
            # content ommited for space
        ],
        "exclusive_rpms": [
            "groff-base-0-1.22.2",
            "less-0-458"
        ],
        "common_rpms": [
            "acl-0-2.2.51",
            "audit-libs-0-2.4.1",
            "basesystem-0-10.0",
            # content ommited for space
        ]
    },
    "centos_with_wget": {
        "release": "CentOS Linux release 7.2.1511 (Core) \n",
        "all_rpms": [
            "acl-0-2.2.51",
            "audit-libs-0-2.4.1",
            "basesystem-0-10.0",
            # content ommited for space
        ],
        "exclusive_rpms": [
            "wget-0-1.14"
        ],
        "common_rpms": [
            "acl-0-2.2.51",
            "audit-libs-0-2.4.1",
            "basesystem-0-10.0",
            # content ommited for space
        ]
    }
}
```

The next time you need to perform some analysis between two docker objects, remember that atomic diff exists and can do some of the heavy lifting for you.  It works on comparing images to images, images to containers, and containers to containers.
