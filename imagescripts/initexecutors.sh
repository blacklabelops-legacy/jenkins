#!/bin/bash
#
# Initialization of Number of Executors
#

if [ -n "${JENKINS_MASTER_EXECUTORS}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  cat > ${JENKINS_HOME}/init.groovy.d/setExecutors.groovy <<_EOF_
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
instance.setNumExecutors(${JENKINS_MASTER_EXECUTORS})
instance.save()
_EOF_
fi
