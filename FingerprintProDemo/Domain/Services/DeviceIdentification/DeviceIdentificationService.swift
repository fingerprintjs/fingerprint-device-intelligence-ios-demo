import FingerprintPro

typealias FingerprintClient = FingerprintClientProviding

protocol FingerprintClientFactory {
    static func getInstance(_ configuration: Configuration) -> FingerprintClient
}

protocol DeviceIdentificationServiceProtocol: Sendable {
    func fingerprintDevice() async throws -> FingerprintResponse
    func startCollectingLocation() async throws
}

struct DeviceIdentificationService<ClientFactory: FingerprintClientFactory>: DeviceIdentificationServiceProtocol {

    private let settingsContainer: any ReadOnlySettingsContainer

    init(settingsContainer: any ReadOnlySettingsContainer) {
        self.settingsContainer = settingsContainer
    }
    
    func startCollectingLocation() async throws {
        let client = try makeFingerprintClient()
        await MainActor.run {
            client.allowUseOfLocationData = true
        }
    }

    func fingerprintDevice() async throws -> FingerprintResponse {
        let client = try makeFingerprintClient()
        await MainActor.run {
            client.allowUseOfLocationData = true
        }
        let response = try await client.getVisitorIdResponse()
        return response
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
