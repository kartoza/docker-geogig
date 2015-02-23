FROM ubuntu:14.04
MAINTAINER admire@kartoza.com

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get -y update
RUN apt-get -y install  default-jdk wget unzip daemontools maven git
RUN mkdir -p  /etc/service
RUN mkdir -p  /etc/service/geogig_serve
WORKDIR /etc/service/geogig_serve
RUN echo "#!/bin/bash" >run
RUN echo "exec /GeoGig/src/cli-app/target/geogig/bin/geogig serve  /GeoGigRepo" >>run
RUN chmod 0755 run

#install geogig
WORKDIR /
RUN if [ ! -f /1.0-beta1.zip ]; then \
wget https://github.com/boundlessgeo/GeoGig/archive/1.0-beta1.zip; \
fi; 

RUN unzip 1.0-beta1.zip
RUN mv GeoGig-1.0-beta1 GeoGig
RUN rm  1.0-beta1.zip
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

ENV PATH /GeoGig/src/cli-app/target/geogig/bin:$PATH
RUN echo "export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH" >>/root/.bashrc
EXPOSE 8182
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]

