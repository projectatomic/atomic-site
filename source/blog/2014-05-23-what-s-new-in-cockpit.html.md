---
author: stef
comments: true
layout: post
title: "What's New in Cockpit?"
date: 2014-05-23 14:55 UTC
tags:
- Cockpit
- Atomic
- Upstream
categories:
- Blog
---
<a href="http://cockpit-project.org/"><img src="http://www.projectatomic.io/images/cockpit-logo.png"></a> <a href="http://cockpit-project.org/">Cockpit</a> 0.9 has been released and includes some major milestones for the project. With Cockpit 0.8, we'd moved beyond the prototype stage, and have closed a bunch of security and stability issues.

With Cockpit 0.9 we added continuous integration tests for running on SELinux. We want to be the first to know if Cockpit breaks due to SELinux and not find out about it because someone ran into a problem somewhere. At least that's the goal!

One of the most notable changes is that Cockpit now respects the system access privileges and won't provide a way to escalate privileges without going through the usual channels like `polkit` or `sudo`.

Because of this some features that used to work for accounts in the wheel group, now only work as root. We're working on fixing this regression by fixing system default policies in the various services (like NetworkManager) that we access.

## Still Evolving, Be Careful

Soon to come down the pipe are Docker image pull support in 0.10, and soon a redone Networking configuration page.

Cockpit has changed a bit in the jump to 0.8, and a lot of it runs unprivileged now. We've built our own quite restrictive SELinux policy, and will be running test suites against this policy and updating it to make changes. 

Our goal is that having Cockpit 0.8 or later installed should pose no security risk. That said, Cockpit is still in rapid development, and you should still be careful when using it to manage your system.

Want to take a look at Cockpit, or provide feedback? Check it out [on GitHub](https://github.com/cockpit-project/cockpit/releases), and open an [issue if you find any problems](https://github.com/cockpit-project/cockpit/issues). 

We hope to have a new Atomic Fedora 20-based image up soon that will include the latest Docker, Cockpit, and other updates. 
