I assume you have docker installed already (the build file and example below
refers to docker instead of docker for commands since that is how it is
packaged in Ubuntu 16.04). So all instructions below are based on 16.04 as the
host:

Change the username and email address in the bash command to run the container:

```bash
docker pull kartoza/geogig
sudo docker run -e USER='name' -e EMAIL_ADDRESS='name@gmail.com' --name="geogig" -p 38080:8182  -d  kartoza/geogig
```


If you want to build the image yourself using the Docker recipe then do the following:


```bash
sudo apt-get install apt-cacher-ng
```

```bash
git clone git@github.com:kartoza/docker-geogig.git
cd docker-geogig
```
**VERSION** build arg can be set to `dev` for the lastest
development build or to a specific version, the default
value is `1.1.1` and it will build geogig-`1.1.1`.

**OSMPLUGIN** build arg to be set to OSM to install OSM dev geogig plugin

**BDBPLUGIN no longer supported** As of GeoGig release 1.0, the BerkeleyDB backend has been replaced by RocksDB
(https://github.com/facebook/rocksdb)

```bash
# Set $ADDR to your APT_CATCHER_IP
docker build -t kartoza/geogig --build-arg VERSION=dev --build-arg APT_CATCHER_IP=$ADDR .
# See ./build.sh for an example run
```


Its going to take a long time (and consume a chunk of bandwidth) for the build
because you have any docker base operating system images on your system and the
maven build grabs a lot of jars.

After it is installed, to run a container substitute your username and email address on the bash command below:

```bash
sudo docker run -e USER='name' -e EMAIL_ADDRESS='name@gmail.com' --name="geogig" -p 38080:8182  -d  kartoza/geogig
```
Then from your local machine you should be able to clone the GeoGigRepo
repository that is created in the docker container:

```
geogig clone http://localhost:38080/repos/geogig_repo gisdata-repo-clone
```


- Tim Sutton, February 2015
