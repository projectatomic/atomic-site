Cockpit
=======
**A remote manager for GNU/Linux servers**

* Cockpit is a server manager that makes it easy to administer your GNU/Linux servers via a web browser.

* Cockpit makes it easy for any sysadmin to perform simple tasks, such as administering storage, inspecting journals and starting and stopping services.

* Jumping between the terminal and the web tool is no problem. A service started via Cockpit can be stopped via the terminal. Likewise, if an error occurs in the terminal, it can be seen in the Cockpit journal interface.

* You can monitor and administer several servers at the same time. Just add them with a single click and your machines will look after its buddies.

## Cockpit and Docker

Cockpit also makes it easy to monitor and administer Docker containers running on Cockpit-managed servers such as Project Atomic hosts.

* Monitor resources consumed by containers
* Adjust resources available to containers
 * Resource limits enforced by the CGroup subsystem in the Linux kernel
 * Adjust CPU shares
 * Assign memory limits
 * More CGroup policy controls to come
* Stop, Start, Delete and Commit container instances
* Run and Delete container images

## Starting and Using Cockpit
**Cockpit is in beta/preview at this time**, but you can still try it out and help test! A preview is included with the image. For more information, see the [Cockpit](http://fedoraproject.org/wiki/Changes/CockpitManagementConsole) project page.

1. After starting your atomic host, you need to enable the `cockpit` service and socket:
    * `$ sudo systemctl enable cockpit.socket`
    * `$ sudo systemctl start cockpit`
2. You can now use the `cockpit` management interface at `http://yourhost:9090`
