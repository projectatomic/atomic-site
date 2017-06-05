#!/bin/bash
# install everything in a docker container based on Fedora 25
# permit to have the same env on any system without any issue

# set SElinux context to allow docker to read the source directory
chcon -Rt svirt_sandbox_file_t source/
chcon -Rt svirt_sandbox_file_t data/

# requires docker and being in the right group
docker build -t middleman .
atomic run middleman
