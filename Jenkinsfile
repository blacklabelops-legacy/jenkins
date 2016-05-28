/** Jenkins 2.0 Buildfile
*
* Slave 'docker' can be started by typing:
* docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link jenkins:jenkins -e "SWARM_CLIENT_LABELS=docker" blacklabelops/swarm-dockerhost
**/
node('docker') {
  checkout scm
  stage 'Build Images'
  sh './scripts/release.sh && ./scripts/buildSupportedCentosImages.sh'
  stage 'Test Images'
  sh './scripts/release.sh && ./scripts/testSupportedCentosImages.sh'
}
