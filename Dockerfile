FROM blacklabelops/centos
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# install dev tools
RUN yum install -y \
    git \
    tar \
    wget \
    zip && \
    yum clean all && rm -rf /var/cache/yum/*

# install java
ENV JAVA_VERSION=1.8.0_45
ENV JAVA_TARBALL=server-jre-8u45-linux-x64.tar.gz
ENV JAVA_HOME=/opt/java/jdk${JAVA_VERSION}

RUN wget --no-check-certificate --directory-prefix=/tmp \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/8u45-b14/${JAVA_TARBALL} && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/${JAVA_TARBALL} -C /opt/java/ && \
    alternatives --install /usr/bin/java java /opt/java/jdk${JAVA_VERSION}/bin/java 100 && \
    rm -rf /tmp/* && rm -rf /var/log/*

# install jenkins
ENV JENKINS_VERSION=latest
ENV JENKINS_HOME=/jenkins

RUN mkdir -p /opt/jenkins && \
    wget --directory-prefix=/opt/jenkins \
         http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war && \
    chmod 644 /opt/jenkins/jenkins.war

# forward jenkins log to docker log collector
RUN ln -sf /dev/stdout /var/log/jenkins.log

VOLUME ["/jenkins"]
EXPOSE 8090

COPY imagescripts/docker-entrypoint.sh /opt/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/opt/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
