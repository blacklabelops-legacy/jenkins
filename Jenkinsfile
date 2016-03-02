# Jenkins 2.0 Buildfile
#
# Slave 'docker' can be started by typing:
# docker run -d -v /var/run/docker.sock:/var/run/docker.sock --link jenkins:jenkins -e "SWARM_CLIENT_LABELS=docker" blacklabelops/swarm-dockerhost
#
node('docker') {
  def JENKINS_VERSION = '1.651'
  sh "scripts/buildImage.sh war ${JENKINS_VERSION} latest Dockerfile"
}
