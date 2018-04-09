#!/bin/bash
# Configure username and password for database backend

/geogig/bin/geogig --repo "postgresql://db/gis/public/gis?user=docker&password=docker" init
/geogig/bin/geogig --repo  "postgresql://db/gis/public/gis?user=docker&password=docker" config --global user.name "${USER_NAME}"
/geogig/bin/geogig --repo  "postgresql://db/gis/public/gis?user=docker&password=docker" config --global user.email "${EMAIL}"

/usr/bin/svscan /etc/service

