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

smtp_replyto_address="dummy@example.com"
smtp_use_ssl="true"
smtp_charset="UTF-8"

if [ -n "${SMTP_REPLYTO_ADDRESS}" ]; then
  smtp_replyto_address=${SMTP_REPLYTO_ADDRESS}
fi

if [ -n "${SMTP_USE_SSL}" ]; then
  smtp_use_ssl=${SMTP_USE_SSL}
fi

if [ -n "${SMTP_CHARSET}" ]; then
  smtp_charset=${SMTP_CHARSET}
fi

if [ -n "${SMTP_USER_NAME}" ] && [ -n "${SMTP_USER_PASS}" ] && [ -n "${SMTP_HOST}" ] && [ -n "${SMTP_PORT}" ]; then
  smtp_user_name=${SMTP_USER_NAME}
  smtp_user_pass=${SMTP_USER_PASS}
  smtp_host=${SMTP_HOST}
  smtp_port=${SMTP_PORT}

  cat > ${JENKINS_HOME}/init.groovy.d/initSMTP.groovy <<_EOF_
import jenkins.model.*

def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Mailer")

desc.setSmtpAuth("${smtp_user_name}", "${smtp_user_pass}")
desc.setReplyToAddress("${smtp_replyto_address}")
desc.setSmtpHost("${smtp_host}")
desc.setUseSsl(${smtp_use_ssl})
desc.setSmtpPort("${smtp_port}")
desc.setCharset("${smtp_charset}")

desc.save()
inst.save()
_EOF_
  cat ${JENKINS_HOME}/init.groovy.d/initSMTP.groovy
fi

if [ -n "${JENKINS_ADMIN_EMAIL}" ]; then
  cat > ${JENKINS_HOME}/init.groovy.d/initAdminEMail.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger

def instance = Jenkins.getInstance()
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setAdminAddress("${JENKINS_ADMIN_EMAIL}")

jenkinsLocationConfiguration.save()
instance.save()
_EOF_
  cat ${JENKINS_HOME}/init.groovy.d/initAdminEMail.groovy
fi

if [ -n "${JENKINS_KEYSTORE_PASSWORD}" ] && [ -n "${JENKINS_CERTIFICATE_DNAME}" ]; then
  if [ ! -f "${JENKINS_HOME}/jenkins_keystore.jks" ]; then
    ${JAVA_HOME}/bin/keytool -genkey -alias jenkins_master -keyalg RSA -keystore ${JENKINS_HOME}/jenkins_keystore.jks -storepass ${JENKINS_KEYSTORE_PASSWORD} -keypass ${JENKINS_KEYSTORE_PASSWORD} --dname "${JENKINS_CERTIFICATE_DNAME}"
    chown jenkins:jenkins ${JENKINS_HOME}/jenkins_keystore.jks
  fi
  jenkins_parameters=${jenkins_parameters}' --httpPort=-1 --httpsPort=8080 --httpsKeyStore='${JENKINS_HOME}'/jenkins_keystore.jks --httpsKeyStorePassword='${JENKINS_KEYSTORE_PASSWORD}
fi

chown -R jenkins:jenkins ${JENKINS_HOME}

log_parameter=""

if [ -n "${LOG_FILE}" ]; then
  log_dir=$(dirname ${LOG_FILE})
  log_file=$(basename ${LOG_FILE})
  if [ ! -d "${log_dir}" ]; then
    mkdir -p ${log_dir}
    chown jenkins:jenkins ${log_dir}
  fi
  if [ ! -f "${LOG_FILE}" ]; then
    touch ${LOG_FILE}
    chown jenkins:jenkins ${LOG_FILE}
  fi
  log_parameter=" --logfile="${LOG_FILE}
fi

if [ "$1" = 'jenkins' ]; then
  size=$((100*1024*1024))
  jenkins_command='java -Dfile.encoding=UTF-8 '${java_vm_parameters}' -jar /opt/jenkins/jenkins.war '${jenkins_parameters}${log_parameter}''
  runuser -l jenkins -c "${jenkins_command}"
fi

exec "$@"
