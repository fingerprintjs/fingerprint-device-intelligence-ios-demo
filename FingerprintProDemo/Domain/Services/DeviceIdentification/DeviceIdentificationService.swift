import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol: Sendable {
    func fingerprintDevice() async -> Result<FingerprintResponse, any Error>
}

struct DeviceIdentificationService<ClientFactory: FingerprintClientFactory>: DeviceIdentificationServiceProtocol {

    private let settingsContainer: any ReadOnlySettingsContainer

    init(settingsContainer: any ReadOnlySettingsContainer) {
        self.settingsContainer = settingsContainer
    }

    func fingerprintDevice() async -> Result<FingerprintResponse, any Error> {
        do {
            let client = try makeFingerprintClient()
            let response = try await client.getVisitorIdResponse()
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}

private extension DeviceIdentificationService {

    func makeFingerprintClient() throws -> FingerprintClient {
        let apiKey: String
        let region: Region
        if apiKeysEnabled {
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
            extendedResponseFormat: true
        )

        return ClientFactory.getInstance(configuration)
    }
}

private extension DeviceIdentificationService {

    var apiKeysEnabled: Bool { (try? settingsContainer.apiKeysEnabled) ?? false }
}
