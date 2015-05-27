---
# Project Atomic Site Style Guide

If you are contributing to the Project Atomic site, please look at the following tips and guidelines.

## Style
* Use Markdown* (which flavors are supported by our Middleman install?)
* Use correct indentation levels for code blocks to support correct copy/paste w/o  leading spaces (examples)

## Blog posts
* Fork this repo
* Create a git branch for the blog post for clean merges
* Blogs reside in the source/data/blog directory
* Naming convention is date-title *yyyy-mm-dd-this-is-a-blog*
* Create a pull request to submit for editorial review
 
### Template
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

### Images: 
Place in correct directory,  use relative links (?)

### Administrivia:
Add yourself to data/authors.yml 
    
    jzb:
    name: Joe Brockmeier
    twitter: jzb
    gravatar: 39606c0c942bb877967b5b54b29a9d66
    description: Works on Red Hat's Open Source and Standards team. Music junkie, and artist-in-training. Vim lover. Fan of polar bears and cats. Enjoys beer.

## Technical guides
* Fork this repo
* Create a git branch per document for clean merges
* Pull and merge often
* Create a pull request to submit for editorial review

### Objective:
* Provide overview of the guides objectives
* What will a successful outcome look like
* What will the reader learn from  following the guide
* How long should it take (rough order of magnitude, 15 mins, 30 mins, 2 hrs, etc)

### Prerequisites:
Complete environment description and skills / understanding required before starting, include versions of packages as tested
* Environment: Local host with virt provider, OpenStack, AWS, etc
* Host OS: Version and variant if applicable (Fedora 21 Workstation, CentOS 7, etc)
* Virtualization platform: QEMU, QEMU w/ VMM, VirtualBox,  etc
* Packages: any additional packages not explicitly installed during the guide

### Guide:
The meat of the instruction set, lay out in some logical order, provide expected outputs where needed.  Only provide enough detail as needed for the objectives, if more detail can be helpful to learn but not needed, link  to an outside resource.
* Provide copy/paste sections, make sure Markdown is correct for leading / trailing whitespace 

