#!/bin/bash

# install dependencies
apt-get update && apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

# add key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

# add repo
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
     $(lsb_release -cs) stable" | \
     tee /etc/apt/sources.list.d/docker.list

# update repo and install
apt-get update && apt-get install -y docker-ce

# install pip
apt install -y python-pip
# install docker-compose
pip install docker-compose 
# add user to docker group
usermod -aG docker $USER

source ~/.profile