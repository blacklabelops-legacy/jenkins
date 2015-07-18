FROM blacklabelops/centos:7.1
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# install dev tools
RUN yum install -y \
    git \
    tar \
    wget \
    unzip \
    zip && \
    yum clean all && rm -rf /var/cache/yum/*

# this envs are for maintaining java updates.
ENV JAVA_MAJOR_VERSION=8
ENV JAVA_UPDATE_VERSION=51
ENV JAVA_BUILD_NUMER=16
# install java
ENV JAVA_VERSION=1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV JAVA_TARBALL=server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz
ENV JAVA_HOME=/opt/java/jdk${JAVA_VERSION}

RUN wget --no-check-certificate --directory-prefix=/tmp \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMER}/${JAVA_TARBALL} && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/${JAVA_TARBALL} -C /opt/java/ && \
    alternatives --install /usr/bin/java java /opt/java/jdk${JAVA_VERSION}/bin/java 100 && \
    rm -rf /tmp/* && rm -rf /var/log/*

# install jenkins
ENV JENKINS_VERSION=1.620
ENV JENKINS_HOME=/jenkins

RUN mkdir -p /opt/jenkins && \
    wget --directory-prefix=/opt/jenkins \
         http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war && \
    /usr/sbin/groupadd jenkins && \
    /usr/sbin/useradd -g jenkins --shell /bin/bash jenkins && \
    chown -R jenkins:jenkins /opt/jenkins && \
    echo "export JENKINS_HOME='${JENKINS_HOME}'" >> /etc/profile

# env variables for the console or child containers to override
ENV JAVA_VM_PARAMETERS=-Xmx512m
ENV JENKINS_MASTER_EXECUTORS=
ENV JENKINS_SLAVEPORT=
ENV JENKINS_ADMIN_USER=
ENV JENKINS_ADMIN_PASSWORD=
ENV JENKINS_PLUGINS=swarm

WORKDIR /jenkins
VOLUME ["/jenkins"]
EXPOSE 8080

COPY imagescripts/docker-entrypoint.sh /opt/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/opt/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
