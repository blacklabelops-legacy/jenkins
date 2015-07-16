import jenkins.model.*

def instance = Jenkins.getInstance()
if (instance.getSlaveAgentPort()==-1) {
instance.setSlaveAgentPort(50000)
println "Slaveport set!"
}


instance.save()
