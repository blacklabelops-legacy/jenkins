import jenkins.model.*
import java.util.logging.Logger

def instance = Jenkins.getInstance()

def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setAdminAddress("Blacklabelops <blacklabelops@itbleul.de>")
jenkinsLocationConfiguration.save()

instance.save()
