@MainActor
extension GeolocationService {

    static let shared: GeolocationService = .init(identificationService: .default)
}

@MainActor
extension GeolocationServiceProtocol where Self == GeolocationService {

    static var `default`: Self { .shared }
}
