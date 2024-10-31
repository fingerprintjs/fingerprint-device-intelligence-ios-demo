protocol SmartSignalsServiceProtocol: Sendable {
    func fetchSignals(for requestId: String) async -> Result<SmartSignalsResponse, any Error>
}

struct SmartSignalsService: SmartSignalsServiceProtocol {

    private let client: SmartSignalsClient
    private let settingsContainer: any ReadOnlySettingsContainer

    init(client: SmartSignalsClient, settingsContainer: any ReadOnlySettingsContainer) {
        self.client = client
        self.settingsContainer = settingsContainer
    }

    func fetchSignals(for requestId: String) async -> Result<SmartSignalsResponse, any Error> {
        let endpoint: SmartSignalsEndpoint
        if apiKeysEnabled {
            do {
                let config = try settingsContainer.apiKeysConfig
                endpoint = .subscriptionEvent(
                    apiKey: config.secretKey,
                    region: config.region,
                    requestId: requestId
                )
            } catch {
                return .failure(error)
            }
        } else {
            endpoint = .demoEvent(requestId: requestId)
        }

        return await client.request(endpoint)
            .mapError { error in
                #if DEBUG
                print("[\(type(of: self))] (\(requestId)) |> \(#function) -> \(error)")
                #endif
                return error
            }
    }
}

private extension SmartSignalsService {

    var apiKeysEnabled: Bool { (try? settingsContainer.apiKeysEnabled) ?? false }
}
