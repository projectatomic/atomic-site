---
title: 'skopeo: inspect remote images'
author: runcom
date: 2016-03-01 10:39:51 UTC
tags: docker
published: true
comments: true
---

The `atomic verify` command checks whether there is a newer image available remotely and scans through all layers to see if any of the layers, which are base images themselves, have a new version available.  If the tool finds an out-of-date image, it will report as such. The command attempts to reach out the registry where the image has been downloaded from to understand if the local image is outdated.

Currently, `atomic verify` relies on a Docker patch that Red Hat is carrying called *remote repository inspection*. It adds a new REST route that basically returns `docker inspect`-like information about a given image as found in the remote registry the image is hosted. We need this feature because `atomic verify` uses `LABEL`(s)&mdash;and in particular the `Version` `LABEL`&mdash;to check whether the local image needs to be updated. For more information about labels, see  the [projectatomic/ContainerApplicationGenericLabels](https://github.com/projectatomic/ContainerApplicationGenericLabels).

READMORE

We've been trying to push this patch upstream but the pull request got closed:  [docker/docker#14258](https://github.com/docker/docker/pull/14258). The linked issue is still open, though: [docker/docker#14257](https://github.com/docker/docker/issues/14257).

To avoid carrying a huge patch just to retrieve information about an image on registry with `docker`, we decided to put this feature into a small go binary called [skopeo](https://github.com/runcom/skopeo).

The `skopeo` binary is really simple, you just need to provide a fully qualified image (plus a reference&mdash;tag or digest&mdash;if you want to. By fully qualified, we mean you need to provide the registry url as part of the full image name (as opposed to what `docker` does when you run `FROM ubuntu`, which resolves to the `docker.io` public registry).

```
$ skopeo docker.io/ubuntu:12.04

{"Tag":"12.04","Digest":"sha256:bb0c00ca5e62017928cdb26324f7f6fe266cdfa21743857fd503d6ea73bc348a","RepoTags":["10.04","12.04.5","12.04","12.10","13.04","13.10","14.04.1","14.04.2","14.04.3","14.04.4","14.04","14.10","15.04","15.10","16.04","latest","lucid","precise-20150212","precise-20150228.11","precise-20150320","precise-20150427","precise-20150528","precise-20150612","precise-20150626","precise-20150729","precise-20150813","precise-20150924","precise-20151020","precise-20151028","precise-20151208","precise-20160108","precise-20160217","precise-20160225","precise","quantal","raring","saucy","trusty-20150218.1","trusty-20150228.11","trusty-20150320","trusty-20150427","trusty-20150528","trusty-20150612","trusty-20150630","trusty-20150730","trusty-20150806","trusty-20150814","trusty-20151001","trusty-20151009","trusty-20151021","trusty-20151028","trusty-20151208","trusty-20151218","trusty-20160119","trusty-20160217","trusty-20160226","trusty","utopic-20150211","utopic-20150228.11","utopic-20150319","utopic-20150418","utopic-20150427","utopic-20150528","utopic-20150612","utopic-20150625","utopic","vivid-20150218","vivid-20150309","vivid-20150319.1","vivid-20150421","vivid-20150427","vivid-20150528","vivid-20150611","vivid-20150802","vivid-20150813","vivid-20150930","vivid-20151021","vivid-20151106","vivid-20151111","vivid-20151208","vivid-20160122","vivid","wily-20150528.1","wily-20150611","wily-20150708","wily-20150731","wily-20150807","wily-20150818","wily-20150829","wily-20151006","wily-20151009","wily-20151019","wily-20151208","wily-20160121","wily-20160217","wily","xenial-20151218.1","xenial-20160119.1","xenial-20160125","xenial-20160217.2","xenial-20160226","xenial"],"Comment":"","Created":"2016-02-26T22:10:13.587480841Z","ContainerConfig":{"Hostname":"4ca411e46fda","Domainname":"","User":"","AttachStdin":false,"AttachStdout":false,"AttachStderr":false,"Tty":false,"OpenStdin":false,"StdinOnce":false,"Env":[],"Cmd":["/bin/sh","-c","#(nop) CMD [\"/bin/bash\"]"],"Image":"98bef3c5ecfd87001d7bf9783237987cbe29663909410e997ba4f601fcbdbf60","Volumes":null,"WorkingDir":"","Entrypoint":null,"OnBuild":null,"Labels":{}},"DockerVersion":"1.9.1","Author":"","Config":{"Hostname":"4ca411e46fda","Domainname":"","User":"","AttachStdin":false,"AttachStdout":false,"AttachStderr":false,"Tty":false,"OpenStdin":false,"StdinOnce":false,"Env":[],"Cmd":["/bin/bash"],"Image":"98bef3c5ecfd87001d7bf9783237987cbe29663909410e997ba4f601fcbdbf60","Volumes":null,"WorkingDir":"","Entrypoint":null,"OnBuild":null,"Labels":{}},"Architecture":"amd64","Os":"linux"}
```

The tool will output a json representation of the image available in the registry, instead of downloading it and later performing the inspection. As part of the output, `skopeo` lists also all available tags the image has on the given registry.
The full json output is really similar to the `docker inspect` output, but it lacks some information such as the size of the image (which is not relevant in a remote inspection).

The `skopeo` app also supports registries that require authentication (such as private images on `docker.io`):

```
$ skopeo docker.io/runcom/busyboxt

{"Tag":"latest","Digest":"sha256:24c4959faaaa08af2b964fa753f6608163bde0b0a8db4250d58989f4737ac4c2","RepoTags":["latest"],"Comment":"","Created":"2016-01-15T18:06:41.282540103Z","ContainerConfig":{"Hostname":"aded96b43f48","Domainname":"","User":"","AttachStdin":false,"AttachStdout":false,"AttachStderr":false,"Tty":false,"OpenStdin":false,"StdinOnce":false,"Env":null,"Cmd":["/bin/sh","-c","#(nop) CMD [\"sh\"]"],"Image":"9e77fef7a1c9f989988c06620dabc4020c607885b959a2cbd7c2283c91da3e33","Volumes":null,"WorkingDir":"","Entrypoint":null,"OnBuild":null,"Labels":null},"DockerVersion":"1.8.3","Author":"","Config":{"Hostname":"aded96b43f48","Domainname":"","User":"","AttachStdin":false,"AttachStdout":false,"AttachStderr":false,"Tty":false,"OpenStdin":false,"StdinOnce":false,"Env":null,"Cmd":["sh"],"Image":"9e77fef7a1c9f989988c06620dabc4020c607885b959a2cbd7c2283c91da3e33","Volumes":null,"WorkingDir":"","Entrypoint":null,"OnBuild":null,"Labels":null},"Architecture":"amd64","Os":"linux"}
```

In our case, we can now provide everything needed to `atomic verify` by just running:

```
$ skopeo registry.access.redhat.com/rhel7 | jq '.Config.Labels.Version'

"7.2"
```

The `skopeo` binary is relatively new and in the future we aim to support [appc](https://github.com/appc/spec) images as well. However, right now, *appc* images need to be downloaded before being inspected, so it might be worth working on exposing image metadata as part of the their discovery procedure.
