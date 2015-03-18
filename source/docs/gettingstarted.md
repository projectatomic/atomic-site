# Project Atomic Getting Started Guide

## About the Project
Project Atomic provides a platform to deploy and manage containers on bare-metal, virtual, or cloud-based servers.  Project Atomic hosts are designed to be minimal hosts focused on the delivery of container services.  The Atomic host is built using OStree, which delivers a set of file system objects rather than RPM packages.  OStree makes these file system objects immutable, rendering updates an atomic operation for easy update and rollback.  Container runtime is provided via docker, and container cluster management is provided by Kubernetes.  

## Prerequisites 
* **A virtualization client.** Virtual Machine Manager (virt-manager) is a very good KVM-based client for Linux systems. Windows and OS X users can give VirtualBox a try. Be sure your virtualization client is properly configured to access the Internet.  An Atomic host can be run under OpenStack or EC2 as well.

* **A virtual machine image.** Images for Atomic based on Fedora and CentOS are available for the supported virtualization options.

## Downloading Atomic
There are Atomic host images available from the Fedora Cloud SIG and the CentOS Atomic SIG.  The Fedora 21 [Atomic host images are available] (https://getfedora.org/en/cloud/download/) in Raw and QCOW2 formats, as well as an AMI.  The CentOS 7 [Atomic host image is available] (http://buildlogs.centos.org/rolling/7/isos/x86_64/ ) in QCOW2 format.

## Installing Atomic
At the moment, only pre-generated disk images are available.  A future
release will have Anaconda support and thus support all installation
scenarios that Anaconda does, including bare metal.  The basic procedure is to import the downloaded host image into your virtualization platform of choice, provide user and meta data to a cloud-init provider, and boot the virtual machine.

### Using virt-manager
See the [Quick Start Guide] (http://www.projectatomic.io/docs/quickstart/) for instructions on how to launch an Atomic host using virt-manager.  Be sure to create a new ISO for each host with an updated meta-data file with an incremented instance-id and correct local-hostname.

### Using VirtualBox
See the [Quick Start Guide] (http://www.projectatomic.io/docs/quickstart/) for instructions on how to launch an Atomic host using VirtualBox.  Be sure to create a new ISO for each host with an updated meta-data file with an incremented instance-id and correct local-hostname.

## Configuring and managing Atomic Host
Atomic hosts are minimal systems similar to hypervisors.  Some tools that would normally be used to manage packages and the system may not exist.  Therefore, we will set up a separate server to act as a master for the Atomic hosts, providing etcd services, Kubernetes master controller duties, and admin configuration access.

It's important to note that on an Atomic system, the `/etc` and `/var` directories are writable as they are on a traditional yum or dpkg managed system.  Any changes made to /etc are propagated forwards. The OSTree upgrade system does not ever change /var in any way.

At present, the primary expected method to install software locally is via docker containers.  You can also use `/usr/local` or `/opt` (in the OSTree model, these are really `/var/usrlocal` and `/var/opt`, respectively).

## Atomic fleet concepts
Clusters of Atomic hosts under control of a Kubernetes master server is the expected operating arrangement of an Atomic environment.  Kubernetes distributes and orchestrates the construction of pods on the Atomic hosts.  Pods are collections of docker containers that logically separate services in an application.  The principle of single responsibility is an important design pattern when looking at building scalable applications with Kubernetes.  

Flannel provides a distributed, tunneled overlay network for Atomic hosts.  This overlay network is used for inter-container networking only, while a Kubernetes proxy service provides for service level access to the host IP space. Etcd is used to distribute configurations for both Kubernetes and Flannel.

One host should be nominated to be the Atomic Kubernetes master server, with the other Atomic hosts providing minion container services.  Since Kubernetes and Flannel use etcd as the distributed store, multiple Atomic clusters would need to replicate a complete cluster to separate workloads.  For this guide, we're using 1 master host and 4 minions in the cluster.

Assumptions for IP addressing for following examples:

    atomic-master 192.168.122.10 kubernetes master
    atomic0[1-4] 192.168.122.1[1-4] kubernetes minions

## Building the fleet boss
Launch an Atomic host to act as the master node for the cluster.  We'll be installing the local docker cache, the etcd source, and the Kubernetes master services here.  As a good practice, update to the latest available Atomic tree. 

    [fedora@atomic-master ~]$ sudo atomic upgrade
    [fedora@atomic-master ~]$ sudo systemctl reboot

### Local Docker registry
Create a caching-only local registry mirror for use by the Kubernetes cluster.  This uses a local volume for persistence, need to explore data container for persistence.  Each Kubernetes cluster will have it's own local cache.

    [fedora@atomic-master ~]$ sudo systemctl enable docker
    [fedora@atomic-master ~]$ sudo systemctl start docker

Create the container using the Docker Hub registry image, exposing the standard Docker Hub port from the container on the host.  We're using a local host directory as a persistence layer for the images that get cached for use.  The other environment variables passed in to the registry set the source registry.  We're still using the Hub as the source, but you could set this to use a private registry instead of the public registry.

    [fedora@atomic-master~]$ sudo docker create -p 5000:5000 \
    -v /var/lib/local-registry:/srv/registry \
    -e STANDALONE=false \
    -e MIRROR_SOURCE=https://registry-1.docker.io \
    -e MIRROR_SOURCE_INDEX=https://index.docker.io \
    -e STORAGE_PATH=/srv/registry \
    --name=local-registry registry

We need to make sure we change the SELinux context on the directory that docker created for our persistence volume.

    [fedora@atomic-master ~]$ sudo chcon -Rvt svirt_sandbox_file_t /var/lib/local-registry

Since we want to make sure the local cache is always up, we'll create a systemd unit file to start it and make sure it stays running.  Reload the systemd daemon and start the new local-registry service.

    [fedora@atomic-master ~]$ sudo vi /etc/systemd/system/local-registry.service
    [Unit]
    Description=Local Docker Mirror registry cache
    Requires=docker.service
    After=docker.service

    [Service]
    Restart=on-failure
    RestartSec=10
    ExecStart=/usr/bin/docker start -a %p 
    ExecStop=-/usr/bin/docker stop -t 2 %p

    [Install]
    WantedBy=multi-user.target

    [fedora@atomic-master ~]$ sudo systemctl daemon-reload
    [fedora@atomic-master ~]$ sudo systemctl enable local-registry
    [fedora@atomic-master ~]$ sudo systemctl start local-registry

### Configuring Kubernetes master
We're using a single etcd server, not a replicating cluster in this guide.  This makes etcd simple, as it will work as needed out of the box.  No need to modify the etcd config file, just enable and start the daemon with all the rest of the Kubernetes services.

For Kubernetes, there's a few config files in /etc/kubernetes we need to set up for this host to act as a master.  First off is setting up the etcd store that Kubernetes will use.  We're using a single local etcd service, so we'll point that at the master on the standard port.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/config 
    KUBE_ETCD_SERVERS="--etcd_servers=http://192.168.122.10:4001"

The apiserver needs to be set to listen on all IP addresses, and where the apiserver will listen for the scheduler.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/apiserver 
    # The address on the local server to listen to.
    KUBE_API_ADDRESS="--address=0.0.0.0"
    # How the replication controller and scheduler find the kube-apiserver
    KUBE_MASTER="--master=192.168.122.10:8080"

The controller manager service needs to how to locate it's minions.  We're using IPs as addresses, which must match the KUBLET_HOSTNAME for the minions kublet service. If hostnames are used, must resolve to match output of `hostname -f` on the minion.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/controller-manager 
    # Comma seperated list of minions
    KUBELET_ADDRESSES="--machines=192.168.122.11,192.168.122.12,192.168.122.13,192.168.122.14"

Enable and start the Kubernetes services.

    [fedora@atomic-master ~]$ sudo systemctl enable etcd kube-apiserver kube-controller-manager kube-scheduler
    [fedora@atomic-master ~]$ sudo systemctl start etcd kube-apiserver kube-controller-manager kube-scheduler

### Configuring the Flannel overlay network
Flanneld provides a tunneled network configuration via etcd.  To push the desired config into etcd, we'll create a JSON file with the options we want and use curl to push the data.  We've selected a /12 network to create a /24 subnet per minion.  

    [fedora@atomic-master ~]$ vi flanneld-conf.json
    {
      "Network": "172.16.0.0/12",
      "SubnetLen": 24,
      "Backend": {
        "Type": "vxlan"
      }
    }

We'll create a keyname specific to this cluster to store the network configuration.  While we're using a single etcd server in a single cluster for this example, setting non-overlapping keys allows us to have a cluster of etcd servers for several Atomic clusters.

    [fedora@atomic-master ~]$ curl -L http://localhost:4001/v2/keys/atomic01/network/config -XPUT --data-urlencode value@flanneld-conf.json

Just to make sure we have the right config, we'll pull it via curl and parse the JSON return.

    [fedora@atomic-master ~]$ curl -L http://localhost:4001/v2/keys/atomic01/network/config | python -m json.tool  
    {
        "action": "get",
        "node": {
            "createdIndex": 11,
            "key": "/atomic01/network/config",
            "modifiedIndex": 11,
            "value": "{\n  \"Network\": \"172.16.0.0/12\",\n  \"SubnetLen\": 24,\n  \"Backend\": {\n    \"Type\": \"vxlan\"\n  }\n}\n\n"
        }
    }

## Atomic Minions
Launch your first Atomic host to act as a minion node for the cluster.  We'll be installing the Kubernetes minion services and configuring docker to use Flannel and our cache.  These nodes will act as the workers and run Pods and containers.  You can repeat this on as many nodes as you like to provide resources to the cluster.  In our master example, we've set up 4 minions.  As a good practice, update to the latest available Atomic tree. 

    [fedora@atomic01 ~]$ sudo atomic upgrade
    [fedora@atomic01 ~]$ sudo systemctl reboot


### Configuring Docker to use the cluster registry cache
Add the local cache registry running on the master to the docker options that get pulled into the systemd unit file.

    [fedora@atomic01 ~]$ sudo vi /etc/sysconfig/docker
    OPTIONS='--registry-mirror=http://192.168.122.10:5000 --selinux-enabled'

### Configuring Docker to use the Flannel overlay
To set up flanneld, we just need to point the local flannel service to the etcd service on the master serving up the config from the right key for the cluster.

    [fedora@atomic01 ~]$ sudo vi /etc/sysconfig/flanneld 
    # etcd url location.  Point this to the server where etcd runs
    FLANNEL_ETCD="http://192.168.122.10:4001"

    # etcd config key.  This is the configuration key that flannel queries
    # For address range assignment
    FLANNEL_ETCD_KEY="/atomic01/network"


To get docker using the flanneld overlay, we'll change the networking config to use the flanneld provided bridge IP and MTU settings.  We'll also change the unit definition to wait for flanneld to start.  That way the environment file created by flanneld is available and will provide a usable address for the docker0 bridge.  

Using a systemd drop-in file allows us to override the distributed systemd unit file without making direct modifications.  The blank `ExecStart=` line erases all previously defined `ExecStart` directives and only subsequent `ExecStart` lines will be used by systemd.

    [fedora@atomic01 ~]$ sudo mkdir -p /etc/systemd/system/docker.service.d/
    [fedora@atomic01 ~]$ sudo vi /etc/systemd/system/docker.service.d/10-flanneld-network.conf 
    
    [Unit]
    After=flanneld.service
    Requires=flanneld.service

    [Service]
    EnvironmentFile=/run/flannel/subnet.env
    ExecStartPre=-/usr/sbin/ip link del docker0
    ExecStart=
    ExecStart=/usr/bin/docker -d --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU} $OPTIONS $DOCKER_STORAGE_OPTIONS

### Configuring Kubernetes minions

***NOTE:***
As of kubernetes-0.7.0, the kubelet systemd unit file has a dependency on the docker.socket systemd unit.  This unit was deprecated in favor of docker.service.  A fix has been submitted and is available in kubernetes-0.9.1.  If you have an earlier version of Kubernetes, you can use the following systemd drop-in config as a workaround.

    [fedora@atomic01 ~]$ sudo mkdir -p /etc/systemd/system/kubelet.service.d
    [fedora@atomic01 ~]$ sudo vi /etc/systemd/system/kubelet.service.d/10-kubelet-docker-workaround.conf

    [Unit]
    After=docker.service cadvisor.service
    Requires=docker.service

The address entry in the kubelet config file must match the KUBLET_ADDRESSES entry on the master.   If hostnames are used, this also must match output of `hostname -f` on the minion.  We're using the eth0 IP address like we did on the master.

We are also setting up the cluster dns settings to allow service ip resolution using kube-dns. Make sure you put the space in before the first parameter in KUBELET_ARGS, otherwise the kubelet daemon sees the rest of the line as a single parameter to cluster_dns and will fail to start up.

    [fedora@atomic01 ~]$ sudo vi /etc/kubernetes/kubelet 
    # The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
    KUBELET_ADDRESS="--address=192.168.122.11"

    # You may leave this blank to use the actual hostname
    KUBELET_HOSTNAME="--hostname_override=192.168.122.11"

    # Add your own!
    KUBELET_ARGS=" --cluster_dns=10.254.0.10 --cluster_domain=kubernetes.local"

Set the location of the etcd server, here we've got the single service on the master.

    [fedora@atomic01 ~]$ sudo vi /etc/kubernetes/config 
    # Comma seperated list of nodes in the etcd cluster
    KUBE_ETCD_SERVERS="--etcd_servers=http://192.168.122.10:4001"

Reload systemd to pick up our workaround and enable the minion services.  Reboot the minion to make sure everything start on boot correctly.

    [fedora@atomic01 ~]$ sudo systemctl daemon-reload

    [fedora@atomic01 ~]$ sudo systemctl enable flanneld kubelet kube-proxy
    {fedora@atomic01 ~]$ sudo systemctl reboot

### Confirm network configuration and cluster health
Once all of your services are started, the networking should look something like what's below.  You'll see the Flannel device that shows the selected range for this host and the docker0 bridge that has a specific subnet assigned.

    [fedora@atomic01 ~]$ sudo systemctl status flanneld docker kubelet kube-proxy
    [fedora@atomic01 ~]$ ip a
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc pfifo_fast state UP group default qlen 1000
        link/ether 0a:45:46:8d:6a:de brd ff:ff:ff:ff:ff:ff
        inet 10.4.0.120/24 brd 10.4.0.255 scope global dynamic eth0
           valid_lft 3570sec preferred_lft 3570sec
        inet6 fe80::845:46ff:fe8d:6ade/64 scope link 
           valid_lft forever preferred_lft forever
    3: flannel.1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8951 qdisc noqueue state UNKNOWN group default 
        link/ether 1a:50:6d:23:5d:a2 brd ff:ff:ff:ff:ff:ff
        inet 172.16.36.0/12 scope global flannel.1
           valid_lft forever preferred_lft forever
        inet6 fe80::1850:6dff:fe23:5da2/64 scope link 
           valid_lft forever preferred_lft forever
    5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
        link/ether 56:84:7a:fe:97:99 brd ff:ff:ff:ff:ff:ff
        inet 172.16.36.1/24 scope global docker0
           valid_lft forever preferred_lft forever
    

[ Repeat on all minions ]

Once you've created all the minions for your cluster, you can check to make sure the Kubernetes cluster is communicating properly.  On the Kubernetes master, check to the visibility of the minions.  This means you should be ready to start scheduling your first pod.
    
    [fedora@atomic-master ~]$ kubectl get minions

## Exploring Kubernetes
There are several ways to get started using Kubernetes pods to create workloads.  The Kubernetes upstream project publishes a Redis guestbook example that works to show off most of the components and use cases.  


Before starting the example, you need to create a kube-dns replication controller and service, so that the guestbook examples can communicate. Get the configuration files skydns-rc.yaml.in and skydns-svc.yaml.in for this from [Kubernetes Github](https://github.com/GoogleCloudPlatform/kubernetes/tree/master/cluster/addons/dns). Copy these files to the master Atomic host, and remove the ".in" from the filename.

These files are yaml templates, so you will need to manually fill in the templated parameters (easily found by as they are surrounded by "{{" and "}}").  In skydns-rc.yaml, set dns_replicas to 1 and both dns_domains to kubernetes.local

    kind: ReplicationController
    apiVersion: v1beta1
    id: kube-dns
    namespace: default
    labels:
      k8s-app: kube-dns
      kubernetes.io/cluster-service: "true"
    desiredState:
      replicas: 1
      replicaSelector:
        k8s-app: kube-dns
      podTemplate:
        labels:
          name: kube-dns
          k8s-app: kube-dns
          kubernetes.io/cluster-service: "true"
        desiredState:
          manifest:
            version: v1beta2
            id: kube-dns
            dnsPolicy: "Default"  # Don't use cluster DNS.
            containers:
              - name: etcd
                image: quay.io/coreos/etcd:v2.0.3
                command: [
                        # entrypoint = "/etcd",
                        "-listen-client-urls=http://0.0.0.0:2379,http://0.0.0.0:4001",
                        "-initial-cluster-token=skydns-etcd",
                        "-advertise-client-urls=http://127.0.0.1:4001",
                ]
              - name: kube2sky
                image: kubernetes/kube2sky:1.1
                command: [
                        # entrypoint = "/kube2sky",
                        "-domain=kubernetes.local",
                ]
              - name: skydns
                image: kubernetes/skydns:2015-03-11-001
                command: [
                        # entrypoint = "/skydns",
                        "-machines=http://localhost:4001",
                        "-addr=0.0.0.0:53",
                        "-domain=kubernetes.local.",
                ]
                ports:
                  - name: dns
                    containerPort: 53
                    protocol: UDP

In skydns-svc.yaml, substitute the dns_server parameter with 10.254.0.10

    kind: Service
    apiVersion: v1beta1
    id: kube-dns
    namespace: default
    protocol: UDP
    port: 53
    portalIP: 10.254.0.10
    containerPort: 53
    labels:
      k8s-app: kube-dns
      name: kube-dns
      kubernetes.io/cluster-service: "true"
    selector:
      k8s-app: kube-dns

You can use kubectl to create the kube-dns replication controller and service as follows:

    [fedora@atomic-master ~]$ kubectl create -f skydns-rc.yaml
    [fedora@atomic-master ~]$ kubectl get replicationController kube-dns
    [fedora@atomic-master ~]$ kubectl get pods -l name=kube-dns

    [fedora@atomic-master ~]$ kubectl create -f skydns-svc.yaml
    [fedora@atomic-master ~]$ kubectl get service kube-dns


Now you can download just the JSON files for the example from the [ Github repo ](https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook) to the master Atomic host.  

Once you've got the files, it's a simple matter to use kubectl to create the pod, service, and replication controller.  Follow along starting with [Step One] (https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook#step-one-turn-up-the-redis-master) in the guide, or skip ahead and run the following commands:

    [fedora@atomic-master ~]$ kubectl create -f redis-master-controller.json
    [fedora@atomic-master ~]$ kubectl get replicationController redis-master-controller
    [fedora@atomic-master ~]$ kubectl get pods -l name=redis-master

    [fedora@atomic-master ~]$ kubectl create -f redis-master-service.json 
    [fedora@atomic-master ~]$ kubectl get service redis-master

    [fedora@atomic-master ~]$ kubectl create -f  redis-slave-controller.json 
    [fedora@atomic-master ~]$ kubectl get replicationController redis-slave-controller
    [fedora@atomic-master ~]$ kubectl get pods -l name=redis-master

    [fedora@atomic-master ~]$ kubectl create -f redis-slave-service.json 
    [fedora@atomic-master ~]$ kubectl get service redisslave

To check the status of the containers using `kubectl get`.  You can also check on services and replication controllers with the `get` command.  At this point, the Redis cluster and associated containers will be downloaded and running on your minions.

    [fedora@atomic-master ~]$ kubectl get pods 
    POD                                    IP                  CONTAINER(S)        IMAGE(S)                                 HOST                LABELS                                                     STATUS
    22341c61-bdeb-11e4-892b-525400fa2bea   172.17.0.2          redis-master        dockerfile/redis                         192.168.122.14/     app=redis,name=redis-master                                Running
    720081b3-bdeb-11e4-892b-525400fa2bea   172.17.0.2          redis-slave         brendanburns/redis-slave                 192.168.122.13/     app=redis,name=redis-slave,uses=redis-master               Running
    7200bf0a-bdeb-11e4-892b-525400fa2bea   172.17.0.2          redis-slave         brendanburns/redis-slave                 192.168.122.11/     app=redis,name=redis-slave,uses=redis-master               Running
    4a933de8-bdee-11e4-892b-525400fa2bea   172.17.0.3          php-redis           kubernetes/example-guestbook-php-redis   192.168.122.12/     app=frontend,name=frontend,uses=redis-slave,redis-master   Running
    4a93f6ff-bdee-11e4-892b-525400fa2bea   172.17.0.3          php-redis           kubernetes/example-guestbook-php-redis   192.168.122.14/     app=frontend,name=frontend,uses=redis-slave,redis-master   Running
    4a9515dd-bdee-11e4-892b-525400fa2bea   172.17.0.3          php-redis           kubernetes/example-guestbook-php-redis   192.168.122.11/     app=frontend,name=frontend,uses=redis-slave,redis-master   Running


The example sets up front end controller and service to provide web access to the Redis cluster.

    [fedora@atomic-master ~]$ kubectl create -f frontend-controller.json

Before creating the service for the web front end, we're going to add a 'load balancer' entry point.  This is a single IP address that will allow for access to any and all of the exposed ports on the minions that will run the front end containters.  This allows you to create an external IP address for a web service without needing to expose all of the minions. Add a `publicIPs` entry for an "external" service, containing one of the eth0 IP addresses of a minion in the cluster.  This doesn't need to be a minion that is actually running the front end containers.  This is also a list, so you could have more than one IP in the entry.

    [fedora@atomic-master ~]$ vi frontend-service.json 
    {
      "id": "frontend",
      "kind": "Service",
      "apiVersion": "v1beta1",
      "port": 8000,
      "publicIPs": ["192.168.122.14"],
      "containerPort": "http-server",
      "selector": {
        "name": "frontend"
      },
      "labels": {
        "name": "frontend"
      }
     }

Then you can create this service.

    [fedora@atomic-master ~]$ kubectl create -f frontend-service.json

Once this service starts, pull up the guestbook in a web browser at the IP you assigned in the publicIPs listening on port 8000.  You've now created and scheduled your first kubernetes pod.  You can explore the kubernetes documentation for more information on how to build pods and services.
