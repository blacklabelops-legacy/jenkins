FROM blacklabelops/java-jdk-8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# env variables for the console or child containers to override
ENV JAVA_VM_PARAMETERS=-Xmx512m
ENV JENKINS_MASTER_EXECUTORS=
ENV JENKINS_SLAVEPORT=50000
ENV JENKINS_ADMIN_USER=
ENV JENKINS_ADMIN_PASSWORD=
ENV JENKINS_PLUGINS=swarm
ENV JENKINS_PARAMETERS=
ENV JENKINS_KEYSTORE_PASSWORD=
ENV JENKINS_CERTIFICATE_DNAME=
ENV JENKINS_ENV_FILE=
ENV JENKINS_HOME=/jenkins
ENV DELAYED_START=

RUN export CONTAINER_USER=jenkins && \
    export CONTAINER_UID=1000 && \
    export CONTAINER_GROUP=jenkins && \
    export CONTAINER_GID=1000 && \
    # Add user
    /usr/sbin/groupadd --gid $CONTAINER_GID jenkins && \
    /usr/sbin/useradd --uid $CONTAINER_UID --gid $CONTAINER_GID --create-home --shell /bin/bash jenkins && \
    # Install latest updates
    yum update -y && \
    # Install software
    yum install -y \
    git \
    unzip \
    wget \
    zip && \
    yum clean all && rm -rf /var/cache/yum/* && \
    # Install jenkins
    export JENKINS_VERSION=latest && \
    mkdir -p /usr/bin/jenkins && \
    wget --directory-prefix=/usr/bin/jenkins \
         http://mirrors.jenkins-ci.org/war/${JENKINS_VERSION}/jenkins.war && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP /usr/bin/jenkins && \
    chmod ug+x /usr/bin/jenkins/jenkins.war && \
    # Jenkins directory
    mkdir -p ${JENKINS_HOME} && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP ${JENKINS_HOME}

WORKDIR /jenkins
VOLUME ["/jenkins"]
EXPOSE 8080 50000

USER jenkins
COPY imagescripts/docker-entrypoint.sh /home/jenkins/docker-entrypoint.sh
ENTRYPOINT ["/home/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
