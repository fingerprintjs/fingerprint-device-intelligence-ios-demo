enum AppRoute: Route {
    case home
    case settings
}

extension Route where Self == AppRoute {

    var childRoute: (any Route)? {
        switch self {
        case .home: .none
        case .settings: .none
        }
    }
}

extension DeepLinkNavigator {

    @_disfavoredOverload
    func callAsFunction(to route: AppRoute) {
        callAsFunction(to: route)
    }
}
