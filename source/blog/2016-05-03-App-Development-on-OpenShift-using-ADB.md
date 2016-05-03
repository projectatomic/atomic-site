---
title: App Development on OpenShift using ADB
author: praveenkumar
date: 2016-05-03 14:14:00 UTC
tags: openshift, origin, ADB
published: true
comments: true
---
[The Atomic Developer Bundle (ADB)](https://github.com/projectatomic/adb-atomic-developer-bundle) is a prepackaged development environment filled production-grade pre-configured tools that also include [OpenShift origin](https://github.com/openshift/origin). Using ADB app-developers can easily start building and developing their application on OpenShift platform.

In this blog post, we are going to learn step by step to create an application on OpenShift platform and deploy. Before we proceed any further, I highly recommend you to go through [prerequisites guide](https://github.com/projectatomic/adb-atomic-developer-bundle/blob/master/docs/installing.rst). ADB provide a custom Vagrantfile to setup and provision OpenShift platform.

READMORE

## Guideline for App Creation

**Step 1. Get ADB custom Vagrantfile for OpenShift**

```
$ git clone https://github.com/projectatomic/adb-atomic-developer-bundle
$ cd adb-atomic-developer-bundle/components/centos/centos-openshift-setup
$ vagrant up
```

**Step 2. Download OpenShift origin client for your host**

- [Windows](https://github.com/openshift/origin/releases/download/v1.1.1/openshift-origin-client-tools-v1.1.1-e1d9873-windows.zip)
- [Mac](https://github.com/openshift/origin/releases/download/v1.1.1/openshift-origin-client-tools-v1.1.1-e1d9873-mac.zip)
- [Linux](https://github.com/openshift/origin/releases/download/v1.1.1/openshift-origin-client-tools-v1.1.1-e1d9873-linux-64bit.tar.gz)

**Step 3. Get OpenShift CLI details using `vagrant-service-manager` plugin**

```
$ vagrant service-manager env openshift
You can access the OpenShift console on: https://10.1.2.2:8443/console
To use OpenShift CLI, run: oc login https://10.1.2.2:8443
```

**Step 4. Login to OpenShift using client tool (*Make sure you use relative/absolute path for client binary*)**

```
$ ./oc login https://10.1.2.2:8443
The server uses a certificate signed by an unknown authority.
You can bypass the certificate check, but any data you send to the server could be intercepted by others.
Use insecure connections? (y/n): y

Authentication required for https://10.1.2.2:8443 (openshift)
Username: openshift-dev
Password: devel
Login successful.

Using project "sample-project".
```

**Step 5. Sample templates provided to give an idea how you can create your application**

```
$ ./oc get templates -n openshift
NAME                                 DESCRIPTION                                                                        PARAMETERS      OBJECTS
cakephp-example                      An example CakePHP application with no database                                    15 (8 blank)    5
cakephp-mysql-example                An example CakePHP application with a MySQL database                               16 (3 blank)    7
eap64-basic-s2i                      Application template for EAP 6 applications built using S2I.                       12 (3 blank)    5
eap64-mysql-persistent-s2i           Application template for EAP 6 MySQL applications with persistent storage bui...   34 (16 blank)   10
jws30-tomcat7-mysql-persistent-s2i   Application template for JWS MySQL applications with persistent storage built...   28 (11 blank)   10
nodejs-example                       An example Node.js application with no database                                    12 (8 blank)    5
nodejs-mongodb-example               An example Node.js application with a MongoDB database                             13 (3 blank)    7

```

**Step 6. Let we go ahead and deploy our first app [nodejs-example](https://github.com/openshift/nodejs-ex)**

```
$ ./oc new-app nodejs-example
--> Deploying template "nodejs-example" in project "openshift" for "nodejs-example"
     With parameters:
      Memory Limit=512Mi
      Git Repository URL=https://github.com/openshift/nodejs-ex.git
      Git Reference=
      Context Directory=
      Application Hostname=
      GitHub Webhook Secret=diq3I7lgSY4IQe5IMgmA7QJB77A6SSCJBjicXd6G # generated
      Generic Webhook Secret=ICtFb7HtU0vBKU5OxFXMR8UKxIdhAG8eiT2AYlYc # generated
      Database Service Name=
      MongoDB Username=
      MongoDB Password=
      Database Name=
      Database Administrator Password=
--> Creating resources with label app=nodejs-example ...
    service "nodejs-example" created
    route "nodejs-example" created
    imagestream "nodejs-example" created
    buildconfig "nodejs-example" created
    deploymentconfig "nodejs-example" created
--> Success
    Build scheduled for "nodejs-example", use 'oc logs' to track its progress.
    Run 'oc status' to view your app.
```

**Step 7. Check status of your deployed application**

```
$ ./oc status
In project OpenShift sample project (sample-project) on server https://10.1.2.2:8443

svc/nodejs-example - 172.30.252.169:8080
  dc/nodejs-example deploys istag/nodejs-example:latest <-
    bc/nodejs-example builds https://github.com/openshift/nodejs-ex.git with openshift/nodejs:0.10
    #1 deployed 3 minutes ago - 1 pod
  exposed by route/nodejs-example

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```

**Step 8. Get your application route to access from browser (*nodejs-example-sample-project.centos7-adb.10.1.2.7.xip.io*)**

```
$ ./oc get routes
NAME             HOST/PORT                                                       PATH      SERVICE          TERMINATION   LABELS
nodejs-example   nodejs-example-sample-project.centos7-adb.10.1.2.7.xip.io            nodejs-example                 app=nodejs-example,template=nodejs-example
```

So now you have a sample app running on OpenShift platform. You can do lot of experiments using [client binary](https://docs.openshift.org/latest/cli_reference/index.html) or from the [browser](https://docs.openshift.org/latest/getting_started/developers/developers_console.html). Give it a try and let us know your feedback/concern/issues.
