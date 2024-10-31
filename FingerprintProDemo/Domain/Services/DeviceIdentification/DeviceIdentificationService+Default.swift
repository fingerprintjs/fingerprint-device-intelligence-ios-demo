import FingerprintPro

extension FingerprintProFactory: FingerprintClientFactory {}

extension DeviceIdentificationServiceProtocol where Self == DeviceIdentificationService<FingerprintProFactory> {

    static var `default`: Self {
        .init(settingsContainer: SettingsContainer.default)
    }
}
