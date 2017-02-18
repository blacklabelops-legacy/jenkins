FROM blacklabelops/java:server-jre.8

# Build time arguments
# Values: latest or version number
ARG JENKINS_VERSION=latest
ARG JENKINS_HASH=
# Cli installation details
ARG JENKINS_CLI_VERSION=2.32.2
ARG JENKINS_CLI_HASH=
# Values: war or war-stable
ARG JENKINS_RELEASE=war
# Permissions, set the linux user id and group id
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000
# Image Build Date By Buildsystem
ARG BUILD_DATE=undefined

# Container Environment Variables
ENV JENKINS_HOME=/jenkins \
    BLACKLABELOPS_JENKINS_HOME=/opt/jenkins \
    CONTAINER_USER=jenkins \
    CONTAINER_GROUP=jenkins

# Add User
RUN addgroup -g $CONTAINER_GID jenkins && \
    adduser -u $CONTAINER_UID -G jenkins -h /opt/jenkins -s /bin/bash -S jenkins

# Install Jenkins
RUN apk add --update \
      git \
      wget && \
    mkdir -p /usr/bin/jenkins && \
    wget --directory-prefix=/usr/bin/jenkins \
         http://mirrors.jenkins-ci.org/${JENKINS_RELEASE}/${JENKINS_VERSION}/jenkins.war && \
    JENKINS_HASH=$(sha1sum /usr/bin/jenkins/jenkins.war) && \
    echo 'Calculated checksum: '$JENKINS_HASH && \
    # Install Jenkins cli
    wget --directory-prefix=/usr/bin/jenkins \
        http://repo.jenkins-ci.org/public/org/jenkins-ci/main/cli/${JENKINS_CLI_VERSION}/cli-${JENKINS_CLI_VERSION}-jar-with-dependencies.jar && \
    mv /usr/bin/jenkins/cli-${JENKINS_CLI_VERSION}-jar-with-dependencies.jar /usr/bin/jenkins/cli.jar && \
    JENKINS_CLI_HASH=$(sha1sum /usr/bin/jenkins/cli.jar) && \
    echo 'Calculated checksum: '$JENKINS_CLI_HASH && \
    # Jenkins Permissions
    chown -R $CONTAINER_USER:$CONTAINER_GROUP /usr/bin/jenkins && \
    chmod ug+x /usr/bin/jenkins/jenkins.war && \
    # Jenkins Directory
    mkdir -p ${JENKINS_HOME} && \
    mkdir -p ${BLACKLABELOPS_JENKINS_HOME} && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP ${JENKINS_HOME} ${BLACKLABELOPS_JENKINS_HOME}

# Install Jenkins cli
RUN touch /usr/bin/jenkins-cli && \
    touch /usr/bin/cli && \
    # Jenkins Permissions
    chown -R $CONTAINER_USER:$CONTAINER_GROUP /usr/bin/jenkins-cli /usr/bin/cli && \
    chmod ug+x /usr/bin/jenkins/cli.jar /usr/bin/jenkins-cli /usr/bin/cli

# Adding Letsencrypt-CA To Truststore
RUN export KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts && \
    wget -P /tmp/ https://letsencrypt.org/certs/letsencryptauthorityx1.der && \
    wget -P /tmp/ https://letsencrypt.org/certs/letsencryptauthorityx2.der && \
    wget -P /tmp/ https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.der && \
    wget -P /tmp/ https://letsencrypt.org/certs/lets-encrypt-x2-cross-signed.der && \
    wget -P /tmp/ https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.der && \
    wget -P /tmp/ https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias isrgrootx1 -file /tmp/letsencryptauthorityx1.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias isrgrootx2 -file /tmp/letsencryptauthorityx2.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx1 -file /tmp/lets-encrypt-x1-cross-signed.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx2 -file /tmp/lets-encrypt-x2-cross-signed.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx3 -file /tmp/lets-encrypt-x3-cross-signed.der && \
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx4 -file /tmp/lets-encrypt-x4-cross-signed.der

# Cleanup
RUN apk del wget && \
    rm -rf /var/cache/apk/* && rm -rf /var/log/* && rm -rf /tmp/*

# Image Metadata
LABEL com.blacklabelops.application.jenkins.version=$JENKINS_VERSION-$JENKINS_RELEASE \
      com.blacklabelops.application.jenkins.hash=$JENKINS_HASH \
      com.blacklabelops.application.jenkins.hashtype=sha1sum \
      com.blacklabelops.application.jenkins.userid=$CONTAINER_UID \
      com.blacklabelops.application.jenkins.groupid=$CONTAINER_GID \
      com.blacklabelops.application.jenkinscli.version=$JENKINS_CLI_VERSION \
      com.blacklabelops.application.jenkinscli.hash=$JENKINS_CLI_HASH \
      com.blacklabelops.application.jenkinscli.hashtype=sha1sum \
      com.blacklabelops.image.builddate.jenkins=${BUILD_DATE}

# Entrypoint Environment Variables
ENV JAVA_VM_PARAMETERS="-Xmx512m -XX:ParallelGCThreads=4 -XX:ConcGCThreads=4 -Dhudson.slaves.ChannelPinger.pingIntervalSeconds=-1 -Dhudson.security.ExtendedReadPermission=true -Dgroovy.use.classvalue=true" \
    JENKINS_PRODUCTION_SETTINGS=false \
    JENKINS_MASTER_EXECUTORS= \
    JENKINS_SLAVEPORT=50000 \
    JENKINS_PLUGINS= \
    JENKINS_PARAMETERS= \
    JENKINS_KEYSTORE_PASSWORD= \
    JENKINS_CERTIFICATE_DNAME= \
    JENKINS_ENV_FILE= \
    JENKINS_DELAYED_START= \
    JENKINS_CLI_URL=http://localhost:8080 \
    JENKINS_CLI_SSH=

WORKDIR ${JENKINS_HOME}
VOLUME ["${JENKINS_HOME}"]
EXPOSE 8080 50000
COPY imagescripts/ ${BLACKLABELOPS_JENKINS_HOME}
USER jenkins
ENTRYPOINT ["/sbin/tini","--","/opt/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
