FROM ubuntu:14.04
MAINTAINER admire@afrispatial.co.za

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
#RUN ln -s /bin/true /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get -y update
RUN apt-get -y install  default-jdk
RUN apt-get  install -y wget unzip daemontools
RUN mkdir -p  /etc/service
RUN mkdir -p  /etc/service/geogig_serve
WORKDIR /etc/service/geogig_serve


RUN echo "#!/bin/bash" >run
RUN echo "exec /GeoGig/src/cli-app/target/geogig/bin/geogig serve  /GeoGigRepo" >>run
RUN chmod 0755 run


RUN apt-get install -y maven git

#install geogig
WORKDIR /
RUN if [ ! -f /GeoGig ]; then \
git clone http://github.com/boundlessgeo/GeoGig.git ; \
fi; 
 
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

ENV PATH /GeoGig/src/cli-app/target/geogig/bin:$PATH
RUN echo "export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH" >>/root/.bashrc
EXPOSE 8182
WORKDIR /
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]


