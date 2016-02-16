# Building The Image

## Project Checkout

First step: Check out this project from github!

Repository location: [blacklabelops/jenkins](https://github.com/blacklabelops/jenkins)

> Puts the Dockerfile in  your local directory.

## Choose The Release

Second step: Choose between Long-Term Support (LTS) Release or latest version release.

Jenkins comes in two flavors. The LTS release is the best for your stable environment as its proven and tested. The release cycle is long term so you do not have to update often. The latest version is perfect if you want to tinker with the latest features.

Here you can see the list of latest releases: [Release List](http://mirrors.jenkins-ci.org/war/)

Here you can see the list of LTS releases: [Long-Term Support Release List](http://mirrors.jenkins-ci.org/war-stable/)

## Build The Image

Third step: Build the image

The build process can take two arguments:

* JENKINS_RELEASE: Takes keyword `war-stable` for LTS releases and `war` otherwise. Default is `war`.
* JENKINS_VERSION: Takes keyword `latest` or specific Jenkins version number. Default is `latest`.

Examples:

Build image with the latest Jenkins release:

~~~~
$ docker build -t blacklabelops/jenkins .
~~~~

> Note: Dockerfile must be inside the current directory!

Build image with the latest Jenkins LTS release:

~~~~
$ docker build --build-arg JENKINS_RELEASE=war-stable -t blacklabelops/jenkins .
~~~~

> Note: Dockerfile must be inside the current directory!

Build image with a specific Jenkins LTS release:

~~~~
$ docker build --build-arg JENKINS_RELEASE=war-stable --build-arg JENKINS_VERSION=1.625.3  -t blacklabelops/jenkins .
~~~~

> Note: Dockerfile must be inside the current directory!

## Using Docker Compose

A minimal Docker-Compose file for building the image can be found in file `docker-compose.yml` inside the repository directory `examples/build`.

The build configuration with arguments are specified inside the following area:

~~~~
jenkins:
  build:
    context: ../../
    dockerfile: Dockerfile
    args:
      JENKINS_VERSION: war-stable
      JENKINS_RELEASE: latest
~~~~

> Adjust JENKINS_VERSION and JENKINS_RELEASE for your personal needs.

Build the latest LTS release with docker-compose:

~~~~
$ cd examples/build
$ docker-compose build
~~~~
