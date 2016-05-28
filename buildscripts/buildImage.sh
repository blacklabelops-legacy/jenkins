#!/bin/bash -x

set -o errexit    # abort script at first error

function buildImage() {
  local release=$1
  local version=$2
  local tagname=$3
  local dockerfile=$4
  local cliversion=$5
  if [[ -z "${param// }" ]]; then
    docker build --no-cache -t blacklabelops/jenkins:$tagname --build-arg JENKINS_RELEASE=$release --build-arg JENKINS_VERSION=$version -f $dockerfile .
  else
    docker build --no-cache -t blacklabelops/jenkins:$tagname --build-arg JENKINS_RELEASE=$release --build-arg JENKINS_VERSION=$version --build-arg JENKINS_CLI_VERSION=$cliversion -f $dockerfile .
  fi
}

buildImage $1 $2 $3 $4 $5
