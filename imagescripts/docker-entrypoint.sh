#!/bin/bash -x
#
# A helper script for ENTRYPOINT.
#
# If first CMD argument is 'jenkins', then the script will bootrstrap Jenkins
# on port 8090 and log stdout and stderr in /var/log/jenkins.log
# If CMD argument is overriden and not 'jenkins', then the user wants to run
# his own process.

set -e

SECURITY_OPTS=""

if [ -n "${JENKINS_ADMIN_USER}" ] && [ -n "${JENKINS_ADMIN_PASSWORD}" ]; then
    SECURITY_OPTS="--argumentsRealm.passwd.${JENKINS_ADMIN_USER}=${JENKINS_ADMIN_PASSWORD} --argumentsRealm.roles.${JENKINS_ADMIN_USER}=admin"
fi

if [ "$1" = 'jenkins' ]; then
  exec java -jar /opt/jenkins/jenkins.war ${SECURITY_OPTS} --httpPort=8090  "$@" > /var/log/jenkins.log 2>&1
fi

exec "$@"
