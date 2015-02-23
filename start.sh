#!/bin/bash

USER=name
EMAIL_ADDRESS=name@gmail.com

if [ -n "$1" ]
then
    USER=$1
fi

if [ -n "$1" ]
then
    EMAIL_ADDRESS=$1
fi


geogig config --global user.name "${USER}"
geogig config --global user.email "${EMAIL_ADDRESS}"

/usr/bin/svscan /etc/service
