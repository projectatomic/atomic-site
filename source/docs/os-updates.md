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
At that point, a three-way merge of configuration is performed, using the
new `/etc` as a base, and applying your changes on top.

After an update is prepared, you should `systemctl reboot` to cause
the updates to take effect.

## Rollback to the Previous Tree

By default, you always have a previous tree (an operating system snapshot) installed. So if something goes wrong, you can always fall back to the previous tree. The previous tree is available as a bootloader entry; to access the previous tree, hold down SHIFT during OS bootup and select the fallback tree in the bootloader menu.

If you boot into the new tree and determine that something is wrong,
you can invoke `rpm-ostree rollback`.

