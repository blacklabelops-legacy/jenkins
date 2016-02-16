#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.cfg

readonly PUSH_REPOSITORY=$1
readonly PUSH_JENKINS_VERSION=$JENKINS_VERSION
readonly PUSH_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

function pushImage() {
  local tagname=$1
  local repository=$2
  docker push $repository/blacklabelops/jenkins:$tagname
}

pushImage latest $PUSH_REPOSITORY
pushImage $TEST_JENKINS_VERSION $PUSH_REPOSITORY
pushImage $TEST_JENKINS_STABLE_VERSION $PUSH_REPOSITORY
pushImage alpine $PUSH_REPOSITORY
pushImage alpine.$TEST_JENKINS_VERSION $PUSH_REPOSITORY
pushImage alpine.$TEST_JENKINS_STABLE_VERSION $PUSH_REPOSITORY
pushImage war-rc $PUSH_REPOSITORY
pushImage war-stable-rc $PUSH_REPOSITORY
