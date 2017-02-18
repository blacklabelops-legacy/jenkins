#!/bin/bash
#
# Initialization of Admin User
#

if [ -n "${JENKINS_ADMIN_USER}" ] && [ -n "${JENKINS_ADMIN_PASSWORD}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  cat > ${JENKINS_HOME}/init.groovy.d/initAdmin.groovy <<_EOF_
import jenkins.model.*
import hudson.security.*
def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def users = hudsonRealm.getAllUsers()
if (!users || users.empty) {
hudsonRealm.createAccount("${JENKINS_ADMIN_USER}", "${JENKINS_ADMIN_PASSWORD}")
instance.setSecurityRealm(hudsonRealm)
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "${JENKINS_ADMIN_USER}")
instance.setAuthorizationStrategy(strategy)
}
instance.save()
_EOF_
fi
