FROM ubuntu:14.04
MAINTAINER admire@afrispatial.co.za


#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update
RUN apt-get -y install  default-jdk
RUN apt-get  install -y  supervisor wget unzip
RUN mkdir -p  /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN apt-get install -y maven git


ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

ENV PATH /GeoGig/src/cli-app/target/geogig/bin:$PATH
RUN echo "export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH" >>/root/.bashrc


RUN echo "#bin/bash">>exec.sh
RUN echo "geogig serve /GeoGigRepo" >>exec.sh

RUN chmod 0755 exec.sh

RUN /bin/sh exec.sh &


RUN sleep 5
RUN geogig --help 
EXPOSE 8182


