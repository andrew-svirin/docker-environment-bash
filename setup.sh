#!/bin/bash

# Script installs environment programs for docker handled project in Debian 10 for servers started OS.
# - Installs ssh server
# - Installs Samba with shared `/var/www` folder.
# - Installs docker
# - Installs docker-compose
# - Installs git
# For launch command add current user to sudo group `/usr/sbin/usermod -aG sudo __CURRENT_USER__` and re-login.
# Launch by command `wget https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/setup.sh | /usr/sbin/sudo bash` 
# or by this short link `wget https://bit.ly/2miZQZR | bash`
echo "Setup runs ...\n"

echo "Install openssh-server ...\n"
/usr/sbin/sudo apt install openssh-server

exit
