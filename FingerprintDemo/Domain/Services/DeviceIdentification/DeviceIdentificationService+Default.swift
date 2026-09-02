import Fingerprint

extension FingerprintFactory: FingerprintClientFactory {}

extension DeviceIdentificationServiceProtocol where Self == DeviceIdentificationService<FingerprintFactory> {

    static var `default`: Self {
        .init()
    }
}
