node('docker') {
    checkout scm
    sh './scripts/release.sh && ./scripts/cleanCentosontainers.sh'
    try {
      sh './scripts/release.sh && ./scripts/testSupportedCentosImages.sh'
    } finally {
      sh './scripts/release.sh && ./scripts/cleanCentosontainers.sh'
    }
}
