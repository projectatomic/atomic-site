Docker and SELinux
==================

There are two basic ideas with SELinux policy. One is to protect the
host.  The other is to protect containers from each other.

# SELinix Label for Docker

If you look at an SELinux label, it consists of 4 parts:

    User:Role:Type:level.

In SELinux we can control processes access based on Type and Level. 
With Docker there are two forms of SELinux protection. 

## Type Enforcement

The first protection is called Type enforcement, where we write rules
based on the type of the process.  The default type for a confined
container process is svirt_lxc_net_t.  This type is allowed to
read/execute all files "types" under /usr and most types under /etc. 
svirt_lxc_net_t is allowed to use the network but is not allowed to read
content under /var, /home, /root, /mnt ...  It is only allowed to write
to files labeled svirt_sandbox_file_t and docker_var_lib_t.  By default
all files in a container get labeled as svirt_sandbox_file_t.  We allow
access to docker_var_lib_t in order to allow the user of docker volumes.

## Multi-Category Security (MCS) Seperation 

The second form of protection is called MCS Separation, sometimes called
svirt.  Basically we use the level field of the SELinux label and set it
unique for each container.  By default each container gets the MCS Level
equivalent to the PID of the docker process that starts the container. 
For example, in OpenShift world this could be overridden to generate an MCS Level
based on the UID.  This field can also be used in MLS environments where
you might want to set the field to TopSecret and Secret. 

In the standard
targeted policy we have rules that say the MCS Labels of the process
must "dominate" the MCS label of the target. This is usually a file. The MCS
Label usually looks something like s0:c1,c2  This label would "Dominate"
files with a label of s0, s0:c1, s0:c2, s0:c1,c2.  But it would not
dominate s0:c1,c3.  We force all MCS Labels to use two Categories so
you should never have s0:c1 or s0:c2. And by default this guarantees that no two
containers can have the same MCS Label.  Files with s0 (Most files on
the system) are not blocked by MCS, so access allowed by Type
Enforcement would still be enforced.

# More Information

For more information on on SELinux see this article for OpenSource.com that explains SELinux in a
coloring book.

http://opensource.com/business/13/11/selinux-policy-guide

