# Jenkins Command Line Interface

This image contains the Jenkins CLI. You can run the cli easily against the Jenkins server locally or remote.

Example:

First start the server:

~~~~
$ docker run -d -p 80:8080 --name jenkins blacklabelops/jenkins
~~~~

> Jenkins will be available at http://yourdockerhost:8090.

## Running CLI Locally

You can enter the running jenkins container and execute the client against the server:

~~~~
$ docker exec jenkins cli
~~~~

> Will list the help of the 
