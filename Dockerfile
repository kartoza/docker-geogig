FROM ubuntu:xenial
MAINTAINER Admire Nyakudya<admire@kartoza.com>

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

ARG VERSION="-1.0-RC3"

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get -y update
RUN apt-get -y install default-jdk wget unzip daemontools maven git

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

EXPOSE 8182
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
