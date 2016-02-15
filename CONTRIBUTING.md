# Contributing

We want your contributions to making our site a great resource for 

What follows is a guide to contributing content to the Project Atomic website.  

## Content We Want

We're looking for anything which relates to the various open source sub-projects of Atomic, or running Linux containers on Red Hat platforms.  In general, all content should relate to open source technologies.  This includes:

* Fedora, Centos, and RHEL Atomic Host
* Atomic Developer Bundle
* Cockpit
* OStree and RPM-OStree
* Atomic.app and Nulecule
* Fedora Atomic Workstation
* Running Docker and/or RunC on Fedora/CentOS/RHEL
* Linux container technology and news

For all of the above, we are looking for blog posts, documentation, and technical guides.  Please see below on how to write and contribute these.  The approval process is also outlined below.

## Project Atomic Site Style Guide and Authoring Details

If you are contributing to the Project Atomic site, please look at the following tips and guidelines.

### Style
* Use Markdown* (which flavors are supported by our Middleman install?)
* Use correct indentation levels for code blocks to support correct copy/paste w/o  leading spaces (examples)

### Blog posts
* Fork this repo
* Create a git branch for the blog post for clean merges
* Blogs reside in the source/data/blog directory
* Naming convention is date-title *yyyy-mm-dd-this-is-a-blog*
* Create a pull request to submit for editorial review
 
#### Template
The header for the post should contain the following information, tags are a free form list.  Your post will start immediately following the header.  Add a 'READMORE' tag on a separate line to define at a good place to continue reading the full post.

    ---
    title: Getting started with cloud-init
    author: mmicene
    date: 2014-10-21
    layout: post
    comments: true
    categories: 
    - Blog
    tags: 
    - cloud-init
    - Kubernetes
    ---

#### Images: 
Place in correct directory,  use relative links (?)

#### Administrivia:
Add yourself to data/authors.yml 
    
    jzb:
    name: Joe Brockmeier
    twitter: jzb
    gravatar: 39606c0c942bb877967b5b54b29a9d66
    description: Works on Red Hat's Open Source and Standards team. Music junkie, and artist-in-training. Vim lover. Fan of polar bears and cats. Enjoys beer.

### Technical guides
* Fork this repo
* Create a git branch per document for clean merges
* Pull and merge often
* Create a pull request to submit for editorial review

#### Objective:
* Provide overview of the guides objectives
* What will a successful outcome look like
* What will the reader learn from  following the guide
* How long should it take (rough order of magnitude, 15 mins, 30 mins, 2 hrs, etc)

#### Prerequisites:
Complete environment description and skills / understanding required before starting, include versions of packages as tested
* Environment: Local host with virt provider, OpenStack, AWS, etc
* Host OS: Version and variant if applicable (Fedora 21 Workstation, CentOS 7, etc)
* Virtualization platform: QEMU, QEMU w/ VMM, VirtualBox,  etc
* Packages: any additional packages not explicitly installed during the guide

#### Guide:
The meat of the instruction set, lay out in some logical order, provide expected outputs where needed.  Only provide enough detail as needed for the objectives, if more detail can be helpful to learn but not needed, link  to an outside resource.
* Provide copy/paste sections, make sure Markdown is correct for leading / trailing whitespace 

## Approval and Publishing Process

All content going to projectatomic.io must be vetted and approved by the Maintainers.  Please see MAINTAINERS.md for a list of names.

### Blog Post / Technical Guide Approval

1. Author submits PR or article text in MD format.
   * if MD file, maintainer adds to his fork and creates PR.
   * if a post by maintainer, he submits his own PR.
2. maintainer does a build of the site with the blog post locally.
3. maintainer checks post for formatting, technical accuracy, spelling and grammar.
   * if revisions required, Maintainer works with author
   * if revisions required but blog post is timely,
         Maintainer produces corrected version and submits a new PR.
4. Maintainer marks PR as "Reviewed and ready" and tags @bkproffitt
5. PR Reviewer re-checks grammar and spelling, and checks against PR policy.
6. PR Reviewer merges PR to master, updates date/published, and pushes to
   production.


### Minor site updates, Doc updates:

1. Author submits changes as a PR or MD file.  MD files are changed
   to PRs by Maintainer on his fork.
2. Maintainer does a build of the site with the updates locally.
3. Maintainer checks changes for formatting, technical accuracy, spelling and grammar.
   * if revisions required, Maintainer works with author
   * if revisions required but changes are timely,
     Maintainer produces corrected version and submits a new PR.
4. Maintainer merges to master and pushes new site version to production.


### Minor site updates, Doc updates by Maintainer:

1. Maintainer writes updates
2. Maintainer does a build of the site locally and checks himself for
   links and appearance.
3. Maintainer submits a PR to the attention of appropriate parties:
   * @bkproffitt for substantial content changes;
   * @dwalsh and/or @jbrooks for technical review
4. Once cleared by the above, Maintainer merges to master and pushes
   new site version to production.


