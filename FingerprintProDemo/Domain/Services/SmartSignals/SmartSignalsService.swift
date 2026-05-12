protocol SmartSignalsServiceProtocol: Sendable {
    func fetchSignals(for requestId: String) async throws -> SmartSignalsResponse
}

struct SmartSignalsService: SmartSignalsServiceProtocol {

    private let client: any FingerprintServerAPI.Client

    init(client: any FingerprintServerAPI.Client) {
        self.client = client
    }

    func fetchSignals(for requestId: String) async throws -> SmartSignalsResponse {
        return try await client.request(.demoEvent(requestId: requestId))
    }
}
