 
# <span style="color:cornflowerblue">Docker daemon command</span>
## <span style="color:cornflowerblue">Author: Shishir Mahajan</span>
---
Docker 1.8 fixes a long term problem with handling of command line options. It introduces the `docker daemon` command which segregates
the global options from the daemon options.

Docker daemon is a background server side process that manages images and containers. It is a child of the init system e.g systemd and can be started using systemd unit files. For the purpose of this article we will using linux distribution fedora.

A system administrator can execute `systemctl start docker` to start the `docker daemon`.

![systemctl start docker](images/docker_daemon_start.png)

As you can see in the above screenshot, writing `systemctl start docker` will instruct systemd to go to `/usr/lib/systemd/system/docker.service` unit file and start docker based on `ExecStart` flag. Under the hood, this unit file executes the docker binary `/usr/bin/docker -d` to start the daemon. What this means is, a user can also start docker daemon by executing `docker -d` or `docker --daemon`.

So why do we need a new `docker daemon` command ?? Is `docker -d or --daemon` not good enough to start the daemon ! . The new docker daemon command solves a very important problem which I like to call the `Daemon Flag-Set Problem`.

## <span style="color:cornflowerblue">Daemon Flag-set Problem</span>
<br/>
If I do `docker --help` on a docker package prior to docker-1.8, I see the below flags.
<br/>

![docker help](images/docker_help.png)

<br/>

These flags are a combination of globals flags and daemon flags. Global flags are flags which are applicable to all docker commands. 
Daemon flags are specific to docker daemon. Since there is no clear distinction of which flags are global and which are daemon, a docker 
user can pass any of these flags to any docker command. If that flag is global it will be applied to the command, else if the flag is daemon 
it will be silently ignored. 

To give an example, `--selinux-enabled` is a daemon flag which enable selinux support. `docker inspect` is a command which returns low level information on a container or image.
Ideally `--selinux-enabled` flag should only be applicable to `docker daemon`, and if passed to other docker commands should blow up.

<br/>

![docker inspect](images/docker_inspect.png)

<br/>

As you can see in the above screenshot `--selinux-enabled` was silently ignored by the inspect command. To solve this `Daemon Flag-Set Problem`, 
docker daemon command will be introduced starting docker rpm 1.8.0.

## <span style="color:cornflowerblue">Docker Daemon Command</span>

<br/>

On docker rpm 1.8.0 onwards, if a user starts docker daemon using `docker -d` or `docker --daemon`, He will get a warning message to switch to new `docker daemon` command.

![docker warning](images/docker-d.png)

<br/>

`docker --help` would be like the below screenshot.

<br/>

![new docker help](images/new_docker_help.png)

<br/>

As you can see in the above screenshot `docker --help` only show the global flags, and not the daemon flags. 
To see the daemon flags we can do `docker daemon --help` which will produce something like the below output.

<br/>

![new docker daemon help](images/new_docker_daemon_help.png)

<br/>

The above screenshot is a trimmed down version of daemon flags. The actual output will show all daemon flags.

Docker daemon command will bring the following changes to the docker users:

1. 	A user can still start docker daemon using `docker -d` and `docker --daemon`. Docker provides full backward compatibility without breaking any existing use-cases.
2. 	With the new `docker daemon` command, global flags and daemon flags must be passed in the below format.

	![docker daemon format](images/docker_daemon_format.png)

	What this means is, the below command `docker --selinux-enabled daemon` will throw an error. Since `--selinux-enabled` is a daemon flag, it should be passed after docker daemon command. 
	This would however completely work with `docker -d` maintaining the backward compatibility.
	
	![docker daemon error](images/docker-selinux.png)
	![docker daemon error](images/docker_daemon_error.png)

3. Daemon flags now cannot be passed to other docker commands (as global flags) like inspect, pull, push etc. Now, If we run the above  `docker inspect` example again, it would blow up.

Daniel Walsh and I of Red Hat worked on fixing these issues for over a year. Special Thanks to Tibor Vass (Docker) for taking over, completing and making it available upstream.
