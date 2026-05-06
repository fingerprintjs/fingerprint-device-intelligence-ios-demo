import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol: Sendable {
    func fingerprintDevice() async throws -> FingerprintResponse
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

    func fingerprintDevice() async throws -> FingerprintResponse {
        let response = try await client.getVisitorIdResponse()
        return response
    }
}
