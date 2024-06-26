import FingerprintPro

struct DeviceIdentificationServicePreviewFixture: DeviceIdentificationServiceProtocol {

    func fingerprintDevice() async -> Result<FingerprintResponse, any Error> { .success(.preview) }
}

extension DeviceIdentificationServiceProtocol where Self == DeviceIdentificationServicePreviewFixture {

    static var preview: Self { .init() }
}
