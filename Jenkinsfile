node('docker') {
  def JENKINS_VERSION = '1.651'
  sh "scripts/buildImage.sh war ${JENKINS_VERSION} latest Dockerfile"
}
