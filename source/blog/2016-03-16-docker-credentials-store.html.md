---
title: Docker Credential Store
author: runcom
date: 2016-03-16 13:25:00 UTC
tags: docker
published: true
comments: true
---
One security feature in the upcoming Docker 1.11 is the capability to use an external credential store for registry authentication. The new version will automatically detect a configured external store, if it is available, and use it instead of the JSON file. We'll be talking more about this in a few paragraphs, but first, let's see how Docker is currently storing credentials.

READMORE

## Login and Logout

Today, Docker stores the credentials used for registry authentication inside a JSON file (usually in `$HOME/.docker/config.json`). Its format is pretty simple:

```
bash
$ cat $HOME/.docker/config.json
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "YW11cmRhY2E6c3VwZXJzZWNyZXRwYXNzd29yZA==",
			"email": "amurdaca@redhat.com"
		},
		"localhost:5001": {
			"auth": "aGVzdHVzZXI6dGVzdHBhc3N3b3Jk",
			"email": ""
		}
	}
}
```

After a successful `docker login`, Docker stores a base64 encoded string from the concatenation of the username, a colon, and the password and associates this string to the registry the user is logging into:

```
bash
$ echo YW11cmRhY2E6c3VwZXJzZWNyZXRwYXNzd29yZA== | base64 -d -
amurdaca:supersecretpassword
```

Let's forget about the `email` field, since it will be removed in Docker 1.11, and has never been used for authentication purposes.

A `docker logout` simply removes the entry from the JSON file for the given registry:

```
bash
$ docker logout localhost:5001
Remove login credentials for localhost:5001

$ cat $HOME/.docker/config.json
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "YW11cmRhY2E6c3VwZXJzZWNyZXRwYXNzd29yZA==",
			"email": "amurdaca@redhat.com"
		}
	}
}
```

## Interacting with Registries

Let's put this simply; if the registry the user is interacting with requires authentication, Docker retrieves the username and the password from the aforementioned JSON file and uses them to authenticate. No big deal.

## External Credential Store

As said above, Docker 1.11 implements communication with an external credential store, in the same way as the `git-credential-helper` does for git.

The implementation calls out to a helper program process when a credential store is configured. The helper program can be implemented in any programming language as long as it follows the conventions for passed arguments and information. The pull request that added this new feature can be found at [docker/docker#20107](https://github.com/docker/docker/pull/20107).
Docker is also providing a library to help building those credentials helpers at [docker/docker-credential-helpers](https://github.com/docker/docker-credential-helpers).

To configure an *external* credential store a user need an external helper program to interact with a specific keychain or external store. Docker requires the helper  program to be in the client's host `$PATH`. The Docker project itself is providing sane defaults for OS X and Windows. I've recently added support for a credential store for desktop Linux ([docker/docker-credential-helpers#7](https://github.com/docker/docker-credential-helpers/pull/7)), which is using `libsecret` to work with the gnome keyring (and the KDE one).

Once the helper program is installed on the client's host the user just needs to tell the Docker client to actually use it. Be aware that the user needs to perform a `docker logout` to remove the credentials already stored in the JSON file.

This is what a configuration file looks like after a successful `docker login`:

```
bash
$ cat $HOME/.docker/config.json
{
	"auths": {
		"localhost:5001": {}
	},
	"credsStore": "secretservice"
}
```

This file is telling us that we have stored credentials for the registry at `localhost:5001` and we can see no credentials are stored in the file. Instead we can see that `credsStore` is populated with the string `secretservice` (which is the default on Linux if installed). Docker reads the `credsStore` string and execute the helper `docker-credential-secretservice` to interact with the credential store.

With the help of the binary `secret-tool` we can retrieve the credentials stored (just for debugging purposes):

```
bash
$ secret-tool search server localhost:5001
[/org/freedesktop/secrets/collection/login/3774]
label = localhost:5001
secret = testpassword
created = 2016-03-11 17:47:36
modified = 2016-03-12 12:29:31
schema = io.docker.Credentials
attribute.username = testuser
attribute.server = localhost:5001
attribute.docker_cli = 1
```

When interacting with registries Docker queries the credential store configured and uses the credentials returned (if any).

Generally, it's desirable to have the system credential store managing secrets (specifically passwords) in order to apply any additional security measures (apart from file permissions).  
The default desktop Linux credential store uses the system keyring to store username and password for Docker in the default Login session, in the same way that other software like Google Chrome does. This means the keyring is automatically unlocked when the user logins into the system. Passwords stored there also persist indefinitely, so that a reboot won't erase them.  

The feature's pluggability helps us create and use more advanced *secrets backends*, especially for server use. We're currently exploring the [`custodia`](https://github.com/latchset/custodia) project to be used as an external credential store for Docker, so stay tuned for more information!

If you want to understand more about how all this is working or if you want to implement your own credential store, you can find more information at [docker/docker-credential-helpers](https://github.com/docker/docker-credential-helpers).
