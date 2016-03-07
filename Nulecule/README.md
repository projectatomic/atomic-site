# atomic-site atomic app

This directory contains the configuration files for running the atomic-site
as an atomic app.  The guide to bringing it up is in BUILD.md in the main directory.
What's in this file is some additional information about the atomic app setup
for this application.

## providers

Currently only the Docker provider is defined for atomic-site.  PRs for
other providers are more than welcome.

## answers.conf

Here are the current parameters in the answers.conf file, and what they mean:

* **image**: the usual, currently jberkus/atomic-site until projectatomic/atomic-site goes up
* **hostport**: the port to map to on the host, default 4567
* **sourcedir**: the full path to the directory of /source in your clone of
  the atomic-site repository
* **datadir**: the full path to the directory of /data in your clone of the
  atomic-site repository

## volumes

Both /source and /data are mounted as volumes.  This allows you to branch and edit
contents of the atomic site and see the results in the displayed webpage.

## autoremove

Currently, under the Docker provider, atomic-site is set up to autoremove the container
when you exit.
