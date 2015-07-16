import jenkins.model.*

def instance = Jenkins.getInstance()

instance.setNumExecutors(0)

instance.save()
