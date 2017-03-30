---
title: Introducing Minishift - Run OpenShift locally
date: 2017-03-30 05:45 UTC
author: budhram
published: true
comments: true
tags: minishift, atomic-developer-bundle, openshift-local
---

We would like to introduce you to [Minishift](https://github.com/minishift/minishift) which provides a far better user experience as compared to [Atomic Developer Bundle (ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle). We have shifted our development effort from ADB to Minishift, to improve the user experience as well as to address Vagrant related issues being faced by our users. We'll explain this more in a later blog post.

Minishift is a CLI tool that helps you run OpenShift locally by running a single-node cluster inside a VM. You can try out OpenShift or develop with it, day-to-day, on your local host.

It is actually a single binary which uses [libmachine](https://github.com/docker/machine/tree/master/libmachine) to provision a VM with a local, single node, [OpenShift Origin](https://github.com/openshift/origin) cluster. It uses [OpenShift local cluster management](https://github.com/openshift/origin/blob/master/docs/cluster_up_down.md) underneath to bring up single node cluster.

It's a platform agnostic CLI tool that supports multiple hypervisors like KVM for Linux, Xhyve for Mac OS, HyperV for Windows and VirtualBox in all OS platforms. Detailed instructions about it can be found in the [Minishift documentation](https://github.com/Minishift/minishift#prerequisites).

## Installing Minishift

1. Install your preferred VM platform on your workstation.

    **Note**: You need to install additional docker-machine driver for 'kvm' or 'xhyve'. See [Docker Machine drivers](https://docs.openshift.org/latest/minishift/getting-started/docker-machine-drivers.html) guide to install it properly.

1. Download the archive for your OS from the Minishift [releases page](https://github.com/minishift/minishift/releases) and unpack it.
1. Copy the contents of the directory to your preferred location.
1. Add the minishift binary to your PATH environment variable.

To install in specific OS, refer to the [minishift installation guide](https://github.com/Minishift/minishift#installing-minishift).

## Quickstart with Minishift

1. Get started as follows:

    ```
    $ minishift start
     Starting local OpenShift cluster using 'kvm' hypervisor...
     ...
        OpenShift server started.
        The server is accessible via web console at:
            https://192.168.99.128:8443

        You are logged in as:
            User:     developer
            Password: developer

        To login as administrator:
            oc login -u system:admin
    ```

    This will:
    - Download the latest [_minishift-b2d-iso_](https://github.com/Minishift/minishift-b2d-iso) (~40 MB)
    - Starts a VM using libmachine
    - Download OpenShift client binary (`oc`) with version `v1.5.0-rc.0` (This version might differ on other minishift version)
    - Cache both `oc` and ISO into your `$HOME/.minishift/cache` folder
    - Finally provisions OpenShift single node cluster

    **Note:** This step also logs you in as `developer` in the `myproject` project.

1. Export the OpenShift client binary (`oc`) to the _PATH_ environment variable as follows:

    ```
    $ export PATH=$HOME/.minishift/cache/oc/v1.5.0-rc.0:$PATH
    ```

1. Deploy a sample application as follows:
    - Create a Nodejs example application:

         ```
         $ oc new-app https://github.com/openshift/nodejs-ex -l name=myapp
         ```
    - Track the build log until the app is built and deployed using:

        ```
        $ oc logs -f bc/nodejs-ex
        ```
    - Expose a route to the service as follows:

        ```
        $ oc expose svc/nodejs-ex
        ```
    - Open the application in a browser as follows:

        ```
        $ minishift openshift service nodejs-ex -n myproject
        ```

1. When done with building the application for the day, stop the cluster as follows:

    ```
     $ minishift stop
     Stopping local OpenShift cluster...
     Stopping "minishift"...
    ```

    If you want to access the same cluster some other day, use `minishift start`.

1. At anytime if you want to delete the cluster, use the following command:

    ```
    $ minishift delete
    ```

Refer to the [Minishift README](https://github.com/Minishift/minishift#minishift) to get more detailed description of getting started with a single node OpenShift cluster.

## Feedback

Try Minishift!

We would love to get your feedback. If you hit a problem, please raise an issue in [minishift issue tracker](https://github.com/minishift/minishift/issues) but please search through the listed issues before creating it. It's possible that a similar issue is already open.

You could also reach us at our IRC channel as mentioned below.

## Community

The Minishift community hangs out on the IRC channel `#minishift` on Freenode (https://freenode.net). You are welcome to join, participate in the discussions, and contribute.

## Resources
- Github Repo: https://github.com/minishift/minishift
- Issue tracker: https://github.com/minishift/minishift/issues
- Documentation: https://github.com/minishift/minishift#documentation
- Minishift Home Page: https://www.openshift.org/minishift
