# Persist Data In Docker Volumes

You can persist your container data inside a Docker Volume.

First: Create a volume!

~~~~
$ docker volume create --name jenkins_data
~~~~

Second and Last: Mount the volume inside the container's folder `/jenkins`.

The folder `/jenkins` is mandatory as the complete image is configured to expect the data inside `/jenkins`.

Mount the directory using docker-cli at container startup:

~~~~
$ docker run -d -p 8080:8080 -v jenkins_data:/jenkins --name jenkins blacklabelops/jenkins
~~~~

Take a look inside the volume with another container in order to check the contents:

~~~~
$ docker run -it --rm -v jenkins_data:/jenkins:ro blacklabelops/jenkins bash
~~~~

> Note: We access the volume in read-only mode because we have another process working on the data!

## Using Docker Compose

A minimal Docker-Compose file for using volumes can be found in file `docker-compose.yml` inside the repository directory [examples/build](https://github.com/blacklabelops/jenkins/tree/master/examples/volumes).

The file looks like this:

~~~~
version: '2'

services:
  # Jenkins Master
  jenkins:
    image: blacklabelops/jenkins
    container_name: jenkins
    ports:
     - "8080:8080"
    volumes:
      - jenkinsdata:/jenkins

volumes:
  jenkinsdata:
    external: false
~~~~

> Adjust JENKINS_VERSION and JENKINS_RELEASE for your personal needs.

Just start up docker-compose, volumes will be managed on-the-fly:

~~~~
$ docker-compose up -d
~~~~
