FROM ubuntu:16.04
MAINTAINER Admire Nyakudya<admire@kartoza.com>

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get -y update
RUN apt-get -y install default-jdk wget unzip daemontools maven git

ENV GS_VERSION v1.1.1
ENV GEOGIG_PATH /geogig/src/cli-app/target/geogig/bin
ENV USER_NAME testuser
ENV EMAIL_ADDRESS testuser@gmail.com

ADD resources /tmp/resources
RUN mkdir -p  /etc/service
RUN mkdir -p  /etc/service/geogig_serve

RUN if [ ! -f /tmp/resources/${GS_VERSION} ]; then \
    wget  -c https://codeload.github.com/locationtech/geogig/zip/${GS_VERSION} \
      -O /tmp/resources/${GS_VERSION}; \
    fi; \
    unzip /tmp/resources/${GS_VERSION} -d /tmp/&& \
    mv /tmp/geogig-* /geogig

WORKDIR /geogig/src/parent

RUN mvn -T 4 clean install -DskipTests

ADD setup.sh /setup.sh
RUN chmod 0755 /setup.sh
RUN /setup.sh


EXPOSE 8182
ADD start.sh /start.sh
RUN chmod 0755 /start.sh


CMD ["/start.sh"]
