#!/bin/bash

# Script installs environment programs for docker handled project in Debian 10 for servers started OS.
# - Installs ssh server
# - Installs Samba with shared `/var/www` folder.
# - Installs docker
# - Installs docker-compose
# - Installs git
# For launch command:
# - install sudo `apt install sudo` by superuser.
# - add current user to sudo group `/usr/sbin/usermod -aG sudo __CURRENT_USER__` by superuser and re-login.
# Launch by command `wget https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/setup.sh | /usr/sbin/sudo bash` 
# or by this short link `wget https://bit.ly/2miZQZR | bash`
echo "Setup runs ..."

echo "Install openssh-server:"
sudo apt install openssh-server
echo -e "\e[30;48;5;82m openssh-server installed \e[0m"

echo "Install samba:"
sudo apt install samba
echo -e "\e[30;48;5;82m samba installed \e[0m"

echo "Make samba config backup:"
SAMBA_CONF_BACKUP=/etc/samba/smb.conf.$(date '+%d-%m-%Y-%H-%M-%S')
sudo cp /etc/samba/smb.conf $SAMBA_CONF_BACKUP
echo -e "\e[30;48;5;82m samba config backuped to: \e[0m \e[38;5;198m $SAMBA_CONF_BACKUP \e[0m"

echo -e "Download samba config and setup username \e[0m \e[38;5;198m $USER \e[0m for access dir \e[0m \e[38;5;198m /var/www/ \e[0m :"
SAMBA_CONF_TMP=smb.conf
sudo wget -q -O - https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/configs/smb.conf | sed -e "s/\$USER/$USER/g" > $SAMBA_CONF_TMP
sudo mv $SAMBA_CONF_TMP $SAMBA_CONF

exit
