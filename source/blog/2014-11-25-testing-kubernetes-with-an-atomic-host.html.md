---
title: Testing Kubernetes with an Atomic Host
author: jbrooks
date: 2014-11-25 14:00:00.000000000 Z
published: true 
comments: true
---

Atomic hosts include [Kubernetes](http://kubernetes.io/) for orchestration and management of containerized application deployments, across a cluster of container hosts. If you're interested in taking Kubernetes for a spin on an Atomic host, read on!

### Kubernetes+Atomic Hello World

First, boot into [CentOS Atomic](http://buildlogs.centos.org/rolling/7/) host. You ought to be able to use [Fedora Atomic](http://fedoraproject.org/get-prerelease#cloud) as well, but currently, Atomic Fedora comes with an earlier version of kubernetes, so for each of the `kubectl` commands in this howto, there's a different `kubecfg` command, for now.

READMORE

Due to [a bug](https://bugs.centos.org/view.php?id=7917) in CentOS Atomic (not necessary in Fedora Atomic), you must:

````
cp /usr/lib/systemd/system/kubelet.service /etc/systemd/system/

vi /etc/systemd/system/kubelet.service 
````
Then, change both instances of `docker.socket` to `docker.service` and:

````
systemctl daemon-reload
````

Next, start and enable kubernetes services:

````
for SERVICES in etcd kube-apiserver kube-controller-manager  kube-scheduler docker kube-proxy.service  kubelet.service; do 
        systemctl restart $SERVICES
        systemctl enable $SERVICES
        systemctl status $SERVICES
    done
````

You should now have one minion to do your bidding:

````
kubectl get minions
````

Now, set up a test pod:

```` 
vi apache.json
````

````
{
  "id": "fedoraapache",
  "kind": "Pod",
  "apiVersion": "v1beta1",
  "desiredState": {
    "manifest": {
      "version": "v1beta1",
      "id": "fedoraapache",
      "containers": [{
        "name": "fedoraapache",
        "image": "fedora/apache",
        "ports": [{
          "containerPort": 80,
          "hostPort": 80
        }]
      }]
    }
  },
  "labels": {
    "name": "fedoraapache"
  }
}
````

Followed by:

````
kubectl create -f apache.json
````

Monitor status with:

````
kubectl get pod fedoraapache
````

You can monitor progress using journalctl. 

For the master role:

````
journalctl -f -l -xn -u kube-apiserver -u etcd -u kube-scheduler
````

For the minion role:

journalctl -f -l -xn -u kubelet -u kube-proxy -u docker


Once `kubectl` reports your pod's status as "Running," you should get a result from:

````
curl http://localhost
````

When you're finished basking in the glory of that application, you can get rid of its pod with:

````
kubectl delete pod fedoraapache
````

Now, you have a single host, single minion kubernetes setup, but since orchestration across multiple container hosts is the point of kubernetes, we need to take our setup to...

### Multi-Minion Country

The best way I've found to accomplish this, across N Atomic hosts, is to use Ansible, as described in [this tutorial](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/fedora/fedora_ansible_config.md) in the kubernetes repo.

Ansible isn't in the Atomic host image, so install Ansible (on Fedora, `yum -y install ansible` or [check here](http://docs.ansible.com/intro_installation.html) for other platforms) on your client machine. Next, grab one or more additional Atomic hosts, and take note of their IP addresses. To speed the configuration process for our tests, set the root passwords on your Atomic hosts to the same value, like `password`.

Also, make sure to apply the `kubelet.service` tweak from the top of this post to your additional Atomic hosts.

Get the IP addresses from the master and minions. Add those to the `inventory` file at the root of the repo on the host running Ansible. You can make one of your Atomic hosts do double duty as a master and a minion, if you wish. Ignore the kube_ip_addr= option for a moment.

````
[masters]
192.168.121.205

[etcd]
192.168.121.205

[minions]
192.168.121.84  kube_ip_addr=[ignored]
192.168.121.116 kube_ip_addr=[ignored]
````

Tell ansible which user has ssh access (and sudo access to root)

edit: `group_vars/all.yml`

````
ansible_ssh_user: root
````

Now, to get the public key created during the container build onto each of your Atomic hosts, created a password file that contain the root password for every machine in the cluster:

````
echo "password" > ~/rootpassword
````

Run the following commands to add set up access between your Ansible machine and your Atomic hosts:

````
ansible-playbook -i inventory ping.yml # This will look like it fails, that's ok
ansible-playbook -i inventory keys.yml
````

Then, configure the ip addresses which should be used to run pods on each machine. The IP address pool used to assign addresses to pods for each minion is the kube_ip_addr= option. Choose a /24 to use for each minion and add that to you inventory file. I stuck with the `kube_ip_addr` values that were already in the file, and those worked fine for me.

````
[minions]
192.168.121.84  kube_ip_addr=10.0.1.1
192.168.121.116 kube_ip_addr=10.0.2.1
````

Run the network setup playbook. In most of my tests, this command errored out on the first run, but completed successfully on the second run. 

````
ansible-playbook -i inventory hack-network.yml
````

Each kubernetes service gets its own IP address. These are not real IPs. You need only select a range of IPs which are not in use elsewhere in your environment. This must be done even if you do not use the network setup provided by the ansible scripts.

edit: `group_vars/all.yml`

````
kube_service_addresses: 10.254.0.0/16
````

Tell ansible to get to work:

````
ansible-playbook -i inventory setup.yml
````

Once this step completes, you'll be able to run `kubectl get minions` on your `master` host and see a list of minions ready to run containers. Test out your pack of kubernetes minions with the project's go-to [example guestbook application](https://github.com/GoogleCloudPlatform/kubernetes/tree/master/examples/guestbook), a redis+apache+php application spread out over three nodes.

On your master host, check out the kubernetes git repository, and change into the guestbook directory:

````
git clone https://github.com/GoogleCloudPlatform/kubernetes.git

cd kubernetes/examples/guestbook
````

First, fire up the redis master pod, and then monitor its process from `Waiting` to `Running`:

````
kubectl create -f redis-master.json

kubectl get pod redis-master
````

Once that's Running, create the redis-master-service:

````
kubectl create -f redis-master-service.json

kubectl get service redis-master-service
````

After that service is Running, create a Replication Controller for some redis slaves: 

````
kubectl create -f redis-slave-controller.json

kubectl get replicationController redis-slave-controller
````

Once that controller is Running, create a redis slave service:

````
kubectl create -f redis-slave-service.json

kubectl get service redis-slave-service
````

Finally, create a frontend controller:

````
kubectl create -f frontend-controller.json

kubectl get replicationController frontend-controller
````

When all of these elements are Running, you should be able to visit port 8000 on any of your hosts running the frontend service to see and interact with the guestbook application.

### Till Next Time

If you run into trouble following this walkthrough, I'll be happy to help you get up and running or get pointed in the right direction. Ping me at jbrooks in #atomic on freenode irc or [@jasonbrooks](https://twitter.com/jasonbrooks) on Twitter. Also, be sure to check out the [Project Atomic Q&A site](http://ask.projectatomic.io/en/questions/).
