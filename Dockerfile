FROM centos:centos7

#-------------- UTILITIES INSTALL --------------#
RUN yum install -y wget
RUN yum install -y make
#-----------------------------------------------#

#-------------- ENVIRONMENT VARIABLES --------------#
ENV container=docker

# Environment Variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-0.el7_5.x86_64
ENV PATH=$JAVA_HOME/bin:$PATH

# Environment Variables for Tomcat
ENV TOMCAT_CONF=/usr/share/tomcat/conf/tomcat.conf
ENV TOMCAT_USERS=/usr/share/tomcat/conf/tomcat-users.xml
ENV TOMCAT_JAVA_OPTS="\"-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC\""

# Used to start tomcat without systemctl
ENV TOMCAT_SERVICE=/usr/libexec/tomcat/server
ENV TOMCAT_SERVICE_INPUT=start
#---------------------------------------------------#

#-------------- JAVA INSTALL --------------#
RUN yum install -y java-1.8.0-openjdk-devel
#------------------------------------------#

#-------------- VIM INSTALL ---------------#
RUN yum install -y vim
#------------------------------------------#

#------------- TOMCAT INSTALL -------------#
# yum installs tomcat inside /usr/share/tomcat/
RUN yum install -y tomcat; \
    echo JAVA_OPTS=${TOMCAT_JAVA_OPTS} >> ${TOMCAT_CONF}

# Install admin packages, this adds some other directories
# inside the tomcat/webapps folder
RUN yum install -y tomcat-webapps tomcat-admin-webapps; \
    # Install documentations (optional)
    yum install -y tomcat-docs-webapp tomcat-javadoc; \
    sed -i '/<tomcat-users>/a \\t<user username="admin" password="password" roles="manager-gui,admin-gui"/>' ${TOMCAT_USERS}
#------------------------------------------#

#------------ MAVEN INSTALL ---------------#
RUN cd /usr/local/src; \
    wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz; \
    tar -xf apache-maven-3.5.4-bin.tar.gz; \
    mv apache-maven-3.5.4/ apache-maven; \
    rm -rf apache-maven-3.5.4-bin.tar.gz

# Might consider moving this to the top, or put these environment
# variables as export statements inside maven.sh and put maven.sh in
# /etc/profile.d
ENV M2_HOME=/apache-maven
ENV PATH=${M2_HOME}/bin:${PATH}

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/.mavenrc; \
    source /etc/.mavenrc
#------------------------------------------#