---
title: External authentication for Fedora Atomic Host
author: adelton
date: 2015-12-08 16:00:00 UTC
tags: fedora, atomic host, sssd, authentication
comments: true
published: true
---

By default, Fedora Atomic images come with cloud-init, which supports customization of various aspects of the running instance, including password for the default user. However, if many users in an organization should have access to the Atomic Host, the local configuration of the instance will not scale and user identities, authentication, and authorization need to be based on external identity management solution. 

For IPA (FreeIPA/IdM), Active Directory, or generic LDAP servers, SSSD can serve as an agent providing these services, from user identity lookups and user group membership resolution to access control. With an SSSD container now available, Fedora Atomic Hosts can be deployed in very similar way to normal Fedora.

READMORE

## SSSD overview

The System Security Services Daemon (SSSD) is a daemon that provides identity, authentication, and authorization services to the operating system and applications. It provides modules and/or plugins for multiple subsystems of the operating system, including NSS, PAM, or sudo. It can cache multiple types of information to speed-up subsequent lookup or authentication operations, and it can use various remote backend types, including FreeIPA, Active Directory, or LDAP.

SSSD can be configured by editing `/etc/sssd/sssd.conf` directly but due to overlap to other subsystems, those subsystems typically need to be configured as well to make use of SSSD, like `pam_sss.so` for PAM, or `/etc/krb5.*` for Kerberos operations. For two use cases, setups against FreeIPA and Active Directory, setup tools can be used to configure SSSD and other components of the operating system in automated fashion.

## Working with SSSD container

The general steps in deploying the SSSD container include:

* Edit config file with options and parameters, or configure SSSD manually.
* Call `atomic install fedora/sssd [various options]` to invoke setup tool(s) to configure SSSD and other parts of the system.
* Call `atomic run fedora/sssd` or `systemctl start sssd.service` to start the container.

What config files to use and what options to pass depend on the setup you want to achieve. The three most common use-cases will be:

* IPA-enrollment, for configuring the machine against FreeIPA/IdM, using `ipa-client-install` in the container.
* Joining the machine to Active Directory using `realm join`.
* Configuring SSSD manually on the host and telling the SSSD container to just use that configuration, without any setup tool invoked. 

Let us explore the possibilities in more detail.

## IPA-enrolling Fedora Atomic

To IPA-enroll machine to FreeIPA or IdM server, you will want to either specify the parameters for `ipa-client-install` in `/etc/sssd/ipa-client-install-options` on the host before running `atomic install`, or you can pass the parameters as arguments to `atomic install fedora/sssd` directly.

For example, if you've pre-created the host record in IPA with

    ipa$ ipa host-add --random host.example.com
    [...]
      Random password: Fk96SdaP99wV

and obtained a one-time password for the IPA-enrollment, you can either use the `-w` and the password directly when calling `atomic install`:

    host# atomic install fedora/sssd -w Fk96SdaP99wV
    [...]
    Client configuration complete.

Alternatively, you can store the option and the password in `/etc/sssd/ipa-client-install-options`:

    -w Fk96SdaP99wV

You then do not need to pass the arguments to `atomic install` on the command line:

    host# atomic install fedora/sssd
    [...]
    Client configuration complete.

Virtually any option to `ipa-client-install` can be used, and specified either as argument to `atomic install`, or in the `-options` file.

## Joining Fedora Atomic to Active Directory

To join the machine to Active Directory, specify parameters to realm join in `/etc/sssd/realm-join-options,` for example:

    ADDOMAIN.COM

When that file exists, plain

    host# atomic install fedora/sssd

will call `realm join` instead of `ipa-client-install`.

You can also use `realm join` and the parameters on the command line directly:

    host# atomic install fedora/sssd realm join ADDOMAIN.TEST

In either case, since `realm join` does not accept the AD credentials on the command line, you have to put the password to `/etc/sssd/realm-join-password` before calling `atomic install`.

## Using existing SSSD configuration

If you have configured SSSD on the Fedora Atomic Host manually or via some other mechanism, you can just enable the SSSD container and tell it to observe the existing configuration:

    host# atomic install fedora/sssd --migrate

## Further reading

For more information about the SSSD container and the solution used, check [SSSD in container on Fedora Atomic Host](http://www.adelton.com/docs/docker/fedora-atomic-sssd-container).