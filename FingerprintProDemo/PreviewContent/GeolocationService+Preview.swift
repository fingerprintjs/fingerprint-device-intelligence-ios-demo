struct GeolocationServicePreviewFixture: GeolocationServiceProtocol {
    let hasLocationPermission: Bool = false
}

extension GeolocationServiceProtocol where Self == GeolocationServicePreviewFixture {

    static var preview: Self { .init() }
}
