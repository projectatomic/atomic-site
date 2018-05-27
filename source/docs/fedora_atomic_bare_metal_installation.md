Performing a Bare Metal Installation of Fedora Atomic
=====================================================
*Fedora Atomic* can be thought of as a Fedora instance of the Project Atomic pattern. This document shows how to perform a bare metal installation of Fedora Atomic from physical media. The installation is guided by the **Anaconda** tool that is also used in Fedora and Red Hat Enterprise Linux. If you are familiar with the Anaconda GUI, you will find the installation process very similar.

## Getting the Installation Image and Creating Media

Download the **boot.iso** file from [GetFedora.org](https://getfedora.org/atomic/download/) and use it to create installation media. For example, if you run the GNOME desktop, you can use the *Write to disk* capability of the Nautilus file browser to create an installation DVD. Alternatively, you can write the installation ISO image to a USB device with the `dd` command. For example, if you had a USB thumbdrive mounted as `/dev/sdb`, you might use this command (be careful to get the drive location right):

```
dd if=Fedora-AtomicHost-ostree-x86_64-28-20180515.1.iso of=/dev/sdb bs=4M
```

These procedures are described in the [Fedora Installation guide](https://docs.fedoraproject.org/f28/install-guide/install/Preparing_for_Installation.html#sect-preparing-boot-media) in the section called *Preparing Boot Media*.

## Installing Fedora Atomic with the Anaconda Installer

Disconnect any drives which you do not need for the installation, power on your computer system and insert the installation media you created from *boot.iso*. Then, power off the system with the boot media still inside, and power on the system again. Note that you might need to press a specific key or combination of keys to boot from the media or configure your system's *Basic Input/Output System* (BIOS) to boot from the media.

Once your system has completed booting, the boot screen is displayed:

![Fedora Atomic Boot Screen](boot_screen1.png "Fedora Atomic Boot Screen")

The boot media displays a graphical boot menu with three options:

- *Install Fedora-Atomic 28* - Choose this option to install Fedora Atomic onto your computer system using the graphical installation program.

- *Test this media & install Fedora-Atomic 28* - With this option, the integrity of the installation media is tested before installing Fedora Atomic onto your computer system using the graphical installation program. This option is selected by default.

- *Troubleshooting* - This item opens a menu with additional boot options. From this screen you can launch a rescue mode for Fedora Atomic, or run a memory test. Also, you can start the installation in the basic graphics mode as well as boot the installation from local media.

If no key is pressed within 60 seconds, the default boot option runs. Press *Enter* to proceed.

After media check, you are directed to the welcome screen. This interactive install is exactly the same as installing standard Fedora Server, so you can use [Fedora's guide to the Anaconda GUI](https://docs.fedoraproject.org/f28/install-guide/install/Installing_Using_Anaconda.html#sect-installation-graphical-mode).

The one thing which is different is disk partitioning.  Post-install, Atomic will automatically use some of the unused space on your primary LVM partition to create a Docker pool partition. You will need this partition in order to have space for containers. As such, we recommend leaving half your available disk space as unallocated LVM partition space.

Once you configured all required settings, the orange warning signs disappear and you can start the installation by pressing *Begin Installation*.

While the installation proceeds, you can specify user settings, such as a root password and adding one or more system users. We strongly recommend that you do both, as Atomic Host has no GUI login and you will be unable to log in without one or more valid user logins. When the installation is finished, you are prompted to reboot the system by pressing *Reboot*.

## Unattended Installation

Kickstart installations offer a means to automate the installation process, either partially or fully. Kickstart files contain answers to all questions normally asked by the installation program, such as what time zone do you want the system to use, how should the drives be partitioned or which packages should be installed.

The installer ISO contains embedded content, and thus works offline. However, to do a PXE installation, you must download the content dynamically.  We strongly recommend mirroring the OSTree repository, rather than having each machine contact the upstream provider.

So, for unattended installation you need to specify your own kickstart configuration and load it from the boot prompt as described below. Use the `ostreesetup` command in your custom configuration, which is what configures anaconda to consume the rpm-ostree generated content.

For example, create *atomic-ks.cfg* file with the following content, for Fedora Atomic 28:

    lang en_US.UTF-8
    keyboard us
    timezone America/New_York
    zerombr
    clearpart --all --initlabel
    autopart
    # sudo user with an ssh key (use your key)
    user --name=atomic --groups=wheel --sshkey="ssh-rsa AAAAB3NzaC1yc2EAAAA ..."

    # NOTICE: This will download the the latest release from upstream, which could be slow.
    ostreesetup --nogpg --osname="fedora-atomic" --remote="fedora-atomic-28" --url="https://kojipkgs.fedoraproject.org/atomic/28" --ref="fedora/28/x86_64/atomic-host"

    # Alternately, install from the ISO media:
    # ostreesetup --osname="fedora-atomic" --remote="fedora-atomic-28" --url="file:///ostree/repo" --ref="fedora/28/x86_64/atomic-host" --nogpg
    # however, you will need to reset ostree setup afterwards in %post

There are several other options you can specify in the kickstart file, see *Kickstart Options* in the [Fedora Installation guide](https://docs.fedoraproject.org/f28/install-guide/advanced/Kickstart_Installations.html), or this [blog post](/blog/2017/07/fedora-atomic-26-kickstarts) which shows a more complex configuration with disk partitioning.

After creating the configuration file, you have to ensure that it will be available during the installation. Place the file on hard drive, network, or removable media as described in the [Fedora Installation guide](https://docs.fedoraproject.org/en-US/Fedora/24/html/Installation_Guide/chap-kickstart-installations.html). As a simple example, if the kickstart file is on another machine in the same network, you could serve it using a simple HTTP server:

```
cd kickstart/
python -m SimpleHTTPServer
```

Start the installation as described above. On the grub menu screen, press the up arrow to select "Install Fedora". Then press "e" to edit this option. You will see a `linux` or `linuxefi` line which boots the install kernel; edit this line to add a kickstart file location after the directive `inst.ks`. If we were serving the kickstarter file on the network with SimpleHTTPServer as above, for example, we would do this:

```
linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Fedora-Atomic-28-x86_64 inst.ks=http://192.168.1.105:8000/atomic-ks.cfg inst.text quiet
```

See the [Fedora Installation guide]https://docs.fedoraproject.org/f28/install-guide/advanced/Kickstart_Installations.html) for more information on how to start a kickstart installation.

With the kickstart file described above, the installation proceeds automatically until Anaconda reboots the system after finishing the installation. This can be more fully automated if you use a PXEboot server, which can serve up both the OS images and the kickstart file.

There is also a kickstart file in repository [https://pagure.io/fedora-kickstarts](https://pagure.io/fedora-kickstarts/tree/master)


## Updating and Reverting Fedora Atomic

NOTE: If you've used a different `ostreesetup` URL or reference, you'll want to make sure you set the appropriate repository to get updates. If the `ostreesetup` URL is where you'd like to receive updates, you can skip the `rebase` section.

To receive updates for your Fedora Atomic installation, specify the location of the remote OSTree repository. Execute:

    # ostree remote add --if-not-exists \
    # --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-primary \
    # fedora-atomic-28 https://kojipkgs.fedoraproject.org/atomic/28

Here, *fedora-atomic-28* is used as a name for the remote repository. The URL is stored in the */etc/ostree/remotes.d/fedora-atomic.conf* configuration file. While GPG key checking is optional, it's highly recommended to prevent spoofing of installation files. A new GPG key is required for each major Fedora release at this time, but that will change when Atomic shifts to rolling upgrades.

Now you are able to update your system with the following command:

    # rpm-ostree rebase fedora-atomic:

The `rebase` command, that is an extension of the `upgrade` command, switches to a newer version of the current tree. In the above syntax, *fedora-atomic:* stands for the full branch name (in this case *fedora-atomic/rawhide/x86_64/server/docker-host*). Reboot the system to start the updated version of Fedora Atomic:

    # systemctl reboot

To determine what version of the operating system is running, execute:

    # atomic host status

To revert to a previous installation, execute the following commands:

    # atomic host rollback
    # systemctl reboot

<!---
## Uninstalling Fedora Atomic

To remove Fedora Atomic from your computer, you must remove its boot loader information from your master boot record (MBR) and remove any partitions that contain the operating system. Please do not forget to back up any data you want to keep before proceeding.

The removal process varies depending on whether Fedora Atomic is the only operating system installed, or whether the computer is configured to dual-boot Fedora Atomic and another operating system. Fedora Installation guide describes both the [stand-alone](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/ch-x86-uninstall.html#sn-x86-uninstall-single) and [dual-boot](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-x86-uninstall-dual.html) case for Fedora, and these instructions are applicable to Fedora Atomic too.

-->
