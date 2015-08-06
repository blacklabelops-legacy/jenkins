FROM blacklabelops/java-jdk-8:8.51.16
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>

# install dev tools
RUN yum install -y \
    git \
    unzip \
    zip && \
    yum clean all && rm -rf /var/cache/yum/*

# install jenkins
ENV JENKINS_VERSION=1.621
ENV JENKINS_HOME=/jenkins

RUN mkdir -p /opt/jenkins && \
    wget --directory-prefix=/opt/jenkins \
         http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war && \
    /usr/sbin/groupadd jenkins && \
    /usr/sbin/useradd -g jenkins --shell /bin/bash jenkins && \
    chown -R jenkins:jenkins /opt/jenkins && \
    touch /var/log/jenkins.log && \
    chown jenkins:jenkins /var/log/jenkins.log && \
    echo "export JENKINS_HOME='${JENKINS_HOME}'" >> /etc/profile

# env variables for the console or child containers to override
ENV JAVA_VM_PARAMETERS=-Xmx512m
ENV JENKINS_MASTER_EXECUTORS=
ENV JENKINS_SLAVEPORT=
ENV JENKINS_ADMIN_USER=
ENV JENKINS_ADMIN_PASSWORD=
ENV JENKINS_PLUGINS=swarm
ENV JENKINS_PARAMETERS=
# env variables for https
ENV JENKINS_KEYSTORE_PASSWORD=
ENV JENKINS_CERTIFICATE_DNAME=

WORKDIR /jenkins
VOLUME ["/jenkins"]
EXPOSE 8080

COPY imagescripts/docker-entrypoint.sh /opt/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/opt/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
