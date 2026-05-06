extension SmartSignalsServiceProtocol where Self == SmartSignalsService {

    static var `default`: Self {
        .init(
            client: HTTPClient(
                session: .init(configuration: .ephemeral)
            )
        )
    }
}
