#!/bin/bash
#
# Creation of cli scripts
#

PARAMETER_TOKEN='"$@"'
ENVIRONMENT_VARIABLE_TOKEN='${JENKINS_CLI_URL}'
ENVIRONMENT_VARIABLE_SSH_TOKEN='${JENKINS_CLI_SSH}'

cat > /usr/bin/jenkins-cli <<_EOF_
#!/bin/bash
java -jar /usr/bin/jenkins/cli.jar ${PARAMETER_TOKEN}
_EOF_

cat > /usr/bin/cli <<_EOF_
#!/bin/bash
if [ -n "${ENVIRONMENT_VARIABLE_SSH_TOKEN}" ]; then
  java -jar /usr/bin/jenkins/cli.jar -s ${ENVIRONMENT_VARIABLE_TOKEN} -i ${ENVIRONMENT_VARIABLE_SSH_TOKEN} ${PARAMETER_TOKEN}
else
  java -jar /usr/bin/jenkins/cli.jar -s ${ENVIRONMENT_VARIABLE_TOKEN} ${PARAMETER_TOKEN}
fi
_EOF_
