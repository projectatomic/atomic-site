# Single-host networking: Docker

Docker hosts, by default, give each container an IP address on an unused private range, enabling containers on the same host to communicate with each other, given knowledge of the containers’ assigned IP addresses and on their exposed ports. 

Docker’s linked containers feature simplifies communication between containers running on the same host by enabling containers to reference one another through their names, rather than through network values that can change as containers stop and restart.

Docker containers can also communicate with external containers and applications through port forwarding that connects specific container ports to statically or dynamically assigned ports on  the host machine.

However, container linking does not span multiple docker hosts, and it is difficult for applications running inside containers to advertise their external IP and port, as that information is not available to them.

While you may run containers on one or more Atomic hosts using only the networking facilities provided by docker itself, multi-host docker deployments will benefit from using the additional stack components that ship with Atomic.

Consult the upstream docker documentation for more information about docker [networking concepts](https://docs.docker.com/articles/networking), and to learn more about [docker links](https://docs.docker.com/userguide/dockerlinks).

# Multi-host networking: Kubernetes & Flannel

Kubernetes addresses these multi-host container communication issues with the concepts of pods and services. 

A kubernetes [pod](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/pods.md) corresponds to a colocated group of applications running with a shared context. It may contain one or more applications which are relatively tightly coupled -- in a pre-container world, they would have executed on the same physical or virtual host.

Kubernetes gives every pod its own IP address allocated from an internal network, but since pods can fail and be scheduled to different nodes, these addresses will likely change over time. [Services](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/services.md) provide a single, stable name and address for applications spanning kubernetes pods.

In Kubernetes, every machine in the cluster is assigned a full subnet, a model intended to reduce the complexity of doing port mapping, but which can prove challenging to implement in many network environments. Atomic hosts include [flannel](https://github.com/coreos/flannel/blob/master/README.md), which provides an overlay network that gives a subnet to each machine in a kubernetes cluster.

To learn how to configure flannel and kubernetes in an Atomic host cluster, check out the Project Atomic [Getting Started Guide](http://www.projectatomic.io/docs/gettingstarted/).
