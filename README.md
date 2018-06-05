I assume you have docker and docker-composer installed already.So all instructions below are based on 16.04 as the
host:

Change the username and email address in the bash command to run the container:

```bash
docker pull kartoza/geogig:$VER
# Where Version can be set to dev or latest stable release and also varies based on  the storage backend
# Run the Postgres database and link it to the geogig image
docker run --name "db" -p 25434:5432 -d -t kartoza/postgis:9.5-2.2 
docker run -e USER_NAME='name' -e EMAIL='name@gmail.com' --name="geogig" -p 38080:8182 --link db:db  -d  kartoza/geogig
```


If you want to build the image yourself using the Docker recipe then do the following:


```bash
sudo apt-get install apt-cacher-ng
```

```bash
git clone git@github.com:kartoza/docker-geogig.git
cd docker-geogig
```
**VERSION** build arg can be set to `dev` for the developmental branch
development build or to a specific version, the default
value is `1.1.1` and it will build geogig-`1.1.1`.

**BACKEND** Can be set to FILE or DATABASE.
FILE Backend uses the rocks-db storage backend
DATABASE uses the PostgreSQL backend

**OSMPLUGIN** build arg to be set to OSM to install OSM dev geogig plugin

```bash
docker-compose up -d --build
```
The build assumes that you have a docker-geoserver image that has the geogig extension built with it. For 
instructions on how to build geoserver with geogig follow the instructions at [kartoza geoserver](https://github.com/kartoza/docker-geoserver)

To build and bring the services up to custom environment variables edit the `.env` files accordingly.

It's going to take a long time (and consume a chunk of bandwidth) for the build
because you have any docker base operating system images on your system and the
maven build grabs a lot of jars.

Once the docker services are up a user should be able to clone the remote repository locally using the command:

```
geogig clone http://localhost:38080/repos/gis gisdata-repo-clone
```
Before cloning the repository make sure that you have geogig installed locally. You can follow the instructions
from [Geogig Install](http://geogig.org/docs/start/installation.html)

- Tim Sutton, February 2015
