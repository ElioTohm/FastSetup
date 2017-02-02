#!/bin/bash

sudo apt-get update
sudo apt-get -f install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get install apt-transport-https \
                   ca-certificates 

curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

sudo apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

  pub   4096R/2C52609D 2015-07-14
        Key fingerprint = 5811 8E89 F3A9 1289 7C07  0ADB F762 2157 2C52 609D
  uid                  Docker Release Tool (releasedocker) <docker@docker.com>

sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

sudo apt-get update

sudo apt-get -y install docker-engine

sudo apt-get -f install python3
sudo apt-get install libreadline-dev libncurses5-dev libssl1.0.0 tk8.5-dev zlib1g-dev liblzma-dev

sudo apt-get -f install python3

pip install docker-compose


