enum SettingsRoute: Route {
    case apiKeys
}

extension Route where Self == SettingsRoute {

    var childRoute: (any Route)? { .none }
}
