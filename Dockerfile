ARG IMAGE_VERSION=8.0-jre8
ARG JAVA_HOME=/docker-java-home/jre
FROM tomcat:$IMAGE_VERSION
MAINTAINER Admire Nyakudya<admire@kartoza.com>

ARG VERSION=1.2.1
ARG OSMPLUGIN=
ARG GEOGIG_URL=https://github.com/locationtech/geogig/releases/download/v${VERSION}/geogig-cli-app-${VERSION}.zip
ARG PLUGIN_URL=https://github.com/locationtech/geogig/releases/download/v${VERSION}/geogig-plugins-osm-${VERSION}.zip

#-------------Application Specific Stuff ----------------------------------------------------

ENV \
	GEOGIG_CACHE_MAX_SIZE=0.5 \
	EMAIL=geogig@docker.com \
	USER_NAME=geogig \
	STORAGE_BACKEND=DATABASE \
	PGHOST=db \
	PGPORT=5432 \
	PGDATABASE=gis \
	PGUSER=docker \
	PGPASSWORD=docker \
	PGSCHEMA=public \
	GEOGIG_PATH=/geogig/bin \
    PATH="$PATH:${GEOGIG_PATH}" \
	LOCAL_REPO='/geogig_repo/gis' \
	EXTRA_CONFIG_DIR=/settings \
	GEOGIG_PLUGIN_DIR=/geogig/libexec \
	INITIAL_MEMORY="2G" \
	MAXIMUM_MEMORY="4G"

WORKDIR /scripts

RUN apt-get -y update;apt-get -y install default-jdk wget unzip gettext daemontools postgresql-client

ADD scripts /scripts
ADD build_data /build_data
ADD resources /tmp/resources

RUN chmod +x /scripts/*.sh;/scripts/setup.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 8182

CMD ["/bin/bash", "/scripts/start.sh"]
