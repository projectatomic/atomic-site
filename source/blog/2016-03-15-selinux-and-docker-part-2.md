---
title: Extending SELinux Policy for Containers
author: dwalsh
date: 2016-03-14 10:00:00 UTC
tags: selinux, security, containers, docker
comments: true
published: true
---

## The Problem: A Logger SPC

A developer contacted me about building a container which will run as a log aggregator for
`fluentd`.  This container needed to be a [SPC container](http://developers.redhat.com/blog/2014/11/06/introducing-a-super-privileged-container-concept/) that would manage parts of the host system, namely the log files under /var/logs.

Being a good conscientious developer, he wanted to run his application as securely as possible.
The option he wanted to avoid was running the container in `--privileged` mode, removing all security
from the container.  When he ran his container `SELinux` complained about the container processes trying to read log files.

He asked me if there was a way to run a container where SELinux would allow the access but the container process could still be confined.  I suggested that he could disable SELinux protections for just this container, leaving SELinux enforcing on for the other containers and for the host:

```
docker run -d --security-opt label:disable -v /var/log:/var/log fluentd
```

We did not like this solution.  I believe SELinux provides the best security separation currently available for containers.

Another option we talked about was relabeling the content in the /var/log directories:

```
docker run -d -v /var/log:/var/log:Z fluentd
```

The problem with this is that all of the files under /var/log would not be labeled with a container
specific label (`svirt_sandbox_file_t`) Other parts of the host system like Logrotate, and log scanners would now be blocked from access the log files.

The best option we came up with was to generate a new `type` to run the container with.  

We need to write a little bit of writing policy to make this happen.  Here is what I came up with:

```
cat container_logger.te
policy_module(container_logger, 1.0)

virt_sandbox_domain_template(container_logger)
##############################
# virt_sandbox_net_domain(container_logger_t)
gen_require(`
 attribute   sandbox_net_domain;
')

typeattribute container_logger_t sandbox_net_domain;
##############################
logging_manage_all_logs(container_logger_t)
```

Compile and install the policy
```
make -f /usr/selinux/devel/Makefile container_login.pp
semodule -i container_login.pp
```

Run the container with the new policy.

```
docker run -d -v /var/log:/var/log --security-opt label:type:container_logger_t -n logger fluentd
```

Exec into the container to make sure you can read/write the log files.

```
docker exec -ti logger cat /var/log/messages
docker exec -ti logger touch /var/log/foobar
docker exec -ti logger rm /var/log/foobar
```

Everything works!

## A Closer Look at This Policy

```
policy_module(container_logger, 1.0)
```

`policy_module` names the policy and also brings in all standard definitions of policy.  All policy type
enforcement files start with this.

```
virt_sandbox_domain_template(container_logger)
```

`virt_sandbox_domain_template` is a template macro that actually creates the `container_logger_t` type, and
sets up all of the policy so that the docker process (`docker_t`) can transition to it.  It also defines
rules that allow it to manage `svirt_sandbox_file_t` files and sets it up to be MCS Separated.  This means it
will only be able to use its content and no other containers' content, whether or not the container is running
as the default type `svirt_lxc_net_t` or a custom type.

```
##############################
# virt_sandbox_net_domain(container_logger_t)
gen_require(`
	attribute sandbox_net_domain;
')

typeattribute container_logger_t sandbox_net_domain;
##############################
```

This section will eventually be an interface `virt_sandbox_net_domain`.  (I sent a patch to the upstream
selinux-policy package to add this interface) This new interface just assigns an attribute to `container_logger_t`.  Attributes bring in lots of policy rules, basically this attribute gives full network access to the `container_logger_t` processes.  If your container did not need access to the network, or you wanted to tighten the network ports that `container_logger_t` would be able to listen on or connect to, you would not use this interface.  

```
logging_manage_all_logs(container_logger_t)
```

This last interface `logging_manage_all_logs` gives `container_logger_t` the ability to manage all of the log
file types.  SELinux interfaces are defined and shipped under /usr/share/selinux/devel.

## Conclusion

Adding a fairly simple policy module allows us to run the container as securely as possible and still able to get the job done.
