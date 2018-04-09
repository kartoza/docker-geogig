#!/usr/bin/env bash


# Configure username and password for database backend
/geogig/bin/geogig --repo "postgresql://db/gis/public/gis_data?user=docker&password=docker" init
/geogig/bin/geogig --repo  "postgresql://db/gis/public/gis_data?user=docker&password=docker" config --global user.name USERNAME
/geogig/bin/geogig --repo  "postgresql://db/gis/public/gis_data?user=docker&password=docker" config --global user.email ADDRESS
