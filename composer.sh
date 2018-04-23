#!/bin/bash

#!/bin/bash
# Install composer on ubuntu16.04 
# Copyright (c) 2015-2018 Vishal Gupta
# EMAILID="er.vishalkumargupta@gmail.com"
# ---------------------------------------------------------------------


sudo apt-get update
if [ $? -eq 0 ]; then
    echo "pachages installed"
else
    echo "some error while updating package"
    exit
fi


sudo apt-get install php-curl
if [ $? -eq 0 ]; then
    echo "php-curl installed"
else
    echo "some error while installing php-curl"
    exit
fi


sudo apt-get install php-cli
if [ $? -eq 0 ]; then
    echo "php-cli installed"
else
    echo "some error while installing php-cli"
    exit
fi


sudo apt-get install git
if [ $? -eq 0 ]; then
    echo "git installed"
else
    echo "some error while installing git"
    exit
fi

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

if [ $? -eq 0 ]; then
    echo "composer installed"
else
    echo "some error while installing composer"
    exit
fi
