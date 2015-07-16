#!/bin/bash -x
#
# A helper script for ENTRYPOINT.
#
# If first CMD argument is 'jenkins', then the script will bootrstrap Jenkins
# on port 8090 and log stdout and stderr in /var/log/jenkins.log
# If CMD argument is overriden and not 'jenkins', then the user wants to run
# his own process.

set -e

java_vm_parameters=""
jenkins_parameters=""

chown -R jenkins:jenkins ${JENKINS_HOME}

if [ -n "${JAVA_VM_PARAMETERS}" ]; then
  java_vm_parameters=${JAVA_VM_PARAMETERS}
fi

if [ -n "${JENKINS_PARAMETERS}" ]; then
  jenkins_parameters=${JENKINS_PARAMETERS}
fi

if [ -n "${JENKINS_ADMIN_USER}" ] && [ -n "${JENKINS_ADMIN_PASSWORD}" ]; then
  cat > ${JENKINS_HOME}/init.groovy <<_EOF_
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
createAccount("${JENKINS_ADMIN_USER}", "${JENKINS_ADMIN_PASSWORD}")
instance.setSecurityRealm(hudsonRealm)

def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "${JENKINS_ADMIN_USER}")
instance.setAuthorizationStrategy(strategy)

instance.save()
_EOF_
  cat ${JENKINS_HOME}/init.groovy
fi


if [ "$1" = 'jenkins' ]; then
  runuser -l jenkins -c 'java '${java_vm_parameters}' -jar /opt/jenkins/jenkins.war '${jenkins_parameters}' 2>&1'
fi

exec "$@"
