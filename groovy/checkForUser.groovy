import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def adminusr = hudsonRealm.	getAllUsers()
if (!emptyList || emptyList.empty)
println "No Users"
else
println "Admin found"

instance.save()
