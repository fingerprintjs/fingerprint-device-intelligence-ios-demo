protocol SmartSignalsServiceProtocol: Sendable {
    func fetchSignals(for requestId: String) async -> Result<SmartSignalsResponse, any Error>
}

struct SmartSignalsService: SmartSignalsServiceProtocol {

    private let client: SmartSignalsClient

    init(client: SmartSignalsClient) {
        self.client = client
    }

    func fetchSignals(for requestId: String) async -> Result<SmartSignalsResponse, any Error> {
        await client.request(
            .event(requestId: requestId)
        )
        .mapError { error in
            #if DEBUG
            print("[\(type(of: self))] (\(requestId)) |> \(#function) -> \(error)")
            #endif
            return error
        }
    }
}
