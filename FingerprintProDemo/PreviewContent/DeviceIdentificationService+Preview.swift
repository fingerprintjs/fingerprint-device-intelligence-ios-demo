import FingerprintPro

struct DeviceIdentificationServicePreviewFixture: DeviceIdentificationServiceProtocol {

    func fingerprintDevice() async throws -> FingerprintResponse { .preview }
}

extension DeviceIdentificationServiceProtocol where Self == DeviceIdentificationServicePreviewFixture {

    static var preview: Self { .init() }
}
