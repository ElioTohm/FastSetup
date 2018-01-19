#!/bin/bash
#config
INSTALL_LARADOCK=true
INSTALL_DEV_ENV=true
INSTALL_DOCKER=true

# update and upgrade on fresh install
apt-get -y update
apt-get -y upgrade

# install git fish and guake terminal
if [ "$INSTALL_DEV_ENV" = true ] ; then
    sudo apt-get install -yf fish guake 
fi

# install docker and docker-compose 
if [ "$INSTALL_DOCKER" =  true ] ; then
    sh install-docker.sh
fi 

# clone laradock
if [ "$INSTALL_LARADOCK" = true ] ; then
    git clone https://github.com/laradock/laradock.git
    
    if [ "$INSTALL_DOCKER" =  true ] ; then
        # cp env file  to laradock
        cp laradock-env ~/laradock/.env
    fi

    #go to laradock and build containers
    cd ~/laradock
    sudo docker-compose build nginx mongo mysql php-worker workspace beanstalkd beanstalkd-console php-fpm redis rabbitmq selenium elasticsearch php-worker

fi


