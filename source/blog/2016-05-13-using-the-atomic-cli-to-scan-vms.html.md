---
title: Using the Atomic CLI to Scan Virtual Machines
author: baude
date: 2016-05-13 12:00:00 UTC
published: true
comments: true
tags: security, atomic CLI, atomic scan
---

Recently on the Red Hat Developers blog, I wrote about the re-architecture of the [atomic vulnerability scan feature](http://developers.redhat.com/blog/2016/05/02/introducing-atomic-scan-container-vulnerability-detection/).   The primary function of _[atomic](https://github.com/projectatomic/atomic) scan_ is to detect vulnerabilities in your images and containers using a plug-in enabled architecture.

Building upon that concept, we added an additional feature to _atomic scan_ where you can now pass a chroot to it for the purposes of scanning.  One immediate benefit from this change was that we can now use the same scanner for our images and containers to scan a virtual machine (VM) that has been mounted onto the host's filesystem.

In this blog, I will show you how to scan a live VM with _atomic scan_.

READMORE

## Check for a Running VM

The first step is to see what VMs are on your system.  In my case, I have two VMs running; one of which was created for this purpose based on a RHEL 7.2 stock install with no updates.

```
[bbaude@localhost ~]$ sudo virsh list
 Id    Name                           State
----------------------------------------------------
 4     rhel7-scan                     running
 5     centos                         running

```
The VM I want to work with is called _rhel7-scan_.

## Check the Filesystems in the VM

To mount a live VM to our filesystem, I plan to use a couple of applications from the libguestfs package.  While we do know which VM (sometimes referred to as a virtual domain) we want to work with, mounting VMs requires some basic knowledge of the VM's fileystems; specifically, we want to know more about the VM's root filesystem.  We can use _virt-filesystems_ to probe the VM's filesystems.

```
[bbaude@localhost ~]$ sudo virt-filesystems -d rhel7-scan
/dev/sda1
/dev/rhel/root
[bbaude@localhost ~]$
```

We now know the device associated with the root filesystem is _/dev/rhel/root_.  This is a required piece of information for mounting VMs.

## Mount the VM's Root Filesystem

The first step is to create a directory where the VM's root filesystem will reside after mounting.  In this case, I am going to simply create a directory called _/tmp/rhel_.

```
[bbaude@localhost ~]$ mkdir /tmp/rhel
```

Now, armed with the VM's name (or domain) and the root filesystem's device, we can use _guestmount_ to actually perform the mount.  Note here because the VM is live, I have choosen to mount the filesystem as read-only.  I also happen to know that the scanner does not need to write any files to the VM filesystem so read-only is appropriate.

```
[bbaude@localhost ~]$ sudo guestmount  -d rhel7-scan -m /dev/rhel/root --ro /tmp/rhel
```

The VM's root filesystem is now mounted and we can use _ls_ to take a peek at the chroot.

```
[bbaude@localhost ~]$ sudo ls -l /tmp/rhel
total 28
lrwxrwxrwx.  1 root root    7 May 11  2016 bin -> usr/bin
drwxr-xr-x.  2 root root    6 May 11  2016 boot
drwxr-xr-x.  2 root root    6 May 11  2016 dev
drwxr-xr-x. 77 root root 8192 May 11  2016 etc
drwxr-xr-x.  3 root root   18 May 11 13:48 home
lrwxrwxrwx.  1 root root    7 May 11  2016 lib -> usr/lib
lrwxrwxrwx.  1 root root    9 May 11  2016 lib64 -> usr/lib64
drwxr-xr-x.  2 root root    6 May 25  2015 media
drwxr-xr-x.  2 root root    6 May 25  2015 mnt
drwxr-xr-x.  2 root root    6 May 25  2015 opt
drwxr-xr-x.  2 root root    6 May 11  2016 proc
dr-xr-x---.  2 root root 4096 May 11 13:49 root
drwxr-xr-x.  2 root root    6 May 11  2016 run
lrwxrwxrwx.  1 root root    8 May 11  2016 sbin -> usr/sbin
drwxr-xr-x.  2 root root    6 May 25  2015 srv
drwxr-xr-x.  2 root root    6 May 11  2016 sys
drwxrwxrwt.  7 root root 4096 May 11  2016 tmp
drwxr-xr-x. 13 root root 4096 May 11  2016 usr
drwxr-xr-x. 19 root root 4096 May 11  2016 var
```

## Prepare to Scan the Mounted Filesystem

Before we jump into scanning the filesystem, you should verify what scanners (plug-ins) are installed for atomic.  As my previous blog has shown, you can simply use _atomic scan --list_ to see what scanners are currently configured for you.

```
[bbaude@localhost ~]$ sudo atomic scan --list
Scanner: openscap *
  Image Name: openscap
     Scan type: cve *
     Description: Performs a CVE scan based on known CVE data

     Scan type: standards_compliance
     Description: Performs a standard scan


* denotes defaults
```

Based on this output, there is only one scanner available.  It is called _openscap_ and has two different scans avilable: _cve_ and _standards_compliance_.  The _cve_ scan is the noted as the default.  

If you are not familiar with the _atomic scan_ function, you can simply learn more with the _--help_ switch or read the man page.  The key item we need to know about is the _--rootfs_ command line switch.  This switch requires a filesystem path as a value.

```
[bbaude@localhost ~]$ sudo atomic scan --help
usage: atomic scan [-h] [--scanner {openscap}] [--scan_type SCAN_TYPE]
                   [--list] [--verbose] [--rootfs [ROOTFS] | --all | --images
                   | --containers]
                   [scan_targets [scan_targets ...]]

positional arguments:
  scan_targets          container image

optional arguments:
  -h, --help            show this help message and exit
  --scanner {openscap}  define the intended scanner
  --scan_type SCAN_TYPE
                        define the intended scanner
  --list                List available scanners
  --verbose             Show more output from scanning container
  --rootfs [ROOTFS]     Rootfs path to scan
  --all                 scan all images (excluding intermediate layers) and
                        containers
  --images              scan all images (excluding intermediate layers)
  --containers          scan all containers

atomic scan <input> scans a container or image for CVEs
```

## Scan the Filesystem Using Atomic Scan

At this point, we have all the information we need to perform the scan.  It is now only a matter of executing the command properly.  The command syntax is simply _atomic scan --rootfs <path_to_rootfs>_.  You can also enable the _--verbose_ command line switch to see more output, which is good for debug purposes.

**Note**:  Because I already have the openscap image pulled locally, you will not see it being pulled.  Of course, if you do not have the image local, your output will vary slightly.

```
[bbaude@localhost ~]$ sudo atomic scan --rootfs /tmp/rhel
docker run -it --rm -v /etc/localtime:/etc/localtime -v /run/atomic/2016-05-11-13-54-05-804238:/scanin -v /var/lib/atomic/openscap/2016-05-11-13-54-05-804238:/scanout:rw,Z --security-opt label:disable openscap oscapd-evaluate scan --no-standard-compliance --targets chroots-in-dir:///scanin --output /scanout

/tmp/rhel (/tmp/rhel)

The following issues were found:

     RHSA-2016:1025: pcre security update (Important)
     Severity: Important
       RHSA URL: https://rhn.redhat.com/errata/RHSA-2016-1025.html
       RHSA ID: RHSA-2016:1025-00
       Associated CVEs:
           CVE ID: CVE-2015-2328
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-2328
           CVE ID: CVE-2015-3217
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-3217
           CVE ID: CVE-2015-5073
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-5073
           CVE ID: CVE-2015-8385
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-8385
           CVE ID: CVE-2015-8386
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-8386
           CVE ID: CVE-2015-8388
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-8388
           CVE ID: CVE-2015-8391
           CVE URL: https://access.redhat.com/security/cve/CVE-2015-8391
           CVE ID: CVE-2016-3191
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-3191

     RHSA-2016:0722: openssl security update (Important)
     Severity: Important
       RHSA URL: https://rhn.redhat.com/errata/RHSA-2016-0722.html
       RHSA ID: RHSA-2016:0722-00
       Associated CVEs:
           CVE ID: CVE-2016-0799
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-0799
           CVE ID: CVE-2016-2105
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2105
           CVE ID: CVE-2016-2106
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2106
           CVE ID: CVE-2016-2107
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2107
           CVE ID: CVE-2016-2108
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2108
           CVE ID: CVE-2016-2109
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2109
           CVE ID: CVE-2016-2842
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-2842

     RHSA-2016:0685: nss, nspr, nss-softokn, and nss-util security, bug fix, and enhancement update (Moderate)
     Severity: Moderate
       RHSA URL: https://rhn.redhat.com/errata/RHSA-2016-0685.html
       RHSA ID: RHSA-2016:0685-00
       Associated CVEs:
           CVE ID: CVE-2016-1978
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-1978
           CVE ID: CVE-2016-1979
           CVE URL: https://access.redhat.com/security/cve/CVE-2016-1979

...
Content removed due to length
...

Files associated with this scan are in /var/lib/atomic/openscap/2016-05-11-13-54-05-804238.
```

As you can see, there are least three vulnerabilities caught here.  The rest were clipped in the interest of space.

## Unmount the VM's Filesystem

Don't forget to unmount the VM's filesystem when your scan is complete.  In my case, I want to remediate the VM to shore up the vulnerabilties.

```
[bbaude@localhost ~]$ sudo guestunmount /tmp/rhel
```

## Remediate the Vulnerabilties and Rescan

As I said earlier, this VM we scanned was based on a stock RHEL7.2 install without any updates.  This was obviously done on purpose to demonstrate the scan first.  I then logged into the VM and updated the system entirely and will now remount the VM filesystem and rescan.

```
[bbaude@localhost ~]$ sudo guestmount  -d rhel7-scan -m /dev/rhel/root --ro /tmp/rhel
[bbaude@localhost ~]$ sudo atomic scan --rootfs /tmp/rhel
docker run -it --rm -v /etc/localtime:/etc/localtime -v /run/atomic/2016-05-12-10-55-44-763361:/scanin -v /var/lib/atomic/openscap/2016-05-12-10-55-44-763361:/scanout:rw,Z --security-opt label:disable openscap oscapd-evaluate scan --no-standard-compliance --targets chroots-in-dir:///scanin --output /scanout

/tmp/rhel (/tmp/rhel)

/tmp/rhel passed the scan

Files associated with this scan are in /var/lib/atomic/openscap/2016-05-12-10-55-44-763361.

[bbaude@localhost ~]$ sudo guestunmount /tmp/rhel
[bbaude@localhost ~]$  
```

The scan is clean and no vulnerabilities are found.

Using the _atomic scan_ function with the openSCAP project is not only an easy way to find vulnerabilities in your RHEL based images and containers, but it can basically scan and chroot filesystem that is RHEL including read-only mounts of VM root filesystems.  It is a quick, singular way to perform the scan.
