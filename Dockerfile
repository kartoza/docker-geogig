FROM ubuntu:14.04
MAINTAINER admire@afrispatial.co.za


#ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update
RUN apt-get -y install  default-jdk
RUN apt-get  install -y  supervisor wget unzip
RUN mkdir -p  /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/geogig_serve.err.log
RUN mkdir -p /var/log/geogig_serve.out.log
RUN apt-get install -y maven git

ADD GeoGig /GeoGig
ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh

ENV PATH /GeoGig/src/cli-app/target/geogig/bin:$PATH
RUN echo "export PATH=/GeoGig/src/cli-app/target/geogig/bin:$PATH" >>/root/.bashrc


#RUN supervisord  

RUN geogig --help 
EXPOSE 9001
EXPOSE 8182



#VOLUME ["/etc/supervisor/conf.d"]

WORKDIR /etc/supervisor/conf.d

#CMD ["/usr/bin/supervisord", "-c", "/etc/conf.d/supervisor.conf"]
CMD ["/usr/bin/supervisord"]



