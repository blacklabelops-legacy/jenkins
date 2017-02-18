#!/bin/bash
#
# A helper script for ENTRYPOINT.
#
# If first CMD argument is 'jenkins', then the script will bootstrap Jenkins
# If CMD argument is overriden and not 'jenkins', then the user wants to run
# his own process.

set -o errexit

readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

source $CUR_DIR/clicreation.sh

if [ "$1" = 'jenkins' ]; then

  if [ -n "${JENKINS_DELAYED_START}" ]; then
    sleep ${JENKINS_DELAYED_START}
  fi

  if [ -n "${JENKINS_ENV_FILE}" ]; then
    source ${JENKINS_ENV_FILE}
  fi

  java_vm_parameters=""
  jenkins_parameters=""

  if [ -n "${JAVA_VM_PARAMETERS}" ]; then
    java_vm_parameters=${JAVA_VM_PARAMETERS}
  fi

  if [ -n "${JENKINS_PARAMETERS}" ]; then
    jenkins_parameters=${JENKINS_PARAMETERS}
  fi

  source $CUR_DIR/initexecutors.sh
  source $CUR_DIR/initslaveport.sh
  source $CUR_DIR/initplugins.sh
  source $CUR_DIR/initemails.sh
  source $CUR_DIR/initadmin.sh

  if [ -n "${JENKINS_KEYSTORE_PASSWORD}" ] && [ -n "${JENKINS_CERTIFICATE_DNAME}" ]; then
    if [ ! -f "${JENKINS_HOME}/jenkins_keystore.jks" ]; then
      ${JAVA_HOME}/bin/keytool -genkey -alias jenkins_master -keyalg RSA -keystore ${JENKINS_HOME}/jenkins_keystore.jks -storepass ${JENKINS_KEYSTORE_PASSWORD} -keypass ${JENKINS_KEYSTORE_PASSWORD} --dname "${JENKINS_CERTIFICATE_DNAME}"
    fi
    jenkins_parameters=${jenkins_parameters}' --httpPort=-1 --httpsPort=8080 --httpsKeyStore='${JENKINS_HOME}'/jenkins_keystore.jks --httpsKeyStorePassword='${JENKINS_KEYSTORE_PASSWORD}
  fi

  log_parameter=""

  if [ -n "${JENKINS_LOG_FILE}" ]; then
    log_dir=$(dirname ${JENKINS_LOG_FILE})
    log_file=$(basename ${JENKINS_LOG_FILE})
    if [ ! -d "${log_dir}" ]; then
      mkdir -p ${log_dir}
    fi
    if [ ! -f "${JENKINS_LOG_FILE}" ]; then
      touch ${JENKINS_LOG_FILE}
    fi
    log_parameter=" --logfile="${JENKINS_LOG_FILE}
  fi

  unset JENKINS_ADMIN_USER
  unset JENKINS_ADMIN_PASSWORD
  unset JENKINS_KEYSTORE_PASSWORD
  unset SMTP_USER_NAME
  unset SMTP_USER_PASS

  # Start jenkins
  exec /usr/bin/java -Dfile.encoding=UTF-8 -Djenkins.install.runSetupWizard=false ${java_vm_parameters} -jar /usr/bin/jenkins/jenkins.war ${jenkins_parameters}${log_parameter}
elif [[ "$1" == '--'* ]]; then
  # Run Jenkins with passed parameters.
  exec /usr/bin/java -Dfile.encoding=UTF-8 -Djenkins.install.runSetupWizard=false ${java_vm_parameters} -jar /usr/bin/jenkins/jenkins.war "$@"
else
  exec "$@"
fi
