import jenkins.model.*

def pluginParameter="gitlab-plugin hipchat swarm"
def plugins = pluginParameter.split()
println(plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

plugins.each {
  if (!pm.getPlugin(it)) {
    def plugin = uc.getPlugin(it)
    if (plugin) {
      println("Installing " + it)
    	plugin.deploy()
    }
  }
}


instance.save()
instance.doSafeRestart()
