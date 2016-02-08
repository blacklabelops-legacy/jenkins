# Jenkins Docker Container

[![Circle CI](https://circleci.com/gh/blacklabelops/jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/blacklabelops/jenkins/tree/master) [![Docker Repository on Quay](https://quay.io/repository/blacklabelops/jenkins/status "Docker Repository on Quay")](https://quay.io/repository/blacklabelops/jenkins) [![Docker Stars](https://img.shields.io/docker/stars/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacklabelops/jenkins.svg)](https://hub.docker.com/r/blacklabelops/jenkins/)

Docker Image with Jenkins Continuous Integration and Delivery Server.

New: Minimized Alpine Version! [blacklabelops/jenkins:alpine](https://github.com/blacklabelops/jenkins/tree/alpine)

See the difference!

CentOS Image: [![](https://badge.imagelayers.io/blacklabelops/jenkins:latest.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:latest 'blacklabelops/jenkins:latest')

Alpine Image: [![](https://badge.imagelayers.io/blacklabelops/jenkins:alpine.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:alpine 'blacklabelops/jenkins:alpine ')

## Release: blacklabelops/jenkins:latest

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](https://www.hipchat.com/geogBFvEM)

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/jenkins-swarm)

## Instant Usage

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

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

## Manual

The detailed manual moved here:

* [Gitbook blacklabelops/jenkins](https://www.gitbook.com/book/blacklabelops/jenkins)
