FROM ubuntu:xenial
MAINTAINER Admire Nyakudya<admire@kartoza.com>


ARG APT_CATCHER_IP=localhost

# Use apt-catcher-ng caching
# Use local cached debs from host to save your bandwidth and speed thing up.
# APT_CATCHER_IP can be changed passing an argument to the build script:
# --build-arg APT_CATCHER_IP=xxx.xxx.xxx.xxx,
# set the IP to that of your apt-cacher-ng host or comment this line out
# if you do not want to use caching
#RUN  echo 'Acquire::http { Proxy "http://'${APT_CATCHER_IP}':3142"; };' >> /etc/apt/apt.conf.d/01proxy

ARG VERSION="1.1.1"
ARG BACKEND="DATABASE"

# leave empty to use default plugins or set to "OSM" to install also OSM dev plugin
ARG OSMPLUGIN=""

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get -y update

RUN apt-get -y install default-jdk wget unzip daemontools postgresql

ADD resources /tmp/resources
ADD geogig_postgres_config.sh /tmp/geogig_postgres_config.sh

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

EXPOSE 8182
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
