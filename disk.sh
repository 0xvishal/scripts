#! /bin/bash
output=$(df --output=avail /dev/xvda1 | sed -n '2p')
space=1000
if [ $output -gt $space ]
then
    echo "Disk is full"
else
    echo "Disk have a free space"
fi
