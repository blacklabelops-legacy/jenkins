#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly TEST_JENKINS_VERSION=$JENKINS_VERSION
readonly TEST_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

source $CUR_DIR/cleanContainer.sh latest
source $CUR_DIR/cleanContainer.sh $TEST_JENKINS_VERSION
source $CUR_DIR/cleanContainer.sh $TEST_JENKINS_STABLE_VERSION
