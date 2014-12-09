#bin/bash
docker run --name="geogig" -p 38080:8182 -i -d -t kartoza/geogig

geogig clone http://localhost:38080 gisdata-repo-clone
