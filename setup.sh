#!/bin/bash

# Script installs environment programs for docker handled project in Debian 10 for servers started OS.
# - Installs ssh
# - Installs Samba with shared `/var/www` folder.
# - Installs docker
# - Installs docker-compose
# - Installs git
# For launch command add current user to sudo group `usermod -aG sudo __CURRENT_USER__` and re-login.
# Launch by command `wget https://github.com/andrew-svirin/docker-environment-bash/blob/master/setup.sh | sudo bash`
