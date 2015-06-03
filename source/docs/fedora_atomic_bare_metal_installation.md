Performing a Bare Metal Installation of Fedora Atomic 
=====================================================
*Fedora Atomic* can be thought of as a Fedora instance of the Project Atomic pattern. This document shows how to perform a bare metal installation of Fedora Atomic from physical media. The installation is guided by the **Anaconda** tool that is also used in Fedora and Red Hat Enterprise Linux. If you are familiar with the Anaconda GUI, you will find the installation process very similar.

## Getting the Installation Image and Creating Media

Download the [**boot.iso**](https://dl.fedoraproject.org/pub/alt/stage/22_Beta_RC3/Cloud_Atomic/x86_64/iso/Fedora-Cloud_Atomic-x86_64-22_Beta.iso) file and use it to create installation media. For example, if you run the GNOME desktop, you can use the *Write to disk* capability of the Nautilus file browser to create an installation DVD. Alternatively, you can write the installation ISO image to a USB device with the `dd` command.

These procedures are described in the [Fedora Installation guide](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-making-media.html) in the second chapter called *Making media*. 

## Installing Fedora Atomic with the Anaconda Installer

Disconnect any drives which you do not need for the installation, power on your computer system and insert the installation media you created from *boot.iso*. Then, power off the system with the boot media still inside, and power on the system again. Note that you might need to press a specific key or combination of keys to boot from the media or configure your system's *Basic Input/Output System* (BIOS) to boot from the media.

Once your system has completed booting, the boot screen is displayed: 

![Fedora Atomic Boot Screen](boot_screen1.png "Fedora Atomic Boot Screen")

The boot media displays a graphical boot menu with three options:

- *Install Fedora Docker Host* - Choose this option to install Fedora Atomic onto your computer system using the graphical installation program. 

- *Test this media & install Fedora Docker Host* -  With this option, the integrity of the installation media is tested before installing Fedora Atomic onto your computer system using the graphical installation program. This option is selected by default.

- *Troubleshooting* - This item opens a menu with additional boot options. From this screen you can launch a rescue mode for Fedora Atomic, or run a memory test. Also, you can start the installation in the basic graphics mode as well as boot the installation from local media.

If no key is pressed within 60 seconds, the default boot option runs. Press *Enter* to proceed. 

After media check, you are directed to the welcome screen, where you can choose the language of the installation:

![Fedora Atomic Welcome Screen](welcome_screen1.png "Fedora Atomic Welcome Screen")

Select your language of preference and press *Continue*. The *INSTALLATION SUMMARY* screen appears. It is the central menu for configuring localization, software, and system settings for your installation. Items that are not yet configured are marked with orange warning sign. 

![Fedora Atomic Installation Summary](installation_summary1.png "Fedora Atomic Installation Summary")

This menu allows you to configure your installation in the order you choose. Each menu item leads to an individual configuration screen. For description of these sub-screens, see the corresponding sections of the Fedora Installation guide:

- [*Date & Time*](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-timezone-x86.html) - lets you configure date, time, time zone, and NTP (Network Time Protocol).
- [*Keyboard*](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-keyboard-x86.html) - here you can select keyboard layouts to use on your system.  
- [*Language Support*](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/language-support-x86.html) - this screen provides language options for your installation, it is identical to the welcome screen depicted above.
- [*Installation Destination*](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-diskpartsetup-x86.html) - allows you to select storage devices and set partitioning. Note that it is recommended to use the default partitioning configured in the boot.iso image.
- [*Network & Hostname*](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-Netconfig-x86.html) - provides a network management interface.

Once you configured all required settings, the orange warning signs disappear and you can start the installation by pressing *Begin Installation*.

While the installation proceeds, you can specify the user settings:

![Fedora Atomic Final Screen](final_screen1.png "Fedora Atomic Final Screen")

[Select a root password](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-progresshub-x86.html#sn-account_configuration-x86) and [create a user](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-firstboot-systemuser.html) if desired. When the installation is finished, you are prompted to reboot the system by pressing *Reboot*.

## Unattended Installation

Kickstart installations offer a means to automate the installation process, either partially or fully. Kickstart files contain answers to all questions normally asked by the installation program, such as what time zone do you want the system to use, how should the drives be partitioned or which packages should be installed. 

The installer ISO contains embedded content, and thus works offline.

However, to do a PXE installation, you must download the content
dynamically.  We strongly recommend mirroring the OSTree repository,
rather than having each machine contact the upstream provider.

So, for unattended installation you need to specify your own kickstart
configuration and load it from the boot prompt as described below. Use
the `ostreesetup` command in your custom configuration, which is what
configures anaconda to consume the rpm-ostree generated content.

For example, create *atomic-ks.cfg* file with the following content:

    lang en_US.UTF-8
    keyboard us
    timezone America/New_York
    zerombr
    clearpart --all --initlabel
    autopart
    # SSH keys are better than passwords, but this is a simple example
    rootpw --plaintext atomic

    # NOTICE: This will download the content from upstream; this will be very slow.
    # Create your own OSTree repo locally and mirror the content instead.
    ostreesetup --nogpg --osname=fedora-atomic --remote=fedora-atomic --url=https://dl.fedoraproject.org/pub/fedora/linux/atomic/22/ --ref=fedora-atomic/f22/x86_64/docker-host

There are several other options you can specify in the kickstart file, see *Kickstart Options* in the [Fedora Installation guide](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-kickstart2-options.html). 

After creating the configuration file, you have to ensure that it will be available during the installation. Place the file on hard drive, network, or removable media as described in the [Fedora Installation guide](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-kickstart2-putkickstarthere.html).

Start the installation as described above. On the boot screen, press *Esc* to view the *boot:* prompt. At this prompt, specify the path to the kickstart configuration file:

    boot: linux inst.ks=kickstart_location 

The *linux* keyword is used here to specify the installation program image file to be loaded. The *inst.ks* option specifies the kickstart configuration file, replace *kickstart_location* with a path or URL of *atomic-ks.cfg*. See the [Fedora Installation guide](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/s1-kickstart2-startinginstall.html) for more information on how to start a kickstart installation.

With the kickstart file described above, the installation proceeds automatically until Anaconda prompts you to reboot the system to complete the installation. 

## Updating and Reverting Fedora Atomic

To receive updates for your Fedora Atomic installation, specify the location of the remote OSTree repository. Execute:

    # ostree remote add --set=gpg-verify=false fedora-atomic http://dl.fedoraproject.org/pub/alt/fedora-atomic/repo/

Here, *fedora-atomic* is used as a name for the remote repository. The URL is stored in the */etc/ostree/remotes.d/fedora-atomic.conf* configuration file. Today, it is required to disable GPG verification for the remote repository to update Fedora Atomic successfully. Therefore the *--set=gpg-verify=false* option above. Alternatively, you can disable GPG by appending `gpg-verify=false` to */etc/ostree/remotes.d/fedora-atomic.conf*.

Now you are able to update your system with the following command:

    # rpm-ostree rebase fedora-atomic:

The `rebase` command, that is an extension of the `upgrade` command, switches to a newer version of the current tree. In the above syntax, *fedora-atomic:* stands for the full branch name (in this case *fedora-atomic/rawhide/x86_64/server/docker-host*). Reboot the system to start the updated version of Fedora Atomic:
   
    # systemctl reboot

To determine what version of the operating system is running, execute:

    # ostree admin status

To revert to a previous installation, execute the following commands:

    # rpm-ostree rollback
    # systemctl reboot

<!---
## Uninstalling Fedora Atomic

To remove Fedora Atomic from your computer, you must remove its boot loader information from your master boot record (MBR) and remove any partitions that contain the operating system. Please do not forget to back up any data you want to keep before proceeding.

The removal process varies depending on whether Fedora Atomic is the only operating system installed, or whether the computer is configured to dual-boot Fedora Atomic and another operating system. Fedora Installation guide describes both the [stand-alone](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/ch-x86-uninstall.html#sn-x86-uninstall-single) and [dual-boot](http://docs.fedoraproject.org/en-US/Fedora/20/html/Installation_Guide/sn-x86-uninstall-dual.html) case for Fedora, and these instructions are applicable to Fedora Atomic too.

-->
