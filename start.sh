#!/bin/bash
# Configure username and password for database backend

if [ "${STORAGE_BACKEND}" = "FILE" ]; then
    /geogig/bin/geogig config --global user.name "${USER_NAME}"
    /geogig/bin/geogig config --global user.email "${EMAIL}"
else
    /geogig/bin/geogig --repo "postgresql://db/gis/public/gis?user=docker&password=docker" init
    /geogig/bin/geogig --repo  "postgresql://db/gis/public/gis?user=docker&password=docker" config --global user.name "${USER_NAME}"
    /geogig/bin/geogig --repo  "postgresql://db/gis/public/gis?user=docker&password=docker" config --global user.email "${EMAIL}"
fi
/usr/bin/svscan /etc/service

