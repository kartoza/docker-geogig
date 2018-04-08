#!/usr/bin/env bash


# Configure username and password for database backend
exec /geogig/bin/geogig --repo "postgresql://db/gis/public/gis_data?user=docker&password=docker" init
exec /geogig/bin/geogig --repo  "postgresql://db/gis/public/gis_data?user=docker&password=docker" config --global user.name USERNAME
exec /geogig/bin/geogig --repo  "postgresql://db/gis/public/gis_data?user=docker&password=docker" config --global user.email ADDRESS
