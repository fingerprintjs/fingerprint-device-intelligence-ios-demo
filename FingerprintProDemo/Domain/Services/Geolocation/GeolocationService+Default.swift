extension GeolocationService {

    static let shared: GeolocationService = .init()
}

extension GeolocationServiceProtocol where Self == GeolocationService {

    static var `default`: Self { .shared }
}
