#!/bin/bash

USER_NAME=name
EMAIL_ADDRESS=name@gmail.com

if [ -n "$1" ]
then
    USER=$1
fi

if [ -n "$1" ]
then
    EMAIL_ADDRESS=$1
fi


/geogig/bin/geogig config --global user.name "${USER}"
/geogig/bin/geogig config --global user.email "${EMAIL_ADDRESS}"

/usr/bin/svscan /etc/service
