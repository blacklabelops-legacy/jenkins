import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def installed = false
def initialized = false

def pluginParameter="amazon-ecs amazon-ecr awseb-deployment-plugin"
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()

plugins.each {
  logger.info("Checking " + it)
  def actPlugin = pm.getPlugin(it)
  if (!actPlugin) {
    logger.info("Plugin not found " + it)
  } else {
    actPlugin.disable()
  }
}
