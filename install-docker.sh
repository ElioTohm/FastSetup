#!/bin/bash

apt-get update
apt-get -y -f install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    python-software-propertie

curl -fsSL https://yum.dockerproject.org/gpg | apt-key add -

apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

apt-get update

apt-get -y -f install docker-engine libreadline-dev libncurses5-dev libssl1.0.0 tk8.5-dev zlib1g-dev liblzma-dev docker-compose

groupadd docker

gpasswd -a $USER docker

