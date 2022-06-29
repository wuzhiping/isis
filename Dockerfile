FROM mcr.microsoft.com/java/jdk:11-zulu-ubuntu-18.04

ENV LANG C.UTF-8
#maven\
RUN apt-get -q update && \
    apt-get -y --no-install-recommends install curl git gnupg software-properties-common && \
    rm -rf /var/lib/apt/lists/*

ARG MAVEN_VERSION=3.8.6
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN mvn -version

WORKDIR /opt/
RUN APP=isis-app-simpleapp;BRANCH=jpa;curl https://codeload.github.com/apache/$APP/zip/$BRANCH | jar xv;cd $APP-$BRANCH;mvn clean install

WORKDIR /opt/isis-app-simpleapp-jpa
EXPOSE 8080

CMD mvn -pl webapp spring-boot:run
