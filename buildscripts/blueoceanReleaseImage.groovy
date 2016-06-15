node('docker') {
    checkout scm
    sh 'docker push blacklabelops/jenkins:blueocean'
}
