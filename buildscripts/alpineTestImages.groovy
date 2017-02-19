node('docker') {
    checkout scm
    try {
      sh './buildscripts/release.sh && ./buildscripts/testSupportedAlpineImages.sh'
    } finally {
      sh './buildscripts/release.sh && ./buildscripts/cleanAlpineContainers.sh'
    }
}
