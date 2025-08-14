import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol: Sendable {
    func fingerprintDevice() async throws -> FingerprintResponse
}

enum FingerprintClientError: Error {
    case clientNotCreated
}

struct DeviceIdentificationService<ClientFactory: FingerprintClientFactory>: DeviceIdentificationServiceProtocol {

    private let client: (any FingerprintClient)?

    init(settingsContainer: any ReadOnlySettingsContainer) {
        self.client = try? Self.makeFingerprintClient(settingsContainer: settingsContainer)
    }

    func fingerprintDevice() async throws -> FingerprintResponse {
        guard let client else { throw FingerprintClientError.clientNotCreated }
        let response = try await client.getVisitorIdResponse()
        return response
    }
}

private extension DeviceIdentificationService {

    static func makeFingerprintClient(settingsContainer: any ReadOnlySettingsContainer) throws -> FingerprintClient {
        let apiKey: String
        let region: Region
        if apiKeysEnabled(for: settingsContainer) {
            let config = try settingsContainer.apiKeysConfig
            apiKey = config.publicKey
            region = config.region
        } else {
            apiKey = ConfigVariable.apiKey
            region = ConfigVariable.region
        }
        let configuration = Configuration(
            apiKey: apiKey,
            region: region,
            extendedResponseFormat: true,
            allowUseOfLocationData: true
        )

        return ClientFactory.getInstance(configuration)
    }

    static func apiKeysEnabled(for settingsContainer: any ReadOnlySettingsContainer) -> Bool {
        (try? settingsContainer.apiKeysEnabled) ?? false
    }
}
