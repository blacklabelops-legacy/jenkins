#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly PUSH_REPOSITORY=$1
readonly PUSH_JENKINS_VERSION=$JENKINS_VERSION
readonly PUSH_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

function retagImage() {
  local tagname=$1
  local repository=$2
  docker tag -f blacklabelops/jenkins:$tagname $repository/blacklabelops/jenkins:$tagname
}

function pushImage() {
  local tagname=$1
  local repository=$2
  if [ "$repository" != 'docker.io' ]; then
    retagImage $tagname $repository
  fi
  docker push $repository/blacklabelops/jenkins:$tagname
}

pushImage alpine $PUSH_REPOSITORY
pushImage alpine.$PUSH_JENKINS_VERSION $PUSH_REPOSITORY
pushImage alpine.$PUSH_JENKINS_STABLE_VERSION $PUSH_REPOSITORY
pushImage rc $PUSH_REPOSITORY
pushImage stable-rc $PUSH_REPOSITORY
