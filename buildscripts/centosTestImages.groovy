node('docker') {
    checkout scm
    sh './buildscripts/release.sh && ./buildscripts/cleanCentosontainers.sh'
    try {
      sh './buildscripts/release.sh && ./buildscripts/testSupportedCentosImages.sh'
    } finally {
      sh './buildscripts/release.sh && ./buildscripts/cleanCentosontainers.sh'
    }
}
