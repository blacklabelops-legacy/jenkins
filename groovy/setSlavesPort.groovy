import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def instance = Jenkins.getInstance()
def current_slaveport = instance.getSlaveAgentPort()
def defined_slaveport = 50000

if (current_slaveport!=defined_slaveport) {
instance.setSlaveAgentPort(defined_slaveport)
logger.info("Slaveport set to " + defined_slaveport)
}


instance.save()
