import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("jenkins", "swordfish")
instance.setSecurityRealm(hudsonRealm)

def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "jenkins")
instance.setAuthorizationStrategy(strategy)

instance.save()
