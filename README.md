I assume you have docker installed already (the build file and example below
refers to docker instead of docker for commands since that is how it is
packaged in Ubuntu 14.04). So all instructions below are based on 14.04 as the
host:

```bash
docker pull kartoza/geogig
sudo docker run --name="geogig" -p 38080:8182 -d kartoza/geogig
```


If you want to build the image yourself using the Docker recipe then do the following:

```bash
sudo apt-get install apt-cacher-ng
git clone git@github.com:kartoza/docker-geogig.git
cd docker-geogig
```

Edit ``71-apt-cacher-ng`` to use your host's ip address.
Edit ``setup.sh`` to use your name and email address to configure geogig.

```bash
sudo ./build.sh
```


Its going to take a long time (and consume a chunk of bandwidth) for the build
because you have any docker base operating system images on your system and the
maven build grabs a lot of jars.

After it is installed run a container:

```bash
sudo docker run --name="geogig" -p 38080:8182  -d  kartoza/geogig
```
Then from your local machine you should be able to clone the GeoGigRepo
repository that is created in the docker container:

```
geogig clone http://localhost:38080 gisdata-repo-clone
```


- Tim Sutton, April 2014
