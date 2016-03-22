# Dockerized Jenkins

[![Circle CI](https://circleci.com/gh/blacklabelops/jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/blacklabelops/jenkins/tree/master) [![Docker Stars](https://img.shields.io/docker/stars/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/)

## Jenkins 2.0 Preview

This is a preview version, do not use in production and wait for the official release!

| Distribution | Version      | Tag          | Dockerfile | Size |
|--------------|--------------|--------------|------------|------|
| Alpine | Preview 2.0 | preview-2.0 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:preview-2.0](https://badge.imagelayers.io/blacklabelops/jenkins:preview-2.0.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:preview-2.0 'blacklabelops/jenkins:preview-2.0') |
| Centos | Preview 2.0 | centos.preview-2.0 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) | [![blacklabelops/jenkins:centos.preview-2.0](https://badge.imagelayers.io/blacklabelops/jenkins:centos.preview-2.0.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:centos.preview-2.0 'blacklabelops/jenkins:centos.preview-2.0') |

> Note: Seems like 2.0 really is fully downwards compatible and image features are still working! Build args for version 2.0: JENKINS_RELEASE=war-rc and JENKINS_VERSION=2.0

## Supported tags and respective Dockerfile links

| Distribution | Version      | Tag          | Dockerfile | Size |
|--------------|--------------|--------------|------------|------|
| CentOS | latest | latest | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) | [![blacklabelops/jenkins:latest](https://badge.imagelayers.io/blacklabelops/jenkins:latest.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:latest 'blacklabelops/jenkins:latest') |
| CentOS | 1.654 | 1.654 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) | [![blacklabelops/jenkins:1.654](https://badge.imagelayers.io/blacklabelops/jenkins:1.654.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:1.654 'blacklabelops/jenkins:1.654') |
| CentOS | stable 1.642.3 | 1.642.3 |  [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/Dockerfile) | [![blacklabelops/jenkins:1.642.3](https://badge.imagelayers.io/blacklabelops/jenkins:1.642.3.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:1.642.3 'blacklabelops/jenkins:1.642.3') |
| Alpine | latest | alpine | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine 'blacklabelops/jenkins:alpine') |
| Alpine | 1.654 | alpine.1.654 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.1.654](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.1.654.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine.1.654 'blacklabelops/jenkins:alpine.1.654') |
| Alpine | stable 1.642.3 | alpine.1.642.3 | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.1.642.3](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.1.642.3.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine.1.642.3 'blacklabelops/jenkins:alpine.1.642.3') |
| Alpine | release candidate | rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:rc](https://badge.imagelayers.io/blacklabelops/jenkins:rc.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:rc 'blacklabelops/jenkins:rc') |
| Alpine | stable release candidate | stable-rc | [Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/DockerfileAlpine) | [![blacklabelops/jenkins:alpine.stable-rc](https://badge.imagelayers.io/blacklabelops/jenkins:stable-rc.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:stable-rc 'blacklabelops/jenkins:stable-rc') |

> Older tags remain but are not supported/rebuild.

> Note: Imagelayers.io badges are broken because Dockerhub does not support Docker 1.9 Dockerfiles. (e.g. ARG directive)

## Make It Short

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

> This will pull the container and start the latest jenkins on port 8090

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

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](https://www.hipchat.com/geogBFvEM)

## Build Slaves

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/swarm)

## Manual

The detailed manual moved here:

* [Gitbook blacklabelops/jenkins](https://www.gitbook.com/book/blacklabelops/jenkins)
