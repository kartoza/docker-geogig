# Once-off tasks to run when setting up the container
# Tim Sutton, February 21, 2015
# Install GeoGig

cd /GeoGig/src/parent
mvn clean install -DskipTests

# Make an empty repo
export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH
cd ../../../
mkdir GeoGigRepo
cd GeoGigRepo
geogig init


