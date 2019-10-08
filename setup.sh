#!/bin/bash

# Script installs environment programs for docker handled project in Debian 10 for servers started OS.
# - Installs ssh server
# - Installs Samba with shared `/var/www` folder.
# - Installs git
# - Installs docker
# - Installs docker-compose
# - Open remote connection to dockerd socket
# 
# REQUIREMENTS! 64bit architecture. Run `uname -a` to see what is your current architecture.
# For launch command:
# - install sudo `apt install sudo` by superuser.
# - add current user to sudo group `/usr/sbin/usermod -aG sudo __CURRENT_USER__` by superuser and re-login.
# Launch by command `wget -O - https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/setup.sh | bash` 
# or by this short link `wget -O - https://bit.ly/2miZQZR | bash`
echo "Setup runs ..."

echo "Install openssh-server:"
sudo apt-get -y install openssh-server
echo -e "\e[30;48;5;82m openssh-server installed \e[0m"

echo "Install samba:"
sudo apt-get -y install samba
echo -e "\e[30;48;5;82m samba installed \e[0m"

echo "Make samba config backup:"
SAMBA_CONF_BACKUP=/etc/samba/smb.conf.$(date '+%d-%m-%Y-%H-%M-%S')
sudo cp /etc/samba/smb.conf $SAMBA_CONF_BACKUP
echo -e "\e[30;48;5;82m samba config backuped to: \e[0m \e[38;5;198m $SAMBA_CONF_BACKUP \e[0m"

WWW_DIR=/var/www
echo "Prepare folder: $WWW_DIR"
if [ ! -d directory ]; then
  sudo mkdir $WWW_DIR
  sudo chmod 777 $WWW_DIR
fi

USER_GROUP=www-data
echo "Add user group: $USER_GROUP. Add current user to group $USER_GROUP"
sudo groupadd $USER_GROUP
sudo /usr/sbin/usermod -aG $USER_GROUP $USER

echo -e "Download samba config and setup username \e[0m \e[38;5;198m $USER \e[0m for access dir \e[0m \e[38;5;198m $WWW_DIR \e[0m :"
SAMBA_CONF_TMP=smb.conf
SAMBA_CONF_TPL=https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/configs/smb.conf
sudo wget -q -O - $SAMBA_CONF_TPL | sed -e "s/\$USER/$USER/g" | sed -e "s/\$GROUP/$USER_GROUP/g" > $SAMBA_CONF_TMP
sudo mv $SAMBA_CONF_TMP $SAMBA_CONF

sudo service smbd restart

# Grab first IP record.
IP=`ip addr | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p" | sed -n '1p'`
echo -e "\e[30;48;5;82m samba configured \e[0m Use \e[38;5;198m \\\\\\\\$IP\\\\www \e[0m to mount disk in Windows"

echo "Install GIT:"
sudo apt-get -y install git
echo -e "\e[30;48;5;82m git installed \e[0m"

# Instructions https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository
echo "Install Docker last version and dependencies:"
sudo apt-get -y install \
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
sudo apt-get -y update

echo "Install docker-ce docker-ce-cli containerd.io"
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
DOCKER_VERSION=`docker --version`
echo -e "\e[30;48;5;82m docker installed \e[0m \e[38;5;198m $DOCKER_VERSION \e[0m"

# Instructions https://docs.docker.com/compose/install/
echo "Install docker-compose"
if [ ! -f /usr/local/bin/docker-compose ]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi
DOCKER_COMPOSE_VERSION=`docker-compose --version`
echo -e "\e[30;48;5;82m docker-compose installed \e[0m \e[38;5;198m $DOCKER_COMPOSE_VERSION \e[0m"

echo "Add current user to group docker"
sudo /usr/sbin/usermod -a -G docker $USER
echo "Add autostrat docker on boot"
sudo systemctl enable docker
echo "Start docker right now"
sudo systemctl start docker

# Instructions https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd
echo "Open remote connection to docker"
if [ ! -f /etc/systemd/system/docker.service.d/override.conf ]; then
  # Make dir if not exists.
  sudo mkdir -p /etc/systemd/system/docker.service.d
  DOCKER_SERVICE_CONF=override.conf
  sudo wget -q -O - https://raw.githubusercontent.com/andrew-svirin/docker-environment-bash/master/configs/docker.override.conf > $DOCKER_SERVICE_CONF
  sudo mv $DOCKER_SERVICE_CONF /etc/systemd/system/docker.service.d
  sudo systemctl daemon-reload
  sudo systemctl restart docker.service
fi
echo -e "\e[30;48;5;82m docker remote is \e[0m \e[38;5;198m tcp://$IP:2375 \e[0m"

echo -e "\e[30;48;5;82m Setup finished. Please re-login in the system to apply users groups! \e[0m"
exit
