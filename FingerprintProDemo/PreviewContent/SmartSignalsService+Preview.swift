struct SmartSignalsServicePreviewFixture: SmartSignalsServiceProtocol {

    func fetchSignals(for requestId: String) async -> Result<SmartSignalsResponse, any Error> { .success(.preview) }
}

extension SmartSignalsServiceProtocol where Self == SmartSignalsServicePreviewFixture {

    static var preview: Self { .init() }
}
