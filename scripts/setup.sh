#!/usr/bin/env bash

function create_dir() {
  DATA_PATH=$1

  if [[ ! -d ${DATA_PATH} ]]; then
    echo "Creating" ${DATA_PATH} "directory"
    mkdir -p ${DATA_PATH}
  fi
}

create_dir /tmp/resources
# Setup geogig service
create_dir  /etc/service/geogig_serve

if [ ! -f /tmp/resources/geogig.zip ];then 
   wget --progress=bar:force:noscroll -c ${GEOGIG_URL} -O /tmp/resources/geogig.zip
fi

# set the GeoGig plugin/lib
if [ -f /tmp/resources/geogig.zip ]; then
    unzip /tmp/resources/geogig.zip -d /
    rm /tmp/resources/geogig.zip
fi

# install plugins
if [ -d ${GEOGIG_PLUGIN_DIR} ];then
    if [ "${OSMPLUGIN}" = "OSM" ]; then
        # make sure the OSM plugin version matches the GeoGig version
    	wget -c ${PLUGIN_URL} -P /tmp/resources
    	unzip -j -d ${GEOGIG_PLUGIN_DIR} -P /tmp/resources/geogig-plugins-osm-${VERSION}.zip
    	rm geogig-plugins-osm-${VERSION}.zip
    fi
fi

