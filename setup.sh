# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig

#install geogig
if [ ! -d /geogig ]
then
    if [ "${VERSION}" = "dev" ]; then
        wget http://ares.boundlessgeo.com/geogig/dev/geogig-dev-latest.zip
        unzip geogig-dev-latest.zip
        rm geogig-dev-latest.zip
    else
        wget https://github.com/locationtech/geogig/releases/download/${VERSION}/geogig-${VERSION}.zip
        unzip geogig-${VERSION}.zip
        rm geogig-${VERSION}.zip
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
