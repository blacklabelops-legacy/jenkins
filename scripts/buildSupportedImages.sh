#!/bin/bash -x

set -o errexit    # abort script at first error

readonly JENKINS_VERSION=1.647
readonly JENKINS_STABLE_VERSION=1.642.1

function buildImage() {
  local release=$1
  local version=$2
  local tagname=$3
  local dockerfile=$4
  docker build -t blacklabelops/jenkins:$tagname --build-arg JENKINS_RELEASE=$release --build-arg JENKINS_VERSION=$version -f $dockerfile .
}

buildImage war $JENKINS_VERSION latest Dockerfile
buildImage war $JENKINS_VERSION $JENKINS_VERSION Dockerfile
buildImage war-stable $JENKINS_STABLE_VERSION $JENKINS_STABLE_VERSION Dockerfile
buildImage war $JENKINS_VERSION alpine DockerfileAlpine
buildImage war $JENKINS_VERSION alpine.$JENKINS_VERSION DockerfileAlpine
buildImage war-stable $JENKINS_STABLE_VERSION alpine.$JENKINS_STABLE_VERSION DockerfileAlpine
buildImage war-rc latest rc DockerfileAlpine
buildImage war-stable-rc latest stable-rc DockerfileAlpine
