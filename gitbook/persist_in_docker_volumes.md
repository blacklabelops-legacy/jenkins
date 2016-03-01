# Persist Data In Docker Volumes

Docker offers Docker volumes to separate your precious data from containers. You can remove and replace your container without losing any data.

Firstly, create a volume:

~~~~
$ docker volume create --name jenkins_data
~~~~

> Note: The volumes name is `jenkins_data`. You can also check with `docker volume ls`.

Secondly, start Jenkins and mount the newly created volume:

~~~~
$ docker run -d \
    -p 8090:8080 \
    -v jenkins_data:/jenkins \
    --name jenkins \
    blacklabelops/jenkins
~~~~

> Note: Must be always mounted at `/jenkins`; the container's fixed data directory.

##You want to check what's written inside your volume?

You can check the volume's content from your running Jenkins:

~~~~
$ docker exec -it jenkins bash
... you operations here....
~~~~

> Connects and runs bash inside your running Jenkins. You will be directed to the directory `/jenkins` because it's defined as the container's workfolder.

You can check with a separate container:

~~~~
$ docker run -it --rm \
    -v jenkins_data:/jenkins \
    blacklabelops/alpine bash
$ cd /jenkins
... you operations here....
~~~~

> This container will mount the volume regardless if your Jenkins is still running! Please bear this in mind. Especially backups can be inconsistent when Jenkins is still running.

## Read Only Volume

Docker's default for the volume parameter `-v` is read and write access. There's also a read-only mode.

Example:

~~~~
$ docker run -it --rm \
    -v jenkins_data:/jenkins:ro \
    blacklabelops/alpine bash
$ cd /jenkins
... you operations here....
~~~~

> The volume will be available in read-only mode.

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

Just start up docker-compose, volumes will be managed on-the-fly:

~~~~
$ docker-compose up -d
~~~~
