# Inter-Container Software-Defined Networking using iptables

Geard uses iptables to enable containers to connect to each other.
Network namespaces allows adding iptables rules to the network namespace
of a container. The basic idea is to make remote endpoints appear as
if they were local to a container. For example the database container
could be made to appear to be running locally inside the application
container.

To make this work, ip_forwarding and localnet_routing are enabled
within a container:

    /usr/sbin/sysctl -w net.ipv4.ip_forward=1
    /usr/sbin/sysctl -w net.ipv4.conf.all.route_localnet=1

Then, NAT rules are added to map the remote endpoint to a local endpoint:

    iptables -t nat -A PREROUTING -d ${local_ip}/32 -p tcp -m tcp \
        --dport ${local_port} -j DNAT --to-destination ${remote_ip}:${remote_port}
    iptables -t nat -A OUTPUT -d ${local_ip}/32 -p tcp -m tcp \
        --dport ${local_port} -j DNAT --to-destination ${remote_ip}:${remote_port}
    iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source ${container_ip}

If there are two containers, for example an application container and
a database container, then it would make sense to link the db container
to the application container. If the application container is running
on host 1 and the db container is on host 2 (10.16.138.101:49153), then
running the rules above using gear link would make the db container appear
to run on the localhost:3306 of the application container.

    gear link -n "127.0.0.1:3306:10.16.138.101:49153" server/application_container_1

Two advantages of this approach are:

* The application code or configuration to connect to the database
  doesn't have to change for all instances of the application container.
* The database container could be moved to any host and the application
  would just have to flush and rerun gear link to point to the new location.

