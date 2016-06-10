node('docker') {
    checkout scm
    sh 'docker build -t blacklabelops/jenkins:blueocean -f DockerfileBlueOcean .'
}
