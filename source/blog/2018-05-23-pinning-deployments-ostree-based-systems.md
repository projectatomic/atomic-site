---
title: Pinning Deployments in OSTree Based Systems
tags: fedora, atomic
author: dustymabe
date: 2018-05-23 00:00:00 UTC
published: true
comments: false
---

# Introduction

RPM-OSTree/OSTree conveniently allows you to rollback if you upgrade and don't like the upgraded software. This is done by keeping around the old **deployment**; the old software you booted in to. After a single upgrade you'll have a booted deployement and the rollback deployment. On the next upgrade the current rollback deployment will be discarded and the current booted deployment will become the new rollback deployment.

Typically these two deployments are all that is kept around. However, recently a new [pinning](https://github.com/ostreedev/ostree/issues/1460) feature was added that allows the user to "pin" a deployment to make sure it doesn't get garbage collected.

READMORE

Here is the current state of my system:

```
[dustymabe@dhcp137-98 ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                BaseCommit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat

  ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.81 (2018-02-12 17:50:48)
                BaseCommit: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
```

I have the current booted deployment (`27.122`) and the rollback deployment
(`27.81`) from before the last time I upgraded. I am about to do a rebase
from Fedora 27 to Fedora 28 so I'd like have a little more control and not lose
either of the two deployments I already have on the system. I'll pin them both:


```
[dustymabe@dhcp137-98 ~]$ sudo ostree admin pin 0
Deployment is now pinned
[dustymabe@dhcp137-98 ~]$ sudo ostree admin pin 1
Deployment is now pinned
[dustymabe@dhcp137-98 ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                BaseCommit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes

  ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.81 (2018-02-12 17:50:48)
                BaseCommit: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes
```

You can see in the output that the deployments now show up as `Pinned`.

Now I can rebase to Fedora 28:

```
[dustymabe@dhcp137-98 ~]$ sudo ostree remote add --set=gpgkeypath=/etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-28-primary unifiedrepo https://kojipkgs.fedoraproject.org/atomic/repo/
[dustymabe@dhcp137-98 ~]$ sudo rpm-ostree rebase unifiedrepo:fedora/28/x86_64/atomic-host

25 delta parts, 9 loose fetched; 273519 KiB transferred in 115 seconds
Checking out tree a29367c... done
...
Run "systemctl reboot" to start a reboot
```

After the rebase we can see that we have three (not two) deployments:

```
[dustymabe@dhcp137-98 ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
  ostree://unifiedrepo:fedora/28/x86_64/atomic-host
                   Version: 28.20180515.1 (2018-05-15 16:32:35)
                BaseCommit: a29367c58417c28e2bd8306c1f438b934df79eba13706e078fe8564d9e0eb32b
              GPGSignature: Valid signature by 128CF232A9371991C8A65695E08E7E629DB62FB1
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes

● ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                BaseCommit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes

  ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.81 (2018-02-12 17:50:48)
                BaseCommit: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes
```

And after reboot they are all still there:

```
[dustymabe@dhcp137-98 ~]$ rpm-ostree status
State: idle; auto updates disabled
Deployments:
● ostree://unifiedrepo:fedora/28/x86_64/atomic-host
                   Version: 28.20180515.1 (2018-05-15 16:32:35)
                BaseCommit: a29367c58417c28e2bd8306c1f438b934df79eba13706e078fe8564d9e0eb32b
              GPGSignature: Valid signature by 128CF232A9371991C8A65695E08E7E629DB62FB1
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes

  ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.122 (2018-04-18 23:34:24)
                BaseCommit: 931ebb3941fc49af706ac5a90ad3b5a493be4ae35e85721dabbfd966b1ecbf99
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes

  ostree://fedora-atomic-27:fedora/27/x86_64/atomic-host
                   Version: 27.81 (2018-02-12 17:50:48)
                BaseCommit: b25bde0109441817f912ece57ca1fc39efc60e6cef4a7a23ad9de51b1f36b742
              GPGSignature: Valid signature by 860E19B0AFA800A1751881A6F55E7430F5282EE4
           LayeredPackages: aria2 git git-annex mosh pciutils tig vim weechat
                    Pinned: yes
```

And we can unpin any of them we like. In this case I'll unpin the oldest one:

```
[dustymabe@dhcp137-98 ~]$ sudo ostree admin pin --unpin 2
Deployment is now unpinned
```

Cheers!
