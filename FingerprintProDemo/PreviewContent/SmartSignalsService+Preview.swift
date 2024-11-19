struct SmartSignalsServicePreviewFixture: SmartSignalsServiceProtocol {

    func fetchSignals(for requestId: String) async throws -> SmartSignalsResponse { .preview }
}

extension SmartSignalsServiceProtocol where Self == SmartSignalsServicePreviewFixture {

    static var preview: Self { .init() }
}
