#!/bin/bash

export GEOGIG_OPTS="-Djava.awt.headless=true -server -Xms${INITIAL_MEMORY} -Xmx${MAXIMUM_MEMORY} -DGEOGIG_CACHE_MAX_SIZE=${GEOGIG_CACHE_MAX_SIZE}"
export JAVA_OPTS="$JAVA_OPTS $GEOGIG_OPTS"

# Serve the correct repo from the correct database

if [[ "${BACKEND}" =~ [Ff][Ii][Ll][Ee] ]]; then
    FILE_PATH=${LOCAL_REPO}
    if [ ! -d ${LOCAL_REPO} ];then
        mkdir -p ${LOCAL_REPO}
        cd ${LOCAL_REPO}
        /geogig/bin/geogig init
    fi
else
    FILE_PATH="postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/?user=${PGUSER}&password=${PGPASSWORD}"
fi

export FILE_PATH

if [[ ! -f /etc/service/geogig_serve/run ]]; then
    # If it doesn't exists, copy from /settings directory if exists
    if [[ -f ${EXTRA_CONFIG_DIR}/run ]]; then
      cp -f ${EXTRA_CONFIG_DIR}/run /etc/service/geogig_serve/
    else
      # default values
	  envsubst < /build_data/run > /etc/service/geogig_serve/run
      chmod 0755 /etc/service/geogig_serve/run
    fi
fi

# Setup username and geogig configs
if [ -z "${USER}" ]; then
    USER=${USER_NAME}
fi

if [ -z "${EMAIL_ADDRESS}" ]; then
	EMAIL_ADDRESS=${EMAIL}
fi



if [[ "${STORAGE_BACKEND}" =~ [Ff][Ii][Ll][Ee] ]]; then
    /geogig/bin/geogig config --global user.name "${USER_NAME}"
    /geogig/bin/geogig config --global user.email "${EMAIL}"
else 
	sql=" select (case when exists (SELECT 1 FROM   information_schema.tables  WHERE  table_schema = 'public' AND    table_name = 'geogig_config') then 0 else 1 end) as exist; "
	CHECK_GEOGIG_CONFIG_TABLES=$(PGPASSWORD=${PGPASSWORD} psql -d ${PGDATABASE} -p ${PGPORT} -U ${PGUSER} -h ${PGHOST} -t -c "${sql}")
	if [[ "${CHECK_GEOGIG_CONFIG_TABLES}" -eq '1' ]]; then
		echo 'Geogig tables are non existent and we will initiate them'
	    /geogig/bin/geogig --repo "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/${PGDATABASE}?user=${PGUSER}&password=${PGPASSWORD}" init
        /geogig/bin/geogig --repo  "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/?user=${PGUSER}&password=${PGPASSWORD}" config --global user.name "${USER_NAME}"
        /geogig/bin/geogig --repo  "postgresql://${PGHOST}:${PGPORT}/${PGDATABASE}/${PGSCHEMA}/?user=${PGUSER}&password=${PGPASSWORD}" config --global user.email "${EMAIL}"
    	fi
fi

/usr/bin/svscan /etc/service

