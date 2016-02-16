# Hiding Security Credentials

Hiding Environment Variables! This container can initialize with environment variables from a file.

* If you prefer specifying your default password inside a file rather then inside your docker-compose file.
* This way the password is also hidden from docker and the command **docker inspect**.
* You can reconfigure the container without removing the container.

The environment variable JENKINS_ENV_FILE tells the entryscript where to find the environment variables.

Example:

~~~~
$ docker run --name jenkins \
	-e "JENKINS_ENV_FILE=/home/jenkins/envs/myenvs.env" \
	-v $(pwd)/myenvs.env:/home/jenkins/envs/myenvs.env \
	-p 8080:8080 \
	blacklabelops/jenkins
~~~~

> Mounts the local environment variable file myenvs.env inside the container. (file must have access rights for userid:groupid 1000:1000)

How do you get the file inside the container?

* Use the command **docker cp** in order to copy the file inside an already initialized container.
* Extend the container with a new Dockerfile. Example can be found here: [Example-Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/examples/extension/Dockerfile)
* Put the file inside a data-container and mount it with the **--volumes-from** directive.

## Example Extension Dockerfile

~~~~
FROM blacklabelops/jenkins
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

ADD jenkins-master-security.env /home/jenkins/jenkinssettings
ENV JENKINS_ENV_FILE=/home/jenkins/jenkinssettings
~~~~

## Example Environment File

~~~~
# Setting up the admin account and basic security
JENKINS_ADMIN_USER="jenkins"
JENKINS_ADMIN_PASSWORD="swordfish"
# Specify the Java VM parameters
# See: http://www.oracle.com/technetwork/articles/java/vmoptions-jsp-140102.html
JAVA_VM_PARAMETERS="-Xmx1024m -Xms512m"
# Number of executors on Jenkins master.
JENKINS_MASTER_EXECUTORS="0"
# Whitespace separated list of required plugins.
# Example: gitlab-plugin hipchat swarm
JENKINS_PLUGINS="swarm git"
# Parameters for setting up HTTP.
# Example:
# JENKINS_KEYSTORE_PASSWORD=swordfish
# JENKINS_CERTIFICATE_DNAME=CN=SBleul,OU=Blacklabelops,O=blacklabelops.com,L=Munich,S=Bavaria,C=D
JENKINS_KEYSTORE_PASSWORD="keystoreswordfish"
JENKINS_CERTIFICATE_DNAME="CN=SBleul,OU=Blacklabelops,O=blacklabelops.net,L=Munich,S=Bavaria,C=DE"
# Jenkins port for accepting swarm slave connections
JENKINS_SLAVEPORT="50000"
# Jenkins startup parameters.
# See: https://wiki.jenkins-ci.org/display/JENKINS/Starting+and+Accessing+Jenkins
JENKINS_PARAMETERS=""
# Jenkins Mail Setup
SMTP_USER_NAME=""
SMTP_USER_PASS=""
SMTP_HOST=""
SMTP_PORT=""
SMTP_REPLYTO_ADDRESS=""
SMTP_USE_SSL=""
SMTP_CHARSET=""
# Jenkins log file. Not necessary, because Jenkins logs to Docker.
JENKINS_LOG_FILE=""
~~~~
