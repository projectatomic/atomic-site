#!/bin/bash
# install everything in a docker container based on Fedora 20
# permit to have the same env on any system without any issue

# set SElinux context to allow docker to read the source directory
chcon -Rt svirt_sandbox_file_t source/

# requires docker and being in the right group
docker build -t middleman .
docker run -p 4567:4567 -v "$(pwd)"/source:/tmp/source:ro middleman 
