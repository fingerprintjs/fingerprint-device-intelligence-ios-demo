enum AppRoute: Route {
    case home
    case settings(SettingsRoute?)
}

extension Route where Self == AppRoute {

    var childRoute: (any Route)? {
        switch self {
        case .home: .none
        case let .settings(settingsRoute): settingsRoute
        }
    }
}

extension DeepLinkNavigator {

    @_disfavoredOverload
    func callAsFunction(to route: AppRoute) {
        callAsFunction(to: route)
    }
}
