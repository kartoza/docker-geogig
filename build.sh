#!/bin/bash

#Build with localhost address: APT_CATCHER_IP=192.168.xx.xx

# Start APT Catcher
# docker run -d --name apt-acng -p 3142:3142 acng:latest
# docker logs -f apt-acng

ADDR=`ifconfig wlan1 | grep 'indirizzo inet:' | cut -d: -f2 | awk '{ print $1}'`

docker build -t kartoza/geogig --build-arg VERSION=dev --build-arg APT_CATCHER_IP=$ADDR .
