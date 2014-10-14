# Once-off tasks to run when setting up the container
# Tim Sutton, April 24, 2014
# Install GeoGit
cd /
git clone http://github.com/boundlessgeo/GeoGit.git
cd GeoGit/src/parent
mvn clean install -DskipTests

# Make an empty repo
export PATH=/GeoGit/src/cli-app/target/geogit/bin:$PATH
mkdir GeoGitRepo
cd GeoGitRepo
geogit init

