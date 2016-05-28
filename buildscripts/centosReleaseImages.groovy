node('docker') {
    checkout scm
    sh './buildscripts/release.sh && ./buildscripts/releaseSupportedCentosImages.sh'
}
