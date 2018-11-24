FROM centos:centos7

RUN yum install -y wget

ENV container=docker
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-0.el7_5.x86_64
ENV PATH=$JAVA_HOME/bin:$PATH

############ JAVA INSTALL ##################
RUN yum install -y java-1.8.0-openjdk-devel
###########################################

############ MAVEN INSTALL #################
RUN cd /usr/local/src
RUN wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

RUN tar -xf apache-maven-3.5.4-bin.tar.gz
RUN mv apache-maven-3.5.4/ apache-maven
RUN rm -rf apache-maven-3.5.4-bin.tar.gz

# Might consider moving this to the top, or put these environment
# variables as export statements inside maven.sh and put maven.sh in
# /etc/profile.d
ENV M2_HOME=/apache-maven
ENV PATH=${M2_HOME}/bin:${PATH}

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/.mavenrc
RUN source /etc/.mavenrc
############################################
