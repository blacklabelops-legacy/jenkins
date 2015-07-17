import jenkins.model.*

def pluginParameter="gitlab-plugin hipchat swarm"
def plugins = pluginParameter.split()
println(plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
def installed = false

plugins.each {
  if (!pm.getPlugin(it)) {
    def plugin = uc.getPlugin(it)
    if (plugin) {
      println("Installing " + it)
    	plugin.deploy()
      installed = true
    }
  }
}

instance.save()
if (installed)
instance.doSafeRestart()
