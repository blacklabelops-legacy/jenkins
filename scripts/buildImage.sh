#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local release=$1
  local version=$2
  local tagname=$3
  local dockerfile=$4
  docker build --no-cache -t blacklabelops/jenkins:$tagname --build-arg JENKINS_RELEASE=$release --build-arg JENKINS_VERSION=$version -f $dockerfile .
}

buildImage $1 $2 $3 $4
