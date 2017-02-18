#!/bin/bash
#
# Initialization of Default Security Settings
#

if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
  mkdir ${JENKINS_HOME}/init.groovy.d
fi

cat > ${JENKINS_HOME}/init.groovy.d/securitySettings.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger
def logger = Logger.getLogger("")
logger.info("Security Settings")
// SECURITY-170
System.setProperty('hudson.model.ParametersAction.keepUndefinedParameters', 'true')
// SECURITY-95
System.setProperty('hudson.model.DirectoryBrowserSupport.CSP', '')
_EOF_
