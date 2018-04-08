#!/usr/bin/env bash
# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig
#install geogig

if [ ! -f /tmp/resources/geogig-${VERSION}.zip ]
then
    if [ "${VERSION}" = "dev" ]; then
        wget http://build-slave-01.geoserver.org/geogig/master/geogig-master-latest.zip -P /tmp/resources
    else
        wget http://download.locationtech.org/geogig/geogig-${VERSION}.zip -P /tmp/resources
    fi
fi

# set the GeoGig plugin/lib directory based on version. For GeoGig 1.1.x it is "lib", for 1.2.x/dev it is "libexec".
if [ "${VERSION}" = "dev" ]; then
    unzip /tmp/resources/geogig-master-latest.zip -d /
    GEOGIG_PLUGIN_DIR=/geogig/libexec
else
    unzip /tmp/resources/geogig-${VERSION}.zip -d /
    GEOGIG_PLUGIN_DIR=/geogig/lib
fi

# install plugins
if [ -d ${GEOGIG_PLUGIN_DIR} ]
then
    if [ "${OSMPLUGIN}" = "OSM" ]; then
        # make sure the OSM plugin version matches the GeoGig version
        if [ "${VERSION}" = "dev" ]; then
            wget -c http://build-slave-01.geoserver.org/geogig/master/geogig-plugins-osm-master-latest.zip
            unzip -j -d ${GEOGIG_PLUGIN_DIR} geogig-plugins-osm-master-latest.zip
            rm geogig-plugins-osm-master-latest.zip
        else
            wget https://github.com/locationtech/geogig/releases/download/v${VERSION}/geogig-plugins-osm-${VERSION}.zip
            unzip -j -d ${GEOGIG_PLUGIN_DIR} geogig-plugins-osm-${VERSION}.zip
            rm geogig-plugins-osm-${VERSION}.zip
        fi
    fi
fi

mkdir -p  /etc/service
export PATH=/geogig/bin:$PATH
GEOGIG_PATH=/geogig/bin
echo "export PATH=${GEOGIG_PATH}:$PATH" >>/root/.bashrc

# Setup username and geogig configs
if [ -z "${USER}" ]; then
	USER=geogig
fi

if [ -z "${EMAIL_ADDRESS}" ]; then
	EMAIL_ADDRESS=geogig@docker.com
fi

if [ "${BACKEND}" = "FILE" ]; then
    FILE_PATH=/geogig_repo/gis
    if [ ! -d /geogig_repo/gis ]
    then
        mkdir -p geogig_repo/gis
        cd /geogig_repo/gis
        /geogig/bin/geogig init
        /geogig/bin/geogig config --global user.name "${USER}"
        /geogig/bin/geogig config --global user.email "${EMAIL_ADDRESS}"

    fi
else
    FILE_PATH="postgresql://db/gis/public/?user=docker&password=docker"
    mkdir -p /etc/service/geogig_config
    cp /tmp/geogig_postgres_config.sh /etc/service/geogig_config/run
    sed -i "s/USERNAME/${USER}/g" /etc/service/geogig_config/run
    sed -i "s/ADDRESS/${EMAIL_ADDRESS}/g" /etc/service/geogig_config/run
    chmod 0755 /etc/service/geogig_config/run
fi

# Setup geogig service
mkdir -p  /etc/service/geogig_serve
cd /etc/service/geogig_serve
echo "#!/bin/bash
# Serve all repos under the specified folder

exec /geogig/bin/geogig serve -m ${FILE_PATH}" > run
chmod 0755 run














