# Once-off tasks to run when setting up the container
# Tim Sutton, April 24, 2014
# Install GeoGit
cd /
git clone http://github.com/boundlessgeo/GeoGig.git
cd GeoGig/src/parent
mvn clean install -DskipTests

# Make an empty repo
export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH
cd ../../../
mkdir GeoGigRepo
cd GeoGigRepo
geogig init
geogig config --global user.name "admire"
geogig config --global user.email "admire@kartoza.com"
wget http://geogig.org/docs/_downloads/tutorial_data.zip
unzip tutorial_data.zip
geogig shp import snapshot1/parks.shp
geogig add
geogig commit -m "initial test commit"
