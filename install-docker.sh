#!/bin/bash

# get docker with this url and execute it will automatically detect the architecture and install dependencies
$ curl -sSL https://get.docker.com | sh
# add user to docker group
usermod -aG docker $USER
# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

source ~/.profile