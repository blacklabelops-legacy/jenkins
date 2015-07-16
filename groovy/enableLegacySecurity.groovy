import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new LegacySecurityRealm()
instance.setSecurityRealm(hudsonRealm)

def strategy = new LegacyAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

instance.save()
