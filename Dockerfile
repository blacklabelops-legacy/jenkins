FROM blacklabelops/java:server-jre.8

# Build time arguments
# Values: latest or version number
ARG JENKINS_VERSION=latest
ARG JENKINS_HASH=
# Cli installation details
ARG JENKINS_CLI_VERSION=2.121.3
ARG JENKINS_CLI_HASH=
# Values: war or war-stable
ARG JENKINS_RELEASE=war
# Permissions, set the linux user id and group id
ARG CONTAINER_UID=1000
ARG CONTAINER_GID=1000

# Container Environment Variables
ENV JENKINS_HOME=/jenkins

RUN export CONTAINER_USER=jenkins && \
    export CONTAINER_GROUP=jenkins && \
    # Add User
    addgroup -g $CONTAINER_GID jenkins && \
    adduser -u $CONTAINER_UID -G jenkins -h /home/jenkins -s /bin/bash -S jenkins && \
    # Install Software
    apk add --update \
      git \
      wget && \
    # Install Jenkins
    mkdir -p /usr/bin/jenkins && \
    wget --directory-prefix=/usr/bin/jenkins \
         http://mirrors.jenkins-ci.org/${JENKINS_RELEASE}/${JENKINS_VERSION}/jenkins.war && \
    JENKINS_HASH=$(sha1sum /usr/bin/jenkins/jenkins.war) && \
    echo 'Calculated checksum: '$JENKINS_HASH && \
    touch /usr/bin/jenkins-cli && \
    touch /usr/bin/cli && \
    # Install Jenkins cli
    wget --directory-prefix=/usr/bin/jenkins \
        http://repo.jenkins-ci.org/public/org/jenkins-ci/main/cli/${JENKINS_CLI_VERSION}/cli-${JENKINS_CLI_VERSION}-jar-with-dependencies.jar && \
    mv /usr/bin/jenkins/cli-${JENKINS_CLI_VERSION}-jar-with-dependencies.jar /usr/bin/jenkins/cli.jar && \
    JENKINS_CLI_HASH=$(sha1sum /usr/bin/jenkins/cli.jar) && \
    echo 'Calculated checksum: '$JENKINS_CLI_HASH && \
    # Jenkins permissions
    chown -R $CONTAINER_USER:$CONTAINER_GROUP /usr/bin/jenkins /usr/bin/jenkins-cli /usr/bin/cli && \
    chmod ug+x /usr/bin/jenkins/jenkins.war /usr/bin/jenkins/cli.jar /usr/bin/jenkins-cli /usr/bin/cli && \
    # Jenkins directory
    mkdir -p ${JENKINS_HOME} && \
    chown -R $CONTAINER_USER:$CONTAINER_GROUP ${JENKINS_HOME} && \
    # Adding letsencrypt-ca to truststore
    export KEYSTORE=$JAVA_HOME/jre/lib/security/cacerts && \
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
    keytool -trustcacerts -keystore $KEYSTORE -storepass changeit -noprompt -importcert -alias letsencryptauthorityx4 -file /tmp/lets-encrypt-x4-cross-signed.der && \
    # Remove obsolete packages and cleanup
    apk del wget && \
    rm -rf /var/cache/apk/* && rm -rf /var/log/* && rm -rf /tmp/*

LABEL com.blacklabelops.application.jenkins.version=$JENKINS_VERSION-$JENKINS_RELEASE \
      com.blacklabelops.application.jenkins.hash=$JENKINS_HASH \
      com.blacklabelops.application.jenkins.hashtype=sha1sum \
      com.blacklabelops.application.jenkins.userid=$CONTAINER_UID \
      com.blacklabelops.application.jenkins.groupid=$CONTAINER_GID \
      com.blacklabelops.application.jenkinscli.version=$JENKINS_CLI_VERSION \
      com.blacklabelops.application.jenkinscli.hash=$JENKINS_CLI_HASH \
      com.blacklabelops.application.jenkinscli.hashtype=sha1sum

# Entrypoint Environment Variables
ENV JAVA_VM_PARAMETERS=-Xmx512m \
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

USER jenkins
COPY imagescripts/ /home/jenkins
ENTRYPOINT ["/sbin/tini","--","/home/jenkins/docker-entrypoint.sh"]
CMD ["jenkins"]
