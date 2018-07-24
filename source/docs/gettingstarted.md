# Project Atomic Getting Started Guide

## About this Guide
Project Atomic provides a platform to deploy and manage containers on bare-metal, virtual, or cloud-based servers.  Project Atomic hosts are designed to be minimal hosts focused on the delivery of container services.  Project Atomic hosts ship with Docker, Flannel, and Kubernetes to build clusters for container based services.  Docker provides the container runtime, Flannel provides overlay networking, and Kubernetes provides scheduling and coordination of containers on hosts.

### Objectives of the guide
You will configure:

* Flannel to provide overlay networks
* Docker to use Flannel bridges
* Kubernetes to schedule Docker containers
* Service pods to run on the Atomic cluster

At the end of this guide, you will have:

* a cluster of 4 Atomic hosts running containers from Kubernetes called **nodes**
* an Atomic host running a local Docker cache called **master**
* a web accessible service for demonstration purposes

### Used in this guide
|  |  |
|---|---|
| Platform Host OS | Fedora 28 Workstation |
| Virtualization | KVM with virt-manager |
| Atomic Host OS | Fedora 28 Atomic v 25.89 |
| Additional Storage | 10G per Atomic host |

#### Installing using virt-manager
See the [Quick Start Guide] (http://www.projectatomic.io/docs/quickstart/) for instructions on how to launch an Atomic host using virt-manager.  Be sure to create a new cloud-init ISO source for each host with an updated meta-data file with an incremented instance-id and correct local-hostname.

## Atomic cluster concepts
Clusters of Atomic hosts under control of a Kubernetes master server is the expected operating arrangement of an Atomic environment.  Kubernetes distributes and orchestrates the construction of pods on the Atomic hosts.  Pods are collections of docker containers that logically separate services in an application.  The principle of single responsibility is an important design pattern when looking at building scalable applications with Kubernetes.

Flannel provides a distributed, tunneled overlay network for Atomic hosts.  This overlay network is used for inter-container networking only, while a Kubernetes proxy service provides for service level access to the host IP space. Etcd is used to distribute configurations for both Kubernetes and Flannel.

One host should be nominated to be the Atomic Kubernetes master server, with the other Atomic hosts providing node container services.  Since Kubernetes and Flannel use etcd as the distributed store, multiple Atomic clusters would need to replicate a complete cluster to separate workloads.  For this guide, we're using 1 master host and 4 nodes in the cluster.

In this guide we'll be using the following networking settings:

    Physical interfaces for hosts:
    atomic-master 192.168.122.10 kubernetes master
    atomic0[1-4] 192.168.122.1[1-4] kubernetes nodes

    Overlay Docker networking range:
    172.16.0.0/12

Of course, you need to replace "192.168.122.X" with the addresses of your actual machines.  You should be able to use the overlay and application networks as-is, though.

## Building the cluster master
Launch an Atomic host to act as the master node for the cluster.  We'll be creating the local docker cache, the etcd source, and the Kubernetes master services here.

As a good practice, update to the latest available Atomic tree.

    [fedora@atomic-master ~]$ sudo atomic host upgrade --reboot

### Local Docker registry
Normally when you want to bring up a docker container it uses [Docker Hub](https://hub.docker.com/) images. This's the default. However, you may want your images stay on your own Infrastructure what ensures privacy, availability, speed, ease of integration, and continuous delivery. Configure a local registry is an **optional** procedure, you may want to acquire, and manipulate images from a remote repository.

The Atomic cluster will use a local Docker registry mirror for caching with a local volume for persistence.  You may need to look at the amount of storage available to the Docker storage pool on the master host.  We don't want the container recreated every time the service gets restarted, so we'll create the container locally then set up a systemd unit file that will only start and stop the container.

Create a named container from the Docker Hub registry image, exposing the standard Docker Hub port from the container via the host.  We're using a local host directory as a persistence layer for the images that get cached for use.  The other environment variables passed in to the registry set the source registry.

    [fedora@atomic-master~]$ sudo docker run -d -p 5000:5000 --restart always \
    -v /var/lib/local-registry:/var/lib/registry \
    -e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/var/lib/registry \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
    --name local-registry registry:2

**Note:** We need to change the SELinux context on the directory that docker created for our persistence volume.

    [fedora@atomic-master ~]$ sudo mkdir -p /var/lib/local-registry
    [fedora@atomic-master ~]$ sudo chcon -Rvt svirt_sandbox_file_t /var/lib/local-registry

### Configuring Kubernetes master

#### Configure etcd

We're using a single etcd server, not a replicating cluster in this guide.  This makes etcd simple, we just need to listen for client connections, then enable and start the daemon with all the rest of the Kubernetes services.  For simplicity, we'll have etcd listen on all IP addresses.  The official port for etcd clients is 2379, but we'll add 4001 as well since that was widely used in guides to this point.

We first install the etcd package:

    [fedora@atomic-master ~]$ sudo rpm-ostree install etcd

Then edit the configuration file:

    [fedora@atomic-master ~]$ sudo vi /etc/etcd/etcd.conf
    ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379,http://0.0.0.0:4001"
    ETCD_ADVERTISE_CLIENT_URLS="http://192.168.122.10:2379,http://192.168.122.10:4001"

#### Generating certificates

Multiple Kubernetes services rely on certificates for authentication. There are lots of ways to configure this aspect of a cluster, the following method is based on [these steps](https://kubernetes.io/docs/admin/authentication/#easyrsa) from the upstream Kubernetes project.

Download, unpack, and initialize the patched version of easyrsa3.

    [fedora@atomic-master ~]$ curl -L -O https://storage.googleapis.com/kubernetes-release/easy-rsa/easy-rsa.tar.gz
    [fedora@atomic-master ~]$ tar xzf easy-rsa.tar.gz
    [fedora@atomic-master ~]$ cd easy-rsa-master/easyrsa3
    [fedora@atomic-master ~]$ ./easyrsa init-pki

Generate a CA. (--batch set automatic mode. --req-cn default CN to use.)

    [fedora@atomic-master ~]$ MASTER_IP=192.168.122.10
    [fedora@atomic-master ~]$ ./easyrsa --batch "--req-cn=${MASTER_IP}@`date +%s`" build-ca nopass

Generate server certificate and key. (build-server-full [filename]: Generate a keypair and sign locally for a client or server)

    [fedora@atomic-master ~]$ ./easyrsa --subject-alt-name="IP:${MASTER_IP}" build-server-full server nopass

Copy pki/ca.crt, pki/issued/kubernetes-master.crt, and pki/private/kubernetes-master.key to `/etc/kubernetes/certs`.

    [fedora@atomic-master ~]$ sudo mkdir /etc/kubernetes/certs
    [fedora@atomic-master ~]$ for i in {pki/ca.crt,pki/issued/server.crt,pki/private/server.key}; do sudo cp $i /etc/kubernetes/certs; done
    [fedora@atomic-master ~]$ sudo chown -R kube:kube /etc/kubernetes/certs

#### Configure services

For Kubernetes, there's a few config files in /etc/kubernetes we need to set up for this host to act as a master.  First off is the general config file used by all of the services.  Then we'll add service specific variables to those service config files.

    Services
        config
        apiserver
        controller-manager
        scheduler

**Note:** If you've been following this documentation starting from CentOs, it is important want you to know, that current versions of CentOS Atomic have the kubernetes-master pkg removed from the image, to be run from containers. There's info on that here: [instructions on the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster).

#### Common service configurations
We'll be setting up the etcd store that Kubernetes will use.  We're using a single local etcd service, so we'll point that at the master on the standard port.  We'll also set up how the services find the apiserver.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/config
    # Comma separated list of nodes in the etcd cluster
    KUBE_ETCD_SERVERS="--etcd_servers=http://192.168.122.10:2379"

    # How the controller-manager, scheduler, and proxy find the kube-apiserver
    KUBE_MASTER="--master=http://192.168.122.10:8080"

#### Apiserver service configuration
The apiserver needs to be set to listen on all IP addresses, instead of just localhost.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/apiserver
    # The address on the local server to listen to.
    KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0"

If you need to modify the set of IPs that Kubernetes assigns to services, change the KUBE_SERVICE_ADDRESSES value. Since this guide is using the 192.168.122.0/24 and 172.16.0.0/12 networks, we can leave the default.  This address space needs to be unused elsewhere, but doesn't need to be reachable from either of the other networks.

    # Address range to use for services
    KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"

We'll also add parameters for the certificates we generated earlier.

    # Add your own!
    KUBE_API_ARGS="--tls-cert-file=/etc/kubernetes/certs/server.crt --tls-private-key-file=/etc/kubernetes/certs/server.key --client-ca-file=/etc/kubernetes/certs/ca.crt --service-account-key-file=/etc/kubernetes/certs/server.crt"

#### Controller-manager service configuration

The controller-manager also needs parameters for the certificates we generated.

    [fedora@atomic-master ~]$ sudo vi /etc/kubernetes/controller-manager
    # Add your own!
    KUBE_CONTROLLER_MANAGER_ARGS="--service-account-private-key-file=/etc/kubernetes/certs/server.key --root-ca-file=/etc/kubernetes/certs/ca.crt"

Enable, start and check the Kubernetes services.

    [fedora@atomic-master ~]$ sudo for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do systemctl enable $SERVICES; systemctl start $SERVICES; systemctl status $SERVICES ; done

### Configuring the Flannel overlay network
Flanneld provides a tunneled network configuration via etcd.  To push the desired config into etcd, we'll create a JSON file with the options we want and use curl to push the data.  We've selected a /12 network to create a /24 subnet per node.

    [fedora@atomic-master ~]$ vi flanneld-conf.json
    {
      "Network": "172.16.0.0/12",
      "SubnetLen": 24,
      "Backend": {
        "Type": "vxlan"
      }
    }

We'll create a keyname specific to this cluster to store the network configuration.  While we're using a single etcd server in a single cluster for this example, setting non-overlapping keys allows us to have a multiple flannel configs for several Atomic clusters.

    [fedora@atomic-master ~]$ curl -L http://localhost:2379/v2/keys/atomic.io/network/config -XPUT --data-urlencode value@flanneld-conf.json

Just to make sure we have the right config, we'll pull it via curl and parse the JSON return.

    [fedora@atomic-master ~]$ curl -L http://localhost:2379/v2/keys/atomic.io/network/config | python -m json.tool
    {
        "action": "get",
        "node": {
            "createdIndex": 11,
            "key": "/atomic.io/network/config",
            "modifiedIndex": 11,
            "value": "{\n  \"Network\": \"172.16.0.0/12\",\n  \"SubnetLen\": 24,\n  \"Backend\": {\n    \"Type\": \"vxlan\"\n  }\n}\n\n"
        }
    }

## Atomic Nodes
We'll be configuring Docker to use Flannel and our cache for configuring the Kubernetes services.  These nodes will act as the workers and run Pods and containers.  You can repeat this on as many nodes as you like to provide resources to the cluster.  In this guide, we'll set up 4 nodes.

As a good practice, update to the latest available Atomic tree.

    [fedora@atomic01 ~]$ sudo atomic host upgrade
    [fedora@atomic01 ~]$ sudo systemctl reboot

### Configuring Docker to use the cluster registry cache
Add the local cache registry running on the master to the docker options that get pulled into the systemd unit file.

    [fedora@atomic01 ~]$ sudo vi /etc/sysconfig/docker
    OPTIONS='--registry-mirror=http://192.168.122.10:5000 --selinux-enabled --log-driver=journald'

### Configuring Docker to use the Flannel overlay
To set up flanneld, we need to tell the local flannel service where to find the etcd service serving up the config. We also give it the right key to find the networking values for this cluster.

    [fedora@atomic01 ~]$ sudo vi /etc/sysconfig/flanneld
    # etcd url location.  Point this to the server where etcd runs
    FLANNEL_ETCD_ENDPOINTS="http://192.168.122.10:2379"

    # etcd config key.  This is the configuration key that flannel queries
    # For address range assignment
    FLANNEL_ETCD_PREFIX="/atomic.io/network"

### Configuring Kubernetes nodes

The address entry in the kubelet config file must match the KUBLET_ADDRESSES entry on the master.   If hostnames are used, this also must match output of `hostname -f` on the node.  We're using the eth0 IP address like we did on the master.

    [fedora@atomic01 ~]$ sudo vi /etc/kubernetes/kubelet
    # The address for the info server to serve on (set to 0.0.0.0 or "" for all interfaces)
    KUBELET_ADDRESS="--address=192.168.122.11"

    # You may leave this blank to use the actual hostname
    KUBELET_HOSTNAME="--hostname-override=192.168.122.11"

    # location of the api-server
    KUBELET_API_SERVER="--api-servers=http://192.168.122.10:8080"

Set the location of the etcd server, here we've got the single service on the master.

    [fedora@atomic01 ~]$ sudo vi /etc/kubernetes/config
    # How the controller-manager, scheduler, and proxy find the kube-apiserver
    KUBE_MASTER="--master=http://192.168.122.10:8080"

Set the cluster CIDR for Kubernetes Proxy.

    [fedora@atomic01 ~]$ sudo vi /etc/kubernetes/proxy
    # Add your own!
    KUBE_PROXY_ARGS="--cluster-cidr=10.254.0.0/16"

If you created the drop-in, reload systemd and then enable the node services.  Reboot the node to make sure everything starts on boot correctly.

    [fedora@atomic01 ~]$ sudo iptables --policy FORWARD ACCEPT
    [fedora@atomic01 ~]$ sudo systemctl daemon-reload
    [fedora@atomic01 ~]$ sudo systemctl enable flanneld kubelet kube-proxy
    [fedora@atomic01 ~]$ sudo systemctl reboot

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


Repeat these steps on the other 3 nodes to complete the cluster configuration.

Once you've created all the nodes for your cluster, you can check to make sure the cluster is communicating properly.  On the cluster master, check to the visibility of the nodes.  A Ready status on all nodes means you're ready to start scheduling pods.

    [fedora@atomic-master ~]$ kubectl get node
    NAME             LABELS    STATUS
    192.168.122.11   <none>    Ready
    192.168.122.12   <none>    Ready
    192.168.122.13   <none>    Ready
    192.168.122.14   <none>    Ready


## Exploring Kubernetes

We can now create a simple Kubernetes pod to schedule a workload.

We'll create a simple nginx pod definition on the master.  You can use JSON or YAML to create pods, we'll use YAML.

    [fedora@atomic-master ~]$ vi kube-nginx.yml
    apiVersion: v1
    kind: Pod
    metadata:
      name: www
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
              hostPort: 8080

To get the pod up and running, use `kubectl create`

    [fedora@atomic-master ~]$ kubectl create -f kube-nginx.yml
    pod "www" created

To check the status of the containers using `kubectl get`.  At this point, the Nginx container will be downloaded and running on your nodes.

    [fedora@atomic-master ~]$ kubectl get pod
    NAME      READY     STATUS    RESTARTS   AGE
    www       1/1       Running   0          1m

Once you see the pod status is Running, you can check to see which node it's running on.

    [fedora@atomic-master ~]$ kubectl describe pods www | grep Node
    Node:		192.168.122.11/192.168.122.11

Point a web browser at the host Kubernetes created the container on. Use port 8080, since that was the host port we connected to the container port 80 in the pod definition. You should see the nginx welcome page.

You've now created and scheduled your first kubernetes pod.  You can explore the kubernetes documentation for more information on how to build pods and services, and checkout [these ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) for a fuller-featured cluster that includes kubernetes addons such as dns.
