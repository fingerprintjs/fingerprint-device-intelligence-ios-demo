import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol: Sendable {
    func fingerprintDevice(with tag: String) async throws -> FingerprintResponse
}

struct DeviceIdentificationService<ClientFactory: FingerprintClientFactory>: DeviceIdentificationServiceProtocol {

    private let client: any FingerprintClient

    init() {
        let configuration = Configuration(
            apiKey: ConfigVariable.apiKey,
            region: ConfigVariable.region,
            extendedResponseFormat: true,
            allowUseOfLocationData: true
        )

        self.client = ClientFactory.getInstance(configuration)
    }

    func fingerprintDevice(with tag: String) async throws -> FingerprintResponse {
        var metadata = Metadata()
        metadata.setTag(tag, forKey: "secret")
        let response = try await client.getVisitorIdResponse(metadata)
        return response
    }
}
