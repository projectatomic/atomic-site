---
title: Creating a Simple Bare Metal Atomic Host Cluster
author: waugustyn
date: 2015-06-30 18:21:45 UTC
tags: bare metal, Docker, Kubernetes, Flannel, etcd, cluster
comments: true
published: true
---

Atomic host is a great technology for containerized applications. I like it especially on bare metal machines. In this post I will describe how to setup a simple Do-It-Yourself cluster consisting of three netbooted machines running docker over flannel. Flannel provides a NAT-less private network overlay. Through that network, application containers can easily reach any other containers within the cluster regardless of which machine they run on.

We use three machines called _a1_, _a2_, and _a3_. Let's designate static IP addresses to them.

+ a1: 192.168.99.51
+ a2: 192.168.99.52
+ a3: 192.168.99.53

We install atomic host OS on these machines via netboot from another host. Let's call that host _boothost_. It holds all installation and configuration files. We set up an unattended installation and configuration using kickstart and cloud-init.

READMORE

### Kickstart

Thanks to ostree and cloud-init, we can simplify `kickstart.cfg` immensely. We need to tell it how to partition disks, where the ostree repository is, and where cloud-init files reside.  Sometimes I wonder if the entire kickstart can be reduced to nil by writing appropriate cloud-init modules but for now we go with the tradition.

Most items in the kickstart file are selected according to local preference. Here we list those that relate to setting up the cluster. Line continuations are used for readability only, they don't appear in the scripts.

```
text
ostreesetup --osname="Fedora-Cloud_Atomic" \
			--remote="Fedora-Cloud_Atomic" \
            --url="http://boothost/f22-atomic/content/repo" \
            --ref="fedora-atomic/f22/x86_64/docker-host" --nogpg
services --enabled=cloud-init,cloud-config,cloud-final,cloud-init-local
bootloader --location=mbr --append="ds=nocloud\;seedfrom=/var/cloud-init/"
part /boot --fstype=ext4 --asprimary --size=512 --ondrive=sda
part pv.01 --fstype=ext4 --asprimary --grow --ondrive=sda
volgroup fedora pv.01
logvol swap --vgname=fedora --fstype=swap --name=swap --recommended
logvol none --vgname=fedora --thinpool --name=docker-pool --size=100000
logvol / --vgname=fedora --fstype=ext4 --name=root --grow --percent=95
clearpart --all --initlabel --drives=sda
reboot
%post
ostree remote add --set=gpg-verify=false \
	   Fedora-Cloud_Atomic \
       'http://dl.fedoraproject.org/pub/fedora/linux/atomic/22/'
mkdir /var/cloud-init
curl http://boothost/f22-atomic/meta-data.a1 > /var/cloud-init/meta-data
curl http://boothost/f22-atomic/user-data > /var/cloud-init/user-data
curl http://boothost/f22-atomic/bootcmd > /var/cloud-init/bootcmd
chmod a+x /var/cloud-init/bootcmd
%end
```

Items _text_ and _ostreesetup_ are boilerplate, nothing special about them. I prefer text because sometimes only a serial console is available. _ostreesetup_  gives the opportunity to install some other system, such as centos atomic for example. In this exercise, we take the default fedora tree.

Since by default cloud-init is disabled we need to enable those services in _services_.

For bare metal installations, I prefer cloud-init datasource located directly on the local disk. This selection is made by setting 'ds=nocloud' in _bootloader_. It can also be configured to fetch from a URL using nocloud-net if that's more suitable. Notice that semicolon must be escaped. Otherwise grub might fail because the bootline is truncated.

Disk partitioning is largely a local preference. Here, LVM is used only because docker with devmapper works best with dedicated thin pool partition. The rest of the disk goes to / partition for simplicity.  Note that even with a thin pool, docker volumes still go to local disk under `/var/lib/docker`. Ideally, we'd forego LVM and allocate a single / ext4 partition. This is possible with overlayfs for example.

In the %post section, we point to a live ostree repository and we also install cloud-init configuration. The installation amounts to copying three files. Two of them are the standard cloud-init files: meta-data and user data. The third one is the script that sets up the cluster. Note that meta-data sets hostname. We need to supply different meta-data for each machine.

### cloud-init

There are many ways cloud-init configuration can be structured and applied during the boot process. Here, we go with simplicity keeping DIY cluster installations in mind. We use generic options in meta-data and user-data delegating most of the work to a single script.

**meta-data**

```
instance-id: iid-local01
local-hostname: a1
```

We set hostname as _a1_, _a2_, _a3_ respectively for each machine.

**user-data**

```
#cloud-config
password: letmein
ssh_pwauth: True
chpasswd: { expire: False }

ssh_authorized_keys:
  - ssh-dss AAAAB3...pbLwNOo= me@diycluster

users:
  - name: fedora
  - groups: docker

bootcmd:
  - /var/cloud-init/bootcmd
```

The first line is not a comment, it is required for the file to be recognized as a cloud-init configuration. We set password for user _fedora_. This user is hardcoded into the image. We also setup an ssh key for a more secure access.  Sometimes things don't go as planned so a password comes in handy if all we get is a serial console. We add user _fedora_ to group _docker_ to gain direct access to docker.

