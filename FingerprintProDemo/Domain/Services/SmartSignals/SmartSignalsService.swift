protocol SmartSignalsServiceProtocol: Sendable {
    func fetchSignals(for requestId: String) async throws -> SmartSignalsResponse
}

struct SmartSignalsService: SmartSignalsServiceProtocol {

    private let client: any FingerprintServerAPI.Client
    private let settingsContainer: any ReadOnlySettingsContainer

    init(
        client: any FingerprintServerAPI.Client,
        settingsContainer: any ReadOnlySettingsContainer
    ) {
        self.client = client
        self.settingsContainer = settingsContainer
    }

    func fetchSignals(for requestId: String) async throws -> SmartSignalsResponse {
        let endpoint: FingerprintServerAPI.Endpoint
        if apiKeysEnabled {
            let config = try settingsContainer.apiKeysConfig
            endpoint = .subscriptionEvent(
                apiKey: config.secretKey,
                region: config.region,
                requestId: requestId
            )
        } else {
            endpoint = .demoEvent(requestId: requestId)
        }

        return try await client.request(endpoint)
    }
}

private extension SmartSignalsService {

    var apiKeysEnabled: Bool { (try? settingsContainer.apiKeysEnabled) ?? false }
}
