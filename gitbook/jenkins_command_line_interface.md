# Jenkins Command Line Interface

This image contains the Jenkins CLI. You can run the cli easily against the Jenkins server locally or remote.

Example:

First start the server:

~~~~
$ docker run -d -p 80:8080 --name jenkins blacklabelops/jenkins
~~~~

> Jenkins will be available at http://yourdockerhost:8090.

## Running CLI Locally

You can enter the running jenkins container and execute the client against the server!

~~~~
$ docker exec jenkins cli
~~~~

> Will list the help of the Jenkins cli

## Running CLI Against Server

You can run the CLI against any Jenkins server!

~~~~
$ docker run -it --rm -e "JENKINS_CLI_URL=http://jenkins.example.com" blacklabelops/jenkins cli
~~~~

> Will run the cli against the Jenkins server defined in JENKINS_CLI_URL

You can also use the non-parameterized jenkins-cli command and run against any network available Jenkins!

~~~~
$ docker run -it --rm blacklabelops/jenkins jenkins-cli -s http://jenkins.example.com
~~~~

> Will run the cli with any given and valid jenkins cli parameter.

## Running CLI Remotely

You can run the cli against a linked jenkins server!

~~~~
$ docker exec --link jenkins:jenkins -e "JENKINS_CLI_URL=http://jenkins:8080" blacklabelops/jenkins cli
~~~~

> Will run the cli against the linked Jenkins container

## SSH Authentication

You can define an SSH authentication file with the environment variable JENKINS_CLI_SSH!

~~~~
$ docker exec --link jenkins:jenkins -v myauthentication.pem:/sshfiles/tokenfile.pem -e "JENKINS_CLI_SSH=/sshfiles/tokenfile.pem" -e "JENKINS_CLI_URL=http://jenkins:8080" blacklabelops/jenkins cli
~~~~

> Will trigger cli with authentication.