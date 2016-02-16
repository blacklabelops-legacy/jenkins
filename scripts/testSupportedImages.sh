#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.cfg

readonly TEST_JENKINS_VERSION=$JENKINS_VERSION
readonly TEST_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

function testImage() {
  local tagname=$1
  local port=$2
  docker run -d -p $port:8080 --name=$tagname blacklabelops/jenkins:$tagname
  sleep 10
  curl --retry 10 --retry-delay 10 -v http://localhost:$port
  docker stop $tagname
}

testImage latest 8090
testImage $TEST_JENKINS_VERSION 8100
testImage $TEST_JENKINS_STABLE_VERSION 8110
testImage alpine 8120
testImage alpine.$TEST_JENKINS_VERSION 8130
testImage alpine.$TEST_JENKINS_STABLE_VERSION 8140
testImage rc 8150
testImage stable-rc 8160
