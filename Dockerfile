FROM centos:centos7
#FROM registry.psgit.bankofthewest.com/docker/images/botw_rhel7:latest

MAINTAINER sandeep.chitte@bankofthewest.com

USER root

ENV ADMIN_PASSWORD 1234567
ENV CERT_PASSWORD 98786654

# Prepare environment 
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.232.b09-0.el7_7.x86_64/jre
ENV CATALINA_HOME /usr/local/tomcat 
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.35

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar && \
 yum install -y  java-1.8.0-openjdk && \
 yum clean all


RUN mkdir -p /usr/local/tomcat
ADD apache-tomcat-8.5.47.tar.gz .
RUN tar xvf apache-tomcat-8.5.47.tar.gz -C ${CATALINA_HOME} --strip-components=1

COPY server.xml ${CATALINA_HOME}/conf/server.xml
ADD run.sh /run.sh

RUN chmod +x ${CATALINA_HOME}/bin/*sh && \
  chmod +x /run.sh && \
  rm -rf apache-tomcat-8.5.47.tar.gz

# Create tomcat user
RUN groupadd -r tomcat && \
 useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c "Tomcat user" tomcat && \
 chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR /opt/tomcat

EXPOSE 8080 8443

USER tomcat
CMD ["/run.sh"]
