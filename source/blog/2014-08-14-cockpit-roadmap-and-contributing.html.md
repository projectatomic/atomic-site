---
author: stef
comments: true
layout: post
title: Cockpit Roadmap and Contributing
date: 2014-08-14 09:22 UTC
tags:
- Cockpit
- Orchestration
- Community
categories:
- Blog
---
These days it's easier than ever to contribute to Cockpit. Here's how.

Make sure you have it installed and running. Then checkout the cockpit sources and link the modules directory into your home directory.

    $ git clone https://github.com/cockpit-project/cockpit.git
    $ mkdir -p ~/.local/share
    $ ln -snf $(pwd)/cockpit/modules ~/.local/share/cockpit

Now log into Cockpit with your own user login. Any changes you make in the modules subdirectory of the cockpit javascript or HTML that you checked out, should be visible immediately after a refresh.
  
If you want to hack on other parts of Cockpit, such as the backend, there's a handy guide here:

[https://github.com/cockpit-project/cockpit/blob/master/HACKING.md](https://github.com/cockpit-project/cockpit/blob/master/HACKING.md)

You can file issues you run into here:

[https://github.com/cockpit-project/cockpit/issues/new](https://github.com/cockpit-project/cockpit/issues/new)

And finally you can see what we're working on at our Trello board:

[https://trello.com/b/mtBhMA1l/cockpit](https://trello.com/b/mtBhMA1l/cockpit)

Have fun!
