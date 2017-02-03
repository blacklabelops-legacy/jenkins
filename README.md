# Dockerized Jenkins

[![Docker Stars](https://img.shields.io/docker/stars/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/)

## Supported tags and respective Dockerfile links

| Distribution | Version      | Tag          | Dockerfile |
|--------------|--------------|--------------|------------|
| CentOS | latest | latest | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| CentOS | 2.44 | 2.44 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| CentOS | stable 2.32.2 | 2.32.2 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) |
| Alpine | latest | alpine | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) |
| Alpine | 2.44 | alpine.2.44 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) |
| Alpine | stable 2.32.2 | alpine.2.32.2 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) |
| Alpine | release candidate | rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) |
| Alpine | stable release candidate | stable-rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) |

> Older tags remain but are not supported/rebuild.

## Make It Short

~~~~
$ docker run -d -p 80:8080 --name jenkins blacklabelops/jenkins
~~~~

> You will have to restart the server to activate installed plugins!

Recommended: Docker-Compose! Just curl the files and modify the environment-variables inside
the .env-files.

~~~~
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/docker-compose.yml
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/jenkins-master.env
$ curl -O https://raw.githubusercontent.com/blacklabelops/jenkins/master/jenkins-slave.env
$ docker-compose up -d
~~~~

> [jenkins-master.env](https://github.com/blacklabelops/jenkins/blob/master/jenkins-master.env) contains a full list of environment variables.

Scaling jenkins slaves:

~~~~
$ docker-compose scale slave=3
~~~~

> Starts three java JDK-8 slaves.

## Passing Parameters

You can run the Jenkins solely with command line parameters!

Example:

~~~~
$ docker run \
     -d -p 8090:8080 \
     --name jenkins \
	   blacklabelops/jenkins --debug=9
~~~~

> Staring Jenkins with custom debug level.

Example list parameters:

~~~~
$ docker run --rm blacklabelops/jenkins --help
~~~~

> Lists jenkins plugin parameters.

Example printing Jenkins version:

~~~~
$ docker run --rm blacklabelops/jenkins --version
~~~~

> Prints the image's Jenkins version.

## Features

* Install latest Jenkins.
* Enable security, install plugins, set swarm port with environment-variables.
* On-Demand https.
* Set the Jenkins version number.
* Container writes data to Docker volume.
* Supports the Docker-Compose tool.
* Includes several convenient cli wrapper scripts around docker.

## What's Included

* Jenkins
* Java 8

## Support & Feature Requests

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](http://support.blacklabelops.com)

## Build Slaves

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/swarm)

## Manual

The detailed manual moved here:

* [Gitbook blacklabelops/jenkins](https://www.gitbook.com/book/blacklabelops/jenkins)
