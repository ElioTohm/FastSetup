#!/bin/bash

# install dependencies
apt-get update && apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
# add keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# add docker repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
# update repos list and install
apt-get update && apt-get -y install docker-ce
# add user to docker group
usermod -aG docker $USER
# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
