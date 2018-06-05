#!/bin/bash

# Serve the correct repo from the correct database
if grep -rl -q "db" /etc/service/geogig_serve/run

then
    echo "Use the correct PG Host that is defined by the env variable"
    sed -i "s/db:/$PGHOST:/g" /etc/service/geogig_serve/run
else
    echo "The PG Host has not changed"

fi

# Configure username and password for database backend
export PGPASSWORD=${PGPASSWORD}
sql=" select (case when exists (SELECT 1 FROM   information_schema.tables  WHERE  table_schema = 'public' AND    table_name = 'geogig_config') then 0 else 1 end) as exist; "
conn="-d ${PGDATABASE} -p ${PGPORT} -U ${PGUSER} -h ${PGHOST}"
output=$(psql ${conn} -t -c "${sql}")
echo ${output}


if [ "${STORAGE_BACKEND}" = "FILE" ]; then
    /geogig/bin/geogig config --global user.name "${USER_NAME}"
    /geogig/bin/geogig config --global user.email "${EMAIL}"
else
    if [ "${output}" -eq '1' ]; then

	    echo 'Geogig tables are non existent and we will initiate them'
	    /geogig/bin/geogig --repo "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/gis?user=${PGUSER}&password=${PGPASSWORD}" init
        /geogig/bin/geogig --repo  "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/?user=${PGUSER}&password=${PGPASSWORD}" config --global user.name "${USER_NAME}"
        /geogig/bin/geogig --repo  "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/?user=${PGUSER}&password=${PGPASSWORD}" config --global user.email "${EMAIL}"

    else
	    echo 'Database already initiated'
    fi


fi
/usr/bin/svscan /etc/service

