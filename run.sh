#!/bin/bash
#config
INSTALL_LARADOCK=true
INSTALL_DEV_ENV=true
INSTALL_DOCKER=true

# update and upgrade on fresh install
sudo apt-get -y update
sudo apt-get -y upgrade

# install git fish and guake terminal as well as php7 for intellisense 
if [ "$INSTALL_DEV_ENV" = true ] ; then
    sudo apt-get install -yf git fish guake php7 
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
    docker-compose build apache2 mongo mysql php-worker workspace beanstalkd beanstalkd-console php-fpm redis rabbitmq selenium elasticsearch php-worker

fi


