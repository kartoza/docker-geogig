# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig

#install geogig
if [ ! -d /geogig ]
then
    if [ "${VERSION}" = "dev" ]; then
        wget http://build-slave-01.geoserver.org/geogig/master/geogig-master-latest.zip
        unzip geogig-master-latest.zip
        rm geogig-master-latest.zip
    else
        wget http://download.locationtech.org/geogig/geogig-${VERSION}.zip
        unzip geogig-${VERSION}.zip
        rm geogig-${VERSION}.zip
    fi
fi

# set the GeoGig plugin/lib directory based on version. For GeoGig 1.1.x it is "lib", for 1.2.x/dev it is "libexec".
if [ "${VERSION}" = "dev" ]; then
    GEOGIG_PLUGIN_DIR=/geogig/libexec
else
    GEOGIG_PLUGIN_DIR=/geogig/lib
fi

# install plugins
if [ -d ${GEOGIG_PLUGIN_DIR} ]
then
    if [ "${OSMPLUGIN}" = "OSM" ]; then
        # make sure the OSM plugin version matches the GeoGig version
        if [ "${VERSION}" = "dev" ]; then
            wget http://build-slave-01.geoserver.org/geogig/master/geogig-plugins-osm-master-latest.zip
            unzip -j -d ${GEOGIG_PLUGIN_DIR} geogig-plugins-osm-master-latest.zip
            rm geogig-plugins-osm-master-latest.zip
        else
            wget https://github.com/locationtech/geogig/releases/download/v${VERSION}/geogig-plugins-osm-${VERSION}.zip
            unzip -j -d ${GEOGIG_PLUGIN_DIR} geogig-plugins-osm-${VERSION}.zip
            rm geogig-plugins-osm-${VERSION}.zip
        fi
    fi
fi

# Setup geogig service
mkdir -p  /etc/service
mkdir -p  /etc/service/geogig_serve
cd /etc/service/geogig_serve
echo "#!/bin/bash
# Serve all repos under the specified folder
exec /geogig/bin/geogig serve -m /geogig_repo" > run
chmod 0755 run

GEOGIG_PATH=/geogig/bin
echo "export PATH=${GEOGIG_PATH}:$PATH" >>/root/.bashrc

# Make an empty repo
export PATH=/geogig/bin:$PATH
cd /
if [ ! -d /geogig_repo/test_repo ]
then
    mkdir -p geogig_repo/test_repo
fi

cd geogig_repo/test_repo
/geogig/bin/geogig init
