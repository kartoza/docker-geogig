# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig

#install geogig
VERSION=1.0-beta1
if [ ! -d /geogig ]
then 
    wget https://github.com/boundlessgeo/GeoGig/archive/${VERSION}.zip
    unzip ${VERSION}.zip
    mv GeoGig-${VERSION} geogig
    rm ${VERSION}.zip
fi 

cd /geogig/src/parent
mvn clean install -DskipTests

# Setup geogig service
mkdir -p  /etc/service
mkdir -p  /etc/service/geogig_serve
cd /etc/service/geogig_serve
echo "#!/bin/bash
exec /geogig/src/cli-app/target/geogig/bin/geogig serve /geogig_repo" > run
chmod 0755 run

GEOGIG_PATH=/geogig/src/cli-app/target/geogig/bin
echo "export PATH=${GEOGIG_PATH}:$PATH" >>/root/.bashrc

# Make an empty repo
export PATH=/geogig/src/cli-app/target/geogig/bin:$PATH
cd /
if [ ! -d /geogig_repo ]
then 
    mkdir geogig_repo
fi

cd geogig_repo
geogig init


