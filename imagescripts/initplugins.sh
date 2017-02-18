#!/bin/bash
#
# Initialization of Plugins
#

jenkins_plugins=""

DEFAULT_PLUGINS="docker-workflow ant build-timeout credentials-binding email-ext github-organization-folder gradle workflow-aggregator ssh-slaves subversion timestamper ws-cleanup"

if [ ! -n "${JENKINS_PLUGINS}" ]; then
  JENKINS_PLUGINS=$JENKINS_PLUGINS" "$DEFAULT_PLUGINS
else
  JENKINS_PLUGINS=$DEFAULT_PLUGINS
fi

if [ -n "${JENKINS_PLUGINS}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  jenkins_plugins=${JENKINS_PLUGINS}
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
    	def installFuture = plugin.deploy()
      while(!installFuture.isDone()) {
        logger.info("Waiting for plugin install: " + it)
        sleep(3000)
      }
      installed = true
    }
  }
}
if (installed) {
  logger.info("Plugins installed, initializing a restart!")
  instance.save()
  instance.restart()
}
_EOF_
fi
