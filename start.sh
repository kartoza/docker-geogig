#!/bin/bash

if [ "${BACKEND}" = "FILE" ]; then
    cd /geogig_repo/gis && /geogig/bin/geogig init
else
    geogig --repo "postgresql://db/gis/public/?user=docker&password=docker" init
fi
/usr/bin/svscan /etc/service
