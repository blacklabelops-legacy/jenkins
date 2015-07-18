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
jenkins_plugins=""

if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
  mkdir ${JENKINS_HOME}/init.groovy.d
fi

if [ -n "${JAVA_VM_PARAMETERS}" ]; then
  java_vm_parameters=${JAVA_VM_PARAMETERS}
fi

if [ -n "${JENKINS_PARAMETERS}" ]; then
  jenkins_parameters=${JENKINS_PARAMETERS}
fi

if [ -n "${JENKINS_MASTER_EXECUTORS}" ]; then
  cat > ${JENKINS_HOME}/init.groovy.d/setExecutors.groovy <<_EOF_
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
instance.setNumExecutors(${JENKINS_MASTER_EXECUTORS})
instance.save()
_EOF_
  cat ${JENKINS_HOME}/init.groovy.d/setExecutors.groovy
fi

if [ -n "${JENKINS_SLAVEPORT}" ]; then
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
instance.doSafeRestart()
}
_EOF_
  cat ${JENKINS_HOME}/init.groovy.d/setSlaveport.groovy
fi

if [ -n "${JENKINS_ADMIN_USER}" ] && [ -n "${JENKINS_ADMIN_PASSWORD}" ]; then
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
  cat ${JENKINS_HOME}/init.groovy.d/initAdmin.groovy
fi

if [ -n "${JENKINS_PLUGINS}" ]; then
  jenkins_plugins=${JENKINS_PLUGINS}
fi

cat > ${JENKINS_HOME}/init.groovy.d/loadPlugins.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false
def initialized = false

def pluginParameter="${jenkins_plugins}"
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
uc.updateAllSites()

plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
      logger.info("Installing " + it)
    	plugin.deploy()
      installed = true
    }
  }
}

if (installed) {
  logger.info("Plugins installed, initializing a restart!")
  instance.save()
  instance.doSafeRestart()
}
_EOF_
cat ${JENKINS_HOME}/init.groovy.d/loadPlugins.groovy

chown -R jenkins:jenkins ${JENKINS_HOME}

if [ "$1" = 'jenkins' ]; then
  jenkins_command='java '${java_vm_parameters}' -jar /opt/jenkins/jenkins.war '${jenkins_parameters} 2>&1
  runuser -l jenkins -c "${jenkins_command}"
fi

exec "$@"
