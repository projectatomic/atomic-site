Docker and SELinux
==================
The interaction between SELinux policy and Docker is focused on two concerns:
protection of the host, and protection of containers from one another.

# SELinux Labels for Docker

SELinux labels consist of 4 parts:

    User:Role:Type:level.

SELinux controls access to processes by Type and Level.
Docker offers two forms of SELinux protection: type enforcement and
multi-category security (MCS) separation.

## Type Enforcement

Type enforcement is a kind of enforcement in which rules are based on 
process type. It works in the following way. The default type for a confined
container process is svirt_lxc_net_t.  This type is permitted to
read and execute all files "types" under /usr and most types under /etc.
svirt_lxc_net_t is permitted to use the network but is not permitted to 
read content under /var, /home, /root, /mnt ...  svirt_lxc_net_t is permitted
to write only to files labeled svirt_sandbox_file_t and docker_var_lib_t.
All files in a container are labeled by default as svirt_sandbox_file_t.  
Access to docker_var_lib_t is permitted in order to allow the use of docker 
volumes.

## Multi-Category Security (MCS) Separation

MCS Separation is sometimes called svirt. It works in the following way.
A unique value is assigned to the "level" field of the SELinux label of 
each container.  By default each container is assigned the MCS Level 
equivalent to the PID of 
the docker process that starts the container.
In OpenShift, this could be overridden to generate an MCS
Level based on the UID.  This field can also be used in Multi-Level Security (MLS) 
environments where it is desirable to set the field to "TopSecret" or "Secret".

The standard targeted policy includes rules that dictate that the MCS Labels of
the process must "dominate" the MCS label of the target. The target is usually
a file. The MCS Label usually looks something like s0:c1,c2  Such a label
would "Dominate" files labeled s0, s0:c1, s0:c2, s0:c1,c2.  It
would not, however, dominate s0:c1,c3.  All MCS Labels are required to use two Categories.
"s0:c1" and "s0:c2" are ill-formed, and are not MCS Labels. This guarantees that
no two containers can have the same MCS Label by default.  Files with s0 (Most files on
the system) are not blocked by MCS: access to such files, governed by Type Enforcement,
would still be enforced.

# More Information

For more information on SELinux see this article for OpenSource.com: 

http://opensource.com/business/13/11/selinux-policy-guide

(It's a coloring book that explains SELinux!)
