---
title: Creating OCI configurations with the ocitools generate library
author: Haiyan Meng
date: 2016-08-09 14:00:00 UTC
tags: OCI, ocitools, runc
published: true
comments: true
---

[OCI runc](https://github.com/opencontainers/runc) is a cool new tool for running containers on Linux machines. It follows the OCI container runtime specification. As of docker-1.11 it is the main mechanism that docker uses for launching containers.

The really cool thing is that you can use runc without even using docker. First you create a rootfs on your disk: a directory that includes all of your software and usually follows the basic layout of `/`. There are several tools that can create a rootfs, including dnf or the `atomic` command. Once you have a rootfs, you need to create a `config.json` file which runc will read. `config.json` has all of the specifications for running a container, things like which namespaces to use, which capabilities to use in your container, and what is the pid 1 of your container. It is somewhat similar to the output of `docker inspect`.

Creating and editing the config.json is not for the faint of heart, so we developed a command line tool called `ocitools generate` that can do the hard work of creating the config.json file.

## Creating OCI Configurations

This post will guide you through the steps of creating [OCI](https://github.com/opencontainers/runtime-spec/) configurations
using the [ocitools generate library](https://github.com/opencontainers/ocitools/tree/master/generate)
for the go programming language.

There are four steps to create an OCI configuration using the ocitools generate library:

1. Import the ocitools generate library into your project;
2. Create an OCI specification generator;
3. Modify the specification by calling different methods of the specification generator;
4. Save the specification.

READMORE

## Overview

The ocitools generate library defines a struct type, *Generator*, to enclose a
pointer to an [OCI
Spec](https://github.com/opencontainers/runtime-spec/blob/master/specs-go/config.go).
Different methods are defined on the *Generator* type to allow the user to
customize the specification pointed by the Generator.  Once a Generator object
is created, different fields of the specification can be modified by calling
the corresponding methods of Generator.  After finishing modifying the
specification, *Generator.Save* can be called to save the specification into a
local file.

## Create an OCI configurations using the ocitools generate library

**Step 1: import the ocitools generate library in your go project:**

```
import "github.com/opencontainers/ocitools/generate"
```

**Step 2: create a specification Generator:**

```
specgen := generate.New()
```
*generate.New* creates a spec Generator with the default spec.
You can also create a spec Generator with the spec from a local file using *generate.NewFromFile*:

```
specgen := generate.NewFromFile("/data/myspec.json")
```

**Step 3: modify the specification:**

```
specgen.SetRootPath("rootfs")
specgen.SetProcessGID(1000)
specgen.SetProcessTerminal(true)
specgen.SetLinuxResourcesCPUShares(512)
specgen.SetupPrivileged(false)

specgen.ClearAnnotations()
specgen.AddAnnotation("owner", "hmeng")
specgen.RemoveAnnotation("createdat")

specgen.AddLinuxUIDMapping(0, 1000, 50)
specgen.AddPreStartHook("/tmp/install.sh", []string{"--mode", "silent"})
specgen.AddTmpfsMount("/tmp", "ro")
specgen.AddCgroupsMount("rw")
specgen.AddBindMount("/home/test/file1", "/file2", "rw")
specgen.DropProcessCapability("audit_read")

specgen.AddOrReplaceLinuxNamespace("pid", "/proc/28341/ns/pid")
```

For the fields of the OCI spec which have basic types, such as numbers, strings, and booleans, the methods modifying them are
named in the format of *SetFieldName*.
A good example is *SetRootPath*.

For the fields whose types are slices and maps, the library provides the following three categories of methods:
*ClearFieldName* clears the fields,
*AddFieldName* adds a new data object into the field,
and *RemoveFieldName* removes an existing data object from the field.
A good example is *ClearAnnotations*, *AddAnnotation*, and *RemoveAnnotation*.

There are exceptions. For example, *Spec.Process.Args* is a slice of string, however, the library only provides a single method *SetProcessArgs*
to set the process args, because it makes more sense to set the process args in a bundle than adding each argument incrementally.

**Step 4: save the specification:**

```
specgen.SaveToFile("/data/runc/busybox/config.json")
```

And you're done!  You now have a generator for creating spec files for your runc containers.
