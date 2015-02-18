# Once-off tasks to run when setting up the container
# Tim Sutton, April 24, 2014
# Install GeoGit

cd /GeoGig/src/parent
mvn clean install -DskipTests

# Make an empty repo
export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH
cd ../../../
mkdir GeoGigRepo
cd GeoGigRepo
geogig init
geogig config --global user.name "admire"
geogig config --global user.email "admire@kartoza.com"

