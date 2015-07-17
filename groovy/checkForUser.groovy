import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def users = hudsonRealm.	getAllUsers()
if (!users || users.empty)
println "No Users"
else
println "Admin found"

instance.save()
