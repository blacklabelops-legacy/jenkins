#!/bin/bash
#
# Initialization of Slave Port Number
#

if [ -n "${JENKINS_SLAVEPORT}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  cat > ${JENKINS_HOME}/init.groovy.d/setSlaveport.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def instance = Jenkins.getInstance()
def current_slaveport = instance.getSlaveAgentPort()
def defined_slaveport = ${JENKINS_SLAVEPORT}

if (current_slaveport!=defined_slaveport) {
  instance.setSlaveAgentPort(defined_slaveport)
  logger.info("Slaveport set to " + defined_slaveport)
  instance.save()
}
_EOF_
fi
