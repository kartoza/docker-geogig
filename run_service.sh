#!/bin/bash

/etc/init.d/geogig_serve start
sleep 10
# The container will run as long as the script is running, that's why
# we need something long-lived here
#exec tail -f /var/log/tomcat7/catalina.out
