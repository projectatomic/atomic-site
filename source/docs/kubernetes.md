# Kubernetes in Atomic Host

Atomic Hosts rely primarily on Kubernetes for automating deployment, scaling, and operations of application containers across clusters of hosts.

Initially, the Atomic Hosts from Fedora and CentOS shipped with Kubernetes included in the image by default, but the projects have been moving toward containerized Kubernetes deployments, with the goal of making it easier to deploy different versions. 

Below is an overview of the state of Kubernetes in Fedora Atomic and CentOS Atomic, and some information on other installation options. 

## Fedora Atomic Host

As of Fedora 25, Kubernetes, as well as Etcd and Flannel, [is included](https://pagure.io/fedora-atomic/blob/9ca7cc0c806014576a6413ce5aac3db72c421f5d/f/fedora-atomic-docker-host.json#_113) in the default image.

Fedora's Kubernetes [is packaged](https://apps.fedoraproject.org/packages/kubernetes) in three rpms: kubernetes-node (containing the kubelet and kube-proxy), kubernetes-master (containing the scheduler, controller-manager, and apiserver), and kubernetes-client (containing the kubectl cli). Each of master and node components is managed by a systemd service file included in the rpms.

### Deployment

The simplest and most complete way to bring up a Kubernetes cluster with Fedora Atomic Host is to use the upstream [kubernetes ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible). For a more manual approach, consult the [getting started guide](http://www.projectatomic.io/docs/gettingstarted/).

Up until late 2016, Fedora's kubernetes packages were based on a version of kubernetes adapted from openshift origin, which itself was adapted from upstream kubernetes. This arrangement led to delays between upstream kubernetes releases and Fedora's kubernetes releases. Currently, Fedora's kubernetes is based directly on upstream, which has enabled Fedora to significantly narrow the release gap.


## CentOS Atomic Host

As in Fedora, CentOS's Kubernetes [is packaged](https://git.centos.org/summary/?r=rpms/kubernetes) in three rpms: kubernetes-node (containing the kubelet and kube-proxy), kubernetes-master (containing the scheduler, controller-manager, and apiserver), and kubernetes-client (containing the kubectl cli). Each of master and node components is managed by a systemd service file included in the rpms.

The downstream release of [CentOS Atomic Host](https://wiki.centos.org/SpecialInterestGroup/Atomic/Download) ships without the kubernetes-master package built into the image. Instead, users are expected to run the master kubernetes components (apiserver, scheduler, and controller-manager) in containers, managed via systemd, using the service files and [instructions on the CentOS wiki](https://wiki.centos.org/SpecialInterestGroup/Atomic/ContainerizedMaster). The containers referenced in these systemd service files are built in and hosted from the [CentOS Community Container Pipeline](https://wiki.centos.org/ContainerPipeline), based on Dockerfiles from the [CentOS-Dockerfiles repository](https://github.com/CentOS/CentOS-Dockerfiles/tree/master/kubernetes).

It's also possible to layer the kubernetes-master package onto the CentOS Atomic Host image using the command:

```
# rpm-ostree install kubernetes-master --reboot
```

Following a reboot, the kubernetes-master package will be installed and will operate as if it were built into the image, and will persist through future upgrades.

### Deployment

The simplest and most complete way to bring up a Kubernetes cluster with CentOS Atomic Host is to use the upstream [kubernetes ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) after first installing the systemd unit files referenced above or installing kubernetes-master using rpm-ostree install. For a more manual approach, consult the [getting started guide](http://www.projectatomic.io/docs/gettingstarted/).

CentOS's kubernetes packages are based on a version of kubernetes adapted from openshift origin, which itself was adapted from upstream kubernetes. This arrangement has led to delays between upstream kubernetes releases and CentOS's kubernetes releases, but the currently available kubernetes version in CentOS is fairly up-to-date, at v1.5.2.


## CentOS Atomic Host Alpha/Continuous

The CentOS Atomic SIG produces a second, [faster-moving content stream](https://wiki.centos.org/SpecialInterestGroup/Atomic/Devel) that combines a base of CentOS packages with an overlay of [certain continuously-built packages](https://github.com/CentOS/sig-atomic-buildscripts/blob/master/overlay.yml) pulled from upstream git sources. The packages are built using a project called [rpmdistro-gitoverlay](https://github.com/cgwalters/rpmdistro-gitoverlay) that runs as a [Jenkins job](https://ci.centos.org/job/atomic-rdgo-centos7/) within the CentOS CI infrastructure.

This continuous stream is the vanguard of the effort toward containerized Kubernetes deployment, and [ships without](https://github.com/CentOS/sig-atomic-buildscripts/pull/144) kubernetes, etcd, flannel or the packages that enable ceph and gluster storage integration on the host.

### Deployment

Deploying kubernetes on a host running the continuous stream involves replacing the kubernetes components with containers (see Containerized Kubernetes, below) or with rpm-ostree package layering:

```
# rpm-ostree install kubernetes flannel etcd --reboot
```

## Containerized Kubernetes

### Using distribution-provided images and rpms

There's [work underway](https://pagure.io/atomic-wg/issues?status=Open&tags=remove-kube) to remove Kubernetes from the image, in favor of a containerized deployment method. By placing [systemd service files](https://github.com/jasonbrooks/contrib/blob/atomic-update/ansible/roles/master/templates/atomic/kube-apiserver.service) that pull and run Kubernetes containers based on [Fedora](http://www.projectatomic.io/blog/2017/02/fedora-layered-image-release/) or [CentOS](https://wiki.centos.org/ContainerPipeline) packages into `/etc/systemd/system` on a host, these containers can serve as a drop-in replacement for the built-in Kubernetes packages, and should work with the upstream [kubernetes ansible scripts](https://github.com/kubernetes/contrib/tree/master/ansible) or with the [getting started guide](http://www.projectatomic.io/docs/gettingstarted/).

#### Etcd & Flannel System Containers

It's also a goal for flannel and etcd to run in containers on Atomic Hosts, but since flannel needs to modify docker's configuration to operate, and since flannel depends on etcd to run, there's a bit of a chicken and egg situation when running these as docker containers.

[System containers](http://www.projectatomic.io/blog/2016/09/intro-to-system-containers/), which can be run independently from the docker daemon, offer a solution. For drop-in replacement purposes, installation and configuration of system containers is a bit more complicated than dropping unit files into `/etc/systemd/system`. 

For instance, this command to install etcd as a system container takes care of creating a systemd unit file, and at the same time wraps in a portion of the configuration:

```
atomic install --system --set ETCD_ENDPOINTS=http://192.168.122.2:2379 gscrivano/flannel
```

The ansible scripts expect to set etcd configuration options by editing config files on the host. The kubernetes docker images linked above handle this sort of expectation by mounting the host's `/etc/kubernetes` directory into the kubernetes containers, making those configuration files available to the containers.

The ansible scripts and manual setup steps expect that a host with etcd installed will have etcdctl installed as well. This application can be run from within the system container, but must be run as `runc exec -- etcd /usr/bin/etcdctl` which involves some modification to scripts or setup steps. It may be worth exploring creating an etcdctl script in `/usr/local/bin/` that runs etcdctl from within the container to make this simpler.

### Using kubeadm

[kubeadm](https://kubernetes.io/docs/getting-started-guides/kubeadm/) is a tool for more easily deploying kubernetes clusters. kubeadm is currently in alpha. kubeadm is packaged in rpm form and documented to work with CentOS 7. The kubeadm rpms provide binaries for the kubelet, kubectl, kubeadm, and binaries for the kubernetes [Container Networking Interface](https://github.com/containernetworking/cni).

kubeadm can make bringing up a cluster as easy as running `kubeadm init` on a master and then running `kubeadm join --token=<token> <master-ip>` on additional nodes.

As packaged by the upstream, kubeadm's kubernetes-cni package wants to place its binaries in `/opt`, which rpm-ostree does not allow. There have been [some experiments](https://jebpages.com/2016/11/01/installing-kubernetes-on-centos-atomic-host-with-kubeadm/) around modifying the packages to use a different location.

### Using other docker-based methods

It's possible to run kubernetes on an atomic host using upstream-provided containers run by docker by following [this guide](https://github.com/kubernetes/kube-deploy/).