The last item, _bootcmd_, instructs cloud-init to run a script on the earliest opportunity. The script runs before docker starts and before network is configured. This gives us a perfect opportunity to configure the cluster before any defaults interfere with the intentions.

**bootcmd**

```
#!/bin/bash
# Run on boot once

set -eux
if [ -f /etc/systemd/system/etcd.service.d/restart.conf ]; then
    exit 0
fi

groupadd -r docker

# Setup etcd

cluster=a1=http://192.168.99.51:2380,\
		a2=http://192.168.99.52:2380,\
        a3=http://192.168.99.53:2380

host=$(grep local-hostname /var/cloud-init/meta-data | cut -d: -f2 | tr -d [:space:])
host=${host%%.*}

ip=${cluster#*$host=}
ip=${ip%%:2380*}
ip=${ip#*//}

mv /etc/etcd/etcd.conf /etc/etcd/etcd.conf.save
cat <<EOF >/etc/etcd/etcd.conf
# [member]
ETCD_NAME=$host
ETCD_DATA_DIR="/var/lib/etcd/$host.etcd"
ETCD_LISTEN_PEER_URLS="http://$ip:2380"
ETCD_LISTEN_CLIENT_URLS="http://localhost:2379,http://$ip:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://$ip:2380"
ETCD_INITIAL_CLUSTER="$cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="diy-cluster"
ETCD_ADVERTISE_CLIENT_URLS="http://$ip:2379"
EOF

mkdir /etc/systemd/system/etcd.service.d
cat <<EOF >/etc/systemd/system/etcd.service.d/restart.conf
[Service]
Restart=on-failure
RestartSec=1
EOF

# Setup flannel

mv /etc/sysconfig/flanneld /etc/sysconfig/flanneld.save
cat <<EOF >/etc/sysconfig/flanneld
FLANNEL_ETCD=http://127.0.0.1:2379
FLANNEL_ETCD_KEY=/admin/flannel
EOF

mkdir /etc/systemd/system/flanneld.service.d
cat <<EOF >/etc/systemd/system/flanneld.service.d/init.conf
[Service]
ExecStartPre=/usr/bin/etcdctl set /admin/flannel/config \
            {\"Network\":\"172.18.0.0/16\"}
Restart=on-failure
RestartSec=1
EOF

# Restart

systemctl daemon-reload
systemctl enable etcd.service
systemctl enable flanneld.service
systemctl reboot
```

The _if_ statement makes sure the script runs only once after installation. We add group `docker` to give user `fedora` access to docker.

The etcd setup uses bash string processing to deduce the host's name and its assigned ip address. The name of the host is set in the meta-data file. Cluster configuration is set in the _cluster_ variable. This setting relies on dhcp always allocating listed IP addresses to the named hosts. Once _host_ and _ip_ are computed we setup standard etcd bootstrap.  We setup a restart in case of failures using a systemd unit drop-in. It is not necessary but etcd is sometimes confused during boot which causes it to give up. A simple restart brings it back to operation.

Flannel needs to know what network to use as an overlay. We convey that information in an etcd key which is set before flannel starts. The setting of the key will block until the cluster comes up.  This may take several minutes depending on the initial boot sequence.  In case of flannel, we add a restart as well. As with etcd, it is not necessary but sometimes allows flannel to recover from weird etcd states.

Finally, we enable etcd and flannel services before rebooting. I prefer to go through a reboot, rather than continue, because this gives me a better idea what will happen on any subsequent restart whether due to maintenance, power down, or any other reason.

### Start the Cluster

With this configuration, we can now netboot the three machines and they will come up forming an operational atomic host cluster.  We login and run hostname command for a simple check if everything is alright.

```
fedora@a1 ~ $ hostname -I
192.168.99.51 172.18.66.0 172.18.66.1 
```

We can see the IP addresses from the flannel range which is an indication that docker started over flannel network thus implying that all components performed as intended: netboot, kickstart, cloud-init, etcd, flannel, and docker.

To be doubly sure, we run a container and see if we can ping the other hosts.

```
fedora@a1 ~ $ etcdctl ls admin/flannel/subnets
/admin/flannel/subnets/172.18.18.0-24
/admin/flannel/subnets/172.18.66.0-24
/admin/flannel/subnets/172.18.13.0-24

fedora@a1 ~ $ docker run -it --rm centos:7 /bin/bash
[root@080a4f9e60a2 /]# ping 172.18.18.1
PING 172.18.18.1 (172.18.18.1) 56(84) bytes of data.
64 bytes from 172.18.18.1: icmp_seq=1 ttl=61 time=0.955 ms
64 bytes from 172.18.18.1: icmp_seq=2 ttl=61 time=2.23 ms
64 bytes from 172.18.18.1: icmp_seq=3 ttl=61 time=1.01 ms
^C
--- 172.18.18.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.955/1.400/2.230/0.587 ms
[root@080a4f9e60a2 /]# exit
```

First we find out which flannel subnets have been allocated, then we start a container and run a ping targeting flannel end points on the other machines.

Assuming everything has gone according to plan, it works! Now you should have a simple bare metal Atomic Host cluster to work with. 
