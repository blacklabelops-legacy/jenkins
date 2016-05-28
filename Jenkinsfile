/** Jenkins 2.0 Buildfile
*
* Slave 'docker' can be started by typing:
* docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link jenkins:jenkins -e "SWARM_CLIENT_LABELS=docker" blacklabelops/swarm-dockerhost
**/
node('docker') {
  checkout scm
  stage 'Build & Test Images'
  sh './scripts/release.sh && ./scripts/buildSupportedImages.sh'
}
