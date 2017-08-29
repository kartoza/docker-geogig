# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig

#install geogig
if [ ! -d /geogig ]
then
    if [ "${VERSION}" = "dev" ]; then
        wget http://ares.boundlessgeo.com/geogig/master/geogig-master-latest.zip
        unzip geogig-master-latest.zip
        rm geogig-master-latest.zip
    else
        wget http://download.locationtech.org/geogig/geogig-${VERSION}.zip
        unzip geogig-${VERSION}.zip
        rm geogig-${VERSION}.zip
    fi
fi

# install plugins
if [ -d /geogig/lib ]
then
    if [ "${BDBPLUGIN}" = "BDB" ]; then
        wget http://ares.boundlessgeo.com/geogig/dev/geogig-plugins-bdbje-dev-latest.zip
        unzip -j -d /geogig/lib geogig-plugins-bdbje-dev-latest.zip
        rm geogig-plugins-bdbje-dev-latest.zip
    fi

    if [ "${OSMPLUGIN}" = "OSM" ]; then
        wget http://ares.boundlessgeo.com/geogig/dev/geogig-plugins-osm-dev-latest.zip
        unzip -j -d /geogig/lib geogig-plugins-osm-dev-latest.zip
        rm geogig-plugins-osm-dev-latest.zip
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
