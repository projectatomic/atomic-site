#!/usr/bin/env python

"""
This script automates creating a new branch, merging in a numbered pull
request, and starting up the atomic-site in a container so that you can
check the content.  Needs to be run from the atomic-site repo homedir.
Expects Nulecule etc. to be already set up.
"""

import github3
import sys
from subprocess import check_call

if len(sys.argv) < 2:
    print ("usage: test-pull.py #PRNUM")
    sys.exit(-1)
else:
    prnum = sys.argv[1]

# connect anonymously
gh = github3.GitHub()
rep = gh.repository('projectatomic','atomic-site')
# pull the pull request using the user-supplied number
pr = rep.pull_request(prnum)
prsrc = pr.head
# if it's a local pull request, name is branch ...
if prsrc.repo[0] == u'projectatomic':
    prname = prsrc.ref
else:
    #otherwise it's user + branchpip install github3.py
    prname = '{}-{}'.format(prsrc.repo[0],prsrc.ref)

prfrom = 'git://github.com/{}/{}/{}'.format(prsrc.repo[0], prsrc.repo[1], prsrc.ref)

# make sure we're up to date
check_call(["git", "checkout", "master"])
check_call(["git", "pull", "origin", "master"])
# create a branch for the new pr, and pull to it
check_call(["git", "checkout", "-b", prname, "master"])
check_call(["git", "pull", prfrom, prsrc.ref])

# launch the container using docker
check_call(["sudo", "./docker.sh"])
