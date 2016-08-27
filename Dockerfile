FROM centos

# Environment
ENV BAMBOO_VERSION 5.12.4
ENV BAMBOO_HOME /data/bamboo

# Expose web and agent ports
EXPOSE 8085
EXPOSE 54663

# Make sure we get latest packages
RUN yum -y update

# Install Java and tools
RUN yum -y install wget && wget --progress=dot:mega --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm" -O jdk-8-linux-x64.rpm
RUN yum -y install jdk-8-linux-x64.rpm && rm -f jdk-8-linux-x64.rpm
RUN yum -y install git docker

# Install Bamboo
RUN echo "-> Installing Bamboo"
RUN mkdir -p $BAMBOO_HOME
RUN wget --progress=dot:mega http://downloads.atlassian.com/software/bamboo/downloads/atlassian-bamboo-$BAMBOO_VERSION.tar.gz -O /tmp/atlassian-bamboo.tar.gz

RUN echo "-> Extracting Installation"
RUN tar xzf /tmp/atlassian-bamboo.tar.gz -C /opt && rm -f /tmp/atlassian-bamboo.tar.gz
RUN ln -s /opt/atlassian-bamboo-$BAMBOO_VERSION /opt/bamboo
RUN echo "-> Installation completed"

# Clean up
RUN yum clean all

ENTRYPOINT [ "/opt/bamboo/bin/catalina.sh" ]
CMD [ "run" ]
