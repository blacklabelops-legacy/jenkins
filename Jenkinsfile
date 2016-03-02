node('docker') {
  git url: 'https://github.com/blacklabelops/jenkins.git'
  env.JENKINS_VERSION = "1.651"
  sh "scripts/buildImage.sh war $JENKINS_VERSION latest Dockerfile"
}
