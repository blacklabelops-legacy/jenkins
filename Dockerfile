FROM blacklabelops/java-jdk-8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Propert permissions
ENV CONTAINER_USER jenkins
ENV CONTAINER_UID 1000
ENV CONTAINER_GROUP jenkins
ENV CONTAINER_GID 1000
ENV VOLUME_DIRECTORY=/jenkins

RUN /usr/sbin/groupadd --gid $CONTAINER_GID jenkins && \
    /usr/sbin/useradd --uid $CONTAINER_UID --gid $CONTAINER_GID --create-home --home-dir $VOLUME_DIRECTORY --shell /bin/bash jenkins

# install dev tools
RUN yum install -y \
    git \
    unzip \
    wget \
    zip && \
    yum clean all && rm -rf /var/cache/yum/*

# install jenkins
ENV JENKINS_VERSION=latest
ENV JENKINS_HOME=/jenkins

RUN mkdir -p /usr/bin/jenkins && \
    wget --directory-prefix=/usr/bin/jenkins \
         http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war && \
    chown -R $CONTAINER_UID:$CONTAINER_GID /usr/bin/jenkins && \
    chmod ug+x /usr/bin/jenkins/jenkins.war && \
    echo "export JENKINS_HOME='${JENKINS_HOME}'" >> /etc/profile

# env variables for the console or child containers to override
ENV JAVA_VM_PARAMETERS=-Xmx512m
ENV JENKINS_MASTER_EXECUTORS=
ENV JENKINS_SLAVEPORT=50000
ENV JENKINS_ADMIN_USER=
ENV JENKINS_ADMIN_PASSWORD=
ENV JENKINS_PLUGINS=swarm
ENV JENKINS_PARAMETERS=
# env variables for https
ENV JENKINS_KEYSTORE_PASSWORD=
ENV JENKINS_CERTIFICATE_DNAME=

WORKDIR $VOLUME_DIRECTORY
VOLUME ["${VOLUME_DIRECTORY}"]
EXPOSE 8080 50000

USER $CONTAINER_UID
COPY imagescripts/docker-entrypoint.sh /usr/bin/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
