#!/bin/bash -x

set -o errexit    # abort script at first error

readonly JENKINS_VERSION=1.647
readonly JENKINS_STABLE_VERSION=1.642.1

docker build -t blacklabelops/jenkins .
docker build -t blacklabelops/jenkins:$JENKINS_VERSION --build-arg JENKINS_RELEASE=war --build-arg JENKINS_VERSION=$JENKINS_VERSION .
docker build -t blacklabelops/jenkins:$JENKINS_STABLE_VERSION --build-arg JENKINS_RELEASE=war-stable --build-arg JENKINS_VERSION=$JENKINS_STABLE_VERSION .
docker build -t blacklabelops/jenkins:alpine -f DockerfileAlpine .
docker build -t blacklabelops/jenkins:alpine.$JENKINS_VERSION --build-arg JENKINS_RELEASE=war --build-arg JENKINS_VERSION=$JENKINS_VERSION -f DockerfileAlpine .
docker build -t blacklabelops/jenkins:alpine.$JENKINS_STABLE_VERSION --build-arg JENKINS_RELEASE=war-stable --build-arg JENKINS_VERSION=$JENKINS_STABLE_VERSION -f DockerfileAlpine .
