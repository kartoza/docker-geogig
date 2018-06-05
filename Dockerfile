FROM tomcat:8.0-jre8
MAINTAINER Admire Nyakudya<admire@kartoza.com>


#ARG APT_CATCHER_IP=localhost

# Use apt-catcher-ng caching
# Use local cached debs from host to save your bandwidth and speed thing up.
# APT_CATCHER_IP can be changed passing an argument to the build script:
# --build-arg APT_CATCHER_IP=xxx.xxx.xxx.xxx,
# set the IP to that of your apt-cacher-ng host or comment this line out
# if you do not want to use caching
#RUN  echo 'Acquire::http { Proxy "http://'${APT_CATCHER_IP}':3142"; };' >> /etc/apt/apt.conf.d/01proxy

ARG VERSION="1.2.0"
ARG BACKEND="DATABASE"

# leave empty to use default plugins or set to "OSM" to install also OSM dev plugin
ARG OSMPLUGIN=""

#-------------Application Specific Stuff ----------------------------------------------------
ENV GEOGIG_OPTS "-Djava.awt.headless=true -server -Xms2G -Xmx4G  "
#-XX:+UseConcMarkSweepGC use this rather than parallel GC?
ENV JAVA_OPTS "$JAVA_OPTS $GEOGIG_OPTS"

ENV GEOGIG_CACHE_MAX_SIZE 0.5
ENV EMAIL geogig@docker.com
ENV USER_NAME  geogig
ENV STORAGE_BACKEND ${BACKEND}
ENV PGHOST db
ENV PGPORT 5432
ENV PGDATABASE gis
ENV PGUSER docker
ENV PGPASSWORD docker
ENV PGSCHEMA public
RUN apt-get -y update

RUN apt-get -y install default-jdk  daemontools postgresql

RUN mkdir -p /tmp/resources


ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

EXPOSE 8182
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
