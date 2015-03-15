# BlacklabelOps/Jenkins

Docker container with Jenkins Continuous Integration and Delivery server on CentOS.

### Instant Usage

    docker run -d -p 8090:8090 --name="jenkins_jenkins_1" blacklabelops/jenkins

> This will pull the container and start the latest jenkins on port 8090

## Features

Container has the following features:

* Install latest jenkins.
* Set the jenkins version number.
* Container writes data to docker volume.
* Scripts for backup of jenkins data.
* Scripts for restore of jenkins data.
* Configuration file for managing multiple containers.
* Supports the docker-compose tool.
* Includes several convenient cli wrapper scripts around docker.

## What's Included

Following centos packages are included: `git`, `tar`, `wget` and `zip`. The
image contains Java Server JRE (8u31) and per default the latest Jenkins CI
version.

## Usage

This container includes all the required scripts for container management. Simply clone the project and enter the described commands in your project directory.

[TOC]

### Project Usage

This project can be used from the command line, by bash scripts and the docker-compose tool. It's recommended to use the scripts for container management.

#### Run Recommended

~~~~
$ ./scripts/run.sh
~~~~    

> This will run the container with the configuration scripts/container.cfg

#### Run Docker-Composite

~~~~
$ docker-composite -d up
~~~~    

> This will run the container detached with the configuration docker-composite.yml

#### Run Command Line

~~~~
$ docker run -d -p 8090:8090 --name="jenkins_jenkins_1" blacklabelops/jenkins
~~~~

> This will run the jenkins on default settings and port 8090

#### Build Recommended

~~~~
$ ./scripts/build.sh
~~~~    

> This will build the container from scratch with all required parameters.

#### Build Docker-Composite

~~~~
docker-composite build
~~~~
    
> This will build the container according to the docker-composite.yml file.

#### Build Docker Command Line

~~~~
docker build -t="blacklabelops/jenkins" .
~~~~

> This will build the container from scratch.

## Docker Wrapper Scripts

Convenient wrapper scripts for container and image management. The scripts manage one container. In oder to manage multiple containers, copy the scripts and adjust the container.cfg.

Name              | Description
----------------- | ------------
build.sh          | Build the container from scratch.
run.sh            | Run the container.
start.sh          | Start the container from a stopped state.
stop.sh           | Stop the container from a running state.
rm.sh             | Kill all running containers and remove it.
rmi.sh            | Delete container image.
mng.sh            | Manage the docker volume from another container.

> Simply invoke the commands in the project's folder. 

## Feature Scripts

Feature scripts for the container. The scripts manage one container. In oder to manage multiple containers, copy the scripts and adjust the container.cfg.

Name              | Description
----------------- | ------------
logs.sh  | Downloads a jenkins logs file from container
backup.sh         | Backups docker volume ["/jenkins"] from container
restore.sh        | Restore the backup into jenkins container

> The examples are executed from project folder.

### logs.sh

This script will search for configured docker container. If no container
found, an error message will be shown. Otherwise, an jenkins logs will be
copied by default into 'logs' folder with following file name and timestamp.

~~~~
$ ./scripts/logs.sh
~~~~

> The log file with timestamp as name und suffix ".log" can be found in the project's logs folder.

#### Error example

~~~~
$ ./scripts/logs.sh
:: Searching for jenkins_jenkins_1 docker container...

[ERROR] jenkins_jenkins_1 container is not found
~~~~

#### Success example

~~~~
$ scripts/logs.sh
:: Reading scrips config....
:: Reading container config....
:: Searching for jenkins_jenkins_1 docker container...
 container is found

:: Downloading logs from container...
 logs directory: /home/docker/jenkins/logs
 log filename  : JenkinsLogs-2015-03-08-16-14-01.log
~~~~

### backup.sh

Backup of docker volume in a tar archive.

~~~~
$ ./scripts/backup.sh
~~~~

> The backups will be placed in the project's backups folder.

#### Error example

~~~~
$ scripts/backup.sh
:: Searching for jenkins docker container...

[ERROR] dockerjenkins_jenkins_1 container is not found
~~~~

#### Success example

~~~~
$ scripts/backup.sh
:: Reading scrips config....
:: Reading container config....
:: Searching for jenkins_jenkins_1 docker container...
 container found

:: Backuping /jenkins folder from container...
:: Searching for running backup container...
:: Searching for backup container...
:: Starting backup...
tar: removing leading '/' from member names
:: Searching for backup container...
 backup directory: /home/docker/jenkins/backups
 backup file     : JenkinsBackup-2015-03-08-16-28-40.tar
~~~~

### restore.sh

Restore container from a tar archive.

~~~~
$ ./scripts/restore.sh ./backups/JenkinsBackup-2015-03-08-16-28-40.tar
~~~~

> A temp container will be created and backup file will be extracted into docker volume. The container will be stopped and restartet afterwards.

#### Error example

~~~~
$ scripts/restore.sh

:: Reading scrips config....
:: Reading container config....

No backup archive provided.
Usage: restore.sh {path-to-backup-archive.tar}
~~~~

#### Success example

~~~~
$ ./scripts/restore.sh ./backups/JenkinsBackup-2015-03-08-16-28-40.tar
:: Reading scrips config....
:: Reading container config....
:: Searching for backup file...
 backup archive exists

:: Searching for jenkins_jenkins_1 container
 container found

:: Restoring /jenkins_jenkins_1 folder into container...
 stop container if running
:: Searching for running restore container...
:: Searching for restore container...
:: Starting restore...
 backup imported into jenkins_jenkins_1 container

:: Starting jenkins_jenkins_1 with restored data again...
:: Searching for restore container...

[SUCCESS] Restoring of backups complete successfull.

~~~~

## Managing Multiple Containers

The scripts can be configured for the support of different containers on the same host manchine. Just copy and paste the project and folder and adjust the configuration file scripts/container.cfg

Name              | Description 
----------------- | ------------
CONTAINER_NAME    | The name of the docker container.
IMAGE_NAME         | The name of the docker image.
HOST_PORT        | The exposed port on the host machine.
BACKUP_DIRECTORY | Change the backup directory.
LOGFILE_DIRECTORY | Change the logs download directory.
FILE_TIMESTAMP | Timestamp format for logs and backups.

> Note: CONTAINER_VOLUME can't be changed. It is defined inside the Dockerfile.

## Setting the Jenkins Version

The jenkins version is configured in the Dockerfile. Please consider that backups will only work with the respective jenkins versions.

Dockerfile:

~~~~
ENV JENKINS_VERSION=latest
~~~~

> This will install the latest jenkins version in each build process.

Dockerfile:

~~~~
ENV JENKINS_VERSION=1.556
~~~~

> This will install the jenkins version 1.556.

## Docker-Compose

This project supports docker-compose. The configuration is inside the docker-compose.yml file.

Example:

~~~~
$ docker-composite -d up
~~~~   

> Starts a detached docker container.

Consult the [docker-compose](https://docs.docker.com/compose/) manual for specifics.

## References

* [Jenkins Homepage](http://jenkins-ci.org/)
* [Docker Homepage](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Userguide](https://docs.docker.com/userguide/)
