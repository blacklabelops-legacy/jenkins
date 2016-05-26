#!/bin/bash -x

set -o errexit    # abort script at first error

# Setting environment variables
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

printf '%b\n' ":: Reading release config...."
source $CUR_DIR/release.sh

readonly BUILD_JENKINS_VERSION=$JENKINS_VERSION
readonly BUILD_JENKINS_STABLE_VERSION=$JENKINS_STABLE_VERSION

source $CUR_DIR/buildImage.sh war $BUILD_JENKINS_VERSION latest Dockerfile $BUILD_JENKINS_VERSION
source $CUR_DIR/buildImage.sh war $BUILD_JENKINS_VERSION $BUILD_JENKINS_VERSION Dockerfile $BUILD_JENKINS_VERSION
source $CUR_DIR/buildImage.sh war-stable $BUILD_JENKINS_STABLE_VERSION $BUILD_JENKINS_STABLE_VERSION Dockerfile $BUILD_JENKINS_STABLE_VERSION
source $CUR_DIR/buildImage.sh war $BUILD_JENKINS_VERSION alpine DockerfileAlpine $BUILD_JENKINS_VERSION
source $CUR_DIR/buildImage.sh war $BUILD_JENKINS_VERSION alpine.$BUILD_JENKINS_VERSION DockerfileAlpine $BUILD_JENKINS_VERSION
source $CUR_DIR/buildImage.sh war-stable $BUILD_JENKINS_STABLE_VERSION alpine.$BUILD_JENKINS_STABLE_VERSION DockerfileAlpine $BUILD_JENKINS_STABLE_VERSION
source $CUR_DIR/buildImage.sh war-rc latest rc DockerfileAlpine
source $CUR_DIR/buildImage.sh war-stable-rc latest stable-rc DockerfileAlpine
source $CUR_DIR/buildImage.sh war-rc 2.0 preview-2.0 DockerfileAlpine
source $CUR_DIR/buildImage.sh war-rc 2.0 centos.preview-2.0 Dockerfile
