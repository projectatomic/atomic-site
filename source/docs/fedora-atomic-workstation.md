HowTo: Fedora Atomic Workstation
================================
*Fedora Atomic Workstation* (FAW) is the desktop version of Fedora Atomic Host. It is still heavily in development with only few external users. This project is actively maintained and is ready for use by sophisticated and interested users, but not ready for widespread promotion.

More detailed documentation with cheat sheet is coming on 15 February 2018.

For a summary of the why and how, please read [Atomic Workstation](https://fedoraproject.org/wiki/Workstation/AtomicWorkstation) and [Workstation OSTree](https://fedoraproject.org/wiki/Changes/WorkstationOstree).

## Quickstart

Download the [.iso](https://download.fedoraproject.org/pub/fedora/linux/releases/28/Workstation/x86_64/iso/) and use it to create installation media.

For example, if you run the GNOME desktop, you can use the *Write to disk* capability of the Nautilus file browser to create an installation DVD. Alternatively, you can write the installation ISO image to a USB device with the `dd` command or by using the application `ISO Image Writer` which comes pre-installed with Fedora. With dd, if you had a USB thumbdrive mounted as `/dev/sdb`, you might use this command (be careful to get the drive location right):

```
dd if=yourisoname.iso of=/dev/sdb bs=4M
```

**Installing inside an existing system**

If you rather want to install FAW inside an existing system, please follow the steps described on [Pagure](https://pagure.io/workstation-ostree-config/blob/master/f/README-install-inside.md).

## Support

For now, you can ask us questions in the #atomic channel on IRC Freenode or via Twitter [@projectatomic](https://twitter.com/projectatomic). You can also use the [atomic-devel](https://lists.projectatomic.io/mailman/listinfo/atomic-devel) mailing list. Contributions are welcome.

We are also in the process of creating a [Special Interest Group](https://fedoraproject.org/wiki/Workstation/AtomicWorkstation/SIG) - if you are interested in joining, let us know via one of the mentioned channels and we can add you.

## Updating and Reverting Fedora Atomic Workstation

For information on how to update and rollback your system, please read [Operating System Upgrades via rpm-ostree](http://www.projectatomic.io/docs/os-updates/).
