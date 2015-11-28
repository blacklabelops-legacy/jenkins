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

### Hiding Environment Variables

This container can initialize with environment variables from a file.

* If you prefer specifying your default password inside a file rather then inside your docker-compose file.
* This way the password is also hidden from docker and the command **docker inspect**.
* You can reconfigure the container without removing the container.

The environment variable JENKINS_ENV_FILE tells the entryscript where to find the environment variables.

How do you get the file inside the container?

* Use the command **docker cp** in order to copy the file inside an already initialized container.
* Extend the container with a new Dockerfile. Example can be found here: [Example-Dockerfile](https://github.com/blacklabelops/jenkins/blob/master/extension/Dockerfile)
* Put the file inside a data-container and mount it with the **--volumes-from** directive.

### Jenkins Logging

This container does not write a logfile by default. It's considered bad practise as logs
should be accessed by the command `docker logs`. There are use case where you want to
have additional log files, e.g. my use case is to relay log to Loggly [Loggly Homepage](https://www.loggly.com/).
I have added a routine for logging and it's activated by defining a logfile.

Environment Variable: LOG_FILE

Example for a separate volume with a logfile:

~~~~
$ docker run -d -p 8090:8080 \
  -v $(pwd)/logs:/jenkinslogs \
  -e "LOG_FILE=/jenkinslogs/jenkins.log" \
  --name jenkins \
  blacklabelops/jenkins
~~~~

> You can watch the log by typing `cat ./logs/jenkins.log`.

Now lets hook up the container with my Loggly side-car container and relay the log to Loggly! The Full
documentation of the loggly container can be found here: [blacklabelops/loggly](https://github.com/blacklabelops/fluentd/tree/master/fluentd-loggly)

~~~~
$ docker run -d \
  --volumes-from jenkins \
  -e "LOGS_DIRECTORIES=/jenkinslogs" \
	-e "LOGGLY_TOKEN=3ere-23kkke-23j3oj-mmkme-343" \
  -e "LOGGLY_TAG=jenkinslog" \
  --name jenkinsloggly \
  blacklabelops/loggly
~~~~

> Note: You need a valid Loggly Customer Key in order to log to Loggly.

### Jenkins Backups with rsnapshot

You can create automatic backups using [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron).
This side-car container uses rsnapshot to create snapshots of your jenkins volume periodically.

Full documentation can be found here:  [blacklabelops/rsnapshotd](https://github.com/blacklabelops/rsnapshot/tree/master/rsnapshot-cron)

First fire up the Jenkins master:

~~~~
$ docker run -d -p 8090:8080 --name jenkins blacklabelops/jenkins
~~~~

Then start and attach the side-car backup container:

~~~~
$ docker run -d \
  --volumes-from jenkins \
	-v $(pwd)/snapshots/:/snapshots \
  -e "CRON_HOURLY=* * * * *" \
	-e "BACKUP_DIRECTORIES=/jenkins/ jenkins/" \
	blacklabelops/rsnapshotd
~~~~

> Mounts all volumes from the running container and snapshots the volume /jenkins inside the local
snapshot directory under `jenkins/`. Note: If you use Windows then you will have to replace $(pwd)
with an abolute path.

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
