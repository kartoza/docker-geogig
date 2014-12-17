FROM ubuntu:14.04
MAINTAINER admire@afrispatial.co.za


#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update
RUN apt-get -y install  default-jdk
RUN apt-get  install -y wget unzip daemontools
RUN mkdir -p  /etc/service
RUN mkdir -p  /etc/service/geogig_serve
WORKDIR /etc/service/geogig_serve

RUN touch run
RUN echo "#!/bin/bash" >>run
RUN echo "exec /GeoGig/src/cli-app/target/geogig/bin/geogig serve  /GeoGigRepo" >>run
RUN chmod 0755 run
#RUN mv run.sh run
RUN apt-get install -y maven git

#install geogig
ADD GeoGig /GeoGig
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


