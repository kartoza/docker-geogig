I assume you have docker and docker-composer installed already.So all instructions below are based on 16.04 as the
host:

Change the username and email address in the bash command to run the container:

```bash
GEOGIG_VERSION_TAG=1.2.0
docker pull kartoza/geogig:${GEOGIG_VERSION_TAG}
docker run --name "db" -p 25434:5432 -d -t kartoza/postgis:${POSTGIS_VERSION_TAG}
docker run -e USER_NAME='name' -e EMAIL='name@gmail.com' --name="geogig" -p 38080:8182 --link db:db  -d  kartoza/geogig:${GEOGIG_VERSION_TAG}
```

If you want to build the image yourself using the Docker recipe then do the following:

```bash
git clone git@github.com:kartoza/docker-geogig.git
cd docker-geogig
docker-compose -f docker-compose-build.yml up -d --build
```

## Environment variables
A full list of environment variables is available from the env file.

**VERSION** build arg can be set to the version number i.e 1.2.1.

**BACKEND** Can be set to FILE or DATABASE. FILE Backend uses the `rocks-db` storage backend 
DATABASE uses the `PostgreSQL` backend

**OSMPLUGIN** build arg to be set to OSM to install OSM geogig plugin

## Running docker-compose

```bash
docker-compose up -d --build
```
The docker-compose connects to an old version of GeoServer running the geogig extension.

**Note** The GeoServer geogig extension is no longer being maintained and users wanting a newer version would have
to build the extension themselves using the instructions from [GeoServer Integration](http://geogig.org/docs/interaction/geoserver_ui.html)
ld assumes that you have a docker-geoserver image that has the geogig extension built with it. 

Once the docker services are up a user should be able to import, add and commit data in an intialized repository:

To clone a populated repository run the following

```bash
geogig clone http://localhost:38080/repos/gis gisdata-repo-clone
```
Before cloning the repository make sure that you have geogig installed locally. You can follow the instructions
from [Geogig Install](http://geogig.org/docs/start/installation.html)

- Tim Sutton, February 2015
