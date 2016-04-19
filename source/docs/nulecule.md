---
title: "Nulecule Specification"
---

# Nulecule: A Composite Container-based Application Specification

***/NOO-le-kyul/*** *(n.)* &ndash; a made-up word meaning &quot;*[the mother of all atomic particles](http://simpsons.wikia.com/wiki/Made-up_words)*.&quot; Sounds like "molecule". But different.

**Package once. Run anywhere.** With pluggable orchestration providers you can package your application to run on OpenShift, Kubernetes, Docker Compose, Helios, Panamax, Docker Machine, etc. and allow the user to choose the target when deployed.

**Compose applications from a catalog.** No need to re-package common services. Create composite applications by referencing other Nulecule-compliant apps. Adding a well-designed, orchestrated database is simply a reference to another container image.

**MSI Installer for containers.** Replace your shell script and deployment instructions with some metadata.

**Change runtime parameters for different environments.** No need to edit files before deployment. Users can choose interactive or unattended deployment. Guide web interface users with parameter metadata to validate user input and provide descriptive help.

## Problem Statement
Currently there is no standard mechanism to define a composite multi-container application or composite service composed of aggregate pre-defined building blocks spanning multiple hosts and clustered deployments. In addition, the associated metadata and artifact management requires separate processes outside the context of the application itself.

## What is Nulecule?

Nulecule defines a pattern and model for packaging complex multi-container applications, referencing all their dependencies, including orchestration metadata in a container image for building, deploying, monitoring, and active management.

The Nulecule specification enables complex applications to be defined, packaged and distributed using standard container technologies. The resulting container includes dependencies while supporting multiple orchestration providers and ability to specify resource requirements. The Nulecule specification also supports aggregation of multiple composite applications. The Nulecule specification is container and orchestration agnostic, enabling the use of any container and orchestration engine.

## Nulecule Specification

The Nulecule Specification is developed as a community effort on github.

The Team uses a <a href="https://www.redhat.com/mailman/listinfo/container-tools">mailing lists</a> hosted by Red Hat.

If you want to contribute to the Nulecule Specification itself, we welcome you at <a href="https://github.com/projectatomic/nulecule/">the spec's repo</a>.


### Highlights

* Application description and context maintained within a single container through extensible metadata
* Composable definition of complex applications through inheritance and composition of containers into a single, standards-based, portable description.
* Simplified dependency management for the most complex applications through a directed graph to reflect relationships.
* Container and orchestration engine agnostic, enabling the use of any container technology and/or orchestration technology

### Releases

* latest, 0.0.2 <a href="/nulecule/spec/0.0.2/index.html">human readable version</a>, <a href="https://github.com/projectatomic/nulecule/tree/master/spec/schema.json">machine readable version</a>
* 0.0.1-alpha <a href="https://github.com/projectatomic/nulecule/releases/tag/v0.0.1-alpha">Archive</a>

## “The Big Picture”

<img src="/images/nulecule-diagram.png" width="100%" alt="Nulecule specification high-level story" />

## Deployment User Experience

Here's an example using [Atomic App](https://github.com/projectatomic/atomicapp), a reference implementation of Nulecule with a Kubernetes provider.

### Option 1: Interactive

Run the image. You will be prompted to provide required values that are missing from the default configuration.
```
$ [sudo] atomic run projectatomic/helloapache
```

### Option 2: Unattended

1. Fetch an Atomic App with a generated answers.conf file.
```
$ [sudo] atomic run projectatomic/helloapache --mode fetch --destination helloapache 
...

Your application resides in helloapache
Please use this directory for managing your application
```

2. Mode and modify the answers.conf.sample to your liking.
```
$ mv answers.conf.sample answers.conf
$ vim answers.conf

  [general]
  provider = kubernetes

  [helloapache-app]
  image = centos/httpd # optional: choose a different image
  hostport = 80        # optional: choose a different port to expose
```

3. Run the application from the current working directory

```
$ [sudo] atomic run projectatomic/helloapache .
...
helloapache
```

## Developer User Experience

See the [Getting Started with Nulecule guide](https://github.com/projectatomic/nulecule/blob/master/docs/getting-started.md).

## Implementations

This is only a specification. Implementations may be written in any language. See [implementation guide](https://github.com/projectatomic/nulecule/blob/master/docs/implementation_guide.md) for more details.

**Reference implementation:** https://github.com/projectatomic/atomicapp

### Developer tooling

Developer tooling is TBD. There is some work planned for [DevAssistant](http://devassistant.org/).

### Contributing

Please review the [contributing guidelines](https://github.com/projectatomic/nulecule/blob/master/CONTRIBUTING.md) before submitting pull requests.

###Communication channels

* IRC: #nulecule (On Freenode)
* Mailing List: [container-tools@redhat.com](https://www.redhat.com/mailman/listinfo/container-tools)
