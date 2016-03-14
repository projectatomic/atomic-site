---
title: Docker credentials store
author: runcom
date: 2016-03-11 15:55:08 UTC
tags: docker
published: false
comments: true
---

One security feature coming with the upcoming Docker 1.11 is the ability to store the credentials
used to authenticate to registries into an external credentials store. Docker 1.11 will be able to automatically detect and use a default credentials
store for the platform it will run on. We'll be talking more about this in the next paragraphs, but first, let's see how Docker is currently storing credentials.
Login and logout
=
Nowadays Docker stores the credentials used to authenticate to registries inside a json file (usually in `$HOME/.docker/config.json`).
The format is pretty simple:

```bash
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
After a successful `docker login`, Docker stores a base64 encoded string from the concatenation of the username, a colon, 
and the password and associates this string to the registry the user is logging into:

```bash
$ echo YW11cmRhY2E6c3VwZXJzZWNyZXRwYXNzd29yZA== | base64 -d -
amurdaca:supersecretpassword
```
Let's forget about the `email` field because it will be removed in Docker 1.11 and it has never been used for authentication purposes.

A `docker logout` simply removes the entry from the json file for the given registry the user is trying to logout from:

```bash
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
Interacting with registries
=
Let's put this simple; if the registry the user is interacting with requires authentication, Docker retrieves the username and  the password
from the aforementioned json file and use them to authenticate. No big deal.
External credentials store
=
As said above, Docker 1.11 implements communication with an external credentials store, ala `git-credential-helper`. 
The implementation shells out to a helper program when a credentials store is configured. Those programs can be implemented with any language as long as they follow the convention to pass arguments and information. The pull request which added this new feature can be found at [docker/docker#20107](https://github.com/docker/docker/pull/20107).
Docker is also providing a library to help building those credentials helpers at [docker/docker-credential-helpers](https://github.com/docker/docker-credential-helpers).

To configure an *external* credentials store a user need an external helper program to interact with a specific keychain or external store. Docker requires the helper  program to be in the client's host `$PATH`. Docker itself is providing sane defaults for osx and windows and I've recently added support for a credentials store for linux ([docker/docker-credential-helpers#7](https://github.com/docker/docker-credential-helpers/pull/7)) which is using `libsecret` to work with the gnome keyring (and the KDE one). 

Once the helper program is installed on the client's host the user just needs to tell the Docker client to actually use it. Beaware the user needs to perform a `docker logout` to remove the credentials already stored in the json file.

This is how a configuration file looks like  after a successful `docker login`:

```bash
$ cat $HOME/.docker/config.json
{
	"auths": {
		"localhost:5001": {}
	},
	"credsStore": "secretservice"
}
```
The file is telling us that we have stored credentials for the registry at `localhost:5001` and we can see no credentials are stored in the file. Instead we can see that `credsStore` is populated with the string `secretservice` (which is the default on linux if installed). Docker reads the `credsStore` string and execute the helper `docker-credential-secretservice` to interact with the credentials store.

With the help of the binary `secret-tool` we can retrieve the credentials stored (just for debugging purposes):

```bash
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

When interacting with registries Docker queries the credentials store configured and uses the credentials returned (if any).

Generally, it's desiderable to have the system credentials store managing secrets (specifically passwords) in order to apply any additional security measures (apart from file permissions).  
The default linux credentials store uses the system keyring to store username and password for Docker (other tools do this such as Google Chrome) in the default Login session. This means the keyring is automatically unlocked when the user logins into the system. Password stored there also persist indefinitely, a reboot won't erase them for instance.  

This pluggability helps us create and use more advanced *secrets backends* . We're currently exploring the [`custodia`](https://github.com/latchset/custodia) project to be used as an external credentials store for Docker, so stay tuned for more information!  
Other implementations may store encrypted (hashed) credentials and validate the credentials provided without explicitly storing plain passwords.

If you want to understand more about how all this is working or if you want to implement your own credentials store, you can find more information at [docker/docker-credential-helpers](https://github.com/docker/docker-credential-helpers).