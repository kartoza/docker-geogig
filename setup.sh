#!/usr/bin/env bash
# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig


cd /etc/service/geogig_serve
echo "#!/bin/bash
exec /geogig/src/cli-app/target/geogig/bin/geogig serve /geogig_repo" > run
chmod 0755 run

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

geogig config --global user.name "${USER_NAME}"
geogig config --global user.email "${EMAIL_ADDRESS}"


