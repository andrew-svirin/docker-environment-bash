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

WWW_DIR=/var/www
echo "Prepare folder: $WWW_DIR"
sudo mkdir $WWW_DIR
sudo chmod 777 $WWW_DIR

USER_GROUP=www-data
echo "Add user group: $USER_GROUP. Add current user to group $USER_GROUP"
sudo groupadd $USER_GROUP
sudo /usr/sbin/usermod -aG $USER_GROUP $USER

echo -e "Download samba config and setup username \e[0m \e[38;5;198m $USER \e[0m for access dir \e[0m \e[38;5;198m $WWW_DIR \e[0m :"
SAMBA_CONF_TMP=smb.conf
sudo wget -q -O - https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/configs/smb.conf | sed -e "s/\$USER/$USER/g" | sed -e "s/\$GROUP/$USER_GROUP/g" > $SAMBA_CONF_TMP
sudo mv $SAMBA_CONF_TMP $SAMBA_CONF

sudo service smbd restart

IP=`ip addr | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"`
echo -e "\e[30;48;5;82m samba configured \e[0m Use \e[38;5;198m \\\\\\\\$IP\\\\www \e[0m to mount disk in Windows"

echo "Install GIT:"
sudo apt install git
echo -e "\e[30;48;5;82m git installed \e[0m"

echo "Install GIT:"
sudo apt install git
echo -e "\e[30;48;5;82m git installed \e[0m"

echo "Install Docker last version and dependencies:"
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

echo "Add Docker’s official GPG key:"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

echo "Add Docker’s apt repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

echo "Update apt"
sudo apt-get update

echo "Install docker-ce docker-ce-cli containerd.io"
sudo apt-get install docker-ce docker-ce-cli containerd.io
echo -e "\e[30;48;5;82m docker installed \e[0m"


exit
