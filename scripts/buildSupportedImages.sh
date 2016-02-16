#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.cfg

readonly BUILD_JENKINS_VERSION=$JENKINS_VERSION
readonly BUILD_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

function buildImage() {
  local release=$1
  local version=$2
  local tagname=$3
  local dockerfile=$4
  docker build -t blacklabelops/jenkins:$tagname --build-arg JENKINS_RELEASE=$release --build-arg JENKINS_VERSION=$version -f $dockerfile .
}

buildImage war $BUILD_JENKINS_VERSION latest Dockerfile
buildImage war $BUILD_JENKINS_VERSION $BUILD_JENKINS_VERSION Dockerfile
buildImage war-stable $BUILD_JENKINS_STABLE_VERSION $BUILD_JENKINS_STABLE_VERSION Dockerfile
buildImage war $BUILD_JENKINS_VERSION alpine DockerfileAlpine
buildImage war $BUILD_JENKINS_VERSION alpine.$BUILD_JENKINS_VERSION DockerfileAlpine
buildImage war-stable $BUILD_JENKINS_STABLE_VERSION alpine.$BUILD_JENKINS_STABLE_VERSION DockerfileAlpine
buildImage war-rc latest rc DockerfileAlpine
buildImage war-stable-rc latest stable-rc DockerfileAlpine
