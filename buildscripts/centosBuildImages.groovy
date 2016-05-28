node('docker') {
    checkout scm
    sh './buildscripts/release.sh && ./buildscripts/buildSupportedCentosImages.sh'
}
