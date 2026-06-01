protocol SmartSignalsServiceProtocol: Sendable {
    func fetchSignals(for requestId: String, with tag: String) async throws -> SmartSignalsResponse
}

struct SmartSignalsService: SmartSignalsServiceProtocol {

    private let client: any FingerprintServerAPI.Client

    init(client: any FingerprintServerAPI.Client) {
        self.client = client
    }

    func fetchSignals(for requestId: String, with tag: String) async throws -> SmartSignalsResponse {
        return try await client.request(.proxyEvent(requestId: requestId, tag: tag))
    }
}
