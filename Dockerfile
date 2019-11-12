FROM registry.psgit.bankofthewest.com/docker/images/botw_rhel7:latest

MAINTAINER sandeep.chitte@bankofthewest.com

USER root

ENV ADMIN_PASS 1234567
ENV CERT_PASS 98786654

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /usr/local/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

RUN yum update -y ; yum install -y  java-1.8.0-openjdk ; yum clean all

# Install Tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.35

RUN mkdir -p /usr/local/tomcat
COPY apache-tomcat-8.5.23.tar.gz .
RUN tar xvf apache-tomcat-8.5.23.tar.gz -C ${CATALINA_HOME} --strip-components=1

COPY server.xml ${CATALINA_HOME}/conf/server.xml
RUN chmod +x ${CATALINA_HOME}/bin/*sh


ADD run.sh /run.sh
RUN chmod +x /run.sh

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080
EXPOSE 8443

USER tomcat
CMD ["run.sh"]
