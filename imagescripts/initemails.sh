#!/bin/bash
#
# Initialization of EMail Settings
#

smtp_replyto_address="dummy@example.com"
smtp_use_ssl="true"
smtp_charset="UTF-8"

if [ -n "${SMTP_REPLYTO_ADDRESS}" ]; then
  smtp_replyto_address=${SMTP_REPLYTO_ADDRESS}
fi

if [ -n "${SMTP_USE_SSL}" ]; then
  smtp_use_ssl=${SMTP_USE_SSL}
fi

if [ -n "${SMTP_CHARSET}" ]; then
  smtp_charset=${SMTP_CHARSET}
fi

if [ -n "${SMTP_USER_NAME}" ] && [ -n "${SMTP_USER_PASS}" ] && [ -n "${SMTP_HOST}" ] && [ -n "${SMTP_PORT}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  smtp_user_name=${SMTP_USER_NAME}
  smtp_user_pass=${SMTP_USER_PASS}
  smtp_host=${SMTP_HOST}
  smtp_port=${SMTP_PORT}

  cat > ${JENKINS_HOME}/init.groovy.d/initSMTP.groovy <<_EOF_
import jenkins.model.*

def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Mailer")

desc.setSmtpAuth("${smtp_user_name}", "${smtp_user_pass}")
desc.setReplyToAddress("${smtp_replyto_address}")
desc.setSmtpHost("${smtp_host}")
desc.setUseSsl(${smtp_use_ssl})
desc.setSmtpPort("${smtp_port}")
desc.setCharset("${smtp_charset}")

desc.save()
inst.save()
_EOF_
fi

if [ -n "${JENKINS_ADMIN_EMAIL}" ]; then
  if [ ! -d "${JENKINS_HOME}/init.groovy.d" ]; then
    mkdir ${JENKINS_HOME}/init.groovy.d
  fi
  cat > ${JENKINS_HOME}/init.groovy.d/initAdminEMail.groovy <<_EOF_
import jenkins.model.*
import java.util.logging.Logger

def instance = Jenkins.getInstance()
def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setAdminAddress("${JENKINS_ADMIN_EMAIL}")

jenkinsLocationConfiguration.save()
instance.save()
_EOF_
fi
