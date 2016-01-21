#!/bin/sh

git submodule init && git submodule update

sudo dnf install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch make tar xz-devel zlib-devel libxml2-devel ImageMagick redhat-rpm-config

bundle install
