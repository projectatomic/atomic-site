#/bin/bash

#tell SELinux to share the Data and Source directories
#with the container

chcon -Rt svirt_sandbox_file_t source/
chcon -Rt svirt_sandbox_file_t data/
