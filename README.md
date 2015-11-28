[![Circle CI](https://circleci.com/gh/blacklabelops/jenkins/tree/master.svg?style=shield)](https://circleci.com/gh/blacklabelops/jenkins/tree/master)
[![Image Layers](https://badge.imagelayers.io/blacklabelops/jenkins:latest.svg)](https://imagelayers.io/?images=blacklabelops/jenkins:latest 'Get your own badge on imagelayers.io')
[![Docker Repository on Quay](https://quay.io/repository/blacklabelops/jenkins/status "Docker Repository on Quay")](https://quay.io/repository/blacklabelops/jenkins)

[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/)

Docker container with Jenkins Continuous Integration and Delivery Server.

Leave a message and ask questions on Hipchat: [blacklabelops/hipchat](https://www.hipchat.com/geogBFvEM)

Build Slaves can be found here: [blacklabelops/swarm](https://github.com/blacklabelops/jenkins-swarm)

How-To run this container inside the Google Container Engine (GCE): [blacklabelops/gce-jenkins](https://github.com/blacklabelops/gce-jenkins)

### Instant Usage

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

Container has the following features:

* Install latest Jenkins.
* Enable security, install plugins, set swarm port with docker envs.
* On-Demand https.
* Set the Jenkins version number.
* Container writes data to Docker volume.
* Scripts for backup of Jenkins data.
* Scripts for restore of Jenkins data.
* Supports the Docker-Compose tool.
* Includes several convenient cli wrapper scripts around docker.

## What's Included

* Jenkins Latest
* CentOS 7.1.503
* Java 8

## Works with

* Docker Latest
* Docker-Compose Latest

## Configuration

### Jenkins Backups in Google Storage Buckets

You can periodically create backups and upload them to your [Google Storage Bucket](https://cloud.google.com/storage/).

Full documentation of the backup container can be found hee: [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the [blacklabelops/gcloud](https://github.com/blacklabelops/gcloud) container!

The required example crontab can be found here: [example-crontab-backup.txt](https://github.com/blacklabelops/gcloud/blob/master/example-crontab-backup.txt)

~~~~
$ docker run \
  --volumes-from jenkins \
  -v $(pwd)/backups/:/backups \
  -v $(pwd)/logs/:/logs \
  -e "GCLOUD_ACCOUNT=$(base64 auth.json)" \
  -e "GCLOUD_CRON=$(base64 example-crontab-backup.txt)" \
  blacklabelops/gcloud
~~~~

> Uses the authentication file auth.json and executed the crontab th°°at uploads archives to the specified cloud bucket. Logs and
backups are available locally.

## References

* [Jenkins Homepage](http://jenkins-ci.org/)
* [Docker Homepage](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Userguide](https://docs.docker.com/userguide/)
* [Official CentOS Container](https://registry.hub.docker.com/_/centos/)
* [Oracle Java8](https://java.com/de/download/)
