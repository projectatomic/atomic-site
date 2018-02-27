---
title: Buildah Blocks- Buildah builds itself!
author: tsweeney
date: 2018-02-27 00:00:00 UTC
published: true
comments: false
tags: atomic, buildah, containers
---

I’m a fan of Isaac Asimov’s ["Three Laws of Robotics"](https://en.wikipedia.org/wiki/Three_Laws_of_Robotics) and I'm beginning to wonder if these laws need to be wired into [Buildah](https://github.com/projectatomic/buildah). You see Buildah builds itself. It’s self-propagating.

READMORE

We recently were building out our test system for Buildah and for part of that testing we needed to make sure Buildah's RPM would build.  Buildah uses Travis CI to do its testing and within our test bats file we create a container and then the RPM within it to make sure the RPM builds appropriately. While reviewing the code for that test, I commented that it would be nice if we could create a second container to install the RPM on and maybe make sure the command `buildah help` worked.

Nalin Dahyabhai, who started the Buildah project, one upped that (truth be told, that's Nalin's Standard Operating Procedure).  What he put together was deceptively simple, yet extremely powerful.

First Nalin creates a container using the command ‘buildah from’ using Fedora 27.  This creates a container that runs Fedora 27.  He then uses ‘buildah mount’ to get the location of the container’s root file system and saves that to the ‘$root’ variable.  Once that’s in hand, a directory is created for the rpm bits and pieces to be placed into that will be needed to make an RPM for Buildah.

```
# Build a container to use for building the binaries.
    	image=registry.fedoraproject.org/fedora:27
    	cid=$(buildah --debug=false from --pull --signature-policy ${TESTSDIR}/policy.json $image)
    	root=$(buildah --debug=false mount $cid)
    	commit=$(git log --format=%H -n 1)
    	shortcommit=$(echo ${commit} | cut -c-7)
    	mkdir -p ${root}/rpmbuild/{SOURCES,SPECS}
```

Now that a container is ready, the necessary spec files are put in place and rpmbuild is invoked on the container to make the rpm file for Buildah.

```
# Build the tarball.
(cd ..; git archive --format tar.gz --prefix=buildah-${commit}/ ${commit}) > ${root}/rpmbuild/SOURCES/buildah-${shortcommit}.tar.gz

# Update the .spec file with the commit ID.
sed s:REPLACEWITHCOMMITID:${commit}:g ${TESTSDIR}/../contrib/rpm/buildah.spec > ${root}/rpmbuild/SPECS/buildah.spec

# Install build dependencies and build binary packages.
buildah --debug=false run $cid -- dnf -y install 'dnf-command(builddep)' rpm-build
buildah --debug=false run $cid -- dnf -y builddep --spec rpmbuild/SPECS/buildah.spec
buildah --debug=false run $cid -- rpmbuild --define "_topdir /rpmbuild" -ba /rpmbuild/SPECS/buildah.spec
```

Then a second container is built again using Fedora 27 and the rpm file that was built on the first container is copied into this new container. Then the rpm is installed using dnf. Buildah has now been installed onto the new container with the latest bits from GitHub.

```
# Build a second new container.
cid2=$(buildah --debug=false from --pull --signature-policy ${TESTSDIR}/policy.json registry.fedoraproject.org/fedora:
root2=$(buildah --debug=false mount $cid2)

# Copy the binary packages from the first container to the second one and build a list of
# their filenames relative to the root of the second container.
rpms=
mkdir -p ${root2}/packages
for rpm in ${root}/rpmbuild/RPMS/*/*.rpm ; do
cp $rpm ${root2}/packages/
rpms="$rpms "/packages/$(basename $rpm)
done

# Install the binary packages into the second container.
buildah --debug=false run $cid2 -- dnf -y install $rpms
```

With the new container up and running, Nalin's able to run a number of commands in the container pulling out key information to verify that the rpm is installed and works as expected.

```
# Run the binary package and compare its self-identified version to the one we tried to build.
id=$(buildah --debug=false run $cid2 -- buildah version | awk '/^Git Commit:/ { print $NF }')
bv=$(buildah --debug=false run $cid2 -- buildah version | awk '/^Version:/ { print $NF }')
rv=$(buildah --debug=false run $cid2 -- rpm -q --queryformat '%{version}' buildah)
echo "short commit: $shortcommit"
echo "id: $id"
echo "buildah version: $bv"
echo "buildah rpm version: $rv"
test $shortcommit = $id
test $bv = $rv
```

There you have it, Buildah building and testing itself.  Granted I’m not too worried if Buildah doesn’t follow the "Three Laws of Robotics" at this point, but this technique is really powerful. This test runs on each and every pull request to Buildah. If the RPM can’t be built, installed and minimal operations completed, the tests won’t run and the code won’t get committed.

For more information on Buildah check it out on [GitHub](https://github.com/projectatomic/buildah) - also checkout the [rpm.bats](https://github.com/projectatomic/buildah/blob/master/tests/rpm.bats) file there which is where code examples in this blog came from.  If you’re interested, we’d love to have you become a contributor on the project.

**Buildah == Simplicity**
