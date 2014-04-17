# Operating System Upgrades via rpm-ostree

Project Atomic features a new update system for operating systems
called `rpm-ostree`.  In the default model, the RPMs are composed on a
server into an OSTree repository, and client systems can replicate in
an image-like fashion, including incremental updates.

Unlike traditional operating system update mechanisms, it
will automatically keep the previous version of the OS, always
available for rollback.

## Upgrading a Machine with rpm-ostree

Simply invoke `rpm-ostree upgrade`.  It checks the repository URL
specified in `/ostree/repo/config` to check for an updated version.

If a new version is found, it will first be downloaded, then deployed.
At that point, a 3-way merge of configuration is performed, using the
new `/etc` as a base, and applying your changes on top.

After an update is prepared, you should `systemctl reboot` to cause
the updates to take effect.

## Rollback to the Previous Tree

If something goes wrong, by default, you always have a previous
tree (operating system snapshot) installed.  It will be available
as a bootloader entry; hold down SHIFT during OS bootup to cause
the bootloader to prompt.

If you boot into the new tree and determine something is wrong,
you can invoke `rpm-ostree rollback`.

